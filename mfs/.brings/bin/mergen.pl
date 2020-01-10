#!/usr/bin/perl

### usage :
#
#  hash = merged_m(@array_of_sorted_hashes)
#
use Text::Diff;
use Text::Patch;

sub merge_n {
 my ($myfile_h,@otherhashes) = @_;
 my $merged = $myfile_h; # 'z6CfPsNrajGLLoNHWshz5fm6JwY2HBYLAyTARUUwwhWe'; 
 foreach my $yourhash (@otherhashes) {
   $merged = &merge2($merged,$yourhash); 
 }
 return $merged;
}

sub merge2 {
  my ($a,$b) = @_;
  my $x = &common_ancestor($a,$b);
  my $hash = &merge3($a,$b,$x);
  return $hash;
}

sub merge3 {
 my ($a,$b,$x) = @_;
 my $xa = &apply_patch(&diff2($b,$z), $a);
 my $xb = &apply_patch(&diff2($a,$z), $b);
 my ($ab, undef) = &vote($xa,$ab);
}

sub apply_patch {
 my ($src,$diff) = @_;
 my $patch = patch( $src, $diff, { STYLE => 'Unified' } );
 return $patch;
}

sub diff2 {
 my ($s1,$s2) = map { &get_content($_) } @_;
 my $diff = diff \$s1, \$s2, { STYLE => 'Unified' }; 
 printf "diff: %s.\n",$diff;
 return $diff;
}

sub vote {
  my ($xa,$xb) = @_;
  if ($xa eq $xb) {
    return ($xa, '');
  } else {
    my $diff = diff \$xa, \$xb, { STYLE => 'Unified' }; 
    return ($xa, $diff);
  }
}

1; # $Source: /my/perl/scripts/mergen.pl $
