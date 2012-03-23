package Mutuki::Web::C::Admin::User::Group;
use strict;
use warnings;

sub index {
    my ($class,$c,$p) = @_;

    $c->render('/admin/user/group/index.tt',{
        user_groups => $c->model('User::Group')->list_with_pager({
            page          => $c->req->param('page') || 1,
        })
    });
}

sub show {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('user_group_id') ) {
        return $c->redirect('/');
    }
    
    $c->render('/admin/user/group/show.tt', {
        user_group             => $c->model('User::Group')->single({ user_group_id => $c->req->param('user_group_id') }),
        user_attribute_groups  => $c->model('User::Attribute::Group')->list_by_user_group_id({ user_group_id => $c->req->param('user_group_id') }),
        user_by_user_id        => sub {
            my $user_id = shift;
            return $c->model('User')->single({ user_id => $user_id });
        },
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

    my @params = qw/name/;

    if( $c->req->method eq 'POST' ) {
        if( @params == ( grep{ $c->req->param($_) } @params ) ) {
            $c->model('User::Group')->add({
                map { $_ => $c->req->param($_) } @params
            });
        }
        return $c->redirect('/admin/user/group/');
    }
    
    $c->render('/admin/user/group/add.tt',{}); 
};


1;
