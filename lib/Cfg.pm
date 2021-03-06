#!/bin/perl
package Cfg;
use strict;
use warnings;
use CfgIni;
sub spawn { bless {}; }

#my $cfg                 = "sfrrc840.ini";   # update with Configuration file name
my $cfg                 = "run-settings.ini";   # update with Configuration file name  

my $name   				= "Unknown"; 
my $status 				= "Unknown";
my $suite_pass_cnt 		= 0;
my $suite_fail_cnt 		= 0;
my $suite_run_cnt  		= 0; 
my $line_number    		= 0;
my $suite_not_run_cnt 	= 0;
my $sort_status 		= 0;
my $verify_status       = 0;
my $cwd;



sub set_cwd {
	$cwd = shift;
}

sub get_cwd {
	return $cwd;
}

sub set_verify_status {
	
	$verify_status = shift;
#	print "!!! setting verify_status to: $verify_status\n";
}

sub get_verify_status {
	return $verify_status;
}

sub set_script_status {
	$status = shift;
}
sub set_suite_run_cnt {
	$suite_run_cnt = shift;
}
sub get_suite_run_cnt {
	return $suite_run_cnt;
}

sub set_suite_not_run_cnt {
	$suite_not_run_cnt = shift;
}
sub get_suite_not_run_cnt {
	return $suite_not_run_cnt;
}
sub get_sort_status {
	return $sort_status;
}
sub set_suite_pass_cnt {
	$suite_pass_cnt = shift;
}
sub get_suite_pass_cnt {
	return $suite_pass_cnt;
}
sub set_suite_fail_cnt {
	$suite_fail_cnt = shift;
}
sub get_suite_fail_cnt {
	return $suite_fail_cnt;
}
sub get_script_status {
	return $status;
}
sub set_script_name {
	$name = shift;
}
sub get_script_name {
	return $name;
}
sub set_line_num {
	$line_number = shift;
}
sub set_sort_status {
	$sort_status = shift;
}
sub get_line_num {
	return $line_number;
}

sub get_ini_file_name {
	return $cfg;
}

sub getcfg {
	
	my $ref = CfgIni->new;
	my $hash = $ref->build($cfg);
	return $hash;

}

sub getLocalCFG {

	my $ref = CfgIni->new;
	my $hash = $ref->create_hash($cfg);
	return $hash;

}
1;
