package Mutuki::Model::Storage::MySQL::User;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;

sub list {
    my $self = shift;
    $self->c->dbh->selectall_arrayref(q{SELECT * FROM user WHERE deleted_fg = 0 ORDER BY updated_at DESC},{ Columns => {} });
}

sub list_with_pager {
    args my $self,
         my $rows          => { isa => 'Int', optional => 1, default => 10 },
         my $page          => { isa => 'Int', optional => 1, default => 1  };

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM user WHERE deleted_fg = 0 ORDER BY updated_at DESC LIMIT ?,?},{ Columns => {} },
        ( ($page - 1) * $rows),
        $rows,
    );
}


sub list_with_pager_by_user_group_id {
    args my $self,
         my $user_group_id => 'Int',
         my $rows          => { isa => 'Int', optional => 1, default => 10 },
         my $page          => { isa => 'Int', optional => 1, default => 1  };

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM user WHERE user_group_id = ? AND deleted_fg = 0 ORDER BY updated_at DESC LIMIT ?,?},{ Columns => {} },
        $user_group_id,
        ( ($page - 1) * $rows),
        $rows,
    );
}

sub single {
    args my $self,
         my $user_id => 'Int';

    return $self->c->dbh->selectrow_hashref(q{SELECT * FROM user WHERE id = ?},{ Columns => {} },
        $user_id,
    );
}

sub add {
    args my $self,
         my $name          => 'Str' ;

    $self->c->dbh->do(q{INSERT INTO user (name,created_at) VALUES (?,NOW())}, {}, 
        $name,
    ); 
}

sub delete {
    args my $self,
         my $user_id => 'Int';

    my $user = $self->c->dbh->selectrow_hashref(q{SELECT * FROM user WHERE id = ?},{ Columns => {} },
        $user_id, 
    );

    #FIXME: Exceptionクラス作ったらそちらへ移す
    unless( $user ) {
        Carp::croak($user_id);
    }

    $self->c->dbh->do(q{UPDATE user SET deleted_fg = 1 WHERE id = ?}, {}, 
        $user_id,
    );      
}

sub update {
    args my $self,
         my $user_id => 'Int',
         my $name    => { isa => 'Str', optional => 1 };

    my $user = $self->c->dbh->selectrow_hashref(q{SELECT * FROM user WHERE id = ?},{ Columns => {} },
        $user_id,
    );

    unless( $user ) {
        Carp::croak($user_id);
    }

    if( $name ) {
        $self->c->dbh->do(q{UPDATE user SET name = ? WHERE id = ?}, {}, 
            $name,
            $user->{id},
        ); 
    }
}

1;
