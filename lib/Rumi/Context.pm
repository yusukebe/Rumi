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

sub model {
    my ( $self, $name ) = @_;
    return $self->{model}{$name};
}

1;
