package Mutuki::Validator::User;
use strict;
use warnings;
use parent 'Mutuki::Validator::Base';

sub insert {
    my $self = shift;

    $self->check([
        name       => [qw/NOT_NULL ASCII/, [qw/LENGTH 4 255/]],
        nickname   => [qw/NOT_NULL/],
        passwd1    => [qw/NOT_NULL ASCII/ ,[qw/LENGTH 4 30/]],
        passwd2    => [qw/NOT_NULL ASCII/ ,[qw/LENGTH 4 30/]],
        { passwds  => [qw/passwd1 passwd2/] } =>  [qw/DUPLICATION/],
    ]);

    if( 
        $self->c->req->param('name') 
        && 
        $self->c->model('User')->single_by_name({ name => $self->c->req->param('name') })  
    ) { 
        $self->validator->set_error(
            same_name => 'exists',
        );
    }

    return $self;
}

sub login {
    my $self = shift;

    $self->check([
        name      => [qw/NOT_NULL/],
        passwd    => [qw/NOT_NULL/],
    ]);

    if( 
        $self->c->req->param('name') && $self->c->req->param('passwd') 
        &&
        ( not $self->c->model('User')->single_by_name_passwd({ name => $self->c->req->param('name'), passwd => $self->c->req->param('passwd') }) ) 
    ) {
        $self->validator->set_error(
            name_or_passwd => 'no_match',
        );
    }

    return $self;
}

1;
