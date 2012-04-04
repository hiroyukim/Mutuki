package Mutuki::Model::Storage::MySQL::User;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;
use Mutuki::Crypt::Factory;

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

sub single_by_name {
    args my $self,
         my $name => 'Str';

    return $self->c->dbh->selectrow_hashref(q{SELECT * FROM user WHERE name = ?},{ Columns => {} },
        $name,
    );
}

sub single_by_name_passwd {
    my ($self,$args) = @_;
    #FIXME  passwdが数値のみの場合Strだと通らないあとで対応する　
    my $name   = $args->{name}   or die Carp::confess('name');
    my $passwd = $args->{passwd} or die Carp::confess('passwd');

    my $user = $self->single_by_name({ name => $name }); 

    unless( $user ) {
        return;
    }

    if( not $self->crypt->validate($user->{passwd},$passwd) ) { 
        return $user;
    }
    else {
        return; 
    }
}

sub add {
    my ($self,$args) = @_;
    my $name     = $args->{name}     or die Carp::confess('name');
    my $nickname = $args->{nickname} or die Carp::confess('nickname');
    my $passwd = $args->{passwd}     or die Carp::confess('passwd');

    $self->c->dbh->do(q{INSERT INTO user (name,nickname,passwd,created_at) VALUES (?,?,?,NOW())}, {}, 
        $name,
        $nickname,
        $self->crypt->encode($passwd),
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

    $self->c->dbh->begin_work;
    try {
        $self->c->dbh->do(q{UPDATE user SET deleted_fg = 1 WHERE id = ?}, {}, 
            $user_id,
        );      

        # User::Attribute::Group からも削除する必要がある
        # FIXME storeage関係なくまとめて消せる奴が必要
        # FIXME Transactionもそちら用にまとめる必要がある
        if( my $user_attribute_groups = $self->c->model('User::Attribute::Group')->list_by_user_id({ user_id => $user_id }) ) {
            for my $user_attribute_group ( @{$user_attribute_groups} ) {
                $self->c->model('User::Attribute::Group')->delete({
                    user_id       => $user_attribute_group->{user_id},
                    user_group_id => $user_attribute_group->{user_group_id},
                });
            }
        }
    
        $self->c->dbh->commit();
    }
    catch {
        my $err = shift;
        $self->c->dbh->rollback();
        Carp::croak($err);
    };
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
