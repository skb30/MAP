#!/usr/bin/perl
use strict;
use warnings;
use DBI;

main (@ARGV);

sub main {
	my $tablename = "products";
    my @row;
	my $dbh = connect2DB('usmghcentosqa.asg.com', 'MAP', '[scottba]', 'qamap');

#	getByColumn($dbh, $tablename, "MGH"); 
#	listTable($dbh, $tablename );
#   insertProduct($dbh, $tablename);
	deleteProduct($dbh, $tablename, "DOCUTEXT");

	$dbh->disconnect();
}
sub deleteProduct {
	my $dbh       = shift;
	my $tablename = shift;
	my $product   = shift; 
	
	my $sql = "DELETE FROM $tablename WHERE $tablename.name = '$product'";
	my $rc = $dbh->do($sql); 
	
	if ($rc) {
		# no entry found in table
		if ($rc == '0E0') {
			print "Product $product not found in $tablename table.\n";
		} else {
			print "The number of row(s) delete from $tablename : $rc\n";
		}
	} else {
		print "Delete unsuccessful $rc\n";
	}

	return $rc; 
}
sub insertProduct {
	my $dbh       = shift;
	my $tablename = shift;
	
	my $sth = $dbh->prepare("INSERT INTO $tablename(name,site,platform,visible) VALUES (?,?,?,?)");
	$sth->execute('DOCUTEXT', 'MGH', 'z/os', '1');
	
	return; 
}
sub getByColumn {
	my $dbh         = shift;
	my $tablename   = shift;
	my $column      = shift;
	
	if (!$dbh || !$tablename || $column) {
		print "missing parameter(s)\n";
		return;
	}
	my @rows;
	
	my $sth = $dbh->prepare("SELECT * FROM $tablename WHERE site=?");
 	$sth->execute( qq[$column] );

	while ( @rows = $sth->fetchrow_array ) {
	  print "@rows\n";
	}
	
}

sub listTable {
	my $dbh       = shift;
	my $tablename = shift;
	if (!$dbh || !$tablename) {
		print "missing parameter(s)\n";
		return;
	}
	my @row; 
    my $sth = $dbh->prepare("SELECT * FROM $tablename");
 	$sth->execute();
	while (@row = $sth->fetchrow_array) {
    	print "$row[0]:$row[1]:$row[2]:$row[3]:$row[4]\n";
	}
	
}

sub connect2DB {
	my $host       = shift;
	my $db         = shift;
	my $user       = shift;
	my $password   = shift;
	my $dsn        = "DBI:mysql:$db;host=$host";
	                       
	my $dbh = DBI->connect($dsn, $user, $password 
	       ) || die "Could not connect to database: $DBI::errstr";
	 
	return $dbh;
}



