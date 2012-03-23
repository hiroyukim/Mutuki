use strict;
use warnings;
use utf8;
use Test::More;

use_ok $_ for qw(
    Mutuki::Model::Storage::MySQL::Base
    Mutuki::Model::Storage::MySQL::Wiki
    Mutuki::Model::Storage::MySQL::Wiki::Group
    Mutuki::Plugin::Model
    Mutuki::Plugin::Web::Dispatcher::AutoLoad
    Mutuki::Web
    Mutuki::Web::C::Root
    Mutuki::Web::C::Wiki
    Mutuki::Web::C::Wiki::Group
    Mutuki::Web::Dispatcher
    Mutuki
);

done_testing;
