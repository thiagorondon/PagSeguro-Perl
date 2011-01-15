
package PagSeguro::Base;

use Moose::Role;
use MooseX::Types::Email qw/EmailAddress/;
use Moose::Util::TypeConstraints;


has ref_transacao => (
    is => 'ro',
    isa => 'Str'
);

has email_cobranca => (
    isa => EmailAddress,
    required => 1,
    is => 'ro'
);

enum 'TipoFrete' => qw(EN SD);

has tipo_frete => (
    is => 'ro',
    isa => 'TipoFrete',
    default => 'EN'
);

enum 'TipoCarrinho' => qw(CBR CP);

has tipo_carrinho => (
    is => 'ro',
    isa => 'TipoCarrinho',
    default => 'CBR'
);

has moeda => (
    is => 'ro',
    isa => 'Str',
    default => 'BRL'
);

1;

