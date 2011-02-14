package Rumi::Web::Plugin::FillInForm;
use strict;
use warnings;
use Rumi::Util;
use HTML::FillInForm::Lite;

sub init {
    my ($class, $c, $conf) = @_;
    Rumi::Util::add_method(ref $c, 'fillin_form', \&_fillin_form);
}

sub _fillin_form {
    my ( $self, @stuff ) = @_;
    $self->add_trigger(
        'HTML_FILTER' => sub {
            my ( $c, $html ) = @_;
            return HTML::FillInForm::Lite->fill( \$html, @stuff );
        },
    );
}

1;
