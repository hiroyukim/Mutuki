package Mutuki::Web::C::Login;
use strict;
use warnings;

#FIXME: 本来ならここはhttpsにすべき
sub index {
    my ($class,$c,$p) = @_;
    $c->render('/login/index.tt',{});
};

sub do {
    my ($class,$c,$p) = @_;

    if( $c->req->method eq 'POST'  ) {
        my $validator = $c->validator('User')->login();

        if( $validator->has_error() ) {
            $c->fillin_form( $validator->to_hash );
            return $c->render('/login/index.tt',{
                validator => $validator->validator(), 
            }); 
        }

        $c->session->set( user => $c->model('User')->single_by_name_passwd($validator->to_hash) ); 
    }
    
    return $c->redirect('/');
}

1;
