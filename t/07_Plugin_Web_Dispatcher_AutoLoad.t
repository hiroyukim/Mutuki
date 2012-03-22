package HogeTest::Web::Dispatcher;
use strict;
use warnings;
use Mutuki::Plugin::Web::Dispatcher::AutoLoad;

use strict;
use warnings;
use utf8;
use Test::More;

subtest 'dispatch_with_load_class' => sub {
    can_ok('HogeTest::Web::Dispatcher','dispatch_with_load_class');
};

done_testing;
