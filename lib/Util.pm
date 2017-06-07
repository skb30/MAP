#!/bin/perl 
no warnings;
package Util;
use Cfg;
use Cwd;
use IO::Tee;
use IO::File;
use Net::FTP;
use File::Copy;
use Algorithm::Diff qw(diff);
# define the globals
#my $tee = new IO::Tee(\*STDOUT,new IO::File(">runlog.txt"));

sub ftpGetFile {

	my $iphostname  = shift;
	my $userID      = shift;
	my $password    = shift;
	my $file2Get    = shift;
	my $fileName    = shift;

	$ftp = Net::FTP->new( $iphostname, Timeout => 240 ) or $newerr = 1;
#	print "Can't ftp to $iphostname: $!\n" if $newerr;
	printStatus(1, "ftpGetFile Can't ftp to iphostname $iphostname: $!")if $newerr;
	return -1                        if $newerr;

#	print "Connected\n";
	printStatus(0, "ftpGetFile Connected");
	$ftp->login( $userID, $password ) or $newerr = 1;
	
#	print "Can't login to $_: $!\n" if $newerr;
	printStatus(1, "ftpGetFile Can't login to $_: $!")if $newerr;
	$ftp->quit                      if $newerr;
	next                            if $newerr;
	printStatus(0, "ftpGetFile Logged in ");
	
	# beware there is no way of checking the completion status of FTP
	
ftp->get( "\'$file2Get\'", $fileName );

	return 0;
}

sub compareArrays {

#------------------------------------------------------------------------------------------#
# Compare 2 arrays and reports the difference in an array reference
# If no differences exsit then a single element array is returned with "no diffs found"
# message.
# Returns: @noDiff  array
#          @diff    array reference  diffs
#------------------------------------------------------------------------------------------#

	my $exp      = shift;
	my $curr     = shift;
	my $skip     = shift;   # used to skip around the clean machine
	
	my $rc;
	my @curr;
	my @exp;
		

	# Remove any strings you don't want to
	# compare before sending to the compare engine
	

	
	if ($skip eq 'skip') {
		@curr = @{$curr};
		@exp  = @{$exp};
		
	} else {
		# convert refs back to arrays
		@curr = cleanupArray($curr);
		@exp  = cleanupArray($exp);
	}

    # check to make sure array's are not empty
	if (@curr or @exp) {} 
	else {
			print"+++ Empty array passed to Compare Engine +++\n";
			return ("empty array", -1);
	}
	# let's compare them
	my $diffs = diff( \@exp, \@curr );

	# we didn't have any differences, return with 0

	if ( !@$diffs ) {
		@$diffs[0] = "No Differences Found.";
		$rc = 0;
	}
	else {
		$rc = 1;
	}

	# we had diffs return the reference to the diffs
	return \@$diffs, $rc;
}

sub cleanupArray {

	# The array refenece
	my $array = shift;
	my $configRef = Cfg::getcfg();
	my $product   = lc $configRef->{'AUT'};
	my @clean;
		
	
	if (!$product) {
		print "+++ Missing Product +++\n";
		return -1;
	}
	
	if ($product eq "smartfilemvs" || $product eq "smartfiledb2" ||
	    $product eq "esw") {
		@array = cleanupArray_Smarfile($array);
	}
	else {
		@array = cleanupArray_PROJCL($array);
	}
	return @array;
}		
sub cleanupArray_Smarfile{
	
	# The array refenece
	my $array = shift;
	my @clean;
	
	while ( \@$array ) {
		my $line = shift(@$array);
		if ($line) {
						
			# Remove SDSF OUTPUT DISPLAY line
			$line =~ s/\SDSF OUTPUT DISPLAY\s.*//;
			
			# Remove the 5 numeric digit from SYSnnnnn  ej:SYS00210
			$line  =~s/(\sSYS)[0-9]{5}\s/$1/g;
			
			#remove dataset volume    : QAL528
			$line =~ s/QAL\d{3}//g;	
			
			# REMOVE Page or CSR from   Scroll ===>
			$line  =~s/(.*Scroll ===>)\s..../$1/gi;
			
			# REMOVE Page or CSR from   SCROLL ===>
			$line  =~s/(.*SCROLL ===>)\s..../$1/g;
			
			
			#remove SSID=SUBSYSTEM INFORMATION
			if ($line =~ m/\s+SSID=.+/) {
				$line =~ s/\=.+//g;	
			}
			#remove JOBxxxxx information
			$line =~ s/JOB\d{5}//g;	
			
			#remove datasets    : QAL.PHX.SFM820C.SFDMLOAD 
			$line =~ s/QAL.PHX.SFM.*//g;	
            
            #remove Userid     : QAPHX6 information
			$line =~ s/QAPHX\d.+//g;	
            
            #remove Userid     : QA###A information
			$line =~ s/QA\d+.*//g;
			
            #remove Userid     : QA056A information
			$line =~ s/QA[0-9A-Z]{3,4}.//g;	
			
            #remove Subsystem     : QAQQ information
			$line =~ s/DAQQ//g;	
            
            #remove Subsystem     : QAEQ information
			$line =~ s/DAEQ//g;	
            
            #remove TSUnnnnn     information
            $line =~s/\s+TSU[0-9]{5}.*//g;
            
            # remove time and date info for ej TIME: 18.02.07  DATE: 01/29/13
			$line =~ s/(.*)(TIME: \d{1,2}\.\d{1,2}\.\d{1,2}  DATE: \d{1,2}\/\d{1,2}\/\d{2})/$1/g; 
                        
			#remove the date
			$line =~ s/(\d{1,2}\/\d{1,2}\/\d{4})//;
			$line =~ s/(\d{1,2}\/\d{1,2}\/\d{2})//;
			$line =~ s/(\d{4}\/\d{1,2}\/\d{1,2})//;
			#remove  yyyy-mm-dd format
			$line =~ s/\d\d\d\d-\d\d-\d\d//;
			
			# remove DATE: 12JUL2012 date format
			$line =~ s/(.*)DATE: \d{1,2}[A-Z]{3}\d{4}/$1/g;  
			
			#remove the hh:mm:ss time format
			$line =~ s/(\d{1,2}:\d{1,2}:\d{1,2})//;
			
			#remove hh:mm time format
			$line =~ s/(\d{1,2}:\d{1,2})//;
			
			# remove time info for ej TIME: 19:23:27 
			$line =~ s/(.*)TIME: \d{1,2}:\d{1,2}:\d{1,2}/$1/g; 
			
			
			
			# remove the release number
			$line =~ s/\s+[R]\d\d\d//;
								
			# Remove Z18A or SYSQ from SJL output line
			# PRO/JCL Release R300   RTS Member: QARTS   System: Z18A   Security Exit: ON
			
			if ($line =~ m/\s+SYSTEM: SYSQ/) {
				$line =~ s/\s+SYSQ//g;	
			}
			
			if ($line =~ m/\s*SYSQ/) {
				$line =~ s/\s*SYSQ//g;	
			}
			if ($line =~ m/\s*SYSA/) {
				$line =~ s/\s*SYSA//g;	
			}
			
		 	
			if ($line =~ m/NOTIFY=(QA[0-9A-Z]{4,5})/) {
 				 $line =~ s/QA[0-9A-Z]{4,5}/XXXXXXXX/; 
  			#	 $line = rtrim($line);
  				 $line =~ s/ +//g;
 			}
 			
 			# ignore header record from this panel.
 			if ($line =~ m/ISRBROBA.*/) {	
 				$line =~ s/.*//g;	
 			}
 			

			# filter out PAGE or CUR from Command line record
			$line =~ s/Scroll ===\>\s(\w{3,4})\s+//;
			
			push @clean, $line;
		}
		else { last; }
	}
	return @clean;
}

sub cleanupArray_PROJCL{	
	# The array refenece
	my $array = shift;
	my @clean;
	
	while ( \@$array ) {
		my $line = shift(@$array);
		if ($line) {
			#remove PORT INFORMATION
			$line =~ s/(PORT=).*/$1/g;	
			
			$line =~ s/.*PRO\/JCL RELEASE.*//g;  
			
			#remove Release number R320 as in PRO/JCL RELEASE R320B AS OF 01/14/2014
			$line =~ s/R[0-9A-Z]{3,4}\s.*//g;
			
			#remove Release number CATALOG.Zxxx.MASTER
			$line =~ s/\CATALOG\.Z.*//g;	
			
			#remove anything after ISREDDE2
			$line =~ s/ISREDDE2\.*//g;	
			
			#remove JOB number INFORMATION ej JOB02874. 
			$line  =~s/JOB\d{5}\s+/$1/g;
			
			#remove IP ADDRESS INFORMATION ej IP Address : 10.2.8.58  
			$line  =~s/IP Address :.*//g;
						
			#remove any characters after SYS (used for SYSA, SYSQ...)
			$line =~ s/\s*SYS.*//g;	
			
			# REMOVE Page or CSR from   Scroll ===>
			$line  =~s/(.*Scroll ===>)\s..../$1/g;
			
			# REMOVE Page or CSR from   SCROLL ===>
			$line  =~s/(.*SCROLL ===>)\s..../$1/g;
			
			# remove Port       : 50105 port information
			$line =~ s/(Port\s+:).*/$1/g;	
			
			# System   port information on SYSQ on port 50105 DSS01753 message
			$line =~ s/(port\s+).*/$1/g;
				
			#remove EPASS INFORMATION
			if ($line =~ m/\s+EPASS=.+/) {
				$line =~ s/\=.+//g;	
			}
			#remove Userid     : QA056A information
			$line =~ s/(Userid\s+:).*/$1/g;	
			
			#Change  Display  Filter  View  Print  Options line to null
			$line =~ s/(Display  Filter  View  Print  Options.*)//g;	 
 
			
			#remove Server Location information
			$line =~ s/(Server Location:)\s.*/$1/g;
			
			#remove PCFile Owner information
			$line =~ s/(PCFile Owner:)\s.*/$1/g;
			
			#Connected to master PCFile on: mvssysq.asg.com(10.2.8.58/50105)  information
			$line =~ s/(Connected to master PCFile on:).*/$1/g;	
			
			#remove JCLLIB ORDER INFORMATION
			if ($line =~ m/\s+JCLLIB ORDER=.+/) {
				$line =~ s/\=.+//g;	
			}
			#remove Connected to master PCFile INFORMATION
			if ($line =~ m/\Connected to master PCFile on: .+/) {
				$line =~ s/\: .+//g;	
			}		
	 		#remove the date
			$line =~ s/(\d{1,2}\/\d{1,2}\/\d{4})//;
			$line =~ s/(\d{4}\/\d{1,2}\/\d{1,2})//;
			#remove  yyyy-mm-dd format
			$line =~ s/\d\d\d\d-\d\d-\d\d//;
			
			#remove the hh:mm:ss time format
			$line =~ s/(\d{1,2}:\d{1,2}:\d{1,2})//;
			
			#remove hh:mm time format
			$line =~ s/(\d{1,2}:\d{1,2})//;
			# remove the release number
			$line =~ s/\s+[R]\d\d\d//;
			
			# remove anything after temporay dataset names
			if ($line =~ m/\.TEMP(\d{1,3})/) {
				$line = $`;
			} 
			# convert variable userid length to fixed length maximum before comparing
			# 1 space or more before userid
			# ej: QAMGH01.QAMGH01.XXXXXX.  Both QAMGH01 ARE CHANGED TO XXXXXXXX
			if ($line  =~ m/(\s+QA[0-9A-Z]{4,5}.QA[0-9A-Z]{4,5})/) {
 				$line =~ s/\s+QA[0-9A-Z]{4,5}.QA[0-9A-Z]{4,5}//; 
	 			$line =~ s/ +//g;	
			}
	
			# convert variable userid length to fixed length maximum before comparing
			# 1 space or more before userid
			if ($line  =~ m/(\s+QA[0-9A-Z]{4,5})/) {
				$line =~ s/\s+QA[0-9A-Z]{4,5}/XXXXXXXX/g; 
			#	$line = rtrim($line);	
	   			$line =~ s/ +//g;
			}
			# Remove Z18A or SYSQ from SJL output line
			# PRO/JCL Release R300   RTS Member: QARTS   System: Z18A   Security Exit: ON
			if ($line =~ m/\s+SYSTEM: Z18A/) {
				$line =~ s/\s+Z18A//g;	
			}	
			if ($line =~ m/\s+SYSTEM: SYSQ/) {
				$line =~ s/\s+SYSQ//g;	
			}
			# Remove Z18A or SYSQ from any sentence
			if ($line =~ m/\s*Z18A/) {
				$line =~ s/\s*Z18A//g;	
			}
			if ($line =~ m/\s*SYSQ/) {
				$line =~ s/\s*SYSQ//g;	
			}
			
			# replace INFO/X JOB Lis Row 3,962 to 3,990 of 5,603 to
 			#  INFO/X JOB Lis Row  
 			if ($line =~ m/INFO\/X JOB Lis Row .*/) {
				$line =~ s/INFO\/X JOB Lis Row .*/INFO\/X JOB Lis Row/;
			}
			
			# replace PCFILE OWNER: ASGZ18A.ASG.COM(10.31.8.15/50105)  to NULL  
 			if ($line =~ m/PCFILE OWNER: .+/) {
 				$line =~ s/PCFILE OWNER: .+//;
				$line =~ s/ +//g;
			}
										
			# remove from reports : (SJL=QA056A.SJL)
			if ($line =~ m/(SJL=QA[0-9A-Z]{4,5}\..JL)/) {
		 	    $line =~ s/(SJL=QA[0-9A-Z]{4,5}\..JL)//;
		 	#    $line = rtrim($line);	
		 	    $line =~ s/ +//g;	
			}
		 	
		 	
			if ($line =~ m/NOTIFY=(QA[0-9A-Z]{4,5})/) {
 				 $line =~ s/QA[0-9A-Z]{4,5}/XXXXXXXX/; 
  			#	 $line = rtrim($line);
  				 $line =~ s/ +//g;
 			}
 			
 			# ignore header record from this panel.
 			if ($line =~ m/ISRBROBA.*/) {	
 				$line =~ s/.*//g;	
 			}
 			# replace Release number and UserID to NULL  QAL.MGH.RELEASE.userID
 			#  for ej (PR290$) and remove all blanks on line to compare
 			if ($line =~ m/QAL.MGH.(PR[0-9]{3}\$*\.QA[0-9A-Z]{4,5})/) {
				$line =~ s/PR[0-9]{3}\$\.QA[0-9A-Z]{4,5}.//;
				$line =~ s/ +//g;
			}
				 
	 
			
			# replace Release number and UserID to NULL  QAL.MGH.RELEASE.userID
 			#  for ej (PR307) and remove all blanks on line to compare
 			if ($line =~ m/QAL.MGH.(PR[0-9]{3}\.QA[0-9A-Z]{4,5})/) {
				$line =~ s/PR[0-9]{3}\.QA[0-9A-Z]{4,5}.//;
				$line =~ s/ +//g;
			}
				
			# remove from reports a date like: 12Oct2009
			$line =~ s/(\d{2}[A-Za-z]{3}\d{4})//;
			# filter out owner & location for script jjdirect/ph2a157.pl
			$line =~ s/(^Server Location:.*)//;
			$line =~ s/(^PCFile Owner:.*)//;
			$line =~ s/.*(SPFTEMP\d{1,3}).*//;
			# filter out PAGE or CUR from Command line record
			$line =~ s/Scroll ===\>\s(\w{3,4})\s+//;
			
			push @clean, $line;
		}
		else { last; }
	}
	return @clean;
}


sub reportResults {

	my $message  = shift;
	my $fileName = shift;

	# create the folder if it doesn't exist
#	open( RESULTS, ">>$fileName" ) or die "unable to open $fileName\n";
#	printf RESULTS $message;
#	close(RESULTS);
	return;
}

sub writeDiffs2File {

	my $fileName = shift;
	my $diffs    = shift;
	my $passed   = shift;

	# if the folder doesn't exist then create it.
	$fileName =~ /\/(.*)\//;
	my $folder = ($1);
	if ( !( -e $folder ) ) {

		# make the folder
		mkdir($folder);
	}
	open( DIFF, ">$fileName" ) or die("Couldn't open $fileName: $!\n");

	# If the test passed then we don't have any differences but we still need to
	# report that in the diff file.
	if ( $passed == 0 ) {
		print DIFF "No Differences Found. \n";
	}

	# dump the diff object to diff file
	else {
		$passed = 1;
		foreach my $chunk (@$diffs) {
			foreach my $line (@$chunk) {
				my ( $sign, $lineno, $text ) = @$line;
				printf DIFF "%8d$sign %s\n", $lineno + 1, $text;
				printf "%8d$sign %s\n", $lineno + 1, $text;
				print2log($lineno + 1 .  $text);
				
			}
			print DIFF
			  "-------------------------------------------------------------\n";
		}
	}
	close DIFF;

	return $passed;
}

sub xlateKeys {

#------------------------------------------------------------------------------#
#  Function xlatekeys                                                          #
#                                                                              #
#      translate user friendly keys to API defined keys.                       #
#      called by hitKeys for translation services.                             #                      			                        #
#                                                                              #
#  Parameters -                                                                #
#                                                                              #
#      key to translate                                                        #
#                                                                              #
#  Returns: translated key or 0 if key isn't found.                            #
#                                                                              #
#      None                                                                    #
#                                                                              #
#  Author: CJM                                                                 #
#------------------------------------------------------------------------------#
	%keys3270 = (
		'[f1]'         => '@1',
		'[f2]'         => '@2',
		'[f3]'         => '@3',
		'[f4]'         => '@4',
		'[f5]'         => '@5',
		'[f6]'         => '@6',
		'[f7]'         => '@7',
		'[f8]'         => '@8',
		'[f9]'         => '@9',
		'[f10]'        => '@a',
		'[f11]'        => '@b',
		'[f12]'        => '@c',
		'[f13]'        => '@d',
		'[f14]'        => '@e',
		'[f15]'        => '@f',
		'[f16]'        => '@g',
		'[f17]'        => '@h',
		'[f18]'        => '@i',
		'[f19]'        => '@j',
		'[f20]'        => '@k',
		'[f21]'        => '@l',
		'[f22]'        => '@m',
		'[f23]'        => '@n',
		'[f24]'        => '@o',
		'[enter]'      => '@E',
		'[tab]'        => '@T',
		'[home]'       => '@0',
		'[eof]'        => '@F',
		'[back_tab]'   => '@B',
		'[up]' 		   => '@U',
		'[down]' 	   => '@V',
		'[right]' 	   => '@Z',
		'[left]' 	   => '@L',
		'[delete]' 	   => '@D',
		'[end]' 	   => '@q',
		'[clear]' 	   => '@C',
		'[pa1]'        => '@x',
		'[pa2]'        => '@y',
		'[pa3]'        => '@z',
		'[attention]'  => '@A@Q',
		'[pointnshoot]' => '@A@9',
	);

	# get the key that was passed in
	my $key = lc $_[0];
	
	if ($debug) {
		print "Entering xlatekeys with key == $key\n";
	}

	# pull the value using the key
	my $value = $keys3270{$key};

	# if key wasn't found, return the key
	if ( $value eq "" ) {
#		print "*** Unknown key string $key *** \n";
		$value = $key;
	}
	if ($debug) {
		print "Leaving xlatekeys with key == $value\n";
	}
	return $value;
}
sub check_date {
	
    my $month;
	$date= get_current_date("dd-mm-yyyy");
	if ($date =~ m/(\d{2})-(\d{2})-(\d{4})/) {
	    $month = $2;
	    $month = convert_month($month); 
	    $date = "$1$month$3";
	 }	
	 return $date;
}
sub convert_month {

#------------------------------------------------------------------------------#
#  Function convert_Month                                                      #
#                                                                              #
#      Convert numeric month to  Month Name                                    #                      			                        #
#                                                                              #
#  Parameters -                                                                #
#                                                                              #
#      key to translate                                                        #
#                                                                              #
#  Returns: Converted Month Name                                               #
#                                                                              #
#      None                                                                    #
#                                                                              #
#  Author: CJM                                                                 #
#------------------------------------------------------------------------------#
	%month = (
		'01'         => 'JAN',
		'02'         =>'FEB',
		'03'         => 'MAR',
		'04'         => 'APR',
		'05'         => 'MAY',
		'06'         => 'JUN',
		'07'         => 'JUL',
		'08'         => 'AUG',
		'09'         => 'SEP',
		'10'         => 'OCT',
		'11'         => 'NOV',
		'12'         => 'DEC',
		
	);

	# get the key that was passed in
	
	my $key = lc $_[0];
		
	if ($debug) {
		print "Entering month with key == $key\n";
	}

	# pull the value using the key
	my $value = $month{$key};

	# if key wasn't found, return the key
	if ( $value eq "" ) {
#		print "*** Unknown key string $month *** \n";
		$value = $key;
	}
	if ($debug) {
		print "Leaving xlatekeys with key == $value\n";
	}
	return $value;
}

sub convertFile2Array {

#------------------------------------------------------------------------------#
#  Open the current file if it exists and return it in an array.               #                                 				           #
#------------------------------------------------------------------------------#

	my $file 			= shift @_;
	my @file;
	my $rc 				= 0;
    my $dir           	= getcwd(); 
	if ( -r $file ) {
    	open( FILE, $file ) or die "\n +++ Unable to open $file $!+++\n";

		@file = <FILE>;
		close(FILE);
		return (@file);
    } 
	return -1;
}

sub createExpectedData {

	my $configRef     = shift;
	my $file          = shift;
	my $curr_file_ref = shift;
	my $from_folder   = $configRef->{'CurrentFolderName'};
	my $to_folder     = $configRef->{'ExpectedFolderName'};
	my $rc            = 0;   

    printStatus(0, "createExpectedData: Creating  $folder/$file. CFG parameter InitExpFile is on !");
	# if the folder doesn't exist then create it.
	if ( !( -e $to_folder ) ) {

		# make the folder
		mkdir($to_folder);
	}
	copy( "./$from_folder/$file", "./$to_folder/$file" );

	if ( !( -r "./$to_folder/$file" ) ) {
		printStatus (1,"createExpectedData: Unable to open $to_folder/$file");
		$rc = -1;
	}

	return $rc;
}

sub verifyFolder {

	my $file = shift;
	
	 	 	
	# if the folder doesn't exist then create it.
	$file =~ /\/(.*)\//;
	my $folder = ($1);
	if ( !( -e $folder ) ) {

		# make the folder
		mkdir($folder);
	}
	# Make sure that the current_data file is empty.
    if (substr($file,2,12) eq "current_data") {
 	   open(FILE,">", $file) or die("Couldn't open: $file\n");

 	   close(FILE);
    }  
 	   
	return 0;
}

# Trim both sides of the string of whitespace
sub trim($) {
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

# Left trim function to remove leading whitespace
sub ltrim($) {
	my $string = shift;
	$string =~ s/^\s+//;
	return $string;
}

# Right trim function to remove trailing whitespace
sub rtrim($) {
	my $string = shift;
	$string =~ s/\s+$//;
	return $string;
}


sub popupScroll {

	( my $session, my $cmd_label, my $cmd) = @_;
	my $rc;
	my $foundPos = Hllapi::assert( $session, $cmd_label );

	##Todo fix generic scroll method.

	my $i      = 0;
	my $rowCnt = 0;
	my $maxRow = 0;
	my @array  = Hllapi::dumpPanel2Array($session);

	$foundPos = Hllapi::assert( $session, $cmd_label );
	while (@array) {
		if ($foundPos) {

			# make call passing the left tab flag.
			$rc = Hllapi::placeCursorOnInputField( $session, $foundPos, '', 1 );
#			print "found label $cmd_label at $foundPos\n";
			Hllapi::hitKey( $session, $cmd );
			Hllapi::hitKey( $session, "[enter]" );
			return 0;
		}
		else {
			Hllapi::hitKey( $session, '[F8]' );
			$foundPos = Hllapi::assert( $session, $cmd_label );
		}
		print "$_ \n";
		if ( $_ =~ /.*\s+Row\s\d{1,10}\sto\s(\d{1,10}) of (\d{1,10}).*/ ) {
			
			$rowCnt = $1;
			$maxRow = $2;
			if ( $rowCnt == $maxRow ) {
				print " $cmd_label not found\n";
				last;
			}
		}
	}
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

sub get_scalar_time {
	my ($y, $m, $d, $hh, $mm, $ss) = (localtime)[5,4,3,2,1,0]; 
	$y += 1900; $m++;
    return sprintf("%d-%02d-%02d %02d:%02d:%02d", $y, $m, $d, $hh, $mm, $ss);
}
sub get_current_date {
	
#------------------------------------------------------------------------------------------#
# Get the current date from the Host.
# Variable to pass: Dateformat.
# Dateformat are : yyyy-mm-dd, or yyyy/mm-dd mm/dd /yyyy or mm/dd/yyyy
# Returns: current date in the format requested.
#------------------------------------------------------------------------------------------#
	
	
	my $dateformat  = shift;	
	my ($y, $m, $d) = (localtime)[5,4,3]; $y += 1900; $m++;
	
	if ($dateformat eq "yyyy-mm-dd") {
		return sprintf("%d-%02d-%02d", $y, $m, $d);
		}
	elsif ($dateformat eq "yyyy/mm/dd") {
		 return sprintf("%d/%02d/%02d", $y, $m, $d);
		}
	elsif ($dateformat eq "mm/dd/yyyy") {
		 return sprintf("%02d/%02d/%d", $m, $d, $y);
		}	
	elsif ($dateformat eq "mm-dd-yyyy") {
		 return sprintf("%02d-%02d-%d", $m, $d, $y);
		}	
	elsif ($dateformat eq "dd-mm-yyyy") {
		 return sprintf("%02d-%02d-%d", $d, $m, $y);
		}				
	else {
		return "Unknown date format $dateformat\n";
		}
}		 
sub create_suite_run {
	my $date = localtime();
	my $file;
	my $suite;
	# we should be at the suite level in the directory tree
	
	# glob all the suite folders into an array an build the suite name

	my @suites = <*>;
	foreach $suite (@suites) {
		if ( -d $suite ) {
			$name = $suite . "_suite.pl";
			print "Building $name.\n";
			chdir($suite);
			open( DIFF, ">$name" ) or die("Couldn't open $name: $!\n");
	
			print DIFF "#!/bin/perl\n";
			print DIFF "# This code was auto generated by\n";
			print DIFF "# $0 \n";
			print DIFF "# This script will run all tests that were in the suite $suite folder\n";
			print DIFF "# on this date: $date\n";
			print DIFF "use POSIX qw(strftime);\n";
			print DIFF "use Cwd;\n";
			print DIFF "use Cfg;\n";
			print DIFF "use Util;\n";
			print DIFF 'my $status;' . "\n";
			print DIFF 'my $timeDiffStr;' . "\n";
			print DIFF 'my $start_time = Util::get_scalar_time();' ."\n";
			print DIFF "package Util;\n";
			
			print DIFF "print \"Suite $suite Start : " . '$start_time\n";'. "\n";
			print DIFF "open_run_log();\n";
			
			# glob all the scripts into an array
			my @files = <*>;
			foreach $file (@files) {
				if ( -d $file ) {
					chdir($file);
					@scripts = <*>;
					foreach $script (@scripts) {
						if ( $script eq "$file.pl" ) {
							print DIFF '$status' . " = run_test(\"$file\");\n";
						}
					}
					chdir("..");
				}
			}
			chdir("..");
			print DIFF 'my $end_time = get_scalar_time();' ."\n";
			print DIFF '$timeDiffStr = timeDiff( date1 => $start_time, date2 => $end_time );' . "\n";
			print DIFF "close_run_log();\n";
			print DIFF "print \"Suite $suite Ended : " . '$end_time\n";'. "\n";
			print DIFF "print \"Elapsed Time: " . '$timeDiffStr\n";' . "\n";	
		}
	}		
}

sub open_run_log {	
	open(SAVEOUT, ">&STDOUT") or die("Can't save STDOUT :$!\n");
	open(STDOUT, ">./runlog.txt" )or die("Couldn't open: $!\n");
}

sub close_run_log {	
	open(STDOUT, ">&SAVEOUT") or die("Can't save STDOUT :$!\n");
}
sub open_script_log {
	open(RUNLOG, ">test-runlog.txt" ) or die("Couldn't open: $!\n");
}
sub close_script_log {
	close (RUNLOG);
}

sub run_suite {
	my $suite_name = shift;
	my $status;
	my $timeDiffStr;
	my $pass_cnt = 0;
	my $fail_cnt = 0;
	my $suite_not_run_cnt = Cfg::get_suite_not_run_cnt();
	my $start_time = get_scalar_time();
	my $dir;
	my $run_cnt = 0;
	my @scripts;
	my $script;
	my $ucFile;	
	my $lcFile;
	
	# Glob all the script folders into an array
	my @files = <*>;
	foreach my $file (@files) {
		$dir = getcwd();
		if ( -d $file ) {
			chdir($file);
			$dir = getcwd();
			@scripts = <*>;
			
			# make sure we have files in our folder, if not cd up one level
			# to get the next folder.
			if (!@scripts){
				chdir("..");
				next;
			}
			foreach $script (@scripts) {
				$ucFile = uc($file) . ".pl";
				$lcFile = lc($file) . ".pl";
				if ($script eq "$lcFile" || $script eq "$ucFile") {
					$run_cnt++; 
					$status = Util::run_test($script, $suite_name);
					if ($status eq "passed") {
						$pass_cnt++;
					} else {
						$fail_cnt++;
					}
				} 
			}
			# determine if a script was found. If one wasn't found then user
			# probably typo'ed the script name.
			if ($run_cnt == 0){
				print "   +++ $file.pl  not found! Is script misspelled? +++\n";				

			}
			# reset run count 
			$run_cnt = 0;
			chdir '..';
		}
	}
	# check to see if any of the scripts ran in the suite otherwise
	# report 'suite not run' status.
	
	if ($pass_cnt > 0 || $fail_cnt > 0) {
		
		# bump the run suite run count
		my $run_cnt = Cfg::get_suite_run_cnt();
		$run_cnt++;
		Cfg::set_suite_run_cnt($run_cnt);
		
		# if the fail count is greater than 0 we must fail the entire suite run
		if ($fail_cnt != 0) {
			my $suite_fail_cnt = Cfg::get_suite_fail_cnt;
			$suite_fail_cnt++;
			Cfg::set_suite_fail_cnt($suite_fail_cnt);
		} else {
			$status = "Passed";
			my $suite_pass_cnt = Cfg::get_suite_pass_cnt;
			$suite_pass_cnt++;
			Cfg::set_suite_pass_cnt($suite_pass_cnt);
		}	
	} else {
#		$suite_fail_cnt++;
#		Cfg::set_suite_fail_cnt($suite_fail_cnt);
#		$suite_not_run_cnt++;
		Cfg::set_suite_not_run_cnt($suite_not_run_cnt);
		$status = "+++ Suite Not Run! +++";
		
	}
	
	my $end_time = get_scalar_time();
	$timeDiffStr = timeDiff( date1 => $start_time, date2 => $end_time );
		
#	print "  Suite $suite_name Ended : $end_time\n";
#	print "  Suite $suite_name Ended scripts passed : $pass_cnt\n";
#	print "  Suite $suite_name Ended scripts failed : $fail_cnt\n";
#	print "  Suite $suite_name Elapsed Time: $timeDiffStr\n";
#	print "  Suite $suite_name Ended with a status of: $status\n\n";
	return;		
}
sub run_test {
	my $tc         	= shift;
	my $suite_name 	= shift;
	my $configRef 	= Cfg::getcfg();
	my $libPath  = $configRef->{'MapLibPath'};
	my $status;
		
	if (!defined($libPath)) {
		print "+++ Update Cfg.pm->MapLibPath to point to your Eclipse workspace lib path. +++\n";
		print "Suite Driver Ended.\n";
		exit;
	} 
	my $start_time;
	my $end_time;
	format STDOUT_TOP =
   @<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
   "Suite Name", "Script Name", "Start Time", "End Time", "Status", "Elapsed Time"
.
	format STDOUT =
   @<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<  @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
	$suite_name, $tc, $start_time, $end_time, $status, $timeDiffStr
.

	format HISTORYLOG_TOP =
   @<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
   "Suite Name", "Script Name", "Start Time", "End Time", "Status", "Elapased Time"
.
	format HISTORYLOG =
   @<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<  @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
	$suite_name, $tc, $start_time, $end_time, $status, $timeDiffStr
.

	format SUITELOG =
   @<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<  @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
	$suite_name, $tc, $start_time, $end_time, $status, $timeDiffStr
.

	format RTS =
   @<<<<<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<  @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<< @<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<<<<<<<
	$suite_name, $tc, $start_time, $end_time, $status, $timeDiffStr
.
	
	Cfg::set_script_name($tc);
	chdir ($tc);
	my $path = getcwd();
	
	open_run_log();
	#$tee->print (localtime() . " ------- Test Case $tc.pl Started -------\n");
	print (localtime() . " ------- Test Case $tc.pl Started -------\n");
	$start_time = get_scalar_time();
	sleep 1;
    require $tc;
#    my $perlScript = "perl -I $libPath $tc"; 
#
#    print "send command: $perlScript\n";
#    my @runlog = `$perlScript`;
#    
#    my $failure = 0;
#    
#    # print and parse the runlog looking for a failure.
#    if (@runlog) {
#    	foreach my $record (@runlog) {
	
#			print $record;
#			if ($record =~ m/.*Failed! \+\+\+$/) {	
#				$failure = -1;
#			} 
#		}
#    } else {
#    	print "+++ $tc did not produce a run log! +++";
#    	$failure = -1;
#    }
	# did we find a failure message in the log?
#	if ($failure == -1) {$status = -1;} else {$status = 0;}
	$end_time = get_scalar_time();
	$timeDiffStr = timeDiff( date1 => $start_time, date2 => $end_time );
	#$tee->print (localtime() . " ------- Test Case $tc Ended. Elasped Time: $timeDiffStr ------\n\n");
	print (localtime() . " ------- Test Case $tc Ended. Elasped Time: $timeDiffStr ------\n\n");
	
	# close out the log so the following prints will go to console.
	close_run_log();
	
	$status = Cfg::get_script_status();
	if ($status == 0 ) {
		$status = "passed";
	} else {
		$status = "failed <---";
	}

	write;    # sysout 
	open( HISTORYLOG, ">>../../historylog.txt" )or die("Couldn't open: $!\n");
	write HISTORYLOG;
	close (HISTORYLOG);
	open( SUITELOG, ">>../../suitelog.txt" )or die("Couldn't open: $!\n");
	write SUITELOG;
	close (SUITELOG);
	open( RTS, ">>../../rts.txt" )or die("Couldn't open: $!\n");
	write RTS;
	close RTS;
	return $status;
}
sub printStatus {
	my $rc         = shift;
	my $function   = shift;
	my $message;
	my $script     = Cfg::get_script_name();
	my $lineNum    = Cfg::get_line_num();
	my $start_time = Util::get_scalar_time();


	Cfg::set_script_status($rc);
	
	if ($rc == '1' || $rc == '-1') {
    	$message =  "+++ $start_time $script $lineNum - $function Failed! +++\n";
    } elsif ($rc == '0' ) {
    	$message =  "*** $start_time $script $lineNum - $function Passed ***\n";
    } else {
    	$message =  "*** $start_time $script $function ***\n";
    }
    # print to console
    print($message);
    
	# print to log
	print2log ($message);
    #$tee->print($message);
    #$tee->flush;
    
    return $rc;
}

sub print2log {
	my $message = shift; 
	print RUNLOG $message;
#	print " ^^^ $message\n";
}
sub find_element_in_array {
	
	# used to find an element in an array
	# if element is found a 1 (true) is returned 
	# otherwise a zero is returned
	#
	# This routine assumes all elements are in lowercase. 
	# Example on how to convert array elements to lc:
	# TRANSFORM TO LOWERCASE
	# foreach $food (@Foods) {
	#   push(@foods,  "\L$food");
	# }

	my ($ref_array) = shift;
	my @array       = @{$ref_array};
	my $find        = lc(shift);
	my $maxIndex    = $#array;
	my $i           = 0;
	
	# find the item in the array
	while ( ( $i <= $maxIndex ) && ( (lc($array[$i]) ne $find) ) ) {	
		++$i;
	}

	if ( $i <= $maxIndex ) {    # searched it & eureka
		return 1;               # for true;
	}
	return 0;                 # for false;
}
###############################################################################
# convertArrayCharacterSet
# 
#
# DESCRIPTION: Use this function to convert data from ASCII to EBCDIC or 
#              EBCDIC to ASCII.
# Variables passed: 
#          - Session 
#          - Type of conversiont (ASCII or EBCDIC)
# 
###############################################################################
sub convertArrayCharacterSet {
	
	my $columndata  = shift;
    my $convtype    = shift;
    my $rc          = 0;
    my $ebcdic;
    my @columnRows;
    
	# convert the array reference to an array 
		@columnRows = @{$columndata};
	# convert array from ebcdic to ascii
	if ($convtype eq "EBCDIC") {
		$i = 0;
		foreach $ebcdic (@columnRows) {
			$columnRows[$i] = Convert::EBCDIC::ascii2ebcdic($ebcdic);
			$i++;
		}
	}	
	elsif ($convtype eq "ASCII") {
	    $i = 0;
		foreach $ebcdic (@columnRows) {
			$columnRows[$i] = Convert::EBCDIC::ebcdic2ascii($ebcdic);
			$i++;
		} 
	}
	else {
		    $rc = -1;
			Util::printStatus( $rc, "convertArrayCharacterSet parm $convtype is unknown" );
			@columnRows = 0;
		}	    	
	     	
	return ( \@columnRows);
}

sub stripMask {
 
	
	my $exp  	  	 = shift;
	my $curr	  	 = shift;
	my $mask_char    =shift;
	my @curr_clean;
	my @exp_clean;
	my $rc;
		
	my @curr = @{$curr};
	my @exp  = @{$exp};
	
	# clean up lines using the expected file mask
	foreach my $exp_line (@exp) {
		my @offset;
		my $cur_line;
		# get the first line of the screen shot
		$cur_line = shift(@curr);
		
        # convert the expected file line to an array so
        # we calculate the offsets of the mask chars. 
	
		my @char_array  = split(//,$exp_line);
		
		# get the offset of each mask char in the line and store it in the offset table.
		# replace the mask char '#' with a blank and store the line in @exp_clean.
		my $i = 0;
		# loop thru each char of the string looking for the mask char
		foreach my $char (@char_array) {
			if ( $char eq $mask_char ) {
				$char_array[$i] = ' ';
				push( @offset, $i );
			}
			$i++;
		}
		# convert the array back to a string
		my $str = "@char_array";
		# squeeze the extra spaces;
		$str =~ s/(.)\s/$1/seg;
		$str = trim($str);
		push(@exp_clean, $str);
		
		
		# now replace the same line in the current file
		# using the offsets

		if (@offset) {
			my @char_array  = split(//,$cur_line);
			foreach my $pos (@offset) {
				$char_array[$pos] = ' ';
			}
			# convert the array to a string
			my $str = "@char_array";
			# squeeze the extra spaces;
			$str =~ s/(.)\s/$1/seg;
			$str = trim($str);
			push(@curr_clean, $str);
		} else {
			$cur_line = trim($cur_line);
			push(@curr_clean, $cur_line );
		}
	}	
return (\@exp_clean, \@curr_clean);
}

1;
