package Mutuki::Plugin::Model;
use strict;
use warnings;
use Amon2::Util ();
use Class::Load;

sub init {
    my ($class, $c, $conf) = @_;
    Amon2::Util::add_method($c, 'model', \&_model);
}

sub _model {
    my ($c, $schema) = @_;

    my $module  = 'Mutuki::Model::Storage::' .  $c->config->{model}->{$schema}->{storage} . '::' . $schema;   

    Class::Load::load_class($module);

    return $module->new($c);
}

1;
__END__

=encoding utf-8

=head1 NAME

Mutuki::Plugin::Model - Model plugin

=head1 SYNOPSIS

    # your config
    Mutuki:
      storage: MySQL

    __PACKAGE__->load_plugins(qw/Mutuki::Plugin::Model/);

    get '/' => sub {
        my $c = shift;

        $c->model('Wiki')->single({
            wiki_id => $c->req->param('wiki_id')
        });
    };

    __PACKAGE__->to_app();

=head1 DESCRIPTION

This is a Model plugin.

