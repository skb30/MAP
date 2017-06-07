#!/bin/perl  -w
package Eswtool;
use Win32::API;
use Hllapi;
use Common;
use MAP;

sub initProfile {
#-------------------------------------------------------------------------------------#   
#  This routine deletes all ispf profile members associated with ESW and then
#  compress the ispf profile to prevent SD37 abends.	  
# 	
# Inputs: Session ID
# Returns: return code of the failing function otherwise zero
# 
#-------------------------------------------------------------------------------------#
	my $session   = shift;
	my $configRef = Cfg::getcfg();
	my $delCmd    = $configRef->{'DeleteProfileCMD'};
	my $execclist = $configRef->{'Exec'};
	my $lpar      = $configRef->{'IPHostname'};
	my $rc;
	
	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' )if not $rc;
	$rc = MAP::write2CommandLine( $session, "PFSHOW OFF", '[$enter]' );
	$rc = MAP::write2CommandLine( $session, "SWAPBAR OFF", '[$enter]' ); 
	# Execute Delprof exec. Exec deletes all profile members associated with Pro/JCL
#	$rc = MAP::write2CommandLine( $session, "tso ex '$delCmd $lpar'",'[enter]');

    # figure out which lpar so we can delete the appropriate profile
    
    $lpar = substr($lpar, -4);
    
	MAP::write2CommandLine( $session, "tso ex '$delCmd' '$lpar'", '[enter]' );
	
	# make sure the clist worked
	
	$rc = MAP::findStringOnPanel($session, "NOT IN DATASET",0,1);
	if ($rc == '0' ) {
		Util::printStatus(1, "$delCmd not found in dataset. Profile not deleted. Ending script.");
		exit;
	}
	
	$rc = MAP::findStringOnPanel($session, "MEMBER VIASPROF DELETED",0,1);
	if ($rc == '-1' ) {
	   $rc = MAP::findStringOnPanel($session, "VIASPROF NOT FOUND",0,1);
	}
	Util::printStatus( $rc, "Delete Profile Members Clist: $delCmd", 1, 1 );

	$rc = Hllapi::hitKey( $session, '[enter]' );
	$rc = Hllapi::hitKey( $session, '[enter]' );
# 	$rc = Common::compressISPFprofile($session);
 	
 	#    Make sure that INTERCOM is set to ON 	
	 MAP::write2CommandLine( $session, "TSO PROFILE INTERCOM", '[enter]' );
	 MAP::write2CommandLine( $session, "TSO PROFILE", '[enter]' );
	 MAP::verifyStringNotFoundOnPanel( $session, "NOINTERCOM" );
	 MAP::pressKey( $session, '[ENTER]');
	 return $rc; 
}
sub accessProduct {
	my $session = shift;
	my $exec    = shift;
	my $configRef 		  = Cfg::getcfg();
    my $exec2             = $configRef->{'Exec2'};
	
	MAP::execPanelCmd( $session, "Command","ISRTSO" );
	MAP::write2CommandLine( $session, "ex $exec", '[enter]' );
	MAP::pressKey( $session, '[enter]');
	MAP::write2CommandLine( $session, "ex $exec2", '[enter]' );
	MAP::pressKey( $session, '[enter]');
	return 0;
}
sub pressKeyF4 {
#-------------------------------------------------------------------------------------#   
#  This routine press F4 (RUN) and add sleep time delay.
# Inputs: Session, delay time 
#   
#-------------------------------------------------------------------------------------#
	my $session   = shift; 
	my $delay     = shift;
	
	
	#set a default delay time 	
	if (!defined $delay)  {$delay = 5;}
	 		
    MAP::pressKey( $session, '[f4]');
    sleep($delay);
	
	return;
}

sub getEnv {
	
	my $stc = shift;
	   $stc = uc($stc);
	my $task = substr($stc,0,3);
	my $env;
	
	if ($task eq 'T41') {
		$env = $task;
	} elsif ($task eq 'T42' ) {
		$env = $task;
	} elsif ($task eq 'T51') {
		$env = $task;	
	} elsif ($task eq 'T52') {
		$env = 'TS52'
	} else {
		
		Util::printStatus(1, "$stc is an unknown CICS STC.");
		$env = "unknown";
	}
	return $env;
}


1; 	