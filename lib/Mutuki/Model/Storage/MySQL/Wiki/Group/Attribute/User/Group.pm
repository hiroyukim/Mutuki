package Mutuki::Model::Storage::MySQL::Wiki::Group::Attribute::User::Group;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;

sub update {
    args my $self,
         my $wiki_group_id => 'Int',
         my $user_group_id => 'Int',
         my $read_fg       => 'Int',
         my $write_fg      => 'Int';

    my $wiki_group_attribute_user_group = $self->single({ wiki_group_id => $wiki_group_id, user_group_id => $user_group_id });

    unless( $wiki_group_attribute_user_group ) {
        Carp::croak(join(" ",'wiki_group_id', $wiki_group_id, 'user_group_id', $user_group_id) );
    }

    $self->c->dbh->do(q{UPDATE wiki_group_attribute_user_group SET read_fg = ?, write_fg = ? WHERE wiki_group_id = ? AND user_group_id = ?}, {}, 
        $read_fg,
        $write_fg,
        $wiki_group_id,
        $user_group_id,
    ); 
}

sub insert {
    args my $self,
         my $wiki_group_id => 'Int',
         my $user_group_id => 'Int',
         my $read_fg       => 'Int',
         my $write_fg      => 'Int';
    
    $self->c->dbh->do(q{INSERT INTO wiki_group_attribute_user_group (wiki_group_id,user_group_id,read_fg,write_fg,created_at) VALUES (?,?,?,?,NOW())}, {}, 
        $wiki_group_id,
        $user_group_id,
        $read_fg,
        $write_fg,
    ); 
}

sub list_by_wiki_group_id {
    args my $self,
         my $wiki_group_id => 'Int';

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM wiki_group_attribute_user_group WHERE wiki_group_id = ? ORDER BY id DESC},{ Columns => {} },
        $wiki_group_id,
    );
}

sub list_by_user_group_id {
    args my $self,
         my $user_group_id => 'Int';

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM wiki_group_attribute_user_group WHERE user_group_id = ? ORDER BY id DESC},{ Columns => {} },
        $user_group_id,
    );
}

sub single {
    args my $self,
         my $wiki_group_id => 'Int',
         my $user_group_id => 'Int';

    $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki_group_attribute_user_group WHERE wiki_group_id = ? AND user_group_id = ? ORDER BY id DESC},{ Columns => {} },
        $wiki_group_id,
        $user_group_id,
    );
}

1;
