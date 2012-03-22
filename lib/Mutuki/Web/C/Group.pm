package Mutuki::Web::C::Group;
use strict;
use warnings;
use Carp ();
use Try::Tiny;
use Text::Markdown;

sub wiki_list {
    my ($c) = @_;

    my ($rows,$page) = (10,$c->req->param('page')||1);
    my $stash = {};

    $stash->{wiki_groups} = $c->dbh->selectall_arrayref(q{SELECT * FROM wiki WHERE deleted_fg = 0 AND wiki_group_id = ? ORDER BY updated_at DESC LIMIT ?,?},{ Columns => {} },
        $c->req->param('wiki_group_id'),
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

sub show {
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

sub delete {
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

sub add {
    my ($c) = @_;

    if( $c->req->param('title')  ) {
        $c->dbh->do(q{INSERT INTO wiki_group (title,created_at) VALUES (?,NOW())}, {}, 
            $c->req->param('title'),
        ); 
    }
    $c->redirect('/');
};

sub edit {
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
