
package PagSeguro;

use Moose;
with 'PagSeguro::Cliente';
with 'PagSeguro::Base';

use MooseX::Types::Email qw/EmailAddress/;
use Moose::Util::TypeConstraints;
use HTML::Zoom;
use PagSeguro::Item;
use namespace::autoclean;

our $VERSION = '0.001';

has 'items' => (
    is      => 'ro',
    isa     => 'ArrayRef[PagSeguro::Item]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        all_items   => 'elements',
        add_items   => 'push',
        count_items => 'count',
    }
);

has url_action => (
    is      => 'ro',
    isa     => 'Str',
    default => 'https://pagseguro.uol.com.br/checkout/checkout.jhtml'
);

has form_name => (
    is      => 'rw',
    isa     => 'Str',
    default => 'pagseguro'
);

has image_submit => (
    is  => 'rw',
    isa => 'Str',
    default =>
'https://p.simg.uol.com.br/out/pagseguro/i/botoes/pagamentos/99x61-pagar-assina.gif'
);

has zoom => (
    is      => 'ro',
    isa     => 'HTML::Zoom',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my ( $form_name, $url_action ) =
          ( $self->form_name, $self->url_action );
        HTML::Zoom->from_html(<<HTML);
<form class="$form_name" action="$url_action">
<input />
</form>
HTML
    }
);

has fields => (
    is         => 'ro',
    isa        => 'ArrayRef[Any]',
    lazy       => 1,
    auto_deref => 1,
    default    => sub {
        my $self = shift;
        my @fields;
        map {
            push( @fields,
                { name => $_, type => 'hidden', value => $self->$_ } )
              if $self->$_;
          } (
            qw[url_action email_cobranca tipo_carrinho tipo_frete moeda
              cliente_nome cliente_cep cliente_end cliente_num cliente_compl
              cliente_bairro cliente_cidade cliente_uf cliente_pais cliente_ddd
              cliente_tel cliente_email]
          );

        my $loop = 0;
        map {
            $loop++;
            my $item = $_;
            push(
                @fields,
                {
                    name  => join( '_', 'item', $_, $loop ),
                    type  => 'hidden',
                    value => $item->$_
                }
            ) for (qw[id descr quant valor frete peso]);

        } $self->all_items;

        push(
            @fields,
            {
                name  => 'submit',
                type  => 'hidden',
                value => $self->image_submit
            }
        );

        return \@fields;
    }
);

sub make_form {
    my $self = shift;

    my $form = $self->zoom->select( '.' . $self->form_name )->repeat_content(
        [
            map {
                my $field = $_;
                sub {
                    $_->select('input')
                      ->add_to_attribute( name => $field->{name} )
                      ->then->add_to_attribute( type  => $field->{type} )
                      ->then->add_to_attribute( value => $field->{value} );
                  }
              } $self->fields
        ]
    )->to_html;

    return $form;
}

1;

__END__

=pod

=head1

PagSeguro -  Biblioteca PagSeguro Perl

=head1 SYNOPSIS

    use PagSeguro;
    use PagSeguro::Item;

    my $pagseguro = PagSeguro->new(
        email_cobranca => 'foo@bar.com.br',

        cliente_nome => 'Nome do cliente',
        cliente_cep => '29200720',
        cliente_num => '12',
        cliente_compl => 'Sala 109',
        cliente_bairro => 'Bairro do Cliente',
        cliente_cidade => 'Cidade do Cliente',
        cliente_uf => 'MS'
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

    print $pagseguro->make_form;

=head1 DESCRIPTION

(TODO)

=head1 AUTHOR

Thiago Rondon. L<thiago@nsms.com.br>

=head1 COPYRIGHT AND LICENSE

Copyright 2011 by NSMS, http://www.nsms.com.br/

L<http://www.nsms.com.br>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

