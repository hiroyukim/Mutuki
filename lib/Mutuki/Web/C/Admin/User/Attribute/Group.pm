package Mutuki::Web::C::Admin::User::Attribute::Group;
use strict;
use warnings;

sub delete {
    my ($class,$c,$p) = @_;
   
    my @params = qw/user_id user_group_id/;

    unless( @params == ( grep { defined $c->req->param($_) } @params ) ) { 
        return $c->redirect('/');
    }
    
    my $user = $c->model('User')->single({ user_id => $c->req->param('user_id') });

    unless( $user ) {
        return $c->redirect('/');
    }
    
    my $user_group = $c->model('User::Group')->single({ user_group_id => $c->req->param('user_group_id') });

    unless( $user_group ) {
        return $c->redirect('/');
    }

    if( $c->req->method eq 'POST'  ) {
        $c->model('User::Attribute::Group')->delete({
            map { $_ => $c->req->param($_) } @params
        });
        return $c->redirect('/admin/user/group/show',{
            user_group_id => $c->req->param('user_group_id'),        
        });
    }

    $c->render('/admin/user/attribute/group/delete.tt',{ 
        user       => $user, 
        user_group => $user_group,
    }); 
};

sub add {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('user_group_id') ) {
        return $c->redirect('/');
    }

    my @params = qw/user_id user_group_id/;

    if( $c->req->method eq 'POST' ) {
        if( @params == ( grep{ $c->req->param($_) } @params ) ) {
            $c->model('User::Attribute::Group')->add({
                user_id => [$c->req->param('user_id')],
                user_group_id => $c->req->param('user_group_id'),
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
