use strict;
use warnings;
use Test::More;
use Mutuki::Crypt::Factory;

subtest 'Mutuki::Crypt::Factory->create' => sub {
    my $crypt = Mutuki::Crypt::Factory->create();

    ok $crypt;
    isa_ok($crypt,'Mutuki::Crypt::Base');
    isa_ok($crypt,'Mutuki::Crypt::Default');
};

done_testing();
