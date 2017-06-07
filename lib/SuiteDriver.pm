#!/bin/perl 
package SuiteDriver;
use IO::Socket;
use Cwd;
 
use constant {
	PASS     => 1,
	WARNING  => 2,
	FAIL     => 3,
};


sub processOrderedList{
	
	# Verifies that the scripts in the runlist are actually in the suite folder 
	# and returns the list in the order they were found in the list. 
	my ($ref_suiteArray) = shift;
	my @suites = @{$ref_suiteArray};

	my @clean;
	my @dirty;
	my $suite;
	my $found;
	my $run;
	    
	my @RunOnlyList = Util::convertFile2Array("run-list.txt");
	chomp(@RunOnlyList);

	# make sure we have a run list.
	if (@RunOnlyList[0] != '-1') {
		@RunOnlyList    = removeCommentsFromList(\@RunOnlyList);
		
		foreach $run (@RunOnlyList) {
			# check for empty string
			if ($run ne "") {
				$found = Util::find_element_in_array( \@suites, $run  );
				if ($found) {
					push( @clean, $run );
				}
				else {
					print "WWW $run suite not found.  Adding $run to skip list. WWW\n";
					push( @dirty, $run );
				}
			}	
		}
	} else {
		# no runlist which means run everything.
		# but first we must check to make sure the folders actually exist.
		foreach $suite (@suites) {
			 if ( -d $suite ) {
			 	push (@clean, $suite);
			 } 
		}
		return \@clean;
	}
	return ( \@clean, \@dirty );
}
sub processExceptionList {

	my ($ref_suiteArray) = shift;
	my @suites = @{$ref_suiteArray};
	my @clean;
	my @dirty;
	my $suite;
	my $found;
	my $command;
	my $runlist;
	my $skiplist;

	# get the run and skip list.
	$pwd = getcwd();
	my @SkipList    = Util::convertFile2Array("skip-list.txt");
	my @RunOnlyList = Util::convertFile2Array("run-list.txt");

	# determine if we have a skip list and if it has data.
	if ( ( $SkipList[0] != -1 ) && (@SkipList) ) {
		chomp(@SkipList);
		@SkipList = removeCommentsFromList( \@SkipList );
	}
	else {

		# print "Empty or missing skip list.\n";
		@SkipList = ();
	}

	# determine if we have a run list and if it has data.
	if ( ( $RunOnlyList[0] != '-1' ) && (@RunOnlyList) ) {
		chomp(@RunOnlyList);
		@RunOnlyList = removeCommentsFromList( \@RunOnlyList );
	}
	else {

		#print "Empty or missing run list.\n";
		@RunOnlyList = ();
	}

	# determine what command to set for process loop.
	if ( (@SkipList) && (@RunOnlyList) ) {
		print "run-list overriding skip-list. Skip-list ingored! \n";
		
		# if we have a run list then we need to call this routine to 
		# fill the array in the order they are listed in the run-list.txt file and 
		# return it to the caller. 
		
		($runlist, $skiplist) = processOrderedList(\@suites);
		return ($runlist, $skiplist);
	}
	elsif ( (@SkipList) && ( $SkipList[0] != -1 ) ) {
		$command = 'skip';
	}
	elsif ( (@RunOnlyList) && ( $RunOnlyList[0] != -1 ) ) {
		
		# if we have a run list then we need to call this routine to 
		# fill the array in the order they are listed in the run-list.txt file and 
		# return it to the caller. 
		
		($runlist, $skiplist) = processOrderedList(\@suites);
		return ($runlist, $skiplist);
	}
	else {
		$command = 'bypass';
	}

	#
	# process the skip list. If we don't have any lists then
	# run everything.
	#
	
	foreach $suite (@suites) {
		if ( -d $suite ) {

			if ( $command eq "skip" ) {
				$found = Util::find_element_in_array( \@SkipList, $suite );
				if ( !$found ) {
					push( @clean, $suite );
				}
				else {
					push( @dirty, $suite );
				}
			}
			else {
				push( @clean, $suite );
			}
		}
	}
	return ( \@clean, \@dirty );

}

sub promptUser {
	my $prompt = shift;
	print "$prompt (y/n)?\n";
	my $cmd = <STDIN>;
	chomp $cmd;
	if ( $cmd =~ /[yY]/ ) {
		message ("Proceeding...", PASS);
	}
	else {
		message ("Exiting program...", WARNING);
		exit;
	}
}

sub publishResults {
	my $path2Suite = shift;
	my $product    = shift;
	my $release    = shift;
	my $regression = shift;

	# verify agruments

	if (   defined($path2Suite)
		&& defined($product)
		&& defined($release)
		&& defined($regression) )
	{

		# send the linux mkdir and copy commands to centso webserver
		sendLinuxCommand(
			"mkdir /var/www/map_site/products/$product/$release/$regression");
		sendLinuxCommand(
"cp -r $path2Suite /var/www/map_site/products/$product/$release/$regression/  "
		);

	}
	else {
		print "Missing parameter(s)!\n";
		$rc = -1;
	}

	return $rc;

}
sub verifyWebPath {
	my $product    = shift;
	my $release    = shift;
	my $regression = shift;
	my $rc;
	
	$rc = sendLinuxCommand("ls /var/www/map_site/products/$product");
	if ($rc !=  0) {
		message ("Product $product does not exist on the webserver.", FAIL);
		message ("Have your adminstrator create $product on the webserver.", FAIL);
		message ("Exiting Program.", FAIL);
		exit;
	}
	$rc = sendLinuxCommand("ls /var/www/map_site/products/$product/$release");
	if ($rc != 0) {
		# we don't have a release, ask the user if they want to create one.
		promptUser("--- Release $release does not exist. Do you want to create it? ---"
		);
		$rc = sendLinuxCommand("mkdir /var/www/map_site/products/$product/$release");
		if ( $rc == 0 ) {
			message ("Release $release created successfully.", PASS);
			
			#if we just created the release then set regression to 1
			$regression = 1;
			$rc = '0';
		}
		else {
			message ("Failed to create directory $release", FAIL);
			return -1;
		}
	}
	$rc = sendLinuxCommand("ls /var/www/map_site/products/$product/$release/$regression");
	if ( $rc == 0 ) {
		promptUser("--- Regression $regression already exists. Do you want to overwrite these results? ---");
		message ("sending command [rm -rf /var/www/map_site/products/$product/$release/$regression] to centos", WARNING);
		$rc = sendLinuxCommand("rm -rf /var/www/map_site/products/$product/$release/$regression");
		if ($rc == 0) {
			message ("Directory removed successfully", PASS);
		} else {
			message ("Command failed. Directory not removed!", FAIL);
		}
	}
	else {
		promptUser("--- Regression $regression does not exist.\n Do you want to create it? ---");
		$rc = 0;
	}
	return $rc;
}

sub publish {
	my $product    = lc shift;
	my $release    = lc shift;
	my $regression = shift;
	my $rc;
	my $mkdir = 0;
	my $cmd; 

	my $userid = getlogin;
	
	# verify the webserver directories are in order
	$rc = verifyWebPath($product, $release, $regression);
	
	# build the path to the client's mounted windows share
	my $path2Suite = "/mnt/" . "$userid-MAP/" . $product . "/mainframe/suite";

	# verify the users suite path exsists
	$rc = sendLinuxCommand("ls $path2Suite");
	if ( $rc != 0 ) {
		message ("$userid-MAP is not mounted properly on the webserver (centos).", FAIL);
		message ("Have the administrator mount $userid-MAP before publishing.", FAIL);
		exit -1;
	}
    # make the regression directory before copying 
    $cmd = "mkdir /var/www/map_site/products/$product/$release/$regression";
    $rc = sendLinuxCommand($cmd);
	if ( $rc == 0 ) {
		message ("directory $regression successfully created on centos.", PASS);
	}else {
		message("sending command [$cmd] to centos",WARNING);   
		message("command failed with rc = $rc", FAIL);
		message("existing program!", FAIL);
		exit;
	}
	
	message("Starting the copy. This may take a few minutes.", WARNING);
	$cmd = "cp -r $path2Suite /var/www/map_site/products/$product/$release/$regression/";
	message("sending command [$cmd] to centos",WARNING);
	$rc =
	  sendLinuxCommand($cmd);
	if ($rc == 0) {
		message ("Publish results completed successfully. rc = $rc", PASS);
	}  
	else {
		message ("command failed on Centos with a rc = $rc", FAIL);
		message ("Exiting the program", FAIL);
		exit;
	}
	return $rc;
}

sub sendLinuxCommand {

	my $command = shift;
	my $recv_data;
	my $rc;

	# make a connection to the MAP command server
	$socket = getConnection2MAP();
	$socket->send($command);
	$socket->recv( $recv_data, 1024 );

	#print "$recv_data\n";
	close $socket;
	$recv_data =~ m/.*Completed with RC = (\d+)/;
	$rc = $1;
	return $rc;
}

sub getConnection2MAP {

	# connect to port 5000 which the MAP command server is listening on
	$socket = new IO::Socket::INET(
		PeerAddr => 'usmghcentosqa.asg.com',
		PeerPort => 5000,
		Proto    => 'tcp',
	  )
	  or die "Couldn't connect to Server\n";
	return $socket;
}

sub removeCommentsFromList {

	my ($ref_suiteArray) = shift;
	my @list = @{$ref_suiteArray};
	my @clean;
	my $suite;

	foreach my $line (@list) {
		
		# remove null lines
 		if ($line eq "") {
		    next
		}
		# remove blank lines
		if ($line =~ /\s+/) {
			   next
		}
		# ignore comments
		if ( $line =~ m/^#/ ) { 
			next;
		}
		else {

			# capture characters with dashes up until the first space
			if ( $line =~ m/([\w+\-*\w+]+).*/ ) {
				$suite = $1;
			}
			else {
				print "+++ Invalid script name: $line in suite $suite +++\n";
			}
			push @clean, $suite;
		}
	}
	return @clean;

}

sub printList {
	my ($ref_list) = shift;
	my @suites     = @{$ref_list};
	my $i          = 0;
	my $j;
	my $suite1;
	my $suite2;
	my $suite3;
	my $suite4;
	my @printArray;
	my @colArray;
	my $numLines;
	my $numCols = 4;
	my $k       = 0;
	my ( $row, $col );
	my $line  = 0;
	my $index = 0;
	my $numPrintRows;
	$numLines = @suites;
	open( RUNLIST, ">>&STDOUT" )    or die("Couldn't open: $!\n");

	# determine the number of rows in the print array
	if ( $numLines > 4 ) {
		$numPrintRows = $numLines / $numCols;

		$numPrintRows =~ m/(\d+)\.(\d+)/;
		if ($1) {
			$numPrintRows = $1;
			$numPrintRows++;
		}
	}
	else {
		$numPrintRows = $numLines;
	}

	#build the columns
	for ( $i = 0 ; $i < $numLines ; $i = $i + $numPrintRows ) {
		for ( $j = 0 ; $j < $numPrintRows ; $j++ ) {
			$colArray[$j] = $suites[ $i + $j ];
		}

		# put the anonomyous array ref in the the printArray
		push @printArray, [@colArray];
	}

	# print the cols to the console and web server
	for ( $j = 0 ; $j < $numPrintRows ; $j++ ) {
		$col1 = $printArray[0][$j];
		$col2 = $printArray[1][$j];
		$col3 = $printArray[2][$j];
		$col4 = $printArray[3][$j];
		write RUNLIST;
	}
	close(RUNLIST);
	

	format RUNLIST =
   @<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<
    $col1,$col2,$col3,$col4
.

	format RTS =
   @<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<
    $col1,$col2,$col3,$col4
.

}

sub printHash2Html {

	my $hash_ref = shift;

	# convert ref back to hash
	my %theHash  = %{$hash_ref};
	my $htmlTags = shift;

	# print to a file for the web server
	open( RTS, "+>./rts.php" ) or die("Couldn't open: $!\n");

	# print the table headings
	print RTS "$htmlTags\n";
	print RTS q{<table width="400" border="1" cellspacing="5">\n};
	print RTS q{<tr><th scope="col">Key</th><th scope="col">Value</th>\n};
	foreach $key ( sort keys %theHash ) {
        # clean up the quote marks 
        $theHash{$key} =~ s/'//g; 
		print RTS qq{<tr><td>$key</td><td>$theHash{$key}</td></tr>\n};
	}

	# print the ending html
	print RTS "</table>\n";

	close(RTS);

}

sub printArray2Html {

	my $array_ref = shift;

	# convert ref back to hash
	my @theArray = @{$array_ref};
	my $htmlTags = shift;
	open( RTS, ">>./rts.php" ) or die("Couldn't open: $!\n");
	print RTS "$htmlTags\n";

	foreach my $element (@theArray) {
		print RTS "$element <br />\n";
	}
	close(RTS);
	return 0;
}
sub message {
	
	my  $msg = shift;
	my  $sev = shift;
	
	if ($msg) {
		if ($sev == PASS) {
			print ("*** " . $msg . " ***\n"); 
		} elsif ($sev == WARNING){
			print ("--- " . "$msg ---\n");
		} elsif ($sev == FAIL) {
			print ("+++ " . "$msg +++\n");
		} else {
			print "+++ Unknown severity parameter $sev +++\n" ;
		}
	} else {
		print '+++ Missing message string - message($msg, $sev) +++';
		print "\n";
		return -1;
	}
}
1;
