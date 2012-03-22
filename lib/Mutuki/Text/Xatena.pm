package Mutuki::Text::Xatena;
use strict;
use warnings;
use Text::Xatena;
use Text::Xatena::Util;

no strict 'refs';
no warnings 'redefine';
local *{"Text::Xatena::Node::SuperPre\::as_html"} = sub {
    my ($self, %opts) = @_;
    sprintf('<pre class="prettyprint">%s</pre>',
        escape_html(join "", @{ $self->children })
    );
};

sub format {
    my ($class,$text) = @_;
    Text::Xatena->new( hatena_compatible => 1 )->format($text);
}

1;
