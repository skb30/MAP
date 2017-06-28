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
my $CTRrepoURL  = 'ssh://git@source-team.asg.com:7999/~geoffreyt/viash82-prod.git';
my $INSrepoURL  = 'ssh://git@source-team.asg.com:7999/esw/esw-insight.git';
my $srcdir      = "viash82-prod";
my $megajob     = "esw-ci/scripts/cntl/megacomp";
my $megajobp    = "esw-ci/scripts/cntl/megapcmp";
my $megajobc    = "esw-ci/scripts/cntl/megaccmp";
my $megajobs    = "esw-ci/scripts/cntl/megascmp";
my $loc_dir     = "/esw-dev";
my $loc_megajob = "megacomp";
my $loc_prodmega = "megapcmp";
my $cust_megajob = "megajcl";
my $poll_freq   = 100;  #300;        # in secs
my $poll_times  = 100;  #100;
my @dirs;
my @files;
my $count = 0;
my $gdsn;
my $ftp;
my $iphostname  = "mvssysa.asg.com";
my $userID;
my $password;
my $hlq        = "DV023A.";
my $mlq        = "devl.";
my $product     = "CENTER";
my $cenhlq     = ' ';
my $cenmlq     = ' ';
my $asfhlq     = ' ';
my $asfmlq     = ' ';
my $svrhlq     = ' ';
my $svrmlq     = ' ';
my $uid_label;
my $hlq_label;
my $mlq_label;
my $newerr = 0;
my $push2MF = 1;

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

       if ($ARGV[$argnum] eq '-hlq') {
	  $hlq = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-mlq') {
	  $mlq = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-product') {
	  $product = $ARGV[$argnum + 1];
       }

	   if ($ARGV[$argnum] eq '-cenhlq') {
	  $cenhlq = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-cenmlq') {
	  $cenmlq = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-asfhlq') {
	  $asfhlq = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-asfmlq') {
	  $asfmlq = $ARGV[$argnum + 1];
       }       
  
       if ($ARGV[$argnum] eq '-svrhlq') {
	  $svrhlq = $ARGV[$argnum + 1];
       }

       if ($ARGV[$argnum] eq '-svrmlq') {
	  $svrmlq = $ARGV[$argnum + 1];
       }      
            
       if ($ARGV[$argnum] eq '-push2MF') {
	  $push2MF = $ARGV[$argnum + 1];
          if (uc($push2MF) eq "NO") {
             $push2MF = 0;
          }
       }
   }
	print "userID: $userID, hlq: $hlq, mlq: $mlq, push2MF: $push2MF \n";
	print "product: $product, cenhlq: $cenhlq, cenmlq: $cenmlq \n";
	print "asfhlq: $asfhlq, asfmlq: $asfmlq, svrhlq: $svrhlq, svrmlq: $svrmlq \n";
	
	#($uid_label, $userID, $hlq_label, $hlq1, $mlq_label, $hlq2) = @ARGV;
#	print "$uid_label: $userID, $hlq_label: $hlq1, $mlq_label: $hlq2\n";

#    if (($uid_label ne '-userID') or ($hlq_label ne '-hlq1') or ($mlq_label ne '-hlq2')) {
#		die "Define the following input parameters: -userID {userID} -hlq1 {HLQ} -hlq2 {MLQ}\n";
#    }

#	# Re-initialize the repository. Uncomment if you are running outside of Jenkins
#	reset_repos($directory); Uncomment if you are running outside of Jenkins

	# Now clone from Bitbucket
#	clone_repos($reposURL, $directory); Uncomment if you are running outside of Jenkins

#	chdir($directory) or die "cannot change: $!\n";

	$start_time = get_scalar_time();

	print "Starting FTP to $iphostname at: $start_time\n";
        if ($push2MF) {
        	$rc = ftp2MF();
        }

	#use the find command to iterate thru the tree
	#
#	find(\&ftp_files_to_zos, ".");


	$end_time = get_scalar_time();

	$timeDiffStr = timeDiff( date1 => $start_time, date2 => $end_time );
	print "FTP to $iphostname completed at:   $end_time \n";
	print "Elapsed time: $timeDiffStr\n";

	# customize megacomp jcl
	customize_jcl();


    # initiate the build
	$rc = build();
    print "build RC = $rc \n";
	return $rc;
}


sub clone_repos ($$) {
	my $url = shift;
	my $dir = shift;

	print "Cloning Repository $url into $dir\n";
	$status = `git clone $CTRrepoURL`;
	print "Clone Completed. \n";
	return;
}
sub reset_repos ($) {
	my $directory = shift;
	if (-e $directory) {
		unless (rmtree $directory) {
			die "Unable to delete $directory\n";
		}
		sleep(2);
	}
    unless(mkpath $directory) {
        die "Unable to create $directory\n";
    }

   chdir($directory) or die "cannot change: $!\n";
   $dir = getcwd;
   return;
}

sub ftp2MF {
	my $pwd;
	my $path = ' ';

	# cd to tip
	#chdir ($srcdir);
	$pwd = getcwd();

	# glob the folders
	my @folders = <*>;

	# itererate thru each folder doing an MPUT * to z/OS
	foreach my $file (@folders) {
		if ( -d $file ) {
			print "Folder name: $file\n";
			# cleanup
			# ignore hidden files
			if ($path =~ m/\/\./) {return;}
			createPDS ("'" . $hlq . "." .$mlq . "." . $file . "'", $file);
		}
	}
}
sub createPDS {
	my $dsn    = shift;
	my $folder = shift;
	my $pwd;
	my $ftprc;
    if ($ftp){ $ftp->quit(); }
    $ftp = Net::FTP->new( $iphostname, Timeout => 240 ) or $newerr = 1;
	$ftp->login( $userID, $password ) or $newerr = 1;
	$ftp->site("asci") if $newerr;

    $ftp->rmdir($dsn);  # or die "$file doesn't exisit. ", $ftp->message;
	$ftp->quot("site pdstype=pdse");
	$ftp->quot("site LRECL=80");
	$ftp->quot("site RECFM=FB");
	$ftp->quot("site CYL");
	$ftp->quot("site PRI=1");
	$ftp->quot("site SEC=5");
	$ftp->quot("site sbdataconn=ESW.PROD.FTPGIT.TCPXLBIN");
        $ftprc = $ftp->code;
        print "Code Page setting RC: $ftprc\n";
	$ftp->mkdir("$dsn") or die "Cannot create directory $dsn", $ftp->message;
        $ftp->cwd($dsn) or die "Cannot change working directory ", $ftp->message;
        $pwd = $ftp->pwd;

    chdir ($folder);
	$pwd = getcwd();
	$pwd = $ftp->pwd;

	# glob the folders
	my @members = <*>;

	foreach my $member (@members) {
		if ( -f $member ) {
#			print "Storing $dsn($member)\n";
			$ftp->put($member)  or die "ftp $member to $dsn failed.\n", $ftp->message;;
		}
	}
        print "Completed transfer of $folder. \n";
	chdir ("..");
	return;
}
sub ftp_files_to_zos
{
	my $file = $_;
	my $path = $File::Find::name;
	my $dsn;
	my $pwd;

	# cleanup
	if ($file eq '.') { return }
	if ($file eq $srcdir) { return; }
	# ignore hidden files
	if ($path =~ m/\/\./) {return;}

	if (-d $file) {
		$gdsn = "'" . $hlq . $mlq . $file . "'";
		print "allocating $gdsn\n";
		createPDS ($gdsn, $file);

	} else {
		# We are here because we have a file that needs to be pushed into a PDSE.
		# The PDSE was created in createPDS which was called when we landed on a folder.
		$ftp->put($file) or die "put failed for $file ", $ftp->message;
	}

	return;
}

sub customize_jcl {
	my @newline;
	my $jcl;
	my $isproduct = 0;

    if (uc($product) ne "CENTER") {
		$isproduct = 1;
	}

	#chdir ("$loc_dir/$srcdir") or die "cannot change: $!\n";
	#if ($isproduct) {
	#	open $jcl, '<', $loc_prodmega or die "Cannot open product megacomp jcl file.\n";
	#} else {
	#	open $jcl, '<', $loc_megajob or die "Cannot open megacomp jcl file.\n";
	#}
	#open my $newjcl, '>', $cust_megajob or die "Cannot create new megacomp jcl file.\n";


	if ($isproduct) {
		if (uc($product) eq "CASSRV") {
			open $jcl, '<', $megajobc or die "Cannot open cas-svr megacomp jcl file.\n";
		} else {
			if (uc($product) eq "SCOPE") {
			    open $jcl, '<', $megajobs or die "Cannot open scope megacomp jcl file.\n";
		    } else {
				open $jcl, '<', $megajobp or die "Cannot open product megacomp jcl file.\n";
			}
		}
	} else {
		open $jcl, '<', $megajob or die "Cannot open megacomp jcl file.\n";
	}
	open my $newjcl, '>', $cust_megajob or die "Cannot create new megacomp jcl file.\n";

	# substitute HLQ, MLQ and USRID
	print("MEGA JCL SUBMITTED:\n");
	while (<$jcl>) {
		#print("LINE   : $_");

		$_ =~ s/HLQ/$hlq/g;
		$_ =~ s/MLQ/$mlq/g;
		$_ =~ s/USRID/$userID/g;

		#$_ =~ s/NOTIFY=&SYSUID/NOTIFY=&SYSUID,TYPRUN=SCAN/g;

		if ($isproduct) {
			$_ =~ s/PRODUCT/$product/g;
			$_ =~ s/CPROJ/$cenhlq/g;
			$_ =~ s/CLVL/$cenmlq/g;
			$_ =~ s/CASFPROJ/$asfhlq/g;
			$_ =~ s/CASFLVL/$asfmlq/g;
			$_ =~ s/CSVRPROJ/$svrhlq/g;
			$_ =~ s/CSVRLVL/$svrmlq/g;
		}

		print("$_");
		print $newjcl $_;
	}
	close $jcl;
	close $newjcl;
}

sub build {
	my $jobname;
    my $rc=1;
    my $newjob= "";

	#chdir ("$directory/$srcdir") or die "cannot change: $!\n";

	$ftp = Net::FTP->new( $iphostname, Timeout => 240 ) or $newerr = 1;
	$ftp->login( $userID, $password ) or $newerr = 1;

	$ftp->quot("site filetype=jes");
	$ftp->put($cust_megajob);

	unlink($cust_megajob);

	my $rtncode = $ftp->code;
	print("rc: $rtncode\n");
	my $msg=$ftp->message;
	print("msg: $msg");

	# check if job was submitted and get returned job ID
	if ($rtncode == 250) {

	   if ($msg =~ /.*(JOB[\d]+)/) {		# ($msg =~ /^.*[\n].{22}(.+)/) also works
          $jobname = $1;
          print("jobID: $jobname\n");
       }
       $rc = poll_job($jobname, "MEGAJOB", \$newjob);

       print("new mega job to track SYSRSLT: $newjob\n");
       if ($newjob ne "") {
          $rc = poll_job($newjob, "SYSRSLT", \$newjob);
       }
	}
	print "build sub rc: $rc \n";
	return $rc;
}

sub poll_job {
	my $jobname = shift;
	my $ddname  = shift;
	my $newmega = shift;
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
	   print("Mega job completed. Polled JES ", $times_tried, " times.\n");
	   $rc = get_results($jobname, $ddname, \@jeslog, \$$newmega);
	   #print("new mega job in poll_job: $$newmega\n");
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
	my $newmega = shift;
	my $jesline;
	my $resfile;
	my $spoolnum = 0;
	my $failjob  = '';
	my $failID   = '';
	my $failstep = '';
	my $failrc   = 0;

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

	# or attempt to read from $userID.mega.jcl(megarslt)
	# $ftp->quot("site filetype=seq");

	open my $result, '<', $resfile or die "Cannot open result file.\n";

	# parse all failed jobs/steps and their corresponding rc
	while (<$result>) {
		my $line = $_;
		$failjob = '';

		print("LINE: $line");

		if ($ddname eq "MEGAJOB") {
			if ($line =~ /.*MEGACMP\((.+)\)/) {
				$$newmega = $1;

				#print("new mega job in get_results: $$newmega\n");
			}
		}

		if ($line =~ /Job\s(.+)\((.+)\)\sStep\s(.+)\sRC\s(\d+)/) {
			$failjob  = $1;
			$failID   = $2;
			$failstep = $3;
			$failrc   = $4;

		} elsif ($line =~ /DTL.*(MEGA[\d]+).*rc=(\d+)/) {
			$failjob  = 'DTL';
			$failID   = '';
			$failstep = $1;
			$failrc   = $2;

		} elsif ($line =~ /DTL.*failed with rc=(\d+)/) {
			$failjob  = 'DTL';
			$failID   = '';
			$failstep = '';
			$failrc   = $1;
		}

        if ($failjob ne '') {
			print("   fail job : $failjob\n");
			print("   fail ID  : $failID\n");
			print("   fail step: $failstep\n");
			print("   fail rc  : $failrc\n");
        }
	}

	close $result;

	unlink($resfile);

    print "get_results rc: $failrc \n";

    return $failrc;
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
