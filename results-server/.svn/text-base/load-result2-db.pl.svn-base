#!/bin/perl
use strict;
use warnings;
use Cwd;
use Cfg;
use ResultsServer;

my $server       = "test";          #<=== prod or test
my $product      = "smarttest";     #<=== update
my $release      = "999"; 			#<=== update				
my $os           = "999";			#<=== update
my $osversion    = "999";			#<=== update
my $lparname     = "999";			#<=== update
my $subsystem    = "999";			#<=== update
my $subsystemVer = "999";			#<=== update
my $site         = "phx";			#<=== update
my $regname      = "Testing Suite Driver";		    #<=== update
my $scriptCount  = 0;
my $suiteCount   = 0;
my $regressionID;
my $tablename;
my $rc; 
my $releaseID;
my $dbProductName; 
my $database;
# now that ESW has a different path structure we need to do this:
$product = lc($product);
if (substr($product,0,5) eq "smart") {
	if ($product eq "smartfilemvs") {
		$dbProductName = "ESW-SMARTFILE-MVS";
	}elsif ($product eq "smartfiledb2") {
		$dbProductName = "ESW-SMARTFILE-DB2";
	}elsif ($product eq "smarttest") {
		$dbProductName = "ESW-SMARTTEST";
	}elsif ($product eq "smartscope") {
		$dbProductName = "ESW-SMARTSCOPE"; 
	}else {
		print "+++ unknown product $product found. \n";
		exit;
	}
	$rc = chdir("../$site/ESW/$product/mainframe/suite");
	if ($rc == 0) {
		print "+++ Unable to change to directory ../$site/ESW/$product/mainframe/suite +++\n";
		exit;
	}
}
else {	
	$rc = chdir("../$site/$product/mainframe/suite");
	
	if ($rc == 0 ) {
		print "+++ Unable to chdir to: ../$site/$product/mainframe/suite.\n ";
		exit;
	}
	if (lc($product) eq "projcl"){
		$dbProductName = 'PRO/JCL';
	}elsif (lc ($product) eq "infox") {
		$dbProductName = 'INFO/Xe';
	} else {
		# copy the product name to the dbProductName because they're the same outside of ESW
		$dbProductName = uc($product);
	}
}

print "Changed directoy to: " . (getcwd() . "\n");

# set the current working directory so we log ResultsServer::messages to this folder
Cfg::set_cwd(getcwd());

my $suitePath = getcwd();
my $starttime = Util::get_scalar_time("");
#open(LOG, ">>./publish-results.log") or die("Couldn't open: $!\n");
ResultsServer::message("***** Starting Publish-Results program at $starttime *****");

# these parms need to come from the input file. 
my $suiteID; 
my $scriptID;
my(  
	$suiteName, 
    $stime, 
    $etime, 
    $elapsedTime,
    $numPass,
    $numFailed, 
    $status,
    $id, 
    $rts,
    $buildInfo
);


# determine which DB to store the results in. 
if (lc($server) eq 'prod') {$database = "MAP2";} else { $database = "MAP2-TEST";}
my $dbh = ResultsServer::get_connection('usmghcentos65', $database, 'scottba', 'qamap');

# extract product from path
$subsystem = uc($subsystem);
my  $productID = ResultsServer::get_product_id($dbh, $dbProductName, $release);
if ($productID == '0E0') {
	# wasn't in the table so we need to add it and return the ID
	$productID = ResultsServer::insertProduct($dbh, $dbProductName, $release);
	if ($productID == '-1') {
		ResultsServer::message ("+++ Unable to add $dbProductName to product table. +++");
		ResultsServer::message ("+++ Ending Program +++");
		exit;
	} else{
		ResultsServer::message ("*** $dbProductName-$release added to product table with ID: $productID ***");	
	}	
} 

my  $siteID = ResultsServer::get_site_id($dbh, $site);
if ($siteID == '0E0') {
	# wasn't in the table so we need to add it and return the ID
	$siteID = ResultsServer::insertSite($dbh, $site);
	if ($siteID == '-1') {
		ResultsServer::message ("+++ Unable to add $site to site table. +++");
		ResultsServer::message ("+++ Ending Program +++");
		exit;
	} else{
		ResultsServer::message ("*** $site added to site table with ID: $siteID ***");	
	}	
}

my  $osID = ResultsServer::get_os_id($dbh, $os, $osversion);
if ($osID == '0E0') {
	# wasn't in the table so we need to add it and return the ID
	$osID = ResultsServer::insertOS($dbh, $os, $osversion);
	if ($osID == '-1') {
		ResultsServer::message ("+++ Unable to add $os to os table. +++");
		ResultsServer::message ("+++ Ending Program +++");
		exit;
	} else{
		ResultsServer::message ("*** $os version $osversion added to os table with ID: $osID ***");	
	}	
}

my  $lparID = ResultsServer::get_lpar_id($dbh, $lparname);
if ($lparID == '0E0') {
	# wasn't in the table so we need to add it and return the ID
	$lparID = ResultsServer::insertLPAR($dbh, $lparname);
	if ($lparID == '-1') {
		ResultsServer::message ("+++ Unable to add $lparname to lpar table. +++");
		ResultsServer::message ("+++ Ending Program +++");
		exit;
	} else{
		ResultsServer::message ("*** $os version $lparname added to lpar table with ID: $lparID ***");	
	}	
}

my $subID = ResultsServer::get_subsystem_id($dbh, $subsystem, $subsystemVer);
if ($subID == '0E0') {
	# wasn't in the table so we need to add it and return the ID
	$subID = ResultsServer::insertSubsystem($dbh, $subsystem, $subsystemVer);
	if ($subID == '-1') {
		ResultsServer::message ("+++ Unable to add $subsystem to subsystem table. +++");
		ResultsServer::message ("+++ Ending Program +++");
		exit;
	} else{
		ResultsServer::message ("*** $subsystem $subsystemVer added to subsystem table with ID: $subID ***");	
	}	
}

($buildInfo, $stime, $etime, $elapsedTime, $rts) = ResultsServer::getRegressionInfo(getcwd());

# check to see if we already have the regrssion in table
if (!ResultsServer::get_regression( $dbh, $buildInfo, $stime, $etime, $elapsedTime, $rts ) ) {
	$regressionID = ResultsServer::insertRegression($dbh, $productID, $siteID, $osID, $lparID, $subID, $regname, $buildInfo, $stime, $etime, $elapsedTime, $rts );
	if ($regressionID == '0E0') {
		ResultsServer::message ("+++ Unable to add $regname to regression table. +++");
		ResultsServer::message ("+++ Ending Program +++");
		exit;
	} 	else{
		ResultsServer::message ("*** $regname  added to regression root table with ID: $regressionID ***");	
	}		
} else {
	exit;
}
	
# okay, we got the top level stuff now lets start adding the suites

my @suites = <*>;
ResultsServer::message(getcwd());
my @suiteLogScripts = ResultsServer::getRegressionScripts(getcwd());

my $valid = 0;
foreach my $suite (@suites) {

	chomp ($suite);
	if (-f $suite) {
		ResultsServer::message ("WWW $suite is a file not a folder. Skipping. WWW");
	} elsif (-d $suite) {

		# check to see if the suite for this release and regression is already in the database.
		print "--- Processing $product $release $regname suite $suite  ---\n";
		my $suiteID = ResultsServer::get_suite_id($dbh, $regressionID, $suite);
		if ($suiteID == '0E0') {
			# suite not in suites table so we need to add it.
			my ($rc, $stime, $etime, $elapsed, $passed, $failed ) = ResultsServer::getSuiteInfo($suitePath, $suite);
			# if there isn't a record in the suitelog then skip.
			if ($rc != 0) {
				next;
			}
		    $suiteID = ResultsServer::insertSuite($dbh, $regressionID, $suite, $stime, $etime, $elapsed, $passed, $failed );
		    ResultsServer::message ("*** $suite added to suite table with ID: $suiteID ***");
		    $suiteCount++;	 
		} else {
			#ResultsServer::message ("$suiteID: $product/$release/$regression/$suite already in the database.");
		}
		# drill into the suite folder and process each script for the suite.
		chdir($suite);
		my @scripts = <*>; 
		foreach my $script (@scripts) {
			# set the valid flag to false
			$valid = 0;
			# check to see if the script is in the suitelog
			foreach my $logScript (@suiteLogScripts) {
				if ($logScript eq $script) {
					$valid = 1;
					last;
				}
			}
			if (-d $script && $valid) {
                # check to see if the script is in scripts table with this ID. If not, add it. 
                $scriptID = ResultsServer::get_script_id($dbh, $suiteID, $script); 
                if ($scriptID == '0E0') {
					my ($rc, $source, $stime, $etime, $elapsed, $status, $log) = ResultsServer::getScriptInfo($script);
					# check to see if getScriptInfo had a problem
					if ($rc != '0') {
						chdir ("..");
						next;
					}
				    $scriptID = ResultsServer::insertScript($dbh, $suiteID, $script, $source, $stime, $etime, $elapsed, $status, $log);
				    ResultsServer::message ("*** $script added to script table with ID: $scriptID ***");
				    $scriptCount++;	 
				} else {
					ResultsServer::message ("WWW script: $script already in scripts table with id: $scriptID. WWW");
				}
                # now check to see if the script has expected and difference folder
                chdir($script);
                my @script_folder = <*>;
                foreach my $file (@script_folder) {
                	$file = lc($file);
                	# process the expected, current and differences folders
                	if (-d $file  && $file eq "exp_data" || $file eq "current_data" || $file eq "differences") {
                		chdir($file);
                		my @exp_folder = <*>;
                		foreach my $exp (@exp_folder) {
                			$id = ResultsServer::get_folder_data_id($dbh, $scriptID, $exp, $file);
                			if ($id != '0E0' ) {
                				ResultsServer::message("WWW $script/$file/$exp already in $file table with ID: $id WWW");
                					
                			} else {
                				$id = ResultsServer::add_folder_data($dbh, $scriptID, $exp, $file);
                				if ($id == -1) {
                					ResultsServer::message ("+++ Unable to add $script/$exp to exp_files table. +++");
                					exit;
                				} else {
                					ResultsServer::message ("*** $script/$exp added to $file table with ID: $id ***");
                				}
                			}
                		}
                		chdir ("..");	
                	} 
                }
                chdir("..");
			}
		}
		chdir("..");
	} else {
		ResultsServer::message ("+++ Unknown: $suite +++\n");
	}
}

 # update the total pass and fail counts for this regression 
 ResultsServer::update_regression_status_by_ID($dbh, $regressionID);
 ResultsServer::update_regression_status_by_ID($dbh, $regressionID);

my $endtime = Util::get_scalar_time("");
my $timeDiffStr = Util::timeDiff( date1 => $starttime, date2 => $endtime );
ResultsServer::message ("***************************************************************)");
ResultsServer::message ("total scripts added to scripts table: $scriptCount");
ResultsServer::message ("Total suites added to suite table: $suiteCount");
ResultsServer::message ("Time to load results: $timeDiffStr");
ResultsServer::message ("***************************************************************");

ResultsServer::disconnect($dbh);
#close LOG;

#where am I?
#$pwd = getcwd();

