package Rumi;
use strict;
use warnings;
use File::Spec;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;
    my $self = bless { %args }, $class;
    return $self;
}

sub config {
    my $class = shift;
    $class = ref $class || $class;
    my $name = shift || 'config.pl';
    my $config = do File::Spec->catfile($name);
    no strict 'refs';
    *{"$class\::config"} = sub { $config };
    return $config;
}

1;

__END__

=head1 NAME

Rumi - yet another girl.

=head1 SYNOPSIS

  package MyApp;
  use prent qw( Rumi );
  1;

=head1 DESCRIPTION

Rumi is only my web application framework.

=head1 AUTHOR

Yusuke Wada E<lt>yusuke at kamawada.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
