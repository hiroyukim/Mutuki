package Mutuki::Web::C::Logout;
use strict;
use warnings;

sub do {
    my ($class,$c,$p) = @_;

    if( $c->req->method eq 'POST'  &&  $c->session->get('user') ) {
        $c->session->remove('user');
    }
    
    return $c->redirect('/');
}

1;
