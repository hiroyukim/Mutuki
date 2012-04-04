package Mutuki::Model::Plugin::Crypt;
use strict;
use warnings;
use Carp ();
use Mutuki::Crypt::Factory;

sub import {
    my $caller = caller();

    no strict 'refs';
    *{"$caller:\:crypt"} = sub {
        my $self = shift; 

        unless( $self->can('c') ) {
            Carp::confess('need c ');
        }

        return Mutuki::Crypt::Factory->create($self->c->config->{Crypt});
    };
}

1;
