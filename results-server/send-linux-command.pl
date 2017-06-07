#!/bin/perl 
use POSIX qw(strftime);
use SuiteDriver;

my $rc;
my $path2Suite = "/mnt/claudie/Results_Server/map-site/products/infox/";

SuiteDriver::sendLinuxCommand("cp -r $path2Suite/setup.txt /var/www/map_site/products/infox/.  ");


