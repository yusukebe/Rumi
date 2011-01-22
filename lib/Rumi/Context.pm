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

sub route {
    return shift->{route};
}

sub render {
    my $self = shift;
    my ($name, $param) = @_;
    $param->{base} = $self->req->base;
    return $self->{render_view}($name, $param);
}

1;
