package Mutuki::Crypt::Factory;
use strict;
use warnings;
use Smart::Args;
use Class::Load;
use Carp ();

sub create {
    args_pos my $class => 'ClassName',
             my $name  => { isa => 'Str', optional => 1, default => 'Default' };

    
    my $module = 'Mutuki::Crypt::' . $name; 

    Class::Load::load_class($module);

    unless( $module->isa('Mutuki::Crypt::Base') ) {
        Carp::confess('use base Mutuki::Crypt::Base');
    }

    return $module->new(); 
}

1;
