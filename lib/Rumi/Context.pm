package Rumi::Context;
use strict;
use warnings;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;
    bless { %args }, $class;
}

sub req {
    return shift->{req};
}

1;
