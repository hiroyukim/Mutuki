package Mutuki::Model::Storage::MySQL::Wiki::History;
use strict;
use warnings;
use parent 'Mutuki::Model::Storage::MySQL::Base';
use Carp ();
use Try::Tiny;
use Smart::Args;

sub list_with_pager {
    args my $self,
         my $wiki_id => 'Int',
         my $rows    => { isa => 'Int', optional => 1, default => 10 },
         my $page    => { isa => 'Int', optional => 1, default => 1  };

    $self->c->dbh->selectall_arrayref(q{SELECT * FROM wiki_history WHERE wiki_id = ? ORDER BY id DESC LIMIT ?,?},{ Columns => {} },
        $wiki_id,
        ( ($page - 1) * $rows),
        $rows,
    );
}

sub single {
    args my $self,
         my $wiki_history_id => 'Int';

    return $self->c->dbh->selectrow_hashref(q{SELECT * FROM wiki_history WHERE id = ?},{ Columns => {} },
        $wiki_history_id,
    );
}

1;
