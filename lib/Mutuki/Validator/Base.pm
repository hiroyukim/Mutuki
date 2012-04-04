package Mutuki::Validator::Base;
use strict;
use warnings;
use base qw/Class::Accessor::Fast/;
use Mutuki;
use Smart::Args;
use FormValidator::Lite;

__PACKAGE__->mk_accessors(qw/rules c validator/);

sub new   { 
    args_pos my $class => 'ClassName',
             my $c     => 'Object';

    bless {
        c => $c,
    }, $class; 
}

sub check {
    args_pos my $self,
             my $rules  => 'ArrayRef';
    
    $self->rules($rules);

    $self->validator( FormValidator::Lite->new($self->c->req) );
    $self->validator->set_message_data(Mutuki->config->{'Validator::Lite'}->{'message_data'}); 

    $self->validator->check(@{$rules});

    return $self;
}

sub has_error          { $_[0]->validator->has_error          }
sub get_error_messages { $_[0]->validator->get_error_messages }

sub to_hash {
    my $self = shift;

    my %hash = @{$self->rules};

    +{
        map { 
            $_ => $self->c->req->param($_) ||'',
        } grep { not ref $_ } keys %hash,
    };
}

1;
