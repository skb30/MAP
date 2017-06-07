#!/bin/perl 
use POSIX qw(strftime);
use Cwd;
use Cfg;
use Util;
use Common;
use SuiteDriver;
use CfgIni;


my $hostname = `hostname`;
my $status;
my $timeDiffStr;
my $start_time 		= Util::get_scalar_time();
my $results;
my $script;
my $run_cnt     	= 0;
my $fail_cnt    	= 0;
my $not_run_cnt 	= 0;
my $pass_cnt    	= 0;
my $site            = 'PHX';          # <== update with product site folder name
my $product 		= 'smartfilemvs'; # <== update with product name
my $bypass          = 0;
$pwd = getcwd();
# now the ESW has a different path structure then the rest of the products we need to this:
if (substr($product,0,5) eq "smart") {
	chdir("../$site/ESW/$product/mainframe/suite");
}
else {	
    chdir("../$site/$product/mainframe/suite");
}

my $configRef 		= Cfg::getcfg();
my $ini             = Cfg::get_ini_file_name();
my $buildInfo		= $configRef->{'BuildInfo'};

my $regressionID 	= $configRef->{'RegressionID'};
my $initExpFile	    = $configRef->{'InitExpFile'};
my @suiteList;
my @skipList;
my @runList;
# Save current directory
my $curr_path = getcwd();

# Get the path to the ini file for the results server 
$cwd = chdir("../..");
my $ini_path = getcwd() . "/" . $ini;
chdir("$curr_path");
SuiteDriver::printHash2Html($configRef,"<p>$hostname: $ini_path </p>");
SuiteDriver::promptUser("Use the configuation settings from: $ini_path?");
# restore suite directory

if ($initExpFile == 1) {
   SuiteDriver::promptUser("Are you sure you want the Expected file Flag turned on?");	
}
##todo pull product from configuration file.

$pwd = getcwd();

my @suites 	= <*>;    # glob all the files from CWD

my ($runlist, $skiplist);
	
($runlist, $skiplist) = SuiteDriver::processExceptionList(\@suites);

# we need to convert the runlist reference into an array for suite processing.
@suiteList = @{$runlist};


if (@suiteList == 0 ) {
	print "+++ No Matching Suites found in run-list. +++\n";
	exit;
}
print "The following suite(s) will be skipped:\n";
open( RTS, ">>./suite_driver_log.txt" )or die("Couldn't open: $!\n");
print RTS "\nThe following suite(s) will be skipped:\n";
close (RTS);
SuiteDriver::printList($skiplist);
SuiteDriver::printArray2Html($skiplist,"<h4>Suite Skip List</h4>");

print "The following suite(s) will be run:\n";
open( RTS, ">>./suite_driver_log.txt" )or die("Couldn't open: $!\n");
print RTS "\nThe following suite(s) will be run:\n";
close (RTS);
SuiteDriver::printList($runlist);
SuiteDriver::printArray2Html($runlist,"<h4>Suite Run List</h4>");
SuiteDriver::promptUser();


# write the build and regression record into the suitelog
my $start_date = Util::get_scalar_time("");
open( SUITELOG, "+>./suitelog.txt" )or die("Couldn't open: $!\n");
print SUITELOG "$buildInfo#Regression $regressionID# $start_date\n";
close (SUITELOG);
# break befor each suite?
print "Break before each suite run? (y/n)?\n";
my $bypss_continue = <STDIN>;
chomp $bypss_continue;
if ( $bypss_continue =~ /[yY]/ ) {
	$bypass = 1;
} else {
	$bypass = 0;
}

# process the suites folder
foreach $suite (@suiteList) {	
	chdir($suite);    # cd into the suite folder
	$dir           = getcwd();
	@scriptFolders = <*>;        # glob the suite folders

	# make sure this folder isn't empty
	if ( !@scriptFolders ) {
		chdir("..");
		next;
	}
	
	$dir = getcwd();
	# check to see if it has run and skip list criteria.{


	($runlist, $skiplist) = SuiteDriver::processExceptionList(\@scriptFolders);
	
	print "$suite skip list:\n";
	SuiteDriver::printList($skiplist);
	
	print "$suite run list:\n";
	SuiteDriver::printList($runlist);
	@runList = @{$runlist};
	if (@runList == 0 ) {
		print "+++ No Matching Script(s) found in $suite. Make sure your $suite run-list.txt is correct. +++\n";
		exit;
	}

    # bypass the suite continue
    if ($bypass == 1) {
    	SuiteDriver::promptUser("Continue?");
    }
	
	# now  process the scripts folder by comparing the parent folder name to
	# a script with the same name, if we find a script with the same
	# name as the parent then we know we have a script to run.
   
	foreach $scriptFolder (@runList) {
		if ( -d $scriptFolder ) {
			# drop into the script folder looking for the script
			chdir($scriptFolder);
			$dir = getcwd();
			
            
			# glob only the .pl's into the array
			my @scripts = <*.pl>;
			foreach $script (@scripts) {
				$script = ($script);

				# check to see if we have a script that matches the
				# parent folder name
			   	if ( $script =~ m/$scriptFolder\.pl/ ) {
					print "Starting $suite $script\n";
					$run_cnt++;

					$status = Util::run_test($script, $suite, $configRef);
					if ($status eq "passed") {
						$pass_cnt++;
					} else {
						$fail_cnt++;
					}
				}
				else {
					print "Script $script missing in folder! \n";
					$not_run_cnt++;
				}
			}
			# cd back to the script folder
			chdir("..");
			$dir = getcwd();
		}
	}

	# cd back to the suite level for next iteration
	chdir("..");
	$dir = getcwd();
}

my $end_time = Util::get_scalar_time("");
$timeDiffStr = Util::timeDiff( date1 => $start_time, date2 => $end_time );

open( HISTORYLOG, ">>./historylog.txt" ) or die("Couldn't open: $!\n");
write HISTORYLOG;
close(HISTORYLOG);


print
"\n---------------------------------------------------------------------------------------------------\n";
print "      Suites passed  : " . $pass_cnt . "\n";
print "      Suites failed  : " . $fail_cnt . "\n";
print "Total Suites run     : " . $run_cnt . "\n";
print "Total Suites missing : " . $not_run_cnt . "\n";
#print "Total Suites skipped : " . $skipped_cnt . "\n";
print "Percentage Passed    : " . ($pass_cnt / $run_cnt) * 100 . "\n";
print "Elasped Time         : $timeDiffStr\n";


#format RUNLIST =
#   @<<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<
#      $suite;            $suite            $suite           $suite;
#.
format HISTORYLOG_TOP =
   @||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
   "Summary Report"
.
format HISTORYLOG =
   Scripts Passed:  @<<<<<<<<<<<<<<<<<<<<<
	 			    $pass_cnt;
   Scripts Failed:  @<<<<<<<<<<<<<<<<<<<<<
	 			    $fail_cnt;
   Scripts Run:     @<<<<<<<<<<<<<<<<<<<<<
	 			    $run_cnt;
   Scripts Skipped: @<<<<<<<<<<<<<<<<<<<<<
	 			    $not_run_cnt;	 			    			   	 			   
   Elasped Time:    @<<<<<<<<<<<<<<<<<<<<<
	 			    $timeDiffStr	 	 			    			   	 			   
   Percent Passed:  @<<<<
	 			    ($pass_cnt / $run_cnt) * 100	 			   			   
.