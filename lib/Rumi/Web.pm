package Rumi::Web;
use strict;
use warnings;
use Rumi::Context;
use Rumi::Util qw();
use Plack::Request;
use Carp qw( croak );

sub init {
    my $self = shift;
    return if $self->{dispatcher} && $self->{view};
    $self->{_class} = ref $self;
    $self->{dispatcher} = $self->load_class('Dispatcher');
    $self->{view} = $self->install_view();
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
        my $req = Plack::Request->new( $env );
        my $route = $self->{dispatcher}->_dispatch($req);
        my $controller = $self->load_class( 'Controller::' . $route->{controller} );
        my $action = $route->{action};
        my $c = Rumi::Context->new( req => $req );
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
        }
    };
}

sub render {
    my ( $self, $name, $param ) = @_;
    my $view_name = $param->{view} || 'default';
    my $method = $self->{view}->{$view_name}->{method} || 'render' ;
    return $self->{view}->{$view_name}->{class}->$method( $name, $param );
}

sub install_view { die "This is abstract method: install_view" }

1;
