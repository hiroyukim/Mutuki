use inc::Module::Install;
name 'Mutuki';
all_from 'lib/Mutuki.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
