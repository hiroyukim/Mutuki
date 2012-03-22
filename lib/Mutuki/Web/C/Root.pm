package Mutuki::Web::C::Root;
use strict;
use warnings;

sub index {
    my ($class,$c,$p) = @_;

    my ($rows,$page) = (10,$c->req->param('page')||1);
    my $stash = {};

    $stash->{wiki_groups} = $c->dbh->selectall_arrayref(q{SELECT * FROM wiki_group WHERE deleted_fg = 0 ORDER BY updated_at DESC LIMIT ?,?},{ Columns => {} },
        ( ($page - 1) * $rows),
        $rows,
    );

    $stash->{selectrow_hashref_wiki} = sub {
        my $wiki_id = shift or die 'wiki_id';

        return $c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
            $wiki_id,
        );
    };

    $c->render('index.tt',$stash);
};

1;
