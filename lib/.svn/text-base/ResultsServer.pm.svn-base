#!/bin/perl
package ResultsServer;
use strict;
use warnings;
use DBI;
use Cwd;
use Util;
use Cfg;



sub get_connection {
	my $host       = shift;
	my $db         = shift;
	my $user       = shift;
	my $password   = shift;
	my $dsn        = "DBI:mysql:$db;host=$host";
	                       
	my $dbh = DBI->connect($dsn, $user, $password 
	       ) || die "Could not connect to database: $DBI::errstr";
	 
	return $dbh;
}

sub disconnect {
	my $dbh = shift;
	
	my $rc = $dbh->disconnect();
	
	return $rc;
	
}

sub update_regression_status {
	
	# This fucntion will update the regression table's passsed/failed fields
	
	my $dbh = shift;
	my $passed;
	my $failed;
	
	if (!$dbh) {print "update_regression_status is missing the DB handle)\n"; return -1;}
	
	my $sql = qq[
	SELECT regressionID FROM regression 
	];

	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";

	my $regressionID;
	my @regressions;

 	while ( $regressionID = $sth->fetchrow_array ) {
		$passed = get_status_count($dbh, $regressionID, "passed");
		$failed = get_status_count($dbh, $regressionID, "failed");
		print "$regressionID passed = $passed | $failed\n";
		update_status_by_regressionID($dbh, $regressionID, $passed, "passed");
		update_status_by_regressionID($dbh, $regressionID, $failed, "failed");
 	}
	return;
}

sub update_regression_status_by_ID {
	
	# This fucntion will update the regression table's passsed/failed fields
	
	my $dbh = shift;
	my $regressionID = shift;
	my $passed;
	my $failed;
	
	if (!$dbh) {print "update_regression_status is missing the DB handle)\n"; return -1;}
	
	if (isdigit($regressionID) && $regressionID > 0) {
		$passed = get_status_count($dbh, $regressionID, "passed");
		$failed = get_status_count($dbh, $regressionID, "failed");
		print "$regressionID passed = $passed | $failed\n";
		update_status_by_regressionID($dbh, $regressionID, $passed, "passed");
		update_status_by_regressionID($dbh, $regressionID, $failed, "failed");
	} else {
		message ("+++ Invalid regression ID. +++");
	}
	return;
}

sub update_status_by_regressionID {
	# This fucntion will update the regression table's passsed/failed fields
	
	my $dbh   = shift;
	my $regID = shift;
	my $total = shift;
	my $type  = shift;
	
	my $query;

	
	if (!$dbh)   {print "+++ update_status_by_regressionID is missing the DB handle +++\n"; return -1;}
	if (!$regID) {print "+++ update_status_by_regressionID is missing the regID parm +++\n"; return -1;}
	if (!$type)  {print "+++ update_status_by_regressionID is missing the passed/failed type parm +++\n"; return -1;}
	
	$query .= "UPDATE regression SET $type = $total ";
	$query .= "WHERE  ";
	$query .= "regression.regressionID = $regID ";

	my $sth = $dbh->prepare($query);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	return;
}
sub get_status_count {
	my $dbh          = shift;
    my $regressionID = shift;
    my $type         = shift;
    
    my $query; 
    my $count;
    my @row; 
    
	$query .= "SELECT  COUNT(*) AS total ";
	$query .= "FROM regression, suite, script ";
	$query .= "WHERE  ";
	$query .= "regression.regressionID = suite.regressionID ";
	$query .= "AND suite.suiteID = script.suiteID ";
	$query .= "AND regression.regressionID = '$regressionID' ";
	$query .= "AND script.status ='$type' ";

	my $sth = $dbh->prepare($query);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";

	@row = $sth->fetchrow_array; 

	$count = $row[0];
	
	return $count;
}
sub get_regression {
	my $dbh             = shift;
	my $buildInfo		= shift;
	my $stime 			= shift;
	my $etime			= shift; 
	my $elapsedTime 	= shift;
	my $rts 			= shift;
	
	if (!$dbh || !$buildInfo || !$stime || !$etime || !$elapsedTime || !$rts ) {
		print "get_regression missing parameter(s)\n";
		return -1;
	}
	
	my $sql = qq[
	SELECT regressionID FROM regression
		WHERE buildinfo = '$buildInfo'
		AND   start     = '$stime'
		AND   end       = '$etime'
		AND   elapsed   = '$elapsedTime'
	];
#	print "$sql\n";
	
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	# if we already have a record in the DB then return true
	if ($rc != '0E0' ) {
		message ("WWW Regression already in regression table. Skipping. WWW");
		$rc = 1;
	} else {
		$rc = 0;
	}
	return $rc;
}
sub get_suite_id {
	my $dbh            = shift;
	my $regressionID   = shift;
	my $suite          = shift;
	my $suiteID;
	my $num;
	my @rows;
	
	if (!$dbh || !$regressionID|| !$suite) {
		print "get_suite_id missing parameter(s)\n";
		return -1;
	}
	
	my $sql = qq[
	SELECT suiteID FROM suite
		WHERE regressionID = '$regressionID'
		AND   name         = '$suite'
	];
	
#	print $sql;
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc == '0E0' ) {
		message ("*** get_suite_id:  $suite with regressionID of: $regressionID not in suites table. ***");
		return $rc;
	}
	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 1) {
 		$suiteID = shift @rows;
 	} else {
 		message ("More than one $suite in suites table.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		message( "@rows\n");
		}
		$suiteID = '-1';
 	}
	return $suiteID;
}
sub get_script_id {
	
	my $dbh         = shift;
	my $suiteID     = shift;
	my $script      = shift;
	my $sth;
	my $num;
	my $scriptID;
	my $rc;
	my @rows;
	
	if (!$dbh || !$suiteID ||!$script ) {
		print "missing parameter(s)\n";
		return;
	}
	my $sql  = qq[SELECT scriptID FROM script WHERE name=? ];
	   $sql .= qq[AND suiteID =? ];
	
	
	$sth = $dbh->prepare($sql);
 	$rc = $sth->execute($script, $suiteID )or die "SQL Error: $DBI::errstr\n";
 	
 	if ($rc == '0E0') {
 		return $rc;
 	}
 	
 	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 1) {
 		$scriptID = shift @rows;
 	} else {
 		message ("More than one productID in products table.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$scriptID = '-1';
 	}
	return $scriptID;
}
sub get_folder_data_id {
	
	my $dbh         = shift;
	my $scriptID    = shift;
	my $fileName    = shift;
	my $folder      = shift;
	my $table;
	my $id;
	my $sth;
	my $num;
	my $rc;
	my $col;
	my @rows;
	
	if (!$dbh || !$scriptID ||!$fileName || !$folder ) {
		print "get_folder_data_id() missing parameter(s)\n";
		exit;
	}
	
	# determine what folder it is
	if ($folder eq "exp_data") {
		$table = "exp_files";
		$col   = "exp_fileID";
	} elsif ($folder eq "current_data") {
		$table = "current";
		$col   = "currentID";
	} elsif ($folder eq "differences") {
		$table = "differences";
		$col   = "differenceID";
	} else {
		message ("+++ get_folder_data_id() +++ Unknown folder name of: $folder\n");
		exit;
	}

	my $sql  = qq[SELECT $col FROM $table WHERE name=? ];
	   $sql .= qq[AND scriptID =? ];
	
	$sth = $dbh->prepare($sql);
 	$rc = $sth->execute($fileName, $scriptID )or die "SQL Error: $DBI::errstr\n";
 	
 	if ($rc == '0E0') {
 		return $rc;
 	}
 	
 	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 1) {
 		$id = shift @rows;
 	} else {
 		message ("More than one productID in products table.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$id = '-1';
 	}
	return $id;
}
sub get_exp_id_bkup {
	
	my $dbh         = shift;
	my $scriptID    = shift;
	my $fileName    = shift;
	my $expID;
	my $sth;
	my $num;
	my $rc;
	my @rows;
	
	if (!$dbh || !$scriptID ||!$fileName ) {
		print "missing parameter(s)\n";
		return;
	}
	my $sql  = qq[SELECT exp_fileID FROM exp_files WHERE name=? ];
	   $sql .= qq[AND scriptID =? ];
	
	
	$sth = $dbh->prepare($sql);
 	$rc = $sth->execute($fileName, $scriptID )or die "SQL Error: $DBI::errstr\n";
 	
 	if ($rc == '0E0') {
 		return $rc;
 	}
 	
 	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 1) {
 		$expID = shift @rows;
 	} else {
 		message ("More than one productID in products table.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$expID = '-1';
 	}
	return $expID;
}



sub get_site_id {
	
	my $dbh         = shift;
	my $siteName    = shift;
	my $siteID;
	my $num;
	my @rows;
	
	if (!$dbh || !$siteName) {
		message ("+++ get_site_id(dbh, siteName,  missing parameter(s) +++");
		return -1;
	}
	
	
   my $sql = qq[
	SELECT siteID FROM site WHERE name = '$siteName'
	];
	
#	print $sql;
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc == '0E0' ) {
		return $rc; 
	}

 	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 0) {
 		message ("$siteName not found in table.");
 		$siteID = -1;
 		
 	} elsif ($num == 1) {
 		$siteID = shift @rows;
 	} else {
 		message ("More than one $siteName in sites table.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$siteID = '-1';
 	}
	return $siteID;
}

sub get_lpar_id {
	
	my $dbh         = shift;
	my $lparname    = shift;
	my $lparID;
	my $num;
	my @rows;
	
	if (!$dbh || !$lparname) {
		message ("+++ get_lpar_id(dbh, $lparname,  missing parameter(s) +++");
		return -1;
	}
	
	
   my $sql = qq[
	SELECT lparID FROM lpar WHERE name = '$lparname'
	];
	
#	print $sql;
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc == '0E0' ) {
		return $rc; 
	}

 	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 0) {
 		message ("$lparname not found in table.");
 		$lparID = -1;
 		
 	} elsif ($num == 1) {
 		$lparID = shift @rows;
 	} else {
 		message ("More than one $lparname in sites table.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$lparID = '-1';
 	}
	return $lparID;
}


sub get_os_id {
	
	my $dbh         = shift;
	my $osname      = shift;
	my $osversion   = shift;
	my $osID;
	my $num;
	my @rows;
	
	if (!$dbh || !$osname || !$osversion) {
		message ("+++ get_os_id(dbh, os,  missing parameter(s) +++");
		return -1;
	}
	
	
   my $sql = qq[
	SELECT osID FROM os WHERE name = '$osname' AND version = '$osversion'
	];
	
#	print $sql;
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc == '0E0' ) {
		return $rc; 
	}

 	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 0) {
 		message ("$osname not found in os table.");
 		$osID = -1;
 		
 	} elsif ($num == 1) {
 		$osID = shift @rows;
 	} else {
 		message ("More than one $osname in sites table with version $osversion.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$osID = '-1';
 	}
	return $osID;
}

sub get_subsystem_id {
	
	my $dbh         = shift;
	my $subname     = shift;
	my $subversion  = shift;
	my $subID;
	my $num;
	my $sql;
	my @rows;
	
	if (!$dbh || !$subname || !$subversion ) {
		message ("+++ get_subsystem_id(dbh, subname, subversion  missing parameter(s) +++");
		return -1;
	}
   if ($subname eq "N/A" || !defined($subname)) {
   	   $sql = qq[
		SELECT subsystemID FROM subsystem WHERE name = '$subname'
		];
   	
   } else {
   		$sql = qq[
		SELECT subsystemID FROM subsystem WHERE name = '$subname' AND version = '$subversion'
		];
   }
 
	
#	print $sql;
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc == '0E0' ) {
		return $rc; 
	}

 	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 0) {
 		message ("$subname not found in subsystem table.");
 		$subID = -1;
 		
 	} elsif ($num == 1) {
 		$subID = shift @rows;
 	} else {
 		message ("More than one $subname in subsystem table with version $subversion.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$subID = '-1';
 	}
	return $subID;
}


sub get_product_id {
	
	my $dbh         = shift;
	my $productName = shift;
	my $release     = shift;
	my $productID;
	my $num;
	my @rows;
	
	if (!$dbh || !$productName) {
		print "missing parameter(s)\n";
		return -1;
	}
	
	
   my $sql = qq[
	SELECT productID FROM product WHERE product.name = '$productName' AND product.release = '$release';
	];
	
#	print $sql;
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc == '0E0' ) {
		return $rc; 
	}

 	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 0) {
 		message ("$productName  $release not found in table.");
 		$productID = -1;
 		
 	} elsif ($num == 1) {
 		$productID = shift @rows;
 	} else {
 		message ("More than one productID in products table.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$productID = '-1';
 	}
	return $productID;
}

sub get_regression_id {
	
	my $dbh        = shift;
	my $releaseID  = shift;
	my $reg_name   = shift;
	my $regressionID;
    my $num;
	my @rows;
	
	
	if (!$dbh || !$releaseID || !$reg_name) {
		message ("+++missing parameter(s)+++");
		return;
	}
	
	my $sql = qq[
	SELECT regressionID FROM regressions
		WHERE releaseID = '$releaseID'
		AND   name      = '$reg_name'
	
	];
	
#	print $sql;
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc == '0E0' ) {
		message ("+++ Regression name $reg_name with releaseID of: $releaseID is missing in DB +++ ");
		return $rc;
	}
	
	@rows = $sth->fetchrow_array;
 	
 	# determine if we have more then 1 product ID
 	$num = @rows;
 	
 	if ($num == 1) {
 		$regressionID = shift @rows;
 	} else {
 		message ("More than one $reg_name in regressions table.");
 		while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
		}
		$regressionID = '-1';
 	}
	return $regressionID;
}

sub list_regressions_for_product {
	
	my $dbh         = shift;
	my $productName = shift;

	my $sth;
	my $rc;
	my @rows;
	
	if (!$dbh || !$productName) {
		print "missing parameter(s)\n";
		return;
	}
	
	my $sql = qq[
	SELECT products.name,  releases.name, releases.releaseID, regressions.name
    FROM products, releases, regressions
	WHERE products.productID        = releases.productID
    AND   releases.releaseID        = regressions.releaseID
    AND   products.name = '$productName';

	];
	
	$sth  = $dbh->prepare($sql);
	$rc   = $sth->execute();
	
	while ( @rows = $sth->fetchrow_array ) {
	  		print "@rows\n";
	}
	return \@rows;
	
}
sub message {
	my $path = Cfg::get_cwd();
	my $message = shift;
	print ("ResultsServer: $message\n");
	
	# now print to the log
    open(LOG, ">>$path/publish-results.log") or die("Couldn't open: $!\n");
	print (LOG "$message\n");
    close LOG;
	
	
}
sub process_exp_files {
	my $script = shift;
	
    # drill into the script folder
	chdir($script);
	my @files = <*>; 
	foreach my $script_folder_file (@files) {
		if (-d $script_folder_file) {
			# determine if its the expected folder
			if ($script_folder_file =~ m/exp_data/) {
				# drill into the exp_data folder
				chdir($script_folder_file);
				my @exp_files = <*>;
				foreach my $exp_file ( @exp_files) {
#				my $rc = ResultsServer::load_expected_file($dbh, "1", $exp_file);				 
				}
				chdir ("..");
				message("   Expected direcotry: $script_folder_file");
			}
#		message("   script direcotry: $script_folder_file");
		} else {
#			message("   script name: $script_folder_file");
		}
	}
	chdir("..");         
	return;
}		
sub add_folder_data {
	my $dbh            = shift;
	my $scriptID       = shift;
	my $fileName       = shift;
	my $folder         = shift;
	my $visible        = 1;
	my $table;
	my $col;
	my $id;
	my $contents;
	my $sql;
	my $type;
	
	if (!$dbh || !$scriptID || !$fileName || !$folder) {
		print "+++ add_folder_data() bad parameter list +++\n";
		exit;
	}
	# determine what folder it is so that we can process them all in 1 routine
	if ($folder eq "exp_data") {
		$table = "exp_files";
		$col   = "exp_fileID";
		$type  = "line-numbers";
	} elsif ($folder eq "current_data") {
		$table = "current";
		$col   = "currentID";
		$type  = "line-numbers";
	} elsif ($folder eq "differences") {
		$table = "differences";
		$col   = "differenceID";
	} else {
		message ("+++ add_folder_data() Unknown folder name of: $folder  +++\n");
		exit;
	}
	
	$contents = convert_file_2_scalar($fileName, $type) || "File not found: $fileName \n";

	
	my $sth = $dbh->prepare("INSERT INTO $table (scriptID, name, contents, visible) VALUES (?, ?, ?, ?)");
	my $rc  = $sth->execute($scriptID, $fileName, $contents, $visible) or die "SQL Error: $DBI::errstr\n";
	
	if ($rc) {
		# now get the ID for the inserted product
		$sql = qq[
	    SELECT $col FROM $table WHERE scriptID = '$scriptID'
	    AND name = '$fileName'
		];
#		print $sql;
		$sth    = $dbh->prepare($sql);
		$rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
		
	 	my @rows = $sth->fetchrow_array;
	 	
	 	# determine if we have more then 1 product ID
	 	my $num = @rows;
	 	
	 	if ($num == 0) {
	 		message ("WWW $fileName not found in $table  table. WWW");
	 		$id = -1;
	 		
	 	} elsif ($num == 1) {
	 		$id = shift @rows;
	 	} else {
	 		message ("WWW More than one $fileName in $table table. WWW");
	 		while ( @rows = $sth->fetchrow_array ) {
		  		print "@rows\n";
			}
			$id = '-1';
	 	}
	} 	
	return $id; 
}
sub add_script_not_used {
	my $dbh            = shift;
	my $suiteID        = shift;
	my $script         = shift;
	my $stime          = shift || "";
	my $etime          = shift || "";
	my $elapsedTime    = shift || "";
	my $status         = shift || "";
	my $log;
	my $source;
	
	if (!$dbh || !$suiteID || !$script) {
		print "missing parameter(s)\n";
		return;
	}
	
	# drill into script folder 
	chdir($script);
	
	$log      = convert_file_2_scalar("runlog.txt") || "No run-log on file system";
	$source   = convert_file_2_scalar("$script.pl") || "No script source on file system";
	
	chdir("..");
	
	if ($log =~ m/.*Ended with a status of:  Passed \*\*\*/) {
		$status = "passed";
	} else {
		$status = "failed";
	}
	# determine the start and end time for this script
	$log =~ m/(\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{1,2}:\d{1,2}).* started/;
	$stime = $1 || "Unknown";
	$log =~ m/(\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{1,2}:\d{1,2}).* Ended/;
	$etime = $1 || "Unknown";
	
	my $sth = $dbh->prepare("INSERT INTO script (suiteID, name, source, start, end, status, log) VALUES (?, ?, ?, ?, ?, ?, ?)");
	my $rc  = $sth->execute($suiteID, $script, $source, $stime, $etime, $status, $log) or die "SQL Error: $DBI::errstr\n";
	
	if ($rc != 0) {
		message ("$script successfully added to script table.");
	}
	return $rc; 
}
sub insertProduct {
	#
	# Insert a product into the products database. 
	#
	#
	my $dbh            = shift;
	my $product        = shift;
	my $release        = shift;
	my $productID;
	my $siteID;
	
	if (!$dbh || !$product || !$release) {
		message ("insertProduct (dbh, product, site) missing parameter(s).");
		return -1;
	}
	
	# all systems go for insert.
    my $sql = qq[
    INSERT INTO product (product.name, product.release, product.visible) VALUES ('$product', '$release', '1')
	];
	
	print $sql;
	my $sth    = $dbh->prepare($sql);
	my $rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc) {
		# now get the ID for the inserted product
		$sql = qq[
	    SELECT productID FROM product WHERE product.name = '$product' AND product.release = '$release';
		];
#		print $sql;
		$sth    = $dbh->prepare($sql);
		$rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
		
	 	my @rows = $sth->fetchrow_array;
	 	
	 	# determine if we have more then 1 product ID
	 	my $num = @rows;
	 	
	 	if ($num == 0) {
	 		message ("$product not found in table.");
	 		$productID = -1;
	 		
	 	} elsif ($num == 1) {
	 		$productID = shift @rows;
	 	} else {
	 		message ("More than one $product in table.");
	 		while ( @rows = $sth->fetchrow_array ) {
		  		print "@rows\n";
			}
			$productID = '-1';
	 	}
	}
	return $productID;
}

sub insertOS {
	#
	#
	#
	my $dbh            = shift;
	my $osname         = shift;
	my $version       = shift;
	my $osID;

	if (!$dbh || !$osname || !$version  ) {
		message ("insertOS (dbh, $osname, $version) missing parameter(s).");
		return -1;
	}
	# all systems go for insert.
    my $sql = qq[
    INSERT INTO os ( name, version) VALUES ('$osname', '$version')
	];
	
#	print $sql;
	my $sth    = $dbh->prepare($sql);
	my $rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc) {
		# now get the ID for the inserted product
		$sql = qq[
	    SELECT osID FROM os
	    WHERE name     = '$osname'
	    AND version    = '$version';
		];
#		print $sql;
		$sth    = $dbh->prepare($sql);
		$rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
		
	 	my @rows = $sth->fetchrow_array;
	 	
	 	# determine if we have more then 1 product ID
	 	my $num = @rows;
	 	
	 	if ($num == 0) {
	 		message ("$osname not found in table.");
	 		$osID = -1;
	 		
	 	} elsif ($num == 1) {
	 		$osID = shift @rows;
	 	} else {
	 		message ("More than one $osname in sites table.");
	 		while ( @rows = $sth->fetchrow_array ) {
		  		print "@rows\n";
			}
			$osID = '-1';
	 	}
	}
	
	return $osID;
	
}

sub insertSubsystem {
	#
	#
	#
	my $dbh           = shift;
	my $subname       = shift;
	my $subversion    = shift;
	my $subID;

	if (!$dbh || !$subname || !$subversion  ) {
		message ("insertSubsystem (dbh, $subname, $subversion) missing parameter(s).");
		return -1;
	}
	# all systems go for insert.
    my $sql = qq[
    INSERT INTO subsystem ( name, version) VALUES ('$subname', '$subversion')
	];
	
#	print $sql;
	my $sth    = $dbh->prepare($sql);
	my $rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc) {
		# now get the ID for the inserted product
		$sql = qq[
	    SELECT subsystemID FROM subsystem
	    WHERE name     = '$subname'
	    AND version    = '$subversion';
		];
#		print $sql;
		$sth    = $dbh->prepare($sql);
		$rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
		
	 	my @rows = $sth->fetchrow_array;
	 	
	 	# determine if we have more then 1 product ID
	 	my $num = @rows;
	 	
	 	if ($num == 0) {
	 		message ("$subname not found in subsystem table.");
	 		$subID = -1;
	 		
	 	} elsif ($num == 1) {
	 		$subID = shift @rows;
	 	} else {
	 		message ("More than one $subname in subsystem table.");
	 		while ( @rows = $sth->fetchrow_array ) {
		  		print "@rows\n";
			}
			$subID = '-1';
	 	}
	}
	
	return $subID;
	
}

sub insertLPAR {
	#
	#
	#
	my $dbh           = shift;
	my $lparname      = shift;
	my $lparID;

	if (!$dbh || !$lparname ) {
		message ("insertOS (dbh, $lparname) missing parameter(s).");
		return -1;
	}
	# all systems go for insert.
    my $sql = qq[
    INSERT INTO lpar ( name) VALUES ('$lparname')
	];
	
#	print $sql;
	my $sth    = $dbh->prepare($sql);
	my $rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc) {
		# now get the ID for the inserted product
		$sql = qq[
	    SELECT lparID FROM lpar
	    WHERE name     = '$lparname';
		];
#		print $sql;
		$sth    = $dbh->prepare($sql);
		$rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
		
	 	my @rows = $sth->fetchrow_array;
	 	
	 	# determine if we have more then 1 product ID
	 	my $num = @rows;
	 	
	 	if ($num == 0) {
	 		message ("$lparname not found in  LPAR table.");
	 		$lparID = -1;
	 		
	 	} elsif ($num == 1) {
	 		$lparID = shift @rows;
	 	} else {
	 		message ("More than one $lparname in LPAR table.");
	 		while ( @rows = $sth->fetchrow_array ) {
		  		print "@rows\n";
			}
			$lparID = '-1';
	 	}
	}
	
	return $lparID;
	
}
sub insertRegression {
	#
	# Insert a product into the products database. 
	#
	#
	my $dbh            = shift;
	my $productID      = shift;
	my $siteID         = shift;	
	my $osID           = shift;
	my $lparID         = shift;
	my $subID          = shift;
	my $regression     = shift;
	my $buildInfo      = shift;
	my $start          = shift;
	my $end            = shift;
	my $elapsed        = shift;
	my $rts            = shift;
	my $regressionID;
	
	my $numcheck = 0;
    
    $numcheck += isdigit($productID);
    $numcheck += isdigit($siteID);
    $numcheck += isdigit($osID);
    $numcheck += isdigit($lparID);
    $numcheck += isdigit($subID);
    
    if ($numcheck == 5) {
    	
    } else {
    	message ("insertRegression is missing a for foreign key. aborting regression");
    	exit;
    }

	# all systems go for insert.
    my $sql = qq[
    INSERT INTO regression (productID, siteID, osID, lparID, subsystemID, name, buildinfo, start, end, elapsed, rts) 
    	VALUES ('$productID', '$siteID', '$osID', '$lparID', '$subID', '$regression', '$buildInfo', '$start', '$end', '$elapsed', '$rts')
	];
	
#	print $sql;
	my $sth    = $dbh->prepare($sql);
	my $rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc) {
		# now get the ID for the inserted product
		$sql = qq[
	    SELECT regressionID FROM regression
	    WHERE name      = '$regression'
	    AND productID   = '$productID'
	    AND siteID      = '$siteID'
	    AND osID        = '$osID'
	    AND lparID      = '$lparID'
	    AND subsystemID = '$subID'
	    AND buildinfo   = '$buildInfo'
	    AND start       = '$start'
	    AND end         = '$end'
	    AND elapsed     = '$elapsed'
	    AND rts         = '$rts'
	    
		];
#		print $sql;
		$sth    = $dbh->prepare($sql);
		$rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
		
	 	my @rows = $sth->fetchrow_array;
	 	
	 	# determine if we have more then 1 product ID
	 	my $num = @rows;
	 	
	 	if ($num == 0) {
	 		message ("$regression not found in table.");
	 		$regressionID = -1;
	 		
	 	} elsif ($num == 1) {
	 		$regressionID = shift @rows;
	 	} else {
	 		message ("More than one $regression in sites table.");
	 		while ( @rows = $sth->fetchrow_array ) {
		  		print "@rows\n";
			}
			$$regressionID = '-1';
	 	}
	}
	
	return $regressionID;
	
}

sub insertSuite {
	#
	# Insert a product into the products database. 
	#
	#
	my $dbh            = shift;
	my $regressionID   = shift;
	my $suite          = shift;
	my $stime          = shift;
	my $etime          = shift;
	my $elapsed        = shift;
	my $passed         = shift;
	my $failed         = shift; 
	my $suiteID;

	
	if (!$dbh ||!$regressionID ||!$suite || !$stime || !$etime || !$elapsed) {
		message ("+++ insertSuite (dbh, regressionID, suiteName) missing parameter(s). ++++");
		exit;
	}

	
	# all systems go for insert.
    my $sql = qq[
    INSERT INTO suite (regressionID, name, start, end, elapsed, passed, failed)
    VALUES ('$regressionID', '$suite', '$stime', '$etime', '$elapsed', '$passed', '$failed')
	];
	
#	print $sql;
	my $sth    = $dbh->prepare($sql);
	my $rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
	
	if ($rc) {
		# now get the ID for the inserted product
		$sql = qq[
	    SELECT suiteID FROM suite
	    WHERE name     = '$suite'
	    AND regressionID  = '$regressionID';
		];
#		print $sql;
		$sth    = $dbh->prepare($sql);
		$rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
		
	 	my @rows = $sth->fetchrow_array;
	 	
	 	# determine if we have more then 1 product ID
	 	my $num = @rows;
	 	
	 	if ($num == 0) {
	 		message ("$suite not found in table.");
	 		$suiteID = -1;
	 		
	 	} elsif ($num == 1) {
	 		$suiteID = shift @rows;
	 	} else {
	 		message ("More than one $suite in regression table.");
	 		while ( @rows = $sth->fetchrow_array ) {
		  		print "@rows\n";
			}
			$suiteID = '-1';
	 	}
	}
	return $suiteID;
}

sub insertScript {
	#
	# Insert a product into the products database. 
	#
	#
	my $dbh            = shift;
	my $suiteID        = shift;
	my $script         = shift;
	my $source         = shift;
	my $stime		   = shift;
	my $etime          = shift;
	my $elapsed        = shift;
	my $status         = shift;
	my $log            = shift;
	my $scriptID;

	
	if (!$dbh || !$suiteID || !$script || !$source || !$stime || !$etime || !$elapsed || !$status || !$log ) {
		message ("insertScript (dbh, suiteID, scriptName) missing parameter(s).");
		return -1;
	}
	
	my $sql  = qq[INSERT INTO script (suiteID, name, source, start, end, elapsed, status, log) ];
	$sql .= qq[ VALUES (?, ?, ?, ?, ?, ?, ?, ?)];
	
	my $sth = $dbh->prepare($sql);
	my $rc  = $sth->execute($suiteID, ,$script, $source, $stime, $etime, $elapsed, $status, $log) or die "SQL Error: $DBI::errstr\n";
	# all systems go for insert.

	
	if ($rc) {
		# now get the ID for the inserted product
		$sql = qq[
		    SELECT scriptID FROM script
		    WHERE name     = '$script'
		    AND suiteID  = '$suiteID';
		];
#		print $sql;
		$sth    = $dbh->prepare($sql);
		$rc     = $sth->execute() or die "SQL Error: $DBI::errstr\n";
		
	 	my @rows = $sth->fetchrow_array;
	 	
	 	# determine if we have more then 1 product ID
	 	my $num = @rows;
	 	
	 	if ($num == 0) {
	 		message ("+++ $script not found in table. +++");
	 		$scriptID = -1;
	 		
	 	} elsif ($num == 1) {
	 		$scriptID = shift @rows;
	 	} else {
	 		message ("More than one $script in script table.");
	 		while ( @rows = $sth->fetchrow_array ) {
		  		print "@rows\n";
			}
			$scriptID = '-1';
	 	}
	}
	return $scriptID;
}
sub getRegressionScripts {
	my $path = shift;
	my @suiteScripts;
	my $script;
	
	open (SUITE, "<", "suitelog.txt") or die $!;
	
#	my $record = <SUITE>;
	foreach my $record (<SUITE>) {
		# find the script name and pull it out of the record
		if ($record =~ m/([A-Za-z0-9-_]+)\.pl.*/) {
			$script = $1;
			push(@suiteScripts, $1);
		}	
	}
	return @suiteScripts;
	
}
sub getRegressionInfo {
	my $path = shift;
	my $runtime;
    my $endtime;

	
	# return parms
	my ($buildInfo, $stime, $etime, $elapsed, $rts );
	
	if ( !$path ) {
		message ("getRegressionInfo (path) missing parameter.");
		return -1;
	}
	chdir($path);
	
	if (-e "rts.php") {
		open (RTS, "<", "rts.php")  or die $!;
	
		while (<RTS>) {
			$rts .= "$_";
		}
		close RTS;
		
	} else {
		$rts = "<h3> No RTS data for this release. </h3>"
	}
	
	open (SUITE, "<", "suitelog.txt") or die $!;
	
	my $first = <SUITE>;
	my $last  = $first;
	while (<SUITE>) {
		$last = $_;
	}
	close SUITE;
	if ($first =~ m/(.*)\#(.*)/)  {
		$buildInfo = $1;
		$runtime   = $2;
	} else {
		message("+++ getRegressionInfo() suitelog.txt missing header record. +++");
		exit;
	}
	
	if ($last =~ m/\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{1,2}:\d{1,2}\s+(\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{1,2}:\d{1,2})/)  {
		$etime   = $1;
	} else {
		message("+++ getRegressionInfo() suitelog.txt missing last record. +++");
		exit;
	}
	# get only the time segment
	if ($runtime =~ m/(\d{1,2}:\d{1,2}:\d{1,2})/) {
		$stime = $1;	
	} 
	
	if ($stime) {
		$stime = substr($etime,0,10) . " " . substr($stime, -9);	
	}

	if ($stime && $etime) {
		$elapsed = Util::timeDiff( date1 => $stime, date2 => $etime );
	} else {
		$elapsed = "Unknown";
	}

	return ($buildInfo, $stime, $etime, $elapsed, $rts);
}

sub getSuiteInfo {
	
	my $path   = shift;
	my $suite  = shift;
	my $passed = 0;
	my $failed = 0;
    my $firstRecordInSuite = 1;
    my $rc     = 0;
	
	# return parms
	my ($stime, $etime, $elapsed);
	
	if ( !$path || !$suite ) {
		message ("getSuiteInfo  missing parameter.");
		return -1;
	}
	chdir($path);
	
	open (SUITE, "<", "suitelog.txt") or die $!;
	
	# pop the first record off the stack 
	my $first = <SUITE>;
	
	while (<SUITE>) {
		if ($_ =~ m/$suite/) {
			
			if ($firstRecordInSuite) { # first record, get the stime
				$firstRecordInSuite = 0;
				if ($_ =~ m/(\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{1,2}:\d{1,2})/) {
					$stime = $1;
				}  else {message ("+++ Suite start time missing! +++");}
			}
			if ($_ =~ m/passed/) {
				$passed++;
			} elsif ($_ =~ m/failed/) {
				$failed++;
			}
			# ugly but it works.  get the suite end time
			if ($_ =~ m/\.pl\s+\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{1,2}:\d{1,2}\s+(\d{4}-\d{2}-\d{2}\s\d{1,2}:\d{1,2}:\d{1,2})\s+/) {
				$etime = $1;
			}
		} 
	}
	close SUITE;
    if($stime && $etime) {
    	$elapsed = Util::timeDiff( date1 => $stime, date2 => $etime );
    }
    if ($stime || $etime || $elapsed) {
    	return ($rc, $stime, $etime, $elapsed, $passed, $failed );	
    } else {
    	message ("WWW getSuiteInfo() -  $suite will not be uploaded. Entry missing in suitelog.txt WWW ");
    	return -1;
    }
	
}
sub addRegressionPassedCount {
	
	my $dbh          = shift;
	my $regressionID = shift;
	my $passed       = shift;
	update_status_by_regressionID($dbh, $regressionID, $passed, "passed");
	
	return;
}
sub addRegressionFailedCount {
	
	my $dbh          = shift;
	my $regressionID = shift;
	my $failed       = shift;
	update_status_by_regressionID($dbh, $regressionID, $failed, "failed");
	
	return;
}
sub getScriptInfo {
	
	my $script     = shift;
	my $scriptName = $script . ".pl";
	my $status     = "Passed";
	my $etime      = "Empty";
	my $rc         = 0;
    # return values
    my ($source, $stime, $elapsed, $log);
	
	# make sure we have a script in the folder 
	chdir ($script);
	message(getcwd());
	
	# check to see if we have a runlog.txt file. If not,
	# then don't bother trying to add the script. It never ran. 
	 if (-e "runlog.txt") {
	 } else {
	 	message ("WWW runlog.txt missing. Script didn't run. Bypassing. WWW");
	 	return -1;
	 	
	 }
	$source = convert_file_2_scalar($scriptName,'line-numbers');
	$log    = convert_file_2_scalar("runlog.txt");
	open (SCRIPT, "<", "runlog.txt") or die $!;

	my $first = <SCRIPT>;
	my $last  = $first;
	while (<SCRIPT>) {
		$last = $_;
		if ($_ =~ m/^\+/) {
			$status = "Failed";
		} 
		if ($last =~ m/(.*) ------- /)  {
			$etime   = $1;
			last;
		} 
	}
	close SCRIPT;
	chdir ("..");
	if ($first =~ m/(.*) ------- /)  {
		$stime = $1;
	} else {
		message("+++ missing header record in runlog.txt for $script. +++");
		$rc = -1;
	}
	
	if ($last eq "Empty")  {
		message("+++ missing last record in runlog.txt for $script. +++");
		$rc = -1;
	} 
    $elapsed = Util::timeDiff( date1 => $stime, date2 => $etime );
#
	return ($rc, $source, $stime, $etime, $elapsed, $status, $log);
}
sub load_expected_file {
	
	my $dbh            = shift;
	my $scriptID       = shift;
	my $filename       = shift;
	my $path           = getcwd();
	my $contents;
	my $sql;
	my $rc;
	my $sth;
	
	# open the expected file and load the contents into a scalar
	open (EXP, $filename);
	while (<EXP>) {
		$contents .= $_;
	}
    #message ($contents);
	close (EXP);
	
	$sql  = qq[INSERT INTO exp_files (scriptID, name, contents) ];
	$sql .= qq[ VALUES (?,?,?)];
	
	$sth = $dbh->prepare($sql);
	$rc  = $sth->execute($scriptID, $filename, $contents) or die "SQL Error: $DBI::errstr\n";

#	my $sql  = qq[LOAD DATA LOCAL INFILE '$path/$filename' ];
#	   $sql .= qq[INTO TABLE exp_files ];
#	   $sql .= qq[LINES TERMINATED BY '\n' ];
#	   $sql .= qq[(contents);];

	return $rc; 
}

sub convert_file_2_scalar {
	
	my $filename = shift;
	my $type     = shift;
	my $contents;
	my $i = 0;
	#my $path           = getcwd();

	if (!$type) {
		$type = 'no-line-numbers';
	}
	
	# open the expected file and load the contents into a scalar
	#print "$filename\n";
	open (EXP, $filename)  or die $!;
	
		if ($type eq 'line-numbers') {
			while (<EXP>) {$contents .= "$i $_"; $i++; }
		} else {
			while (<EXP>) {$contents .= $_;  }
		}

	close (EXP);
	return $contents;
}

sub isdigit  {
	my $var = shift;
	
	if ($var =~ /^[+-]?\d+$/ ) {
    	return 1;
	} else {
	    return 0;
	}
}

1