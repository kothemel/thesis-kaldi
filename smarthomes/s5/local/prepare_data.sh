#!/bin/bash

mkdir -p data/local
local=`pwd`/local
scripts=`pwd`/scripts

export PATH=$PATH:/home/kothemel/kaldi-trunk/tools/irstlm/bin

echo "Preparing train and test data"

train_base_name=train_smarthomes
test_base_name=test_smarthomes
waves_dir=$1

cd data/local

ls -1 ../../$waves_dir > waves_all.list
../../local/create_smarthomes_waves_test_train.pl waves_all.list waves.test waves.train

../../local/create_smarthomes_wav_scp.pl ${waves_dir} waves.test > ${test_base_name}_wav.scp

../../local/create_smarthomes_wav_scp.pl ${waves_dir} waves.train > ${train_base_name}_wav.scp

../../local/create_smarthomes_txt.pl waves.test > ${test_base_name}.txt

../../local/create_smarthomes_txt.pl waves.train > ${train_base_name}.txt

cp ../../input/task.arpabo lm_tg.arpa

cd ../..

# This stage was copied from WSJ example
for x in train_smarthomes test_smarthomes; do 
  mkdir -p data/$x
  cp data/local/${x}_wav.scp data/$x/wav.scp
  cp data/local/$x.txt data/$x/text
  cat data/$x/text | awk '{printf("%s global\n", $1);}' > data/$x/utt2spk
  utils/utt2spk_to_spk2utt.pl <data/$x/utt2spk >data/$x/spk2utt
done

