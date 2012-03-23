package Mutuki::Model::Storage::MySQL::Base;
use strict;
use warnings;
use Smart::Args;
use parent 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/c/);

sub new {
    args_pos my $class => 'ClassName',
             my $c     => 'Object';

    bless {
        c => $c,
    },$class;
}

1;
