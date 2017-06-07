#!/bin/perl
use strict;
use warnings;
use Cwd;
use ResultsServer;

my $path       = "D:/Eclipse_projects/MAP/projcl/mainframe/suite/";
my $product    = "smartFileMVS";
my $release    = "820C";
my $regression = "3";

my $regressionID;

my $dbh          = ResultsServer::get_connection('usmghcentosqa.asg.com', 'MAP', '[scottba]', 'qamap');
#my $productID   = ResultsServer::get_product_id($dbh, $product);
#my $rows        = ResultsServer::list_regressions_for_product($dbh, $product, $release);
#my $suiteID     = ResultsServer::get_suite_id($dbh, $product, "IVP", $release, $regression);
#my $releaseID   = ResultsServer::get_release_id($dbh, $product,  $release );
#$regressionID   = ResultsServer::get_regression_id($dbh, $product, $release, "1st" );
#message ($regressionID);
#ResultsServer::disconnect($dbh);
#exit;
my $suiteID;
my $scriptID;
my( $regrssionID, 
	$suiteName, 
    $stime, 
    $etime, 
    $elapsedTime,
    $numPass,
    $numFailed, 
    $status,
);
my $tablename;
my $rc; 
my $releaseID;
chdir($path); 
my @suites = <*>;

foreach my $suite (@suites) {
	chomp ($suite);
	if (-f $suite) {
#		message ("suites: $suite");
		
	} elsif (-d $suite) {
#		message("*** cd into $suite ***");
		
		# check to see if the suite for this release and regression is in the database.
		my $suiteID = ResultsServer::get_suite_id($dbh, $product, $suite,  $release, $regression);
		if ($suiteID == '0E0') {
#			# suite not in suites table so we need to add it.
		    $regressionID   = ResultsServer::get_regression_id($dbh, $product,  $release, $regression );
			$rc = ResultsServer::insertSuiteName(
			      $dbh,
			      $regressionID, 
			      $suite, 
			      "", 
			      "today", 
			      $elapsedTime,
			      $numPass, 
			      $numFailed);
		} else {
			message ("$product/$release/$regression/$suite already in the database.");
		}
		
		# drill into the suite folder and process each script for the suite.
		chdir($suite);
		my @scripts = <*>; 
		foreach my $script (@scripts) {
			if (-d $script) {
#				message("*** cd into $suite ***");
                # check to see if the script is in scripts table. If not, add it. 
                $scriptID = ResultsServer::get_script_id($dbh, $suiteID, $script); 
                
                # no script in the table, let's add it
                if ($scriptID == '0E0') {
                	$scriptID = ResultsServer::add_script($dbh, $suiteID, $script, $stime, $etime, $status);
                } else {
                	ResultsServer::message("$script is already in the scripts table.");
                }

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
#								my $rc = ResultsServer::load_expected_file($dbh, "1", $exp_file);
								 
							}
							chdir ("..");
							message("   Expected direcotry: $script_folder_file");
						}
#						message("   script direcotry: $script_folder_file");
					} else {
#						message("   script name: $script_folder_file");
					}
				}
				chdir("..");
#				message(getcwd());
			} elsif (-f $suite) {
#				message("script name is: $suite");
			}
		}
		chdir("..");
#		message(getcwd());
	} else {
		message ("unknown: $suite");
	}
}

ResultsServer::disconnect($dbh);
sub message {
	my $s = shift;
	print ("$s \n");
}
#where am I?
#$pwd = getcwd();

