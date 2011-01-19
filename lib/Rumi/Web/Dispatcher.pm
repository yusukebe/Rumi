package Rumi::Web::Dispatcher;
use strict;
use warnings;
use Router::Simple;

my $router = Router::Simple->new();

sub import {
    my $class = shift;
    my %args = @_;
    my $caller = caller(0);

    no strict 'refs';
    *{"${caller}::connect"} = sub {
        $router->connect(@_);
    };
    *{"$caller\::_dispatch"} = \&_dispatch;
}

sub _dispatch {
    my ($class, $req) = @_;
    if( my $p = $router->match($req->env) ){
        return $p;
    }else{
        return;
    }
}

1;
