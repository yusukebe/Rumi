package Rumi::Web;
use strict;
use warnings;
use Rumi::Context;
use Rumi::Web::Request;
use Rumi::Util ();
use Carp qw/croak/;
use Encode ();

sub init {
    my $self = shift;
    return if defined $self->{dispatcher} && defined $self->{view};
    $self->{_class} = ref $self;
    $self->{dispatcher} = $self->load_class('Dispatcher');
    $self->{view} = $self->install_view();
    $self->{model} = $self->install_model();
}

sub load_class {
    my ( $self, $name ) = @_;
    my $class = Rumi::Util::load_class( $name, $self->{_class} );
    return $class;
}

sub to_app {
    my $self = shift;
    $self->init();
    return sub {
        my ($env) = @_;
        my $req = Rumi::Web::Request->new( $env );
        my $route = $self->{dispatcher}->_dispatch($req);
        return $self->res_404() unless $route->{controller};
        my $controller = $self->load_class( 'Controller::' . $route->{controller} );
        my $action = $route->{action};
        my $c = Rumi::Context->new(
            render_view => sub { $self->render(@_) },
            req   => $req,
            model => $self->{model},
            route => $route
        );
        my @codes = $controller->$action($c);
        if( $codes[0] && $codes[1] ){
            $codes[1]->{base} = $req->base;
            my $html = $self->render(@codes);
            return [
                200,
                [
                    'Content-Type'   => 'text/html; charset=UTF-8',
                    'Content-Length' => length $html
                ],
                [$html]
            ];
        }elsif( ref $codes[0] eq 'ARRAY' ){
            return $codes[0];
        }
    };
}

#XXX
sub res_404 {
    return [ 404, ['Content-Type' => 'text/plain'], ['404 not found'] ];
}

sub render {
    my ( $self, $name, $param ) = @_;
    my $view_name = $param->{view} || 'default';
    my $method = $self->{view}->{$view_name}->{method} || 'render' ;
    my $html = $self->{view}->{$view_name}->{class}->$method( $name, $param );
    $html = Encode::encode_utf8( $html );
    return $html;
}

sub install_view  { die "This is abstract method: install_view" }
sub install_model { die "This is abstract method: install_model" }

1;
