#!/usr/bin/env perl

use Moose;
use Test::More tests => 5;

package Base::Test;

    use Moose;
    with 'PagSeguro::Base';

    1;

package main;

my $obj = new Base::Test( email_cobranca => 'foo@bar.com' );

for my $item (qw[ref_transacao email_cobranca tipo_frete tipo moeda]) {
    ok( $obj->can($item) );
}

