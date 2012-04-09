package Mutuki::Web::C::Root;
use strict;
use warnings;

sub index {
    my ($class,$c,$p) = @_;

    my ($rows,$page) = (10,$c->req->param('page')||1);
    my $stash = {};

    $stash->{wiki_groups} = $c->model('Wiki::Group')->list_with_pager({
        rows => $rows,
        page => $page,
    });

    $stash->{model_wiki_single} = sub {
        my $wiki_id = shift or die 'wiki_id';
        return $c->model('Wiki')->single({ wiki_id => $wiki_id });
    };
    
    $stash->{model_user_single} = sub {
        my $user_id = shift or die 'user_id';
        return $c->model('User')->single({ user_id => $user_id });
    };

    $c->render('index.tt',$stash);
};

1;
