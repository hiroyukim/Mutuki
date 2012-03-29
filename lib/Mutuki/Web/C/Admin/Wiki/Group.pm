package Mutuki::Web::C::Admin::Wiki::Group;
use strict;
use warnings;

sub index {
    my ($class,$c,$p) = @_;

    $c->render('/admin/wiki/group/index.tt',{
        wiki_groups => $c->model('Wiki::Group')->list_with_pager({
            page  => $c->req->param('page') || 1,
            rows  => 30,
        })
    });
}

sub show {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('wiki_group_id') ) {
        return $c->redirect('/');
    }
    
    $c->render('/admin/wiki/group/show.tt', {
        wiki_group => $c->model('Wiki::Group')->single({ wiki_group_id => $c->req->param('wiki_group_id') }),
        user_groups => $c->model('User::Group')->list(),
        get_wiki_group_attribute_user_group => sub {
            my ($wiki_group_id,$user_group_id) = @_;

            $c->model('Wiki::Group::Attribute::User::Group')->single({
                wiki_group_id => $wiki_group_id,
                user_group_id => $user_group_id,
            });
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

    my @params = qw/title/;

    if( $c->req->method eq 'POST' ) {
        if( @params == ( grep{ defined $c->req->param($_) } @params ) ) {
            $c->model('Wiki::Group')->add({
                map { $_ => $c->req->param($_) } @params, 
            });
        }
        return $c->redirect('/admin/wiki/group/');
    }
    
    $c->render('/admin/wiki/group/add.tt'); 
};

1;
