#!/bin/perl  -w
package VALIDDATE;
use Win32::API;
use Hllapi;
use MAP;

sub dataReset {
#-------------------------------------------------------------------------------------#   
#  Perform initial setup for ValidDate
# 	
# Inputs: Session ID
# Returns: return code of the failing function otherwise zero
# 
#-------------------------------------------------------------------------------------#

	my $session   = shift;
	my $dsn       = shift;
	my $rc;
	
	
	# delete ValidDate profile data
	initProfile($session);

	return 0;
}

sub initProfile {
#-------------------------------------------------------------------------------------#   
#  This routine deletes all ispf profile members associated with ValidDate
# 	
# Inputs: Session ID
# Returns: return code of the failing function otherwise zero
# 
#-------------------------------------------------------------------------------------#
	my $session   = shift;

	my $configRef = Cfg::getcfg();
	my $delCmd    = $configRef->{'DeleteProfileCMD'};


	my $rc;
		
	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' )if not $rc;
	$rc = MAP::write2CommandLine( $session, "PFSHOW OFF", '[$enter]' ); 
	$rc = MAP::write2CommandLine( $session, "tso ex '$delCmd'",'[enter]') if not $rc;
	$rc = Hllapi::hitKey( $session, '[enter]' ) if not $rc;	
	
	return $rc;
}
1;
