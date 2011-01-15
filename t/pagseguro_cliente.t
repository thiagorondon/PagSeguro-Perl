#!/usr/bin/env perl

use Moose;
use Test::More tests => 12;

package Cliente::Test;

    use Moose;
    with 'PagSeguro::Cliente';

    1;

package main;

my $obj = new Cliente::Test;

for my $item (qw[nome cep end num compl bairro cidade uf pais ddd tel email])
{
    ok( $obj->can("cliente_$item") );
}

