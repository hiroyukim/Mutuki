use strict;
use warnings;
use utf8;
use Test::More;

# grep package **/*.pm | cut -d' ' -f 2 | grep -E ^Mutuki | sort -u
use_ok $_ for qw(
Mutuki::Crypt::Base
Mutuki::Crypt::Default
Mutuki::Crypt::Factory
Mutuki::Model::Plugin::Crypt
Mutuki::Model::Storage::MySQL::Base
Mutuki::Model::Storage::MySQL::User::Attribute::Group
Mutuki::Model::Storage::MySQL::User::Group
Mutuki::Model::Storage::MySQL::User
Mutuki::Model::Storage::MySQL::Wiki::Group::Attribute::User::Group
Mutuki::Model::Storage::MySQL::Wiki::Group
Mutuki::Model::Storage::MySQL::Wiki
Mutuki::Plugin::Auth::Default
Mutuki::Plugin::Model
Mutuki::Plugin::Validator
Mutuki::Plugin::Web::Dispatcher::AutoLoad
Mutuki::Validator::Base
Mutuki::Validator::User
Mutuki::Web::C::Admin::User::Attribute::Group
Mutuki::Web::C::Admin::User::Group
Mutuki::Web::C::Admin::User
Mutuki::Web::C::Admin::Wiki::Group::Attribute::User::Group
Mutuki::Web::C::Admin::Wiki::Group
Mutuki::Web::C::Admin
Mutuki::Web::C::Root
Mutuki::Web::C::Wiki::Group
Mutuki::Web::C::Wiki
Mutuki::Web::Dispatcher
Mutuki::Web
Mutuki

);

done_testing;
