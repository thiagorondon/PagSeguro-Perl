#!/usr/bin/env perl

use Moose;
use Test::More tests => 5;
use Test::Exception;
use PagSeguro::Item;


throws_ok { PagSeguro::Item->new } qr/id/, 'Throws as "without required"
attrs';

my $obj = new PagSeguro::Item(
    id => 1,
    descricao => 'Foo',
    quantidade => 1,
    valor => 100);

for my $item (qw[id descricao quantidade valor]) {
    ok( $obj->can($item) );
}

