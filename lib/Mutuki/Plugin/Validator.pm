package Mutuki::Plugin::Validator;
use strict;
use warnings;
use Amon2::Util ();
use Class::Load;

sub init {
    my ($class, $c, $conf) = @_;
    Amon2::Util::add_method($c, 'validator', \&_validator);
}

sub _validator {
    my ($c, $validator_class) = @_;
    
    my $module  = 'Mutuki::Validator::' . $validator_class; 

    Class::Load::load_class($module);

    return $module->new($c);
}

1;
__END__

=encoding utf-8

=head1 NAME

Mutuki::Plugin::Validator - Validator plugin

=head1 SYNOPSIS

    # your config
    Mutuki:
      'Validator::Lite':
        message_data:
          message:
          param:
          function:

    __PACKAGE__->load_plugins(qw/Mutuki::Plugin::Validator/);

    any '/' => sub {
        my $c = shift;

        my $validator = $c->validator('User')->insert($req);

        if( $validator->has_error() ) {
            # do something
        }
    };

    __PACKAGE__->to_app();

=head1 DESCRIPTION

    This is a Validator plugin.

=head1 AUTHOR

    Hiroyuki Yamanaka

