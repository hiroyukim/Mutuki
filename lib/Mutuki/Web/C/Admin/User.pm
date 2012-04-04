package Mutuki::Web::C::Admin::User;
use strict;
use warnings;

#FIXME: CURD系のやつを作ってしまいたい
sub index {
    my ($class,$c,$p) = @_;

    $c->render('/admin/user/index.tt',{
        users => $c->model('User')->list_with_pager({
            page  => $c->req->param('page') || 1,
            rows  => 20,
        })
    });
}

sub show {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('user_id') ) {
        return $c->redirect('/');
    }
    
    $c->render('/admin/user/show.tt', {
        user => $c->model('User')->single({ user_id => $c->req->param('user_id') }),
    }); 
};

sub delete {
    my ($class,$c,$p) = @_;
    
    unless( $c->req->param('user_id') ) {
        return $c->redirect('/');
    }

    my $user = $c->model('User')->single({ user_id => $c->req->param('user_id') });

    unless( $user ) {
        return $c->redirect('/');
    }

    if( $c->req->method eq 'POST'  ) {
        $c->model('User')->delete({
            user_id => $user->{id},
        });
        return $c->redirect('/');
    }

    $c->render('/admin/user/delete.tt',{ user => $user }); 
};

sub edit {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('user_id') ) {
        return $c->redirect('/');
    }

    my $user = $c->model('User')->single({ user_id => $c->req->param('user_id') });

    unless( $user ) {
        $c->redirect('/');
    }

    my @params = qw/title body/;

    if( $c->req->method eq 'POST' ) {
        if( grep { $c->req->param($_) } @params  ) {
            $c->model('User')->update({
                user_id => $user->{id},
                ( map { $_ => $c->req->param($_) } @params ),                
            });
        }
        return $c->redirect('/admin/user/show',{ user_id => $user->{id} });
    }

    $c->fillin_form($user);
    
    $c->render('/admin/user/edit.tt',{
        user => $user,
    }); 
};

sub add {
    my ($class,$c,$p) = @_;

    if( $c->req->method eq 'POST' ) {
        my $validator = $c->validator('User')->insert();

        if( $validator->has_error() ) {
            $c->fillin_form( $validator->to_hash );
            return $c->render('/admin/user/add.tt',{
                validator => $validator->validator(), 
            }); 
        }

        $c->model('User')->add({
            name   => $c->req->param('name'),
            passwd => $c->req->param('passwd1'),
        });
        
        return $c->redirect('/admin/user/');
    }
    
    $c->render('/admin/user/add.tt'); 
};

1;
