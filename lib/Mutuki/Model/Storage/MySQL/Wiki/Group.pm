package Mutuki::Model::Storage::MySQL::Wiki::Group;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;

sub single {
    args my $self,
         my $wiki_group_id => 'Int';

    return $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki_group WHERE id = ?},{ Columns => {} },
        $wiki_group_id,
    );
}

sub delete {
    args my $self,
         my $wiki_group_id => 'Int';

    my $wiki_group = $self->single({ wiki_group_id => $wiki_group_id });

    unless( $wiki_group ) {
        Carp::croak($wiki_group);
    }

    $c->dbh->do(q{UPDATE wiki_group SET deleted_fg = 1 WHERE id = ?}, {}, 
        $wiki_group_id,
    ); 
};

sub add {
    args my $self,
         my $title         => 'Str';

    $c->dbh->do(q{INSERT INTO wiki_group (title,created_at) VALUES (?,NOW())}, {}, 
        $title,
    ); 
};

sub update {
    args my $self,
         my $wiki_group_id => 'Int';
         my $title         => { isa => 'Str', optional => 1 },
         my $body          => { isa => 'Str', optional => 1 };

    my $wiki_group = $self->single({ wiki_group_id => $wiki_group_id });

    unless( $wiki_group ) {
        Carp::croak($wiki_group);
    }

    if( $title or $body ) { 
        $c->dbh->begin_work;
        try {

            $self->c->dbh->do(q{INSERT INTO wiki_group_history (title,body,wiki_group_id,created_at) VALUES (?,?,?,?)}, {}, 
                map { $wiki_group->{$_} } qw/title body id created_at/
            ); 

            $self->c->dbh->do(q{UPDATE wiki_group SET title = ?, body = ? WHERE id = ?}, {}, 
                $wiki->{title} || $wiki_group->{title},
                $wiki->{body}  || $wiki_group->{body},
                $wiki_group->{id},
            ); 
        
            $c->dbh->commit();
        }
        catch {
            my $err = shift;
            $c->dbh->rollback();
            Carp::croak($err);
        };
    }
};


1;
