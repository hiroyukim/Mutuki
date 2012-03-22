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

get '/wiki/show' => sub {
    my ($c) = @_;

    my $stash = { };

    if( $c->req->param('wiki_id')  ) {
        $stash->{wiki} = $c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
            $c->req->param('wiki_id') 
        );
    }
    
    $c->render('/wiki/show.tt',$stash); 
};

get '/group/show' => sub {
    my ($c) = @_;

    my ($rows,$page) = (10,$c->req->param('page')||1);
    my $stash = {};

    if( $c->req->param('wiki_group_id')  ) {
        $stash->{wiki_group} = $c->dbh->selectrow_hashref(q{SELECT * FROM wiki_group WHERE id = ?},{ Columns => {} },
            $c->req->param('wiki_group_id') 
        );
        $stash->{wikis} = $c->dbh->selectall_arrayref(q{SELECT * FROM wiki WHERE wiki_group_id = ? AND deleted_fg = 0 ORDER BY id DESC LIMIT ?,?},{ Columns => {} },
            $c->req->param('wiki_group_id'),
            ( ($page - 1) * $rows),
            $rows,
        );
    }
    
    $c->render('/group/show.tt',$stash); 
};

any '/wiki/add' => sub {
    my ($c) = @_;

    unless( $c->req->param('wiki_group_id') ) {
        $c->redirect('/');
    }

    my @params = qw/title body wiki_group_id/;

    if( $c->req->method eq 'POST' ) {
        if( @params == ( grep{ $c->req->param($_) } @params ) ) {
            $c->dbh->do(q{INSERT INTO wiki (title,body,wiki_group_id,created_at) VALUES (?,?,?,NOW())}, {}, 
                map { $c->req->param($_) } @params,
            ); 
        }
        return $c->redirect('/');
    }
    
    $c->render('/wiki/add.tt',{
        wiki_group_id => $c->req->param('wiki_group_id'),
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
