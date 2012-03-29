package Mutuki::Web::C::Wiki::Group;
use strict;
use warnings;
use Carp ();
use Try::Tiny;

sub show {
    my ($class,$c,$p) = @_;

    my ($rows,$page) = (10,$c->req->param('page')||1);

    my $stash = {};     

    if( $c->req->param('wiki_group_id')  ) {
        $stash->{wiki_group} = $c->model('Wiki::Group')->single({
            wiki_group_id => $c->req->param('wiki_group_id'), 
        });
        $stash->{wikis} = $c->model('Wiki')->list_with_pager({
            wiki_group_id => $c->req->param('wiki_group_id'),
            rows => $rows,
            page => $page,
        });
    }
    
    $c->render('/wiki/group/show.tt',$stash); 
};

sub delete {
    my ($class,$c,$p) = @_;
   
    # FIXME: このへんを美しくしたい 
    unless( $c->req->param('wiki_group_id') ) {
        $c->redirect('/');
    }
    
    my $wiki_group = $c->model('Wiki::Group')->single({
        wiki_group_id => $c->req->param('wiki_group_id'), 
    });

    unless( $wiki_group ) {
        $c->redirect('/');
    }

    if( $c->req->method eq 'POST' ) {
        $c->model('Wiki::Group')->delete({
            wiki_group_id => $c->req->param('wiki_group_id'),
        });
        return $c->redirect('/');
    }
    
    $c->render('/wiki/group/delete.tt',{
        wiki_group => $wiki_group,
    }); 
};

sub edit {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('wiki_group_id') ) {
        $c->redirect('/');
    }

    my $wiki_group = $c->model('Wiki::Group')->single({
        wiki_group_id => $c->req->param('wiki_group_id'), 
    });

    unless( $wiki_group ) {
        $c->redirect('/');
    }

    my @params = qw/title body/;

    if( $c->req->method eq 'POST' ) {
        if( grep{ $c->req->param($_) } @params  ) {
            $c->model('Wiki::Group')->update({
                wiki_group_id => $wiki_group->{id},
                title         => $c->req->param('title') || undef,
                body          => $c->req->param('body')  || undef,
            });
        }
        return $c->redirect('/wiki/group/show',{ wiki_group_id => $wiki_group->{id} });
    }

    $c->fillin_form($wiki_group);
    
    $c->render('/wiki/group/edit.tt',{
        wiki_group => $wiki_group,
    }); 
};

sub wiki_list {
    my ($class,$c,$p) = @_;

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


1;
