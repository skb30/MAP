#!/bin/perl
use strict;
use warnings;
use Cwd;
use Cfg;
use ResultsServer;

my $server = 'test';

my $database;

# determine which DB to store the results in. 
if (lc($server) eq 'prod') {$database = "MAP2";} else { $database = "MAP2-TEST";}
my $dbh         = ResultsServer::get_connection('usmghcentosqa.asg.com', "$database", '[scottba]', 'qamap');
my @regressions = ResultsServer::update_regression_status($dbh);
foreach my $regression (@regressions) {

	chomp ($regression);
	print "$regression\n";
}


ResultsServer::disconnect($dbh);


