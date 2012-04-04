package Mutuki::Crypt::Default;
use strict;
use warnings;
use parent 'Mutuki::Crypt::Base';
use Crypt::SaltedHash;

sub encode {
    my ($class,$secret) = @_;
    
    my $crypt = Crypt::SaltedHash->new();
    $crypt->add($secret);

    return $crypt->generate();
}

sub validate {
    my ($class,$salted,$secret) = @_;

     Crypt::SaltedHash->validate( $salted, $secret );
}

1;
