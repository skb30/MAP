#!/bin/perl -w
use strict;
use warnings;
use Net::FTP;
use File::Basename;
use File::Find;
use File::Path qw(mkpath rmtree);
use Cwd;
my $dir;
my $rc;
my $status;
my $job_path    = "/var/lib/jenkins/workspace/esw-ci/scripts/cntl";
my $akrjob      = "allocakr";
my $loc_dir     = "/esw-dev";
my $srcdir      = "viash82-prod";
my $loc_akrjob  = "allocakr";
my $cust_akrjob = "akrjcl";
my $poll_freq   = 5;  #300;        # in secs
my $poll_times  = 20;  #100;
my $ftp;
my $iphostname  = "mvssysa.asg.com";
my $userID;
my $password;
my $product     = "CENTER";
my $cendsn     = ' ';
my $akrdsn     = ' ';
my $newerr = 0;

$rc = start();
exit $rc;

sub start {
    my $start_time;
    my $end_time;
    my $timeDiffStr;
    my $rc = 0;


    # process command line args
    foreach my $argnum (0 .. $#ARGV) {
       if ($ARGV[$argnum] eq '-userID') {
	  $userID = $ARGV[$argnum + 1];
       }

	   if ($ARGV[$argnum] eq '-pw') {
	  $password = $ARGV[$argnum + 1];
	   }

	   if ($ARGV[$argnum] eq '-cendsn') {
	  $cendsn = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-akrdsn') {
	  $akrdsn = $ARGV[$argnum + 1];
       }

   }
	print "userID: $userID, cendsn: $cendsn, akrdsn: $akrdsn \n";
	
#	chdir($directory) or die "cannot change: $!\n";

	$start_time = get_scalar_time();

	print "Starting FTP to $iphostname at: $start_time\n";

	$end_time = get_scalar_time();

	$timeDiffStr = timeDiff( date1 => $start_time, date2 => $end_time );
	print "FTP to $iphostname completed at:   $end_time \n";
	print "Elapsed time: $timeDiffStr\n";

	# customize akr alloc jcl
	customize_jcl();


    # initiate verify
	$rc = verify();
    print "verify RC = $rc \n";
	return $rc;
}

sub customize_jcl {
	my @newline;
	my $jcl;

	#chdir ("$loc_dir/$srcdir") or die "cannot change: $!\n";
	
	chdir ("$job_path") or die "cannot change: $!\n";
	
	open $jcl, '<', $akrjob or die "Cannot open akr alloc jcl file.\n";
	
	open my $newjcl, '>', $cust_akrjob or die "Cannot create new akr alloc jcl file.\n";

	# substitute CENDSN, AKRDSN and USRID
	print("AKR ALLOC JCL SUBMITTED:\n");
	while (<$jcl>) {
		#print("LINE   : $_");

		$_ =~ s/CENDSN/$cendsn/g;
		$_ =~ s/AKRDSN/$akrdsn/g;
		$_ =~ s/USRID/$userID/g;

		#$_ =~ s/NOTIFY=&SYSUID/NOTIFY=&SYSUID,TYPRUN=SCAN/g;

		print("$_");
		print $newjcl $_;
	}
	close $jcl;
	close $newjcl;
}

sub verify {
	my $jobname;
    my $rc=1;
    my $newjob= "";

	#chdir ("$directory/$srcdir") or die "cannot change: $!\n";

	$ftp = Net::FTP->new( $iphostname, Timeout => 240 ) or $newerr = 1;
	$ftp->login( $userID, $password ) or $newerr = 1;

	$ftp->quot("site filetype=jes");
	$ftp->put($cust_akrjob);

	unlink($cust_akrjob);

	my $rtncode = $ftp->code;
	print("rc: $rtncode\n");
	my $msg=$ftp->message;
	print("msg: $msg");

	# check if job was submitted and get returned job ID
	if ($rtncode == 250) {

	   if ($msg =~ /.*(JOB[\d]+)/) {		
          $jobname = $1;
          print("jobID: $jobname\n");
       }
      
       $rc = poll_job($jobname, "VIALOG");
      
	}
	#print "verify sub rc: $rc \n";
	return $rc;
}

sub poll_job {
	my $jobname = shift;
	my $ddname  = shift;
    my $rc = 0;
	my $success = 0;
	my $times_tried = 0;
	my @jeslog;
	my $jesline;
	my $status;
    my $rtncode;
    my $msg;

	$ftp->quot("site filetype=jes jesjobname=* jesstatus=all jesowner=*");

	do {
	   # get directory of submitted job
	   @jeslog = $ftp->dir($jobname);
	   $times_tried += 1;

	   $rtncode = $ftp->code;
	   print("rc: $rtncode\n");
	   $msg=$ftp->message;
       print("msg: $msg");

       if (($rtncode == 000) && ($msg eq 'rc: 599')) {
       	  # lost ftp connection; log in again
       	  $ftp = Net::FTP->new( $iphostname, Timeout => 240 ) or $newerr = 1;
	      $ftp->login( $userID, $password) or $newerr = 1;
          $ftp->quot("site filetype=jes jesjobname=* jesstatus=all jesowner=*");
       } else {
            # poll for job completion
	        if ($rtncode == 550) {
	           sleep($poll_freq);
	        } else {

                 foreach $jesline (@jeslog) {
                    print("SAW: $jesline\n");
                    if ($jesline =~ /.*$jobname.{10}(.{6})/) {
                       $status = $1;
                       print("job status: $status\n");
                       last;
                    }
                 }
            }
       }

       if ($status eq 'OUTPUT') {
          $success = 1;
	   } else {
	      sleep($poll_freq);
	   }

	} while (!$success) and ($times_tried <= $poll_times);

	if ($success) {
	   print("AKR Alloc job completed. Polled JES ", $times_tried, " times.\n");
	   $rc = get_results($jobname, $ddname, \@jeslog);

	} else {
	   print("Maximum number of poll attempts exceeded - Cannot determine job completion.\n");
	   $rc = -1;
	}

	return $rc;
}


sub get_results {
	my $jobname = shift;
	my $ddname  = shift;
	my $jeslog  = shift;
	my $jesline;
	my $resfile;
	my $spoolnum = 0;
	my $jobrc   = 1;

    # find spool number of job result
	foreach $jesline (@$jeslog) {
    	print("JES: $jesline\n");
        if ($jesline =~ /.*0(\d+).*$ddname/) {
           $spoolnum = $1;
           print("spool num: $spoolnum\n");
           last;
        }
    }
	if ($spoolnum == 0) { print "No $ddname found. Exiting script.\n"; return -1 }

	$resfile = $jobname.".".$spoolnum;
	print("result file: $resfile\n");
	$ftp->get("$resfile");

	open my $result, '<', $resfile or die "Cannot open result file.\n";

	# parse lines for success notification
	while (<$result>) {
		my $line = $_;

		print("LINE: $line");
		
		if ($line =~ /1\sAKR\(S\)\sINITIALIZED(.+)0\sFAILED./) {
			$jobrc = 0;
		}
	}

	close $result;

	unlink($resfile);

    print "get_results rc: $jobrc \n";

    return $jobrc;
}


sub get_scalar_time {
	my ($y, $m, $d, $hh, $mm, $ss) = (localtime)[5,4,3,2,1,0];
	$y += 1900; $m++;
    return sprintf("%d-%02d-%02d %02d:%02d:%02d", $y, $m, $d, $hh, $mm, $ss);
}

sub timeDiff (%) {
	my %args = @_;

	my @offset_days = qw(0 31 59 90 120 151 181 212 243 273 304 334);

	my $year1  = substr($args{'date1'}, 0, 4);
	my $month1 = substr($args{'date1'}, 5, 2);
	my $day1   = substr($args{'date1'}, 8, 2);
	my $hh1    = substr($args{'date1'},11, 2) || 0;
	my $mm1    = substr($args{'date1'},14, 2) || 0;
	my $ss1    = substr($args{'date1'},17, 2) if (length($args{'date1'}) > 16);
	   $ss1  ||= 0;

	my $year2  = substr($args{'date2'}, 0, 4);
	my $month2 = substr($args{'date2'}, 5, 2);
	my $day2   = substr($args{'date2'}, 8, 2);
	my $hh2    = substr($args{'date2'},11, 2) || 0;
	my $mm2    = substr($args{'date2'},14, 2) || 0;
	my $ss2    = substr($args{'date2'},17, 2) if (length($args{'date2'}) > 16);
	   $ss2  ||= 0;

	my $total_days1 = $offset_days[$month1 - 1] + $day1 + 365 * $year1;
	my $total_days2 = $offset_days[$month2 - 1] + $day2 + 365 * $year2;
	my $days_diff   = $total_days2 - $total_days1;

	my $seconds1 = $total_days1 * 86400 + $hh1 * 3600 + $mm1 * 60 + $ss1;
	my $seconds2 = $total_days2 * 86400 + $hh2 * 3600 + $mm2 * 60 + $ss2;

	my $ssDiff = $seconds2 - $seconds1;

	my $dd     = int($ssDiff / 86400);
	my $hh     = int($ssDiff /  3600) - $dd *    24;
	my $mm     = int($ssDiff /    60) - $dd *  1440 - $hh *   60;
	my $ss     = int($ssDiff /     1) - $dd * 86400 - $hh * 3600 - $mm * 60;

	"$dd Day(s). $hh Hour(s). $mm Min(s). $ss Sec(s).";
}
