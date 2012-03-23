package Mutuki::Web::C::Admin::User::Attribute::Group;
use strict;
use warnings;

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

sub add {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('user_group_id') ) {
        return $c->redirect('/');
    }

    my @params = qw/user_id user_group_id/;

    if( $c->req->method eq 'POST' ) {
        use Data::Dumper;
        warn Dumper $c->req->param('user_id');
        if( @params == ( grep{ $c->req->param($_) } @params ) ) {
            $c->model('User::Attribute::Group')->add({
                map { $_ => $c->req->param($_) } @params
            });
        }
        return $c->redirect('/admin/user/group/');
    }
    
    $c->render('/admin/user/attribute/group/add.tt',{
        users => $c->model('User')->list(),
        user_group => $c->model('User::Group')->single({ user_group_id => $c->req->param('user_group_id') }),
    }); 
};

1;
