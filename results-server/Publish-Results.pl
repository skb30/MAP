#!/bin/perl 
use POSIX qw(strftime);
use SuiteDriver;

my $rc;
my $product = "projcl";
my $release = "r510";
my $regression = "5";

$rc = SuiteDriver::publish ($product, $release, $regression );
