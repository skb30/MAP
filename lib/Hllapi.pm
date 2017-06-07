#!/bin/perl -w
no warnings;
package Hllapi;
use Win32::API;
use Util;
use strict;
use Cfg;
use Win32::OLE;
Win32::OLE->Option( Warn => 3 );

# setup debug flag
my $debug;
my $rc;
my $returnCode;
sub hitKey {

#------------------------------------------------------------------------------#
#  Function hitKey                                                             #
#                                                                              #
#      Used to press the specifed key.                                         #
#  Parameters -                                                                #
#                                                                              #
#      Key to press                                                            #
#                                                                              #
#  Returns: the rc from the API call.                                          #
#                                                                              #
#      None                                                                    #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#
	( my $session, my $key2press, my $option ) = @_;

    my $rc;
	# Return -1 if the value is blank.
	if ( !defined $key2press || $key2press eq "" ) {
		print "Error - No key to press\n";
		return -1;
	}
	my $key = Util::xlateKeys($key2press);
	$rc = callAPI( $session, 3, "$key" );

	if ($option) {
		if ( $option eq "[tab]" ) {
			$rc = callAPI( $session, 3, '@T' );
		}
		elsif ( $option eq "[enter]" ) {
			$rc = callAPI( $session, 3, '@E' );
		}
		else {
#			$rc = callAPI( $session, 3, $option );

			#			print "*** hitkey() unknown type $option ***\n";
		}

	}

	if ($debug) {
		print "Leaving hitKey, rc = $rc\n\n";
	}
	return $rc;
}

sub queryCursorLocation {

	#
	# Function 7
	# This function determines the location of the cursor
	# in the Host session presentation space.
	#
	my $session = shift;
	my $pos = callAPI( $session, 7 );
	return $pos;

}


#------------------------------------------------------------------------------#
#  Function placeCursorOnInputField                                            #
#                                                                              #
#      Used to place the curson on a specified position on the panel.          #
#                                                                              #
#  Parameters -                                                                #
#      The location to place the cursor.                                       #
#                                                                              #
#                                                                              #
#  Returns: the rc from the API call.                                          #
#                                                                              #
#      None                                                                    #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#
sub pause {

	# Pause - Function 18
	( my $session, my $waitTime ) = @_;

	if ( $waitTime eq "" ) {
		$waitTime = 120;    # pause for a of second.
	}
	if ($debug) {
		print "Entering pause() with a wait time of $waitTime\n";
	}
	my $rc = callAPI( $session, 18,, 0, $waitTime );

	if ($debug) {
		print "  Leaving Pause() with rc = $rc \n";
	}
	return $rc;
}

sub callAPI {

	# call the HLLAPI and return the results - private method.
	# private data
	my $result_set;

	my $rc;


	# load the private vars from the passed in agruments
	
	my $session    = shift;
	my $function   = shift;
	my $string     = shift;
	my $length     = shift;
	my $returnCode = shift; 
	
	# define $returnCode to eliminate warning messages
	if (!defined $returnCode ) {$returnCode = 0; }
  
	# function 40 uses the last parameter for the transport of the data
	if ( $function == 40 ) {
		$returnCode = $string; 
	}

	# pack the params
	$function   = pack( 'L', $function );
	$length     = pack( 'L', length($string) );
 	$returnCode = pack( 'L', $returnCode );

	# make the call
	$session->Call( $function, $string, $length, $returnCode );

	# setup for idle loop wait call

	my $wRC       = pack( 'L', 0 );
    my $wFunciton = pack( 'L', 4 );
	my $wLength   = pack( 'L', 0 );
    my $wData     = pack( 'L', 0 );

# enter idle loop waiting for host to return back to ready mode
# notice that $wRC is true by virtue of packing it before entering the while loop.
# once the host is available, $wRC will become 0.
	while ($wRC) {
		$session->Call( $wFunciton, $wData, $wLength, $wRC );
		$wRC = unpack( 'L', $wRC );
	}

	# Unpack the retuned data
	$function = unpack( 'L', $function );

	# specialization for Copy Presentation Space (8)
	# no unpacking and return the screen using the rc
	if ( $function == 8 || $function == 5) {
		$rc = $string;

	}
	else {
		$rc     = unpack( 'L', $returnCode );
		$length = unpack( 'L', $length );

	}

	if ($debug) {
		print "   Leaving callAPI function with rc = $rc\n\n";
	}

	# specialization
	if ( $function == 6 || $function == 7 ) {
		$rc = $length;
	}
	elsif ( $function == 34 ) {
		$rc = $string;
	}
	return $rc;
}

sub connect2Session {

	my $sessionID = shift;
	my $hllapi;

	# check to see if PCOM was installed in an x86 folder
	my $pcomPath;
	
	my $hlapi32path = 'C:/Program Files/IBM/Personal Communications/EHLAPI32.dll';
	my $hlapi64path = 'C:/Program Files (x86)/IBM/Personal Communications/EHLAPI32.dll';
	
 	if (-e $hlapi32path) {
 		$pcomPath = $hlapi32path;	
 	} elsif (-e  $hlapi64path) {
 		$pcomPath = $hlapi64path;
 	} else {
 		print "+++ Unable to locate EHLAPI32.dll in the following paths: +++  \n+++ $hlapi32path +++\n+++ $hlapi64path +++\n"; 
 	}

	my $cfg = Cfg::getcfg();
	my $te  = $cfg->{'TerminalEmulator'};
    
	if ( $te eq 'PComm') {
		
		$hllapi = new Win32::API(
			$pcomPath,
			'hllapi', [ 'P', +'P', 'P', 'P' ], 'N'
		);
		die("*** Error! Unable to create handle to HLLAPI. ***\n")
		  unless ( defined($hllapi) );
	}
	elsif ( $te eq 'Rumba' ) {
		$hllapi =
		  new Win32::API( 'C:/Program Files/WallData/SYSTEM/EHLAPI32.dll',
			'hllapi', [ 'P', +'P', 'P', 'P' ], 'N' );
		die("*** Error! Unable to create handle to HLLAPI. ***\n")
		  unless ( defined($hllapi) );
	}
	elsif ( $te eq 'QWS' ) {
		$hllapi = new Win32::API( 'C:/Program Files/QWS3270 Secure/whllapi.dll',
			'WinHLLAPI', [ 'P', +'P', 'P', 'P' ], 'N' );
		die("*** Error! Unable to create handle to HLLAPI. ***\n")
		  unless ( defined($hllapi) );
	}
	elsif ( $te eq 'TN3270 Plus' ) {
		$hllapi =
		  new Win32::API( 'C:/Program Files/SDI/TN3270 Plus/whllapi.dll',
			'WinHLLAPI', [ 'P', +'P', 'P', 'P' ], 'N' );
		die("*** Error! Unable to create handle to HLLAPI. ***\n")
		  unless ( defined($hllapi) );
	}
	else {

		print
" +++ No Terminal Emulator defined in the configuartion object. Exiting Script! +++ \n";
		exit -1;
	}
	my $connBuffer = $sessionID . "\0" x 3;
	my $rc         = callAPI( $hllapi, 1, $connBuffer, 4, 13 );

	#	print "return code -$rc-\n";
	if ($debug) {
		print "Leaving connect2Session function with rc = $rc\n\n";
	}

	#	die("Unable to connect to session\n") if ( $rc != 0 );
	sleep(2);
	return ( $rc, $hllapi );

}

sub assert {

	# Search Presentation Space - 6
	my $session        = shift;
	my $searchString   = shift;
	my $startPos       = shift;
	
	my $returnCode;
	my $size = length($searchString);

	# returns the posistion of the find or 0 if not found.
	my $rc = callAPI( $session, 6, $searchString, $size, $startPos );
	return $rc;
}

sub copyField2String {

	# Copy Field to Sting - 34

	( my $session, my $startPos, my $length ) = @_;

	my $rc;

	my $buff = "\0" x $length;
	$rc = callAPI( $session, 34, $buff, $length, $startPos );

	return $rc;
}

sub isSessionInWaitState {

	#
	# Wait - 4
	# returns 0 if the host is in ready mode otherwise 1>
	#
	my $session = shift;
	if ($debug) {
		print "Entering isSessionInWaitState\n";
	}

	# see if session is busy
	my $rc = callAPI( $session, 4, 0, 0, 0 );

	# it's busy, return our busy signal.
	if ($rc) {
		return -1;
	}

	if ($debug) {
		if ( $rc == 0 ) {
			print "Leaving isSessionInWaitState = No\n";
		}
		else {
			print "Leaving isSessionInWaitState = Yes\n";
		}
	}
	return $rc;
}

sub setSessionParameters {

	#
	# Set Session Parameter - Function 9
	# returns 0 if the host is in ready mode otherwise 1>
	#
	( my $session, my $parmString ) = @_;

	if ($parmString) {
		$rc = callAPI( $session, 9, $parmString );
		if ( $rc == 0 ) {

#			print "*** session parameter $parmString set. ***\n";
		}
		else {
			print "+++ unable to set session parameter $parmString +++\n";
			$rc = -1;
		}
	}
	else {
		print "    No params passed! \n";
		$rc = -1;
	}
	return $rc;
}
sub disconnectWindowServices{
	
	# Disconnect Window Services�Function 102
	#
	# This function disconnects window services between a Windows HLLAPI application and a specified
    # Windows HLLAPI session.
	#
	# Remarks
	# After calling this function, other functions that require a connected session for window services are not
	# valid and should not be called. The Windows HLLAPI application should disconnect from all sessions
	# that have been connected for window services before exiting. This function is not supported for 5250
	# emulation.
	
    my $session = shift;

	my $function = 102;
	my $returnCode;
    my $data_strint  = 'T';
    my $data_length  = '1';

   
	# pack the params
	$function     = pack( 'L', $function );
	my $length    = pack( 'L', $data_length );
	$returnCode   = pack( 'L', $data_length );

	# make the call
	$session->Call( $function, "DISCONNECTWINDOWSERVICES", $length, $returnCode );


	# Unpack the retuned data
	$function = unpack( 'L', $function );
    $returnCode       = unpack( 'L', $returnCode );
	$length   = unpack( 'L', $length );
	
	return $rc;
	
}
sub resetSystem {
	
#------------------------------------------------------------------------------#
#  Function resetSystem   - 21
#
#     The Reset System function reinitializes EHLLAPI to its starting state.
#     The session parameter options are reset to their defaults. Event notification is stopped.
#     The reserved host session is released. The host presentation space is disconnected.
#     Keystroke intercept is disabled.
#     You can use the Reset System function during initialization or at program
#     termination to reset the system to a known initial condition.

#  Parameters -
#                                                                              #
#      Session object                                                          #
#                                                                              #
#  Returns: the rc from the API call.                                          #
#                                                                              #
#                                                                              #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#

	
    my $session = shift;
	my $function = 21;
	my $returnCode;
    my $data_strint  = '0';
    my $data_length  = '0';

   
	# pack the params
	$function     = pack( 'L', $function );
	my $length    = pack( 'L', $data_length );
	$returnCode   = pack( 'L', $data_length );

	# make the call
	$session->Call( $function, "RESETSYSTEM", $length, $returnCode );


	# Unpack the retuned data
	$function = unpack( 'L', $function );
    $returnCode       = unpack( 'L', $returnCode );
	$length   = unpack( 'L', $length );
	
	return $rc;
	
}
sub connectWindowServices{
	
	# Connect Window Services�Function 101

	
    my $session = shift;

	my $function = 101;
	my $returnCode;
    my $data_strint  = 'T';
    my $data_length  = '1';

   
	# pack the params
	$function     = pack( 'L', $function );
	my $length    = pack( 'L', $data_length );
	$returnCode   = pack( 'L', $data_length );

	# make the call
	$session->Call( $function, "CONNECTWINDOWSERVICES", $length, $returnCode );


	# Unpack the retuned data
	$function = unpack( 'L', $function );
    $returnCode       = unpack( 'L', $returnCode );
	$length   = unpack( 'L', $length );
	
	return $rc;
	
}
sub querySessions {

	#
	# Query Sessions - Function 10
	#
	#
	
    my $session = shift;

	my $function = 10;
	my $rc;
    my $data_length = 12*2;
    my $buff = "\0" x $data_length;
   
#	my	$session = new Win32::API(
#			'C:/Program Files/IBM/Personal Communications/EHLAPI32.dll',
#			'hllapi', [ 'P', +'P', 'P', 'P' ], 'N'
#		);
	
	# pack the params
	$function     = pack( 'L', $function );
#	$buff         = pack( 'L', $buff);
	my $length    = pack( 'L', $data_length );
	$returnCode   = pack( 'L', $returnCode );

	# make the call
	$session->Call( $function, $buff, $length, $returnCode );


	# Unpack the retuned data
	$function = unpack( 'L', $function );
    $rc       = unpack( 'L', $returnCode );
#    $buff     = unpack( 'L', $buff);
	$length   = unpack( 'L', $length );
	
    print "printing buff:\n$buff";
	return $rc;
}
sub disconnectPresentationSpace {

	#
	#
	
    my $session = shift; 
	$rc = callAPI($session, 2, 0, 0, 0 );
	return $rc;
}
sub copyPresentationSpace {

	#
	#
	( my $session, my $startPos, my $length ) = @_;
	if ($debug) {
		print "Entering copyPresentationSpace\n";
	}

	my $buff = "\0" x $length;
	if ($startPos) {
		$rc = callAPI( $session, 8, $buff, $length, $startPos );
	}

	if ($debug) {
		print "  Leaving copyPresentationSpace with rc == $rc\n";
	}
	return $rc;
}

#------------------------------------------------------------------------------#
#  Function placeCursorOnInputField                                            #
#                                                                              #
#      Used to place the curson on a specified position on the panel.          #
#                                                                              #
#  Parameters -                                                                #
#      The location to place the cursor.                                       #
#                                                                              #
#                                                                              #
#  Returns: the rc from the API call.                                          #
#                                                                              #
#      None                                                                    #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#
sub placeCursorOnInputField {

	# Set Cursor - Function 40
	( my $session, my $inputFieldLoc, my $enter, my $tab_left ) = @_;

	# Make sure we have a vaild location.
	if (   !defined $inputFieldLoc
		|| $inputFieldLoc eq ""
		|| $inputFieldLoc == 0 )
	{
		print "**** Invalid field position! Ending Script ****\n";
		return -1;
	}

	while ( isSessionInWaitState($session) ) {
		print "*** placeCursorOnInputField - session is busy ***\n";
		sleep(1);
	}
	my $rc = callAPI( $session, 40, $inputFieldLoc );

	# Make sure we don't tab when we're positioned on the Menu Bar
	if ( $inputFieldLoc > 81 && $enter ne "popup" ) {

		# some panels have input fields on the left side of the label
		if ($tab_left) {
			hitKey( $session, '[back_tab]' );
		}
		else {
			hitKey( $session, '[tab]' );
		}
	}

	# do the enter key too
	if ($enter) {
		hitKey( $session, '[enter]' );

	}
	if ($debug) {
		if ( $rc != 0 ) {
			print
"Warning Leaving placeCursorOnInputField with invalid position to place cursor = $rc\n\n";
		}
		else {
			print
"Leaving placeCursorOnInputField with position to place cursor = $rc\n\n";
		}
	}
	return $rc;
}

#------------------------------------------------------------------------------#
#  Function placeCursorOnPanel                                                 #
#                                                                              #
#      Used to place the curson on a specified position on the panel.          #
#                                                                              #
#  Parameters -                                                                #
#      The location to place the cursor.                                       #
#                                                                              #
#                                                                              #
#  Returns: the rc from the API call.                                          #
#                                                                              #
#      None                                                                    #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#
sub placeCursorOnPanel {

	# Set Cursor - Function 40
	( my $session, my $inputFieldLoc ) = @_;

	# Make sure we have a vaild location.
	if (   !defined $inputFieldLoc
		|| $inputFieldLoc eq ""
		|| $inputFieldLoc == 0 )
	{
		print "**** Invalid field position! Ending Script ****\n";
		return -1;
	}

	while ( isSessionInWaitState($session) ) {
		print "*** placeCursorOnInputField - session is busy ***\n";
		sleep(1);
	}
	my $rc = callAPI( $session, 40, $inputFieldLoc );
	return $rc;
}

sub keys2press {
	##todo document this API
	( my $session, my $keys2type, my $enter ) = @_;

	my $rc;
	if ($debug) {
		print "Entering keys2press with keys to press $keys2type\n";
	}
	my $size = length($keys2type);

	while ( isSessionInWaitState($session) ) {
		print "*** keys2press - Waiting for session to become ready ***\n";
		sleep(1);
	}
	$rc = callAPI( $session, 3, $keys2type, $size, 0 );

	# do the enter key too
	if ($enter) {
		while ( isSessionInWaitState($session) ) {
			print
"*** keys2press (enter) - Waiting for session to become ready ***\n";
			sleep(1);
		}
		hitKey( $session, '[enter]' );
	}
	if ($debug) {
		print "Leaving Keys2press with rc = $rc\n";
	}
	return $rc;
}

sub dumpPanel {

	#
	#
	#
	#
	my $session       = shift;
	my $display_panel = shift;
	my $fieldType     = $_[0];
	my $offset        = 1;
	my $rc;
	my @panel;


	# define $display_panel to eliminate warning messages
	if (!defined $display_panel ) {$display_panel = 0; }
	# screen size 80 x 43;
	my $readBuf = "\0" x 3440;

	# model 3 terminal
	my $mod3 = 1920;

	# model 4 terminal
	my $mod4 = 3200;

	#	$rc = callAPI($session,9,"NOXLATE,DISPLAY",15,0);
	#	$rc = callAPI($session,9,"EAB,NOXLATE",12,0);
	$readBuf = callAPI( $session, 8, $readBuf, $mod4, $offset );
    #printf ("%x80", $readBuf);
    #print "\n";
	for ( my $k = 0 ; $k < 43 ; $k++ ) {
		my $offset = $k * 80;
		$panel[$k] = substr( $readBuf, $offset, 80 ) . "\n";

		# display the offsets of each record in the panel
		if ( $display_panel == 1 ) {
			print "$offset+ $panel[$k]";
		}
	}
	if ($debug) {
		print "Leaving dumpPanel\n";
	}
	return @panel;
}

sub dumpCICSscreen {

	#
	#
	#
	#
	my $session       = shift;
	my $display_panel = shift;
	my $fieldType     = $_[0];
	my $offset        = 1;
	my $rc;
	my @panel;

	# screen size 80 x 24;
	my $readBuf = "\0" x 1920;

	# model 3 terminal
	my $mod3 = 1920;

	# model 4 terminal
	my $mod4 = 3200;

	#	$rc = callAPI($session,5,"NOXLATE,DISPLAY",15,0);
	#	$rc = callAPI($session,9,"EAB,NOXLATE",12,0);
	$readBuf = callAPI( $session,5, $readBuf, $mod3, $offset );

	for ( my $k = 0 ; $k < 24 ; $k++ ) {
		my $offset = $k * 80;
		$panel[$k] = substr( $readBuf, $offset, 80 ) . "\n";

		# display the offsets of each record in the panel
		if ( $display_panel == 1 ) {
			print ("$offset+ $panel[$k]");
		}
	}
	if ($debug) {
		print "Leaving dumpPanel\n";
	}
	return @panel;
}

sub dumpPanel2Array {

	#
	#
	#
	#
	my $session = shift;
	if ($debug) {
		print "Entering dumpPanel\n";
	}
	my $fieldType = $_[0];
	my $offset    = 1;
	my $rc;
	my @panel;

	# screen size 80 x 40;
	my $readBuf = "\0" x 3200;

	# model 3 terminal
	my $mod3 = 1920;

	# model 4 terminal
	my $mod4 = 3200;

	#	$rc = callAPI($session,9,"NOXLATE,DISPLAY",15,0);
	#	$rc = callAPI($session,9,"EAB,NOXLATE",12,0);
	$rc = callAPI( $session, 8, $readBuf, $mod4, $offset );

	for ( my $k = 0 ; $k < 40 ; $k++ ) {
		my $offset = $k * 80;
		$panel[$k] = substr( $rc, $offset, 80 );
	}
	if ($debug) {
		print "Leaving dumpPanel\n";
	}
	return @panel;
}

sub startPCOMsession {

	#Starts a new session or connects to an existing one.
	my $pcomId = shift;
	my $rc;
	my $session;
	my $tries;
	my $session_info;
	my $configRef = Cfg::getcfg();
	my $profile   = $configRef->{'PCOM_Profile_Name'};
	my $lpar      = $configRef->{'LPAR'};
	# upper case 
	   $lpar = uc($lpar);
	my $userid    = $configRef->{'UserID'};
	my $password  = $configRef->{'Password'};
	my $proc      = $configRef->{'Logon_Procedure'};
	my $cmd       = $configRef->{'Command'};
	my $connmgr   = Win32::OLE->new("PCOMM.autECLConnMgr")
	  or return ("ERROR:-->Could not create PCOMM.autECLConnMgr : $!");

     Util::printStatus(0, "Starting PCOM with ID of: $pcomId");
	# Start PCOM session if it isn't already started.
	$session_info = $connmgr->{autECLConnList}->FindConnectionByName($pcomId);

	# do we already have a session?
	if ( !$session_info ) {
		$connmgr->StartConnection("profile=$profile connname=$pcomId");
		$tries = 0;
		while (
			!(
				$session_info =
				$connmgr->{autECLConnList}->FindConnectionByName($pcomId)
			)
		  )
		{
			$connmgr->{autECLConnList}->refresh();
			sleep(2);
			$tries++;
			return ("ERROR:-->Unable to start pcomm.") if ( $tries > 10 );
		}

		( $rc, $session ) = Hllapi::connect2Session($pcomId);
		keys2press( $session, "$lpar $userid", "[enter]" );
		sleep(2);
		keys2press( $session, $password );

 		hitKey( $session, '[tab]' );
		# clear proc field before typing the proc name
		hitKey( $session, '[eof]' );
		keys2press( $session, $proc );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[eof]' );
		# write the command if the user supplied one in the .ini file
		keys2press($session, $cmd );				
		hitKey( $session, "[enter]" );
		hitKey( $session, "[enter]" );
		hitKey( $session, "[enter]" );
	}
	return ( $session, $rc );
}

sub startPCOMsessions {

	#Starts a new session or connects to an existing one.
	my $pcomId = shift;
	my $index  = shift;
	my $rc;
	my $session;
	my $tries;
	my $session_info;
	my $configRef = Cfg::getcfg();
	my $profile   = $configRef->{'PCOM_Profile_Name'};
	my $lpar      = $configRef->{"LPAR$index"};
	# upper case 
	   $lpar = uc($lpar);
	my $userid    = $configRef->{"UserID$index"};
	my $password  = $configRef->{"Password$index"};
	my $proc      = $configRef->{"Logon_Procedure$index"};
	my $cmd       = $configRef->{'Command'};
	my $connmgr   = Win32::OLE->new("PCOMM.autECLConnMgr")
	  or return ("ERROR:-->Could not create PCOMM.autECLConnMgr : $!");

     Util::printStatus(0, "Starting PCOM with ID of: $pcomId");
	# Start PCOM session if it isn't already started.
	$session_info = $connmgr->{autECLConnList}->FindConnectionByName($pcomId);

	# do we already have a session?
	if ( !$session_info ) {
		$connmgr->StartConnection("profile=$profile connname=$pcomId");
		$tries = 0;
		while (
			!(
				$session_info =
				$connmgr->{autECLConnList}->FindConnectionByName($pcomId)
			)
		  )
		{
			$connmgr->{autECLConnList}->refresh();
			sleep(2);
			$tries++;
			return ("ERROR:-->Unable to start pcomm.") if ( $tries > 10 );
		}

		( $rc, $session ) = Hllapi::connect2Session($pcomId);
		keys2press( $session, "$lpar $userid", "[enter]" );
		sleep(2);
		keys2press( $session, $password );

 		hitKey( $session, '[tab]' );
		# clear proc field before typing the proc name
		hitKey( $session, '[eof]' );
		keys2press( $session, $proc );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[eof]' );
		# write the command if the user supplied one in the .ini file
		keys2press($session, $cmd );				
		hitKey( $session, "[enter]" );
		hitKey( $session, "[enter]" );
		hitKey( $session, "[enter]" );
	}
	return ( $session, $rc );
}

sub stopPCOMsession {

	#Stops a session
	my $pcomId = shift;
	my $rc;
	my $session;
	my $connmgr = Win32::OLE->new("PCOMM.autECLConnMgr")
	  or return ("ERROR:-->Could not create PCOMM.autECLConnMgr : $!");

	# Start PCOM session if it isn't already started.
	#	$session_info = $connmgr->{autECLConnList}->FindConnectionByName($pcomId);

	$connmgr->StopConnection( "$pcomId", "saveprofile=no" );
	return;
}

sub startPCOMCICSsession {
   
	#Starts a new session or connects to an existing one.
	my $pcomId2 = shift;
	my $applid  = shift;
	
    print "\n $pcomId2 \n";
    
	my $rc;
	my $session;
	my $tries;
	my $session_info;
	my $configRef = Cfg::getcfg();
	my $profile   = $configRef->{'PCOM_Profile_Name'};
	my $aut       = $configRef->{'AUT'};
	my $userID   = $configRef->{'UserID'};
	my $password  = $configRef->{'Password'};
	
    # setup the default applid
    
    if (!defined $applid) {
    	 $applid    = $configRef->{'CICSApplid'};
    }
	
	
	
	my $connmgr   = Win32::OLE->new("PCOMM.autECLConnMgr")
	  or return ("ERROR:-->Could not create PCOMM.autECLConnMgr : $!");

	# Start PCOM session if it isn't already started.
	$session_info = $connmgr->{autECLConnList}->FindConnectionByName($pcomId2);

	# do we already have a session?
	if ( !$session_info ) {
		$connmgr->StartConnection("profile=$profile connname=$pcomId2");
		$tries = 0;
		while (
			!(
				$session_info =
				$connmgr->{autECLConnList}->FindConnectionByName($pcomId2)
			)
		  )
		{
			$connmgr->{autECLConnList}->refresh();
			sleep(2);
			$tries++;
			return ("ERROR:-->Unable to start pcomm.") if ( $tries > 10 );
		}

		( $rc, $session ) = Hllapi::connect2Session($pcomId2);
		# make sure the session is displaying the vtam menu
		while (MAP::findStringOnPanel($session, "Enter APP or APP + userid for TSO",0,1) != 0) {
			sleep 1;
		}
		keys2press( $session, "L APPLID=$applid", "[enter]" );
		
		if ($aut eq 'SmartScope') {
			sleep 5;
			keys2press( $session, "$userID", "[tab]" );
			keys2press( $session, "$password", "[enter]" );
		}
				
	}
	return ( $session, $rc );
}
sub startESHIPsession {
   
	#Starts a new session or connects to an existing one.
	my $pcomId2 = shift;
	my $applid  = shift;
	
    print "\n $pcomId2 \n";
    
	my $rc;
	my $session;
	my $tries;
	my $session_info;
	my $configRef = Cfg::getcfg();
	my $profile   = $configRef->{'PCOM_Profile_Name'};
	my $aut       = $configRef->{'AUT'};
	my $userID   = $configRef->{'UserID'};
	my $password  = $configRef->{'Password'};
	my $cmd       = $configRef->{'Command'};
	
    # setup the default applid
    
    if (!defined $applid) {
    	 $applid    = $configRef->{'CICSApplid'};
    }
	
	
	
	my $connmgr   = Win32::OLE->new("PCOMM.autECLConnMgr")
	  or return ("ERROR:-->Could not create PCOMM.autECLConnMgr : $!");

	# Start PCOM session if it isn't already started.
	$session_info = $connmgr->{autECLConnList}->FindConnectionByName($pcomId2);

	# do we already have a session?
	if ( !$session_info ) {
		$connmgr->StartConnection("profile=$profile connname=$pcomId2");
		$tries = 0;
		while (
			!(
				$session_info =
				$connmgr->{autECLConnList}->FindConnectionByName($pcomId2)
			)
		  )
		{
			$connmgr->{autECLConnList}->refresh();
			sleep(2);
			$tries++;
			return ("ERROR:-->Unable to start pcomm.") if ( $tries > 10 );
		}

		( $rc, $session ) = Hllapi::connect2Session($pcomId2);

		
		# make sure the session is displaying the vtam menu
		while (MAP::findStringOnPanel($session, "Enter: LOGON APPLID",0,1) != 0) {
			sleep 1;
		}
		keys2press( $session, "Logon  APPLID(tsoes)", "[enter]" );
		sleep(1);
		keys2press( $session, "$userID", "[enter]");
		sleep(1);
		keys2press( $session, "$password" );
		sleep (1);
		hitKey( $session, '[tab]' );
#		# clear proc field before typing the proc name
#		hitKey( $session, '[eof]' );
#		keys2press( $session, $proc );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[eof]' );
		# write the command if the user supplied one in the .ini file
		keys2press($session, $cmd );
		# in case ID is still logged on. 	
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );
		hitKey( $session, '[tab]' );			
		hitKey( $session, "s" );
		hitKey( $session, "[enter]" );
		hitKey( $session, "[enter]" );
				
	}
	return ( $session, $rc );
}

sub startPCOM {

	#Starts a new session or connects to an existing one.
	my $pcomId = shift;
	my $rc;
	my $session;
	my $tries;
	my $session_info;
	my $connmgr = Win32::OLE->new("PCOMM.autECLConnMgr")
	  or return ("ERROR:-->Could not create PCOMM.autECLConnMgr : $!");

	# Start PCOM session if it isn't already started.
	$session_info = $connmgr->{autECLConnList}->FindConnectionByName($pcomId);

	# do we already have a session?
	if ( !$session_info ) {
		sleep(1);
		$connmgr->StartConnection("profile=QA057a connname=$pcomId");
		$tries = 0;
		while (
			!(
				$session_info =
				$connmgr->{autECLConnList}->FindConnectionByName($pcomId)
			)
		  )
		{
			$connmgr->{autECLConnList}->refresh();
			$tries++;
			return ("ERROR:-->Unable to start pcomm.") if ( $tries > 10 );
		}

		( $rc, $session ) = Hllapi::connect2Session($pcomId);
	}
	return ( $session, $rc );
}

sub capturePopUp {

	# This routine collects the Popup area of a panel and stuffs it into the
	# report array to be written to the current data file.
	#
	# Returns an array containing the Popup panel contents
	#

	my $session            = shift;
	my $currentFileName    = shift;
	my $configRef          = Cfg::getcfg();
	my $initExpFile        = $configRef->{'InitExpFile'};
	my $currentFoldername  = $configRef->{'CurrentFolderName'};
	my $expectedFolderName = $configRef->{'ExpectedFolderName'};
	my $aut                = $configRef->{'AUT'};
	my $scroll_type;
	my $child = 0;
	my $currfile;
	my @report;
	my @panel;


	@panel = Hllapi::dumpPanel($session);
	$aut   = lc($aut);
	

# check and see if it's a child popup first. If so, figure out it's scrolling method
# then process the records.

	# process a child popup
	foreach my $line (@panel) {

		    if ( $line =~ m/\s[eD].+\se(\s+.*)e\s+e\s/ ) {	
#		    if ($line =~ m/\se\s(.*)\se\s/){	bad setting used from esw - all esw screens need to be recollected
			$child = 1;
			if ( $line =~ m/\s+More:\s+/ ) {

				# scroll type More
				@report = scroll_popup( $session, $child, '1' );
				last;
			}
			elsif (
				$line =~ m/\s+Row\s+\d{1,10}\s+to\s+\d{1,10}\s+of\s+\d{1,10}/ )
			{

				# scroll type Row
				@report = scroll_popup( $session, $child, '0' );
				last;

				# no scroll popup
			}
			else {
				push( @report, "$1\n" );
			}

		}
	}

	# process a parent popup
	if ( !$child ) {
		foreach my $line (@panel) {
			if ( $line =~ m/.*\se\s(.*)\se\s.*/ ) {
				push( @report, "$1\n" );
				if ( $line =~ m/\s+More:\s+/ ) {
					@report = scroll_popup( $session, $child, '1' );
					last;
				}
			}
			elsif (
				$line =~ m/\s+Row\s+\d{1,10}\s+to\s+\d{1,10}\s+of\s+\d{1,10}/ )
			{
				@report = scroll_popup( $session, $child, '0' );
				last;
			}
			else {
				push( @report, "$1\n" );
			}
		}
	}
	
	

	# now write the popup records to the file

	# Check if current_data folder exists. Create it if need be.
	if ( !( -d $currentFoldername ) ) {
		mkdir($currentFoldername);
		print "Building $currentFoldername Directory \n";
	}

	# Delete file if it exists.
	if ( -e ">./$currentFoldername/$currentFileName" ) {
		unlink $currfile;
	}

	# now print the array to a file and go home
	open( CURRFILE, ">./$currentFoldername/$currentFileName" )
	  or die("Couldn't open $currentFileName: $!\n");
	print CURRFILE @report;
	close(CURRFILE);

	# Check if exp_data Directory exists. Create it if not there.
	if ( !( -d $expectedFolderName ) ) {
		mkdir($expectedFolderName);
		print " Building $expectedFolderName Directory \n";
	}

	# Write the expected file only for the first time around.

	if ($initExpFile) {
		$rc = Util::createExpectedData( $configRef, $currentFileName );
	}
	return (@report);
}


sub newCapturePopUp {

	# This routine collects the Popup area of a panel and stuffs it into the
	# report array to be written to the current data file.
	#
	# Returns an array containing the Popup panel contents
	#

	my $session            = shift;
	my $currentFileName    = shift;
	my $configRef          = Cfg::getcfg();
	my $initExpFile        = $configRef->{'InitExpFile'};
	my $currentFoldername  = $configRef->{'CurrentFolderName'};
	my $expectedFolderName = $configRef->{'ExpectedFolderName'};
	my $scroll_type;
	my $child       = 0;
	my $numOfPopups;
	my $page        = 1;
	my $currfile;

	my @report;
	my @panel;
	my @temp;

    until ($page == 0 ) {
    	$page = 0; # reset 
    	$numOfPopups = 0;
    	@panel = Hllapi::dumpPanel($session);

		# process the panel to see how many nested popups are displayed
		@temp = @panel;
		foreach my $line (@temp) {
			if ($line =~ m/Es+N/){
				$numOfPopups++;
			} 
		} 
		foreach my $line (@panel) {
			my $temp;
			# remove the popup markers
			if ($numOfPopups == 1) {
				if ($line =~ m/\se\s(.+).*\se\s/){
					$temp = $1;
					$temp=~ m/\se\s(.*)/;
					push( @report, "$1\n" );;
				}
				# do we need page this popup?
				if ($temp =~ m/More:\s\+/) {
					$page = 1;
				}
			} elsif ($numOfPopups == 2) {
				if ($line =~ m/\se\s.+\se\s(.*)\se\s/){
					$temp = $1;
					$temp=~ m/\se\s(.*)/;
					push( @report, "$1\n" );;
				}
				# do we need page this popup?
				if ($temp =~ m/More:\s\+/) {
					$page = 1;
				}
			} elsif ($numOfPopups == 3 || $numOfPopups == 4) {
				if ($line =~ m/\se\s.+\se\s.+\se(.+)\se.+/){  	
					$temp = $1;
					$temp=~ m/\se\s(.*)/;
					push( @report, "$1\n" );;
				}
				# do we need page this popup?
				if ($temp =~ m/More:\s\+/) {
					$page = 1;
				}
			} else {
#				print "+++ scroll_capture_TriTune() Unknown  Popup +++ \n";
			}
		}
		if ($page == 1) {Hllapi::hitKey( $session, '[F8]' );}
		
    }
	
	
	

	# now write the popup records to the file

	# Check if current_data folder exists. Create it if need be.
	if ( !( -d $currentFoldername ) ) {
		mkdir($currentFoldername);
		print "Building $currentFoldername Directory \n";
	}

	# Delete file if it exists.
	if ( -e ">./$currentFoldername/$currentFileName" ) {
		unlink $currfile;
	}

	# now print the array to a file and go home
	open( CURRFILE, ">./$currentFoldername/$currentFileName" )
	  or die("Couldn't open $currentFileName: $!\n");
	print CURRFILE @report;
	close(CURRFILE);

	# Check if exp_data Directory exists. Create it if not there.
	if ( !( -d $expectedFolderName ) ) {
		mkdir($expectedFolderName);
		print " Building $expectedFolderName Directory \n";
	}

	# Write the expected file only for the first time around.

	if ($initExpFile) {
		$rc = Util::createExpectedData( $configRef, $currentFileName );
	}
	return (@report);
}

sub scroll_popup {
	my $session    = shift;
	my $popupType  = shift;
	my $scrollType = shift;
	
	
	my $configRef  = Cfg::getcfg();
	my $aut        = $configRef->{'AUT'};

	my $endOfPopup = 0;
	my $endOfList  = 1;
	my $endOfData  = 0;
	my $match;
	my $line;
	my $rc;
	my $scroll_down;
	my $type;
	my @panel;
	my @report;
	
	
	# tritune uses F8 for scrolling down. 
	if ($aut eq "TRITUNE") {
		@report = scroll_capture_TriTune($session, $popupType);
		return (@report);
	} 

	until ( $endOfPopup == $endOfList || ( $endOfData == 1 ) ) {
		@panel = Hllapi::dumpPanel($session);
		foreach my $line (@panel) {
			# process either parent or child popup records
			if ( $popupType == 0 ) {
				if ( $line =~ m/.*\se(\s.*\s)e\s/ ) {
					push( @report, "$1\n" );
				}
			}
			else {

				# popup type 'child'
				# if ( $line =~ m/\s[eD].+\se(\s+.*)e\s+e\s/ ) {
				# Capture only the content within the popup
 				#if ($line =~ m/\s[eD](.+)\se\s+.*./) {
 					
				if ($line =~ m/(\s[eD].+\se\s+.*.)/ ) {		
					push( @report, "$1\n" );
				}
			}

			# now determine whether it's 'more' or 'row' scrolling
			if ( $scrollType == 0 ) {

				# look for the 'row xxx to xxx of xxx' tag to determine if we
				# need to page.
				if ( $line =~
					m/.*e.*Row\s+\d{1,10}\s+to\s+(\d{1,10})\s+of\s+(\d{1,10})/ )
				{
					$endOfPopup = $1;
					$endOfList  = $2;
				}
			}

			# 'More' type scrolling
			else {

				if ( $line =~ m/.*e\s+More:\s+-\s+e/ ) {
					$endOfData = 1;

					# determine when to page down inside a 'More' type popup.
					}
					elsif ( $line =~ m/\sDs+M\s/ ) {
						last;
				}	
			}
		}

		# determine when to page down based on scroll type
		if ( $scrollType == 1 ) {

			# 'more' type scrolling
			if ( !$endOfData ) {
				Hllapi::hitKey( $session, '[enter]' );
			}
		}
		else {

			# 'row' type scrolling
			if ( $endOfPopup != $endOfList ) {
				Hllapi::hitKey( $session, '[F8]' );
			}
		}
	}
	return @report;
}

sub scroll_capture_TriTune {
	my $session    = shift;
	my $popupType  = shift;
	my @panel;
	my @report;
	my @temp;
	my $endOfData   = 0;
	my $numOfPopups = 0; 
	
	
	until ( $endOfData == 1 )  {
		@panel = Hllapi::dumpPanel($session);
		@temp  = @panel;
		
		# process the panel to see how many popups are being displayed
		foreach my $line (@temp) {
			if ($line =~ m/Es+N/){
				$numOfPopups++;
			} 
		} 
		foreach my $line (@panel) {
			# determine if we need to page down
			if ($line =~ m/More:\s-\se/) {
				$endOfData = 1;
			}

			# remove the popup markers
			if ($numOfPopups == 1) {
				if ($line =~ m/\se\s(.+).*\se\s/){
					my $temp = $1;
					$temp=~ m/\se\s(.*)/;
					push( @report, "$1\n" );;
				}
				
			} elsif ($numOfPopups == 2) {
				if ($line =~ m/\se\s.+\se\s(.*)\se\s/){
					my $temp = $1;
					$temp=~ m/\se\s(.*)/;
					push( @report, "$1\n" );;
				}
				
			} elsif ($numOfPopups == 3 || $numOfPopups == 4) {
				if ($line =~ m/\se\s.+\se\s.+\se(.+)\se.+/){  	
					my $temp = $1;
					$temp=~ m/\se\s(.*)/;
					push( @report, "$1\n" );;
				}
			} else {
				print "+++ scroll_capture_TriTune() Unknown  Popup +++ \n";
			}
				

		}
		# end of buffer page down
		Hllapi::hitKey( $session, '[F8]' );
	}
	return (@report);
}

sub scroll_popup_find {
	my $session = shift;
	my $label   = shift;
	my $endOfData = 0;
	my $pos;
	my $find;

	until ( $endOfData == 1 ) {
		$pos = assert( $session, $label );
		if ($pos) {
			print "String $find found at pos $pos\n";
			placeCursorOnInputField( $session, $pos );
			hitKey( $session, '[back_tab]' );
			hitKey( $session, '[F1]' );
			$endOfData = 1;
		}
		else {
			hitKey( $session, '[enter]' );
		}

	}
	return $rc;
}

sub querySessionStatus {
	my $sessionID = shift;
	my $connmgr = Win32::OLE->new("PCOMM.autECLConnMgr");
	
	my $session_info = $connmgr->{autECLConnList}->FindConnectionByName($sessionID);	
	print "$session_info\n";
	return $session_info;
}
1;
