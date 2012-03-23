package Mutuki::Web::C::Wiiki;
use strict;
use warnings;
use Carp ();
use Try::Tiny;

sub show {
    my ($class,$c,$p) = @_;

    my $stash = {};

    if( $c->req->param('wiki_id')  ) {
        $stash->{wiki} = $c->model('Wiki')->single({ wiki_id => $c->req->param('wiki_id') });
    }
    
    $c->render('/wiki/show.tt',$stash); 
};

sub delete {
    my ($class,$c,$p) = @_;
    
    unless( $c->req->param('wiki_id') ) {
        $c->redirect('/');
    }

    my $wiki = $c->model('Wiki')->single({ wiki_id => $c->req->param('wiki_id') });

    unless( $wiki ) {
        $c->redirect('/');
    }

    if( $c->req->method eq 'POST'  ) {
        $c->model('Wiki')->delete({
            wiki_id => $wiki->{id},
        });
        return $c->redirect('/');
    }

    $c->render('/wiki/delete.tt',{ wiki => $wiki }); 
};

sub edit {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('wiki_id') ) {
        $c->redirect('/');
    }

    my $wiki = $c->model('Wiki')->single({ wiki_id => $c->req->param('wiki_id') });

    unless( $wiki ) {
        $c->redirect('/');
    }

    my @params = qw/title body/;

    if( $c->req->method eq 'POST' ) {
        if( grep{ $c->req->param($_) } @params  ) {
            $c->model('Wiki')->update({
                wiki_id => $wiki->{id},
                map { $c->req->param($_) } @params,                
            });
        }
        return $c->redirect('/wiki/show',{ wiki_id => $wiki->{id} });
    }

    $c->fillin_form($wiki);
    
    $c->render('/wiki/edit.tt',{
        wiki => $wiki,
    }); 
};

sub add {
    my ($class,$c,$p) = @_;

    unless( $c->req->param('wiki_group_id') ) {
        $c->redirect('/');
    }

    my @params = qw/title body wiki_group_id/;

    if( $c->req->method eq 'POST' ) {
        if( @params == ( grep{ $c->req->param($_) } @params ) ) {
            $c->model('Wiki')->add({
                map { $c->req->param($_) } @params
            });
        }
        return $c->redirect('/');
    }
    
    $c->render('/wiki/add.tt',{
        wiki_group_id => $c->req->param('wiki_group_id'),
    }); 
};

1;
