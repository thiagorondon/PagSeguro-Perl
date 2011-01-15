
package PagSeguro::Item;

use Moose;

for my $item (qw/quant valor/) {
    has $item => (
        is       => 'rw',
        isa      => 'Int',
        required => 1
    );
}

for my $item (qw/id descr/) {
    has $item => (
        is       => 'rw',
        isa      => 'Str',
        required => 1
    );
}

for my $item (qw/frete peso/) {
    has $item => (
        is  => 'rw',
        isa => 'Str',
    );
}

1;

