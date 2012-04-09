package Mutuki::Model::Storage::MySQL::Wiki;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;

sub list_with_pager {
    args my $self,
         my $wiki_group_id => 'Int',
         my $rows          => { isa => 'Int', optional => 1, default => 10 },
         my $page          => { isa => 'Int', optional => 1, default => 1  };

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM wiki WHERE wiki_group_id = ? AND deleted_fg = 0 ORDER BY updated_at DESC LIMIT ?,?},{ Columns => {} },
        $wiki_group_id,
        ( ($page - 1) * $rows),
        $rows,
    );
}

sub single {
    args my $self,
         my $wiki_id => 'Int';

    return $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
        $wiki_id,
    );
}

sub add {
    args my $self,
         my $wiki_group_id => 'Int',
         my $user_id       => 'Int',
         my $title         => 'Str' ,
         my $body          => 'Str' ;

    $self->c->dbh->begin_work;
    try {
        $self->c->dbh->do(q{INSERT INTO wiki (title,body,user_id,wiki_group_id,created_at) VALUES (?,?,?,?,NOW())}, {}, 
            $title,
            $body,
            $user_id,
            $wiki_group_id,
        ); 

        my $last_insert_id = $self->c->dbh->selectrow_arrayref(q{SELECT LAST_INSERT_ID() FROM wiki});

        $self->c->dbh->do(q{UPDATE wiki_group SET last_updated_wiki_id = ?, last_updated_user_id = ? WHERE id = ?}, {}, 
            $last_insert_id->[0],$user_id,$wiki_group_id,
        ); 
    
        $self->c->dbh->commit();
    }
    catch {
        my $err = shift;
        $self->c->dbh->rollback();
        Carp::croak($err);
    };
}

sub delete {
    args my $self,
         my $wiki_id => 'Int';

    my $wiki = $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
        $wiki_id, 
    );

    #FIXME: Exceptionクラス作ったらそちらへ移す
    unless( $wiki ) {
        Carp::croak($wiki_id);
    }

    #FIXME: 重複多すぎなんで治す
    $self->c->dbh->begin_work;
    try {
        $self->c->dbh->do(q{UPDATE wiki SET deleted_fg = 1 WHERE id = ?}, {}, 
            $wiki_id,
        ); 

        # wiki_group.last_updated_wiki_id を更新する必要がある
        my $last_updated_wiki = $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE deleted_fg = 0 AND wiki_group_id = ? ORDER BY updated_at LIMIT 1},{ Columns => {} },$wiki->{wiki_group_id});  
        
        $self->c->dbh->do(q{UPDATE wiki_group SET last_updated_wiki_id = ?,last_updated_user_id = ? WHERE id = ?}, {}, 
            ( $last_updated_wiki ? $last_updated_wiki->{id}    : 0 ), 
            ( $last_updated_wiki ? $last_updated_wiki->{user_} : 0 ), 
            $wiki->{wiki_group_id},
        ); 

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
         my $wiki_id => 'Int',
         my $title   => { isa => 'Str', optional => 1 },
         my $body    => { isa => 'Str', optional => 1 };

    my $wiki = $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
        $wiki_id,
    );

    unless( $wiki ) {
        Carp::croak($wiki_id);
    }

    if( $title or $body ) {
        $self->c->dbh->begin_work;
        try {

            $self->c->dbh->do(q{INSERT INTO wiki_history (title,body,user_id,wiki_id,created_at) VALUES (?,?,?,?,?)}, {}, 
                map { $wiki->{$_} } qw/title body user_id id created_at/
            ); 

            $self->c->dbh->do(q{UPDATE wiki SET title = ?, body = ?, user_id = ? WHERE id = ?}, {}, 
                $title || $wiki->{title},
                $body  || $wiki->{body},
                $user_id,
                $wiki->{id},
            ); 
            
            $self->c->dbh->do(q{UPDATE wiki_group SET last_updated_wiki_id = ?, last_updated_user_id = ? WHERE id = ?}, {}, 
                $wiki->{id},
                $user_id,
                $wiki->{wiki_group_id},
            ); 
        
            $self->c->dbh->commit();
        }
        catch {
            my $err = shift;
            $self->c->dbh->rollback();
            Carp::croak($err);
        };
    }
}

1;
