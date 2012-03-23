package Mutuki::Model::Storage::MySQL::User::Attribute::Group;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;

sub list_by_user_group_id {
    args my $self,
         my $user_group_id => 'Int';

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM user_attribute_group WHERE user_group_id = ? ORDER BY id DESC},{ Columns => {} },
        $user_group_id,
    );
}

sub list_by_user_id {
    args my $self,
         my $user_id => 'Int';

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM user_attribute_group WHERE user_id = ? ORDER BY id DESC},{ Columns => {} },
        $user_id,
    );
}

sub add {
    args my $self,
         my $user_id       => 'Int',
         my $user_group_id => 'Int';

    $self->c->dbh->do(q{INSERT INTO user_attribute_group (user_id,user_group_id,created_at) VALUES (?,?,NOW())}, {}, 
        $user_id,
        $user_group_id,
    ); 
}

sub delete {
    args my $self,
         my $user_id       => 'Int',
         my $user_group_id => 'Int';

    my $user_attribute_group = $self->c->dbh->selectrow_hashref(q{SELECT * FROM user_attribute_group WHERE user_id =? AND user_group_id = ?},{ Columns => {} },
        $user_id,
        $user_group_id, 
    );

    #FIXME: Exceptionクラス作ったらそちらへ移す
    unless( $user_attribute_group ) {
        Carp::croak(join(" ",$user_id, $user_group_id ));
    }

    $self->c->dbh->do(q{DELETE FROM user_attribute_group WHERE user_id =? AND user_group_id = ?}, {}, 
        $user_id,
        $user_group_id, 
    );      
}

1;
