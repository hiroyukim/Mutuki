package Mutuki::Model::Storage::MySQL::Wiki;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;

sub single {
    args my $self,
         my $wiki_id => 'Int';

    return $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
        $wiki_id,
    );
}

sub delete {
    args my $self,
         my $wiki_id => 'Int';

    my $wiki = $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
        $wiki_id; 
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
        my $last_updated_wiki = $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE deleted_fg = 0 ORDER BY updated_at LIMIT 1},{ Columns => {} });  
        
        $self->c->dbh->do(q{UPDATE wiki_group SET last_updated_wiki_id = ? WHERE id = ?}, {}, 
            ( $last_updated_wiki ? $last_updated_wiki->{id} : 0 ), 
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

1;
