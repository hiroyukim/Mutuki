package Mutuki::Validator::User;
use strict;
use warnings;
use parent 'Mutuki::Validator::Base';

sub insert {
    my $self = shift;

    $self->check([
        name       => [qw/NOT_NULL/],
        passwd1    => [qw/NOT_NULL ASCII/ ,[qw/LENGTH 4 30/]],
        passwd2    => [qw/NOT_NULL ASCII/ ,[qw/LENGTH 4 30/]],
        { passwds  => [qw/passwd1 passwd2/] } =>  [qw/DUPLICATION/],
    ]);
}

1;
