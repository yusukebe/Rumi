use inc::Module::Install;
name 'Rumi';
all_from 'lib/Rumi.pm';

requires 'Plack::Request';
requires 'Router::Simple';
requires 'File::Spec';
requires 'Text::Xslate';
requires 'Data::Recursive::Encode';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
