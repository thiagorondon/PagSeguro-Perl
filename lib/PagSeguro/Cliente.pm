
package PagSeguro::Cliente;

use Moose::Role;

for my $item (qw[nome cep end num compl bairro cidade uf pais ddd tel email])
{

    has "cliente_$item" => (
        is => 'rw',
        isa => 'Str'
    );
}

1;


