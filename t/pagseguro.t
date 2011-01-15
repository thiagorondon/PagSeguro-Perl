#!/usr/bin/env perl

use Moose;
use Test::More tests => 3;
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

is( $pagseguro->count_items, 2);

my $valid = <<HTML;
<form class="pagseguro" action="https://pagseguro.uol.com.br/checkout/checkout.jhtml">
<input name="url_action" type="hidden" value="https://pagseguro.uol.com.br/checkout/checkout.jhtml" />

<input name="email_cobranca" type="hidden" value="foo\@bar.com.br" />

<input name="tipo_carrinho" type="hidden" value="CBR" />

<input name="tipo_frete" type="hidden" value="EN" />

<input name="moeda" type="hidden" value="BRL" />

<input name="cliente_nome" type="hidden" value="Nome do cliente" />

<input name="cliente_cep" type="hidden" value="29200720" />

<input name="cliente_num" type="hidden" value="12" />

<input name="cliente_compl" type="hidden" value="Sala 109" />

<input name="cliente_bairro" type="hidden" value="Bairro do Cliente" />

<input name="cliente_cidade" type="hidden" value="Cidade do Cliente" />

<input name="cliente_uf" type="hidden" value="MS" />

<input name="cliente_ddd" type="hidden" value="67" />

<input name="cliente_tel" type="hidden" value="23451234" />

<input name="cliente_email" type="hidden" value="emaildocliente\@cliente.com.br" />

<input name="item_id_1" type="hidden" value="1" />

<input name="item_descr_1" type="hidden" value="Descricao do Produto" />

<input name="item_quant_1" type="hidden" value="1" />

<input name="item_valor_1" type="hidden" value="100" />

<input name="item_frete_1" type="hidden" value="0" />

<input name="item_peso_1" type="hidden" value="0" />

<input name="item_id_2" type="hidden" value="ab1" />

<input name="item_descr_2" type="hidden" value="Descricao do Segundo Produto" />

<input name="item_quant_2" type="hidden" value="1" />

<input name="item_valor_2" type="hidden" value="100" />

<input name="item_frete_2" type="hidden" value="0" />

<input name="item_peso_2" type="hidden" value="0" />

<input name="submit" type="hidden" value="https://p.simg.uol.com.br/out/pagseguro/i/botoes/pagamentos/99x61-pagar-assina.gif" />
</form>
HTML

is ($pagseguro->make_form, $valid);

