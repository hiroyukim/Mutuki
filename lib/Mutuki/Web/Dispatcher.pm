package Mutuki::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::Lite;

any '/' => sub {
    my ($c) = @_;

    my ($rows,$page) = (10,$c->req->param('page')||1);

    my $wiki_groups = $c->dbh->selectall_arrayref(q{SELECT * FROM wiki_group WHERE deleted_fg = 0 ORDER BY id DESC LIMIT ?,?},{ Columns => {} },
        ( ($page - 1) * $rows),
        $rows,
    );

    $c->render('index.tt',{
        wiki_groups => $wiki_groups,
    });
};

post '/group/add' => sub {
    my ($c) = @_;

    if( $c->req->param('title')  ) {
        $c->dbh->do(q{INSERT INTO wiki_group (title,created_at) VALUES (?,NOW())}, {}, 
            $c->req->param('title'),
        ); 
    }
    $c->redirect('/');
};

1;
