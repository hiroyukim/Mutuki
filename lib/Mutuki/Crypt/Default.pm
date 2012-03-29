package Mutuki::Crypt::Default;
use strict;
use warnings;
use parent 'Mutuki::Crypt::Base';
use Smart::Args;
use Crypt::SaltedHash;

sub encode {
    args my $class  => 'ClassName',
         my $secret => 'Str';
    
    my $crypt = Crypt::SaltedHash->new();
    $crypt->add($secret);

    return $crypt->generate();
}

sub validate {
    args my $class  => 'ClassName',
         my $secret => 'Str',
         my $salted => 'Str';

     Crypt::SaltedHash->validate( $salted, $secret );
}

1;
