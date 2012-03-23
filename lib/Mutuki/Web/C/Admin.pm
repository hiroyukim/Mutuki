package Mutuki::Web::C::Admin;
use strict;
use warnings;

sub index {
    my ($class,$c,$p) = @_;
    $c->render('/admin/index.tt',{});
};

1;
