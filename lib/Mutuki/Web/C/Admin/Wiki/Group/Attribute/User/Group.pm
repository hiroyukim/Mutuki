package Mutuki::Web::C::Admin::Wiki::Group::Attribute::User::Group;
use strict;
use warnings;

sub edit {
    my ($class,$c,$p) = @_;

    my @params     = qw/wiki_group_id user_group_id/;
    my @params_opt = qw/read_fg write_fg/;

    my ($read_fg,$write_fg) = map { $c->req->param($_) || 0 } @params_opt; 

    #FIXME: このてのValidation的なものは何とかしたい
    unless( @params == ( grep {  defined $c->req->param($_) } @params ) ) {
        return $c->redirect('/');
    }

    my $wiki_group_attribute_user_group = $c->model('Wiki::Group::Attribute::User::Group')->single({
        map { $_ => $c->req->param($_) } @params
    });

    my $method = $wiki_group_attribute_user_group ? 'update' : 'insert';
    $c->model('Wiki::Group::Attribute::User::Group')->$method({
        read_fg  => $read_fg,
        write_fg => $write_fg,
        map { $_ => $c->req->param($_) } @params
    });

    return $c->redirect('/admin/wiki/group/attribute/user/group/edit_thanks',{
        map { $_ => $c->req->param($_) } grep { not /^.+_fg$/ } @params
    });
}

sub edit_thanks {
    my ($class,$c,$p) = @_;

    my @params = qw/wiki_group_id user_group_id/;

    unless( @params == ( grep {  defined $c->req->param($_) } @params ) ) {
        return $c->redirect('/');
    }
   
    my $wiki_group = $c->model('Wiki::Group')->single({ wiki_group_id => $c->req->param('wiki_group_id') });
    my $user_group = $c->model('User::Group')->single({ user_group_id => $c->req->param('user_group_id') });
    my $wiki_group_attribute_user_group = $c->model('Wiki::Group::Attribute::User::Group')->single({
        map { $_ => $c->req->param($_) }  @params
    });
    if( !$wiki_group || !$user_group || !$wiki_group_attribute_user_group ) {
        return $c->redirect('/');
    }

    $c->render('/admin/wiki/group/attribute/user/group/edit_thanks.tt',{
        wiki_group => $wiki_group,
        user_group => $user_group,
        wiki_group_attribute_user_group => $wiki_group_attribute_user_group,
    });
}

1;
