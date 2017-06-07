#!/bin/perl
# This object is used as a facade for the orginal Cfg.pm file. 
# It allows the user to declaratively chose the the configuation.ini file.
#
# The Cfg.pm class now points to the product.ini file that will be used. 
#


package CfgIni;
use Util;
use strict;
use IO::File;
use Cwd;

# class data
our $VERSION = "0.1";

# used to create the ini file hash when the suites are being run outside the normal file structure
sub create_hash {
	
	# $self needs to be shifted because this is an object 
	my ($self, $file)  = @_;
	# build path
	my $dir = getcwd();
	my $path = $dir . "/" . $file;
#	my $path = "D:/Eclipse-Workspace-Juno-MAP/SF-MVS-820/run-settings.ini";
	my %hash;
	open( FILE, "<", $path )or die("Couldn't open $path - $!\n");
 
	while (<FILE>) {
	   my ($key, $val) = split /=/;
	   $val = Util::trim ($val);
	   $key = Util::trim ($key);
	   if (defined $val && defined $key) {
	   		$hash{$key} .= exists $hash{$key} ? "$val" : $val;
	   } 
	}
    return \%hash;
	
}
sub new {
	my $class = shift;
	my $self = {}; # anonomous hash
	bless ($self, $class);
	return $self;
}
sub build {
	my ($self, $file)  = @_;
	my %hash;
	
	# setup default config file name
	if (!defined $file) {
		$file = "run-settings.ini";
	}
	# find the path to the product folder
	
	# where am I currently? 
	my $dir = getcwd();
#	print "Current Dir:  $dir\n";
	
	my $path2Product;
	my $product;
	my $path;
	
	
	# Get the product path
	if ($dir =~ m/(.*)\/.*\/mainframe\//.*/) {
		$path2Product = $1;
#		print "path2Product: $path2Product \n";
	} else {
		print "+++ Unable to configuration file using this path: $dir +++ \n";
	}
	
	# get the name of the product folder
	if ($dir =~ m/.*\/(.*)\/mainframe\//.*/) {
		$product = $1;
#		print "product: $product \n";
	} else {
		print "+++ Unable to find Product in Configuration path of $dir +++ \n";
	}

	# build the absoulte path to the configuration file 
	$path = $path2Product . "/" . $product . "/" . $file;
#	print "absolute path to config file: $path \n";
	
	# we have the file let's go
			
	open( FILE, "<", $path )or die("Couldn't open $path - $!\n");
 
	while (<FILE>) {
	   my ($key, $val) = split /=/;
	   $val = Util::trim ($val);
	   $key = Util::trim ($key);
	   if (defined $val && defined $key) {
	   		$hash{$key} .= exists $hash{$key} ? "$val" : $val;
	   } 
	}
    return \%hash;
}

1;
