package Rumi;
use strict;
use warnings;

our $VERSION = '0.016';

sub load_config {
    my $class    = shift;
    my $filename = shift;
    my $config   = do $filename
      or die "Cannot load configuration file: $filename";
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
