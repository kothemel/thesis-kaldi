#!/usr/bin/perl

$full_list = $ARGV[0];
$test_list = $ARGV[1];
$train_list = $ARGV[2];

open FL, $full_list;
$nol = 0;
while ($l = <FL>)
{
	$nol++;
}
close FL;

$i = 0;
open FL, $full_list;
open TESTLIST, ">$test_list";
open TRAINLIST, ">$train_list";
while ($l = <FL>)
{
	chomp($l);
	
	# add Sample-xxx to trainlist and TSamples-xxxx to test list
	my $nth = substr($l, 1, 2);
	
	$i++;
	#echo $nth;
	if ($nth eq '08' )
	{
		print TESTLIST "$l\n";
	}
	else
	{
		print TRAINLIST "$l\n";
	}
}
