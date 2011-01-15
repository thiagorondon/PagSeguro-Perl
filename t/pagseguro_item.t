#!/usr/bin/env perl

use Moose;
use Test::More tests => 5;
use Test::Exception;
use PagSeguro::Item;


throws_ok { PagSeguro::Item->new } qr/quant/, 'Throws as "without required"
attrs';

my $obj = new PagSeguro::Item(
    id => 1,
    descr => 'Foo',
    quant => 1,
    valor => 100);

for my $item (qw[id descr quant valor]) {
    ok( $obj->can($item) );
}

