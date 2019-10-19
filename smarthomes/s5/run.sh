#!/bin/bash

train_cmd="utils/run.pl"
decode_cmd="utils/run.pl"

train_smarthomes=train_smarthomes
test_base_name=test_smarthomes

rm -rf exp mfcc data

#-#Data preparation ----> Done

local/prepare_data.sh waves_smarthomes
local/prepare_dict.sh
utils/prepare_lang.sh --position-dependent-phones false  data/local/dict "<SIL>" data/local/lang data/lang
local/prepare_lm.sh

rm data/test_smarthomes/text
rm data/train_smarthomes/text
cp ~/Desktop/test_text/text data/test_smarthomes
cp ~/Desktop/train_text/text data/train_smarthomes
rm data/local/test_smarthomes.txt
rm data/local/train_smarthomes.txt
cp ~/Desktop/test_text/test_smarthomes.txt data/local
cp ~/Desktop/train_text/train_smarthomes.txt data/local


#Feature extraction ----> Done
for x in train_smarthomes test_smarthomes ; do 
 steps/make_mfcc.sh --nj 1 data/$x exp/make_mfcc/$x mfcc
 steps/compute_cmvn_stats.sh data/$x exp/make_mfcc/$x mfcc
done


# Mono training
steps/train_mono.sh --nj 1 --cmd "$train_cmd" --totgauss 400 data/train_smarthomes data/lang exp/mono0a 
  
# Graph compilation  
utils/mkgraph.sh --mono data/lang_test_tg exp/mono0a exp/mono0a/graph_tgpr

# Decoding HMM
steps/decode.sh --nj 1 --cmd "$decode_cmd" exp/mono0a/graph_tgpr data/test_smarthomes exp/mono0a/decode_test_smarthomes
for x in exp/*/decode*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done

steps/get_ctm.sh --cmd "$decode_cmd" --use-segments false data/train_smarthomes data/lang exp/mono0a/decode_test_smarthomes
#steps/get_train_ctm.sh --cmd "$decode_cmd" --use-segments false data/train_smarthomes/ data/lang exp/mono0a/

#rm -rf exp/dnn
#echo 'Deep neural networks training'Deep neural networks
#steps/nnet2/train_pnorm_fast.sh  --num-epochs 2 --num-epochs-extra 1 --num-hidden-layers 1 data/train_smarthomes data/lang exp/mono0a exp/dnn
#--num-epochs 10 --num-epochs-extra 5 --num-hidden-layers 1
#echo 'Deep neural networks decoding'
#steps/nnet2/decode.sh exp/mono0a/graph_tgpr data/test_smarthomes exp/dnn/decode_tree
#for x in exp/dnn/decode*; do [ -d $x ] && grep WER $x/wer_* | utils/best_wer.sh; done