#!/bin/perl  -w
package LCM;
use Win32::API;
use Hllapi;
use MAP;

sub dataReset {
#-------------------------------------------------------------------------------------#   
#  Perform initial setup for LCM
# 	
# Inputs: Session ID
# Returns: return code of the failing function otherwise zero
# 
#-------------------------------------------------------------------------------------#

	my $session   = shift;
	my $dsn       = shift;
	my $rc;
	
	
	# delete LCM profile data
	initProfile($session);

	return 0;
}

sub initProfile {
#-------------------------------------------------------------------------------------#   
#  This routine deletes all ispf profile members associated with LCM
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
 sub delAdminDB {
#-------------------------------------------------------------------------------------#   
#  This routine deletes the Admin files and database by calling a Rexx command
# 	
# Inputs: Session
# 
#-------------------------------------------------------------------------------------#
 	my $session   = shift;
 	my $configRef = Cfg::getcfg();
	my $delDB     = $configRef->{'DeleteDBCMD'};
	my $release   = $configRef->{'Release'};
	
	# delete the Admin DB
	MAP::write2CommandLine( $session, "tso ex '$delDB' '$release'", '[enter]' );
	Hllapi::hitKey( $session, '[enter]');
	Hllapi::hitKey( $session, '[enter]');
	return;
 }
1;
