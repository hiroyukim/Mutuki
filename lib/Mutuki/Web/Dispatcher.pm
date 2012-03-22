package Mutuki::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Carp ();
use Try::Tiny;
use Text::Markdown;
use Amon2::Web::Dispatcher::Lite;

any '/' => sub {
    my ($c) = @_;

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

get '/wiki/show' => sub {
    my ($c) = @_;

    my $stash = { 
        text_markdown => sub { Text::Markdown->new->markdown(@_) }
    };

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

    #FIXME: 本来別の場所に書かれているべきなのであとで纏める 
    my $stash = {
        text_markdown => sub { Text::Markdown->new->markdown(@_) },
    };     

    if( $c->req->param('wiki_group_id')  ) {
        $stash->{wiki_group} = $c->dbh->selectrow_hashref(q{SELECT * FROM wiki_group WHERE id = ?},{ Columns => {} },
            $c->req->param('wiki_group_id') 
        );
        $stash->{wikis} = $c->dbh->selectall_arrayref(q{SELECT * FROM wiki WHERE wiki_group_id = ? AND deleted_fg = 0 ORDER BY updated_at DESC LIMIT ?,?},{ Columns => {} },
            $c->req->param('wiki_group_id'),
            ( ($page - 1) * $rows),
            $rows,
        );
    }
    
    $c->render('/group/show.tt',$stash); 
};

any '/wiki/delete' => sub {
    my ($c) = @_;
    
    unless( $c->req->param('wiki_id') ) {
        $c->redirect('/');
    }

    my $wiki = $c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
        $c->req->param('wiki_id') 
    );

    unless( $wiki ) {
        $c->redirect('/');
    }

    if( $c->req->method eq 'POST'  ) {
        #FIXME: 重複多すぎなんで治す
        $c->dbh->begin_work;
        try {
            $c->dbh->do(q{UPDATE wiki SET deleted_fg = 1 WHERE id = ?}, {}, 
                $c->req->param('wiki_id'),
            ); 

            # wiki_group.last_updated_wiki_id を更新する必要がある
            my $last_updated_wiki = $c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE deleted_fg = 0 ORDER BY updated_at LIMIT 1},{ Columns => {} });  
            
            $c->dbh->do(q{UPDATE wiki_group SET last_updated_wiki_id = ? WHERE id = ?}, {}, 
                ( $last_updated_wiki ? $last_updated_wiki->{id} : 0 ), 
                $wiki->{wiki_group_id},
            ); 

            $c->dbh->commit();
        }
        catch {
            my $err = shift;
            $c->dbh->rollback();
            Carp::croak($err);
        };
         
        return $c->redirect('/');
    }

    $c->render('/wiki/delete.tt',{ wiki => $wiki }); 
};


any '/wiki/edit' => sub {
    my ($c) = @_;

    unless( $c->req->param('wiki_id') ) {
        $c->redirect('/');
    }

    my $wiki = $c->dbh->selectrow_hashref(q{SELECT * FROM wiki WHERE id = ?},{ Columns => {} },
        $c->req->param('wiki_id') 
    );

    unless( $wiki ) {
        $c->redirect('/');
    }

    my @params = qw/title body/;

    if( $c->req->method eq 'POST' ) {
        if( grep{ $c->req->param($_) } @params  ) {

            $c->dbh->begin_work;
            try {

                $c->dbh->do(q{INSERT INTO wiki_history (title,body,wiki_id,created_at) VALUES (?,?,?,?)}, {}, 
                    map { $wiki->{$_} } qw/title body id created_at/
                ); 

                $c->dbh->do(q{UPDATE wiki SET title = ?, body = ? WHERE id = ?}, {}, 
                    ( map { $c->req->param($_) || $wiki->{$_} } @params ),
                    $wiki->{id},
                ); 
            
                $c->dbh->commit();
            }
            catch {
                my $err = shift;
                $c->dbh->rollback();
                Carp::croak($err);
            };
        }
        return $c->redirect('/wiki/show',{ wiki_id => $wiki->{id} });
    }

    $c->fillin_form($wiki);
    
    $c->render('/wiki/edit.tt',{
        wiki => $wiki,
    }); 
};

any '/wiki/add' => sub {
    my ($c) = @_;

    unless( $c->req->param('wiki_group_id') ) {
        $c->redirect('/');
    }

    my @params = qw/title body wiki_group_id/;

    if( $c->req->method eq 'POST' ) {
        if( @params == ( grep{ $c->req->param($_) } @params ) ) {
            $c->dbh->begin_work;
            try {
                $c->dbh->do(q{INSERT INTO wiki (title,body,wiki_group_id,created_at) VALUES (?,?,?,NOW())}, {}, 
                    map { $c->req->param($_) } @params,
                ); 

                my $last_insert_id = $c->dbh->selectrow_arrayref(q{SELECT LAST_INSERT_ID() FROM wiki});

                $c->dbh->do(q{UPDATE wiki_group SET last_updated_wiki_id = ? WHERE id = ?}, {}, 
                    $last_insert_id->[0],$c->req->param('wiki_group_id'),
                ); 
            
                $c->dbh->commit();
            }
            catch {
                my $err = shift;
                $c->dbh->rollback();
                Carp::croak($err);
            };
        }
        return $c->redirect('/');
    }
    
    $c->render('/wiki/add.tt',{
        wiki_group_id => $c->req->param('wiki_group_id'),
    }); 
};

any '/group/delete' => sub {
    my ($c) = @_;
   
    # FIXME: このへんを美しくしたい 
    unless( $c->req->param('wiki_group_id') ) {
        $c->redirect('/');
    }

    my $wiki_group = $c->dbh->selectrow_hashref(q{SELECT * FROM wiki_group WHERE id = ?},{ Columns => {} },
        $c->req->param('wiki_group_id') 
    );

    unless( $wiki_group ) {
        $c->redirect('/');
    }

    if( $c->req->method eq 'POST' ) {
        $c->dbh->do(q{UPDATE wiki_group SET deleted_fg = 1 WHERE id = ?}, {}, 
            $c->req->param('wiki_group_id'),
        ); 
        return $c->redirect('/');
    }
    
    $c->render('/group/delete.tt',{
        wiki_group => $wiki_group,
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

any '/group/edit' => sub {
    my ($c) = @_;

    unless( $c->req->param('wiki_group_id') ) {
        $c->redirect('/');
    }

    my $wiki_group = $c->dbh->selectrow_hashref(q{SELECT * FROM wiki_group WHERE id = ?},{ Columns => {} },
        $c->req->param('wiki_group_id') 
    );

    unless( $wiki_group ) {
        $c->redirect('/');
    }

    my @params = qw/title body/;

    if( $c->req->method eq 'POST' ) {
        if( grep{ $c->req->param($_) } @params  ) {

            $c->dbh->begin_work;
            try {

                $c->dbh->do(q{INSERT INTO wiki_group_history (title,body,wiki_group_id,created_at) VALUES (?,?,?,?)}, {}, 
                    map { $wiki_group->{$_} } qw/title body id created_at/
                ); 

                $c->dbh->do(q{UPDATE wiki_group SET title = ?, body = ? WHERE id = ?}, {}, 
                    ( map { $c->req->param($_) || $wiki_group->{$_} } @params ),
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
        return $c->redirect('/group/show',{ wiki_group_id => $wiki_group->{id} });
    }

    $c->fillin_form($wiki_group);
    
    $c->render('/group/edit.tt',{
        wiki_group => $wiki_group,
    }); 
};

1;
