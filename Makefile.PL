
use inc::Module::Install;

name 'PagSeguro';
license 'perl';
version_from 'lib/PagSeguro.pm';

requires 'Moose';
requires 'namespace::autoclean';
requires 'MooseX::Types::Email';
requires 'HTML::Zoom';
requires 'strictures';

test_requires 'Test::More';
test_requires 'Test::UseAllModules';
test_requires 'Test::Pod::Coverage' => '1.08';
test_requires 'Test::Pod' => '1.41';

tests 't/*.t';

auto_install;
WriteAll;


1;

