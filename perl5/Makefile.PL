use inc::Module::Install;

name 'Check';
all_from 'lib/Check.pm';
install_script 'check.pl';

WriteAll;
