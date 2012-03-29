package Mutuki::Login;
use strict;
use warnings;

#FIXME: 本来ならここはhttpsにすべき
sub index {
    my ($class,$c,$p) = @_;
    $c->render('/login/index.tt',{});
};

sub do {
    my ($class,$c,$p) = @_;

    my @params = qw/user_id passwd/;

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
}

1;
