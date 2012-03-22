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


1;
