package Mutuki::Plugin::Auth::Default;
use strict;
use warnings;

sub init {
    my ($class, $c, $code_conf) = @_;

    $c->add_trigger(BEFORE_DISPATCH => sub {
        my $c = shift;

        #ログインしてないならログインへ
        if( 
            $class->_is_redirect_login($c->req->path_info,$c->session->get('user'))
        ) {
            return $c->redirect('/login/');
        }

        my $user_attribute_groups = $c->model('User::Attribute::Group')->list_by_user_id({ user_id => $c->session->get('user')->{id} }); 

        # どこにも所属してないないならTOPへ(管理者へ連絡してね)
        if( $class->_is_redirect_has_no_user_attribute_groups($c->req->path_info,$user_attribute_groups) ) {
            return $c->redirect('/');
        }
        
        my %user_group_ids = map { $_->{user_group_id} => 1 } @{$user_attribute_groups}; 

        # 管理画面の領域の場合は管理者グループに入ってないとダメです。
        if( $class->_is_user_belongs_to_admin_user_group_in_admin($c->req->path_info,$c->config->{admin_group_id},\%user_group_ids ) ) {
            return;
        }

        # WikiGroupがユーザーが所属しているグループに許可を出してるかどうか調べるよ
        if( 
            $c->req->param('wiki_group_id') 
            && 
            ( my $wiki_group_attribute_user_groups = $c->model('Wiki::Group::Attribute::User::Group')->list_by_wiki_group_id({ wiki_group_id => $c->req->param('wiki_group_id') }) ) 
        ) {
            if( grep { $user_group_ids{$_->{user_group_id}} } @{$wiki_group_attribute_user_groups} ) {
                return;
            }
        }
        # wikiの所属グループから許可を調査
        elsif (
            $c->req->param('wiki_id')
            &&
            ( my $wiki = $c->model('Wiki')->single({ wiki_id => $c->req->param('wiki_id') }) )
        ) {
            my $wiki_group_attribute_user_groups = $c->model('Wiki::Group::Attribute::User::Group')->list_by_wiki_group_id({ wiki_group_id => $wiki->{'wiki_group_id'} });
            if( grep { $user_group_ids{$_->{user_group_id}} } @{$wiki_group_attribute_user_groups} ) {
                return;
            }
        }

        return;
    });
}

sub _is_redirect_login {
    my ($class,$path_info,$user) = @_;
    return ( !($path_info =~ m!^/log(?:in|out)/.*$!) && !$user ) ? 1 : 0;
}

sub _is_redirect_has_no_user_attribute_groups {
    my ($class,$path_info,$user_attribute_groups) = @_;
    return ( !($path_info =~ m!^/$!) && !$user_attribute_groups ) ? 1 : 0;
}

sub _is_user_belongs_to_admin_user_group_in_admin {
    my ($class,$path_info,$admin_user_group_id,$user_group_ids) = @_;
    $user_group_ids ||= {};
    return ( $path_info =~ m!^/admin/.*$! && $user_group_ids->{$admin_user_group_id} ) ? 1 : 0;
}

1;
__END__

=encoding utf8

=head1 NAME

Mutuki::Plugin::Auth::Default - auth with Mutuki 

=head1 SYNOPSIS

    __PACKAGE__->load_plugin('+Mutuki::Plugin::Auth::Default');

=head1 AUTHOR

Hiroyuki Yamanaka E<lt>hiroyukimm AAJKLFJEF GMAIL COME<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Hiroyuki Yamanka 

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

