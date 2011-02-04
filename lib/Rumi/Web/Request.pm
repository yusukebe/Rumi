package Rumi::Web::Request;
use strict;
use warnings;
use base qw/Plack::Request/;
use URI::QueryParam;
use Carp qw/croak/;

sub uri_with {
    my ( $self, %args ) = @_;
    croak( 'Arguments are required uri_with() method!' ) unless %args;
    my $params = $self->uri->query_form_hash();
    for my $key ( keys %$params ) {
        if( defined $args{$key} ){
            $params->{$key} = delete $args{$key};
        }
    }
    for my $key ( keys %args ){
        if( defined $args{$key} ){
            $params->{$key} = $args{$key};
        }else{
            delete $params->{$key};
        }
    }
    my $uri = $self->uri->clone;
    $uri->query_form($params);
    return $uri;
}

1;
