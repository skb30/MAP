#!/bin/perl -w
use strict;
use warnings;
use Net::FTP;

my $rc;
my $ftp;
my $iphostname  = "mvssysa.asg.com";
my $newerr = 0;
my $userID;
my $password;
my $template_path   = "/var/lib/jenkins/workspace/esw-ci/scripts/cntl";
my $loc_dir     = "/esw-dev";
my $srcdir      = "viash82-prod";
my $git2mvs_job 	 = "git2mvsj";
my $cust_git2mvs_job = "g2mjcl";
my $shellscr      = "git2mvss";
my $cust_shellscr = "g2mss";
my $project;
my $group;
my $dirs;
my $poll_freq   = 100;  #300;        # in secs
my $poll_times  = 100;  #100;
my $luser;
my $uuser;

$rc = start();
exit $rc;


sub start {

	# process command line args
    foreach my $argnum (0 .. $#ARGV) {
       if ($ARGV[$argnum] eq '-userID') {
	  $userID = $ARGV[$argnum + 1];
       }

	   if ($ARGV[$argnum] eq '-pw') {
	  $password = $ARGV[$argnum + 1];
	   }

       if ($ARGV[$argnum] eq '-project') {
	  $project = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-branch') {
	  $group = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-dirs') {
	  $dirs = $ARGV[$argnum + 1];
       }
    }
    print "userID: $userID, project: $project, branch: $group \n";

    $luser = lc($userID);
    $uuser = uc($userID);

	#customize_shell();

	customize_jcl();
	create_PDSE();
	$rc = submit_job();

	#cleanup();

	return $rc;
}


sub customize_shell {
	my $shell;

	# switch in jenkins
	#chdir ("$loc_dir/$srcdir") or die "cannot change: $!\n";
	chdir ("$template_path") or die "cannot change: $!\n";

	open $shell, '<', $shellscr or die "Cannot open GITtoMVS shell script file.\n";
	open my $newshell, '>', $cust_shellscr or die "Cannot create new shell script file.\n";

	# substitute lcaseid, project, group
	print("GIT2MVS shell script:\n");
	while (<$shell>) {
		#print("LINE   : $_");

		$_ =~ s/_lcaseid_/$luser/g;
		$_ =~ s/_project_/$project/g;
		$_ =~ s/_group_/$group/g;

		print("$_");
		print $newshell $_;
	}
	close $shell;
	close $newshell;
}


sub customize_jcl {
	my $jcl;

	chdir ("$template_path") or die "cannot change: $!\n";

	open $jcl, '<', $git2mvs_job or die "Cannot open GITtoMVS jcl file.\n";
	open my $newjcl, '>', $cust_git2mvs_job or die "Cannot create new GITtoMVS jcl file.\n";

	# substitute ucaseid, lcaseid, project, group
	print("GIT2MVS JCL SUBMITTED:\n");
	while (<$jcl>) {
		#print("LINE   : $_");

		$_ =~ s/_ucaseid_/$uuser/g;
		$_ =~ s/_lcaseid_/$luser/g;
		$_ =~ s/_project_/$project/g;
		$_ =~ s/_group_/$group/g;
		#$_ =~ s/_scriptpath_/$template_path/g;

		# comment out in jenkins
		#$_ =~ s/REGION=0M/REGION=0M,TYPRUN=SCAN/g;

		print("$_");
		print $newjcl $_;
	}
	close $jcl;
	close $newjcl;
}


sub create_PDSE {
	my $subline;
	my $dsn;

	$ftp = Net::FTP->new( $iphostname, Timeout => 240 ) or $newerr = 1;
	$ftp->login( $userID, $password ) or $newerr = 1;
	$ftp->quot("SITE PDSTYPE=PDSE REC=FB LR=80 BLK=3120 CY PRI=2 SEC=5");

	my @subd = split / /, $dirs;
	foreach $subline (@subd) {
		$dsn = "'". $uuser .".". $project .".". $group .".". uc($subline) ."'";
		print("Deleting $dsn\n");
		$ftp->rmdir($dsn);
		print("Creating $dsn\n");
		$ftp->mkdir($dsn) or die "Cannot create directory $dsn", $ftp->message;
	}
}

sub submit_job {
	my $jobname;
    my $rc = 1;

	#$ftp = Net::FTP->new( $iphostname, Timeout => 240 ) or $newerr = 1;
	#$ftp->login( $userID, $password ) or $newerr = 1;

	$ftp->quot("site filetype=jes");
	$ftp->put($cust_git2mvs_job);

	unlink($cust_git2mvs_job);

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

       # jobname override; comment out in jenkins
       #$jobname = "JOB04345";

       $rc = poll_job($jobname);

	}
	print "build sub rc: $rc \n";
	return $rc;
}

sub poll_job {
	my $jobname = shift;
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
	   print("GIT2MVS job completed. Polled JES ", $times_tried, " times.\n");
	   $rc = get_results($jobname, \@jeslog);
	} else {
	   print("Maximum number of poll attempts exceeded - Cannot determine job completion.\n");
	   $rc = -1;
	}

	return $rc;
}

sub get_results {
	my $jobname = shift;
	my $jeslog  = shift;
	my $jesline;
	my $resfile;
	my $spoolnum = 0;
	my $rc = 0;

	# find spool number of job result
	foreach $jesline (@$jeslog) {
    	print("JES: $jesline\n");
        if ($jesline =~ /.*0(\d+).*STDERR/) {
           $spoolnum = $1;
           print("spool num: $spoolnum\n");
           last;
        }
    }
	if ($spoolnum == 0) { print "No errors found. Exiting script.\n"; return $rc }

	$resfile = $jobname.".".$spoolnum;
	print("error file: $resfile\n");
	$ftp->get("$resfile");

	# or attempt to read from $userID.mega.jcl(megarslt)
	# $ftp->quot("site filetype=seq");

	open my $result, '<', $resfile or die "Cannot open error file.\n";

	# print errors
	while (<$result>) {
		my $line = $_;
		print("LINE: $line");
	}

	close $result;
	$rc = -1;
	unlink($resfile);

    print "get_results rc: $rc \n";

    return $rc;
}

sub cleanup {

	unlink($cust_shellscr);
}
