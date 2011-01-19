package Rumi::Util;
use strict;
use warnings;
use Plack::Util;
use parent qw( Exporter );
our @EXPORT = qw( load_class );

sub load_class {
    Plack::Util::load_class(@_);
}

1;
