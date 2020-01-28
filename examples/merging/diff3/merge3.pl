#!/usr/bib/perl

use Text::Diff3 qw(diff3 merge diff);

my $input0 = 'mine.txt';
my $input1 = 'orig.txt';
my $input2 = 'yours.txt';

open $input0,'<',$input0;
open $input1,'<',$input1;
open $input2,'<',$input2;

my $mytext   = [map {chomp; $_} <$input0>];
my $original = [map {chomp; $_} <$input1>];
my $yourtext = [map {chomp; $_} <$input2>];

my $diff3 = diff3($mytext, $original, $yourtext);
for my $r (reverse @{$diff3}) {
    # 0 : change in mine
    # 1 : change in yours
    # 2 : change in origin
    # A : conflict
    #       fg b1,e1 b2,e2 b3,e3
    printf "%s %d,%d %d,%d %d,%d\n", @{$r};
    # lineno start from not zero but ONE!
    printf "%s:\n",$input0;
    for my $lineno ($r->[1] .. $r->[2]) {
        print $mytext->[$lineno - 1], "\n";
    }
    printf "%s:\n",$input2;
    for my $lineno ($r->[3] .. $r->[4]) {
        print $yourtext->[$lineno - 1], "\n";
    }
    printf "%s:\n",$input1;
    for my $lineno ($r->[5] .. $r->[6]) {
        print $original->[$lineno - 1], "\n";
    }
}

my $merge = merge($mytext, $original, $yourtext);

use YAML::Syck qw(Dump);
printf "merge: %s.\n",Dump($merge); 

exit $?;
1;
