package Mutuki::Model::Storage::MySQL::User::Group;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;

sub list_with_pager {
    args my $self,
         my $rows          => { isa => 'Int', optional => 1, default => 10 },
         my $page          => { isa => 'Int', optional => 1, default => 1  };

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM user_group WHERE deleted_fg = 0 ORDER BY id DESC LIMIT ?,?},{ Columns => {} },
        ( ($page - 1) * $rows),
        $rows,
    );
}

sub single {
    args my $self,
         my $user_group_id => 'Int';

    return $self->c->dbh->selectrow_hashref(q{SELECT * FROM user_group WHERE id = ?},{ Columns => {} },
        $user_group_id,
    );
}

sub add {
    args my $self,
         my $name          => 'Str' ;

    $self->c->dbh->do(q{INSERT INTO user_group (name,created_at) VALUES (?,NOW())}, {}, 
        $name,
    ); 
}

sub delete {
    args my $self,
         my $user_group_id => 'Int';

    my $user_group = $self->c->dbh->selectrow_hashref(q{SELECT * FROM user_group WHERE id = ?},{ Columns => {} },
        $user_group_id, 
    );

    #FIXME: Exceptionクラス作ったらそちらへ移す
    unless( $user_group ) {
        Carp::croak($user_group_id);
    }

    $self->c->dbh->do(q{UPDATE user_group SET deleted_fg = 1 WHERE id = ?}, {}, 
        $user_group_id,
    );      
}

sub update {
    args my $self,
         my $user_group_id => 'Int',
         my $name    => { isa => 'Str', optional => 1 };

    my $user_group = $self->c->dbh->selectrow_hashref(q{SELECT * FROM user_group WHERE id = ?},{ Columns => {} },
        $user_group_id,
    );

    unless( $user_group ) {
        Carp::croak($user_group_id);
    }

    if( $name ) {
        $self->c->dbh->do(q{UPDATE user_group SET name = ? WHERE id = ?}, {}, 
            $name,
            $user_group->{id},
        ); 
    }
}

1;
