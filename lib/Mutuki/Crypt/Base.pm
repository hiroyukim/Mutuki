package Mutuki::Crypt::Base;
use strict;
use warnings;

sub new      { bless {}, $_[0] }
sub encode   { die }
sub validate { die }

1;
