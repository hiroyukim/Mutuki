package Mutuki::Plugin::Web::Dispatcher::AutoLoad;
use strict;
use warnings;
use Class::Load;

sub import {
    my $caller = caller();

    no strict 'refs';
    *{"$caller\::dispatch_with_load_class"} = sub {
        my ($class, $c) = @_;
        my $req = $c->request;
        if (my $p = $class->match($req->env)) {
            my $action = $p->{action};
            $c->{args} = $p;
            my $module = "@{[ ref Amon2->context ]}::C::$p->{controller}";
            Class::Load::load_class($module);
            $module->$action($c, $p);
        } else {
            $c->res_404();
        }
    };
}

1;
