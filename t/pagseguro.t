#!/usr/bin/env perl

use Moose;
use Test::More tests => 1;
use Test::Exception;
use PagSeguro;
use PagSeguro::Item;

#throws_ok { PagSeguro->new } qr/be a valid e-mail/, 'Throws as "without required" attrs';

lives_ok { PagSeguro->new( email_cobranca => 'thiago@aware.com.br') }
    'thiago@aware.com.br is an ok email' ;

my $pagseguro = PagSeguro->new(
    email_cobranca => 'foo@bar.com.br',

    cliente_nome => 'Nome do cliente',
    cliente_cep => '29200720',
    cliente_num => '12',
    cliente_compl => 'Sala 109',
    cliente_bairro => 'Bairro do Cliente',
    cliente_cidade => 'Cidade do Cliente',
    cliente_uf => 'MS',
    cliente_ddd => '67',
    cliente_tel => '23451234',
    cliente_email => 'emaildocliente@cliente.com.br'
);

$pagseguro->add_items(
    PagSeguro::Item->new(
        id => 1,
        descr => 'Descricao do Produto',
        quant => 1,
        valor => 100,
        frete => 0,
        peso => 0
    )
);

$pagseguro->add_items(
    PagSeguro::Item->new(
        id => 'ab1',
        descr => 'Descricao do Segundo Produto',
        quant => 1,
        valor => 100,
        frete => 0,
        peso => 0
    )
);

print $pagseguro->make_form;

