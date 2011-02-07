package Rumi::Web;
use parent qw/Rumi/;
use strict;
use warnings;
use Rumi::Context;
use Rumi::Web::Request;
use Rumi::Util ();
use Carp qw/croak/;
use Encode ();
use Data::Recursive::Encode;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{ $_[0] } : @_;
    my $self = bless { %args }, $class;
    $self->init();
    return $self;
}

sub init {
    my $self = shift;
    $self->{_class} = ref $self;
    $self->{dispatcher} = $self->load_class('Dispatcher');
    $self->{view}       = $self->install_view();
    $self->{model}      = $self->install_model();
}

sub load_class {
    my ( $self, $name ) = @_;
    my $class = Rumi::Util::load_class( $name, $self->{_class} );
    return $class;
}

sub to_app {
    my $self = shift;
    return sub {
        my ($env) = @_;
        my $req = Rumi::Web::Request->new( $env );
        my $route = $self->{dispatcher}->_dispatch($req);
        my $code = 200;
        unless ( $route->{controller} ){
            my $router = $self->{dispatcher}->_router;
            my ($p) = grep { $_->pattern eq '/404' } @{ $router->{routes} };
            return $self->res_404 unless $p;
            $route = $p->{dest};
            $code = 404;
        }
        my $controller = $self->load_class( 'Controller::' . $route->{controller} );
        my $action = $route->{action};
        my $c = Rumi::Context->new(
            _class => $self->{_class},
            render_view => sub { $self->render(@_) },
            req   => $req,
            model => $self->{model},
            route => $route,
            config => $self->{config}
        );
        my @codes = $controller->$action($c);
        if( $codes[0] && $codes[1] ){
            $codes[1]->{base} = $req->base;
            my $html = $self->render(@codes);
            return [
                $code,
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
    my $method = 'render'; #XXX;
    $param = Data::Recursive::Encode->decode_utf8( $param );
    my $html = $self->{view}->{$view_name}->$method( $name, $param );
    $html = Encode::encode_utf8( $html );
    return $html;
}

sub install_view  { die "This is abstract method: install_view" }
sub install_model { }

1;
