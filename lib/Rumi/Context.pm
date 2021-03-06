package Rumi::Context;
use strict;
use warnings;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;
    bless { %args }, $class;
}

sub req     { return shift->{req} }
sub route   { return shift->{route} }
sub config  { return shift->{config} }
sub session { return shift->{req}->session }

sub model {
    my ( $self, $name ) = @_;
    return $self->{model}{$name};
}

sub render {
    my $self = shift;
    my ($name, $param) = @_;
    $param->{base} = $self->req->base;
    return $self->{render_view}($name, $param);
}

sub return_404 {
    my ( $self, $name, $param ) = @_;
    return [ 404, [ 'Content-Type' => 'text/plain' ], ['404 Not Found'] ]
      unless $name || $param;
    my $html = $self->render( $name, $param );
    return [
        404,
        [
            'Content-Type'   => 'text/html; charset=UTF-8',
            'Content-Length' => length $html
        ],
        [$html]
    ];
}

sub redirect {
    my ( $self, $url ) = @_;
    return [ 302, [ 'Location' => $url ], [] ];
}

1;
