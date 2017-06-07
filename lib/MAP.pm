#!/bin/perl -w
package MAP;
no warnings;
use Win32::API;
use Cfg;
use Cwd;
use IO::Tee;
use IO::File;
# ASG's packages
use Common;
use Hllapi;
use Util;
use PROJCL::PanelsMap;
use PROJCL::ProJcl;

sub navigate2Panel {
	( my $session, my $option, my $expPanelID ) = @_;
	my $panelID = Common::getPanelID($session);
	my $panelTitle;
	my $panel_command_field;
	my $panel_option;
	my $rc;

	( $panelTitle, $panel_command_field, $panel_option ) =
	  Common::processPanelMap( $panelID, $option );

	$rc = write2PanelField( $session, $panel_command_field, $panel_option );

	# hit the enter key if previous command was successful
	Hllapi::hitKey( $session, '[enter]' ) if ( not $rc );

 # if we were passed an expected panel id then verify that we are on that panel.
	if ($expPanelID) {
		$rc = findStringOnPanel( $session, $expPanelID ) if ( not $rc );
	}

	Util::printStatus( $rc, "navigate2Panel $expPanelID" );

	#	return $rc;

}

sub navigateBack2Panel {

#------------------------------------------------------------------------------#
#  Function navigate2Panel                                                     #
#                                                                              #
#      Takes the PanelID of the panel that you want to navigate back to.       #
#      This function simply hits PF3 to back out of the application looking for#                      			                        #
#      the panelID that you want to end up on.                                 #
#  Parameters -                                                                #
#                                                                              #
#      The panelID you want to back out to.                                    #
#                                                                              #
#  Returns: translated key or 0 if key isn't found                             #
#                                                                              #
#      None                                                                    #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#

	( my $session, my $panelID, my $f3 ) = @_;
	my $currentPanelID;
	my $postPanelID;
	my $f3orf12;
	my $rc;

	# Return -1 if the value is blank.
	if ( !defined $panelID || $panelID eq "" ) {
		Util::printStatus( '-1', "navigateBack2Panel - No panel ID value specified" );
		return -1;
	}

	# Setup the type of back naviagation.

	if ( uc($f3) eq '[f12]' ) {
		$f3orf12 = '[f12]';
	}
	else {
		$f3orf12 = '[f3]';
	}

	# setup max F3 count
	my $i = 0;

	# exit script if we can't find the panel the user want's to back out to.
	Hllapi::setSessionParameters( $session, "SRCHALL,SRCHFRWD" );
	while ( Hllapi::assert( $session, $panelID ) == 0 ) {
		$currentPanelID = Common::getPanelID($session);
		Hllapi::hitKey( $session, $f3orf12 );
		$postPanelID = Common::getPanelID($session);

		#		# if [f3] doesn't work then try cancel
		#		if ( $currentPanelID eq $postPanelID ) {
		#			write2CommandLine( $session, "cancel", "[enter]", " ===>" );
		#		}
		if ( $i == 10 ) {
			
			$rc = -1;
			Util::printStatus( $rc, "navigate2Panel: Unable to find panel $panelID, exiting script!" );
			last;
		}
		$i++;
	}
    Util::printStatus( $rc, "navigate2Panel-$panelID" );
	return $rc;
}

sub navigate2DropDownList {

#------------------------------------------------------------------------------#
#  Function navigate2DropDown                                                  #
#                                                                              #
#      Use this function to select a menu-item from a drop-list                #
#                                                                              #
#  Parameters -                                                                #
#      Session Object                                                          #
#      The Menu drop-down you want to select                                   #
#      The menu item to select
#                                                                              #
#  Returns -                                                                   #
#      Sucess = 0                                                              #
#      Failure = 1                                                             #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#

	( my $session, my $menu_name, my $menu_key ) = @_;
	my $panelID = Common::getPanelID($session);
	my $panelTitle;
	my $panel_command_field;
	my $panel_option;
	my $rc;
	my $foundPos = Common::findStringPosition( $session, "$menu_name",1 );

	# first things first. If we can't find the menu name return with error.
	if ( !$foundPos ) {
		Util::printStatus( '-1', "navigate2DropDownList \"$menu_name\"" );
		return -1;

	}

# if user dosen't supply and menu key we assume that they just want to display the menu list
	if ( !$menu_key ) {
		$rc = Hllapi::placeCursorOnInputField( $session, $foundPos, "1" );
		return $rc;
	}

	##todo trace rc then add error checking.
	$rc = Hllapi::placeCursorOnInputField( $session, $foundPos, "1" );
	( $panelTitle, $panel_command_field, $panel_option ) =
	  Common::selectMenuMapItem( $session, $panelID,, $menu_name, $menu_key );
	if ( $panelTitle == -1 ) {
		$rc = -1;
	}
	Util::printStatus( $rc, "navigate2DropDownList \"$menu_name\"" );
	return $rc;
}

sub navigate2PopupDropDownList {

#------------------------------------------------------------------------------#
#  Function navigate2DropDown                                                  #
#                                                                              #
#      Use this function to select a menu-item from a drop-list                #
#                                                                              #
#  Parameters -                                                                #
#      Session Object                                                          #
#      The Menu drop-down you want to select                                   #
#      The menu item to select
#                                                                              #
#  Returns -                                                                   #
#      Sucess = 0                                                              #
#      Failure = 1                                                             #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#

	( my $session, my $menu_name, my $menu_key, my $panelID ) = @_;

	#	my $panelID = Common::getPanelID($session);
	my $panelTitle;
	my $panel_command_field;
	my $panel_option;
	my $rc;

	Hllapi::setSessionParameters( $session, "SRCHFROM,SRCHFRWD" );
	my $foundPos = Common::findStringPosition( $session, "$menu_name", '100' );

	# first things first. If we can't find the menu name return with error.
	if ( !$foundPos ) {
		Util::printStatus( $foundPos,
			"navigate2DropPopupDownList \"$menu_name\"" );
		return -1;

	}

# if user dosen't supply and menu key we assume that they just want to display the menu list
	if ( !$menu_key ) {
		$rc = Hllapi::placeCursorOnInputField( $session, $foundPos, "popup" );
		return $rc;
	}

	##todo trace rc then add error checking.
	$rc = Hllapi::placeCursorOnInputField( $session, $foundPos, "popup" );
	( $panelTitle, $panel_command_field, $panel_option ) =
	  Common::selectMenuMapItem( $session, $panelID,, $menu_name, $menu_key );
	if ( $panelTitle == -1 ) {
		$rc = -1;
	}
	Util::printStatus( $rc, "navigate2PopupDropDownList \"$menu_name\"" );
	Hllapi::setSessionParameters( $session, "SRCHALL,SRCHFRWD" );
	return $rc;
}

sub write2CommandLine {

	( my $session, my $cmd, my $enter, my $cmd_line ) = @_;
	my $panelID = Common::getPanelID($session);
	my $panelTitle;
	my $panel_command_field;
	my $panel_option;
	my $tab;
	my $rc;
	my $cmd_line_key = 'field_command';
	my $configRef    = Cfg::getcfg();
	my $aut          = $configRef->{'AUT'};

	# Set default command line
	if ( !$cmd_line ) {
		$cmd_line = "===>";
	}

	# use user supplied command_line instead of Map?
	if ($cmd_line) {

		# use the user supplied command line
		$rc = write2PanelField( $session, $cmd_line, $cmd, $enter, $tab );
	}

	# nope, lookup the command line in the panelsMap
	else {
		( $panelTitle, $panel_command_field, $panel_option, $tab ) =
		  Common::processPanelMap( $panelID, $cmd_line_key );
		$rc =
		  write2PanelField( $session, $panel_command_field, $cmd, $enter,
			$tab );
	}
	Util::printStatus( $rc, "write2CommandLine \"$cmd\"" );
	return $rc;
}

sub copyTextFromScreen {

#-------------------------------------------------------------------------------------#
#	Copies text from the screen specified by the search argument and
#   returns it to the caller based on the length and offset params
#
#
#   Input Params:
#
#		$session - The session
#       $findStr - The search string text used to set the starting location
#                  of the copy
#       $len     - The number of chars you want to copy
#       $$offset - (Optional) The offset from the start location to copy from
#
#       The following examples copies the job number for this data found on a
#       screen.
#
#       IKJ56250I JOB PWCCSEQ(JOB00311) SUBMITTED   <--- Data on the screen
#       $jobNumber = copyTextFromScreen($session,"JOB PWCCSEQ",12,8);
#
#   Returns: the found data string otherwise 0
#-------------------------------------------------------------------------------------#
	my $session = shift;
	my $findStr = shift;
	my $len     = shift;
	my $offset  = shift;

	my $dataPos = Common::findStringPosition( $session, $findStr );
	if ( $dataPos == 0 ) {
		return 0;
	}
	my $data =
	  Common::copyFromScreenLocation( $session, $dataPos + $offset, $len );

	return $data;

}
sub verifyPanelMask {

#-------------------------------------------------------------------------------------#
#      Compares the current panel with the expected panel in the expected folder.
#      '#' characters in the expected file causes comparisons to be skipped. This is
#      usefull for userids, dataset name and dates.
#      If there are differences then write them to the difference folder and returns a
#      status of 1.
#
#      Input parms: a session to connect to and the file name you want to store the
#	   the differences in. If the 3rd parameter of 'no scroll' is passed then no
#      scrolling will be attempted. 
#
#      
#
#	   Returns 0 if no diffs otherwise 1.
#
#-------------------------------------------------------------------------------------#

	my $session   = shift;
	my $fileName  = shift;
	my $no_scroll = shift;
	my $rc;
	my @exp;
	my $message;
	

	my $configRef   = Cfg::getcfg();
    my $currentFile = "$configRef->{'CurrentFolderName'}/$fileName";
    my $expFile     = "$configRef->{'ExpectedFolderName'}/$fileName";
	# verify that the expected and current folders exist. If they don't they will be created.
	Util::verifyFolder("./$currentFile");
	Util::verifyFolder("./$expFile");

	my @curr =
	  Common::capturePanel( $session, $fileName, $configRef, $no_scroll );
	@exp =
	  Util::convertFile2Array("./$expFile");

	# check to see if the expected file is ok. If not, no use doing the diffs.
	# the exp array will have a -1 in [0] if the directory isn't found.	     
	if (Common::doesArrayHaveRecords(\@exp, $expFile) == -1 ) {
		Cfg::set_verify_status('-1');
		return -1;
	}
	
	my ($exp, $curr) = Util::stripMask ( \@exp, \@curr, '#'  ); 
	
	# pass the address of  clean arrays to the compare engine
 	( $diffs, $rc ) = Util::compareArrays( $exp, $curr, "skip" );
     
	$message = Util::printStatus( $rc, "verifyPanelMask $fileName" );

	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
	Util::reportResults( $message, "./results.log" );

	# set verify panel status so that the script can continue to run
	#
	my $failed;
	if ( $rc != 0 ) {
		$failed = Cfg::get_verify_status();

		#only need to set once.
		if ( !$failed ) {
			Cfg::set_verify_status('-1');
		}
	}
	return $rc;

}

sub verifyCICS {
	# Wrapper function that calls verifyPanel forcing 
	# VerifyPanel to use CICS dump routine via $cics argument
	
	my $session   = shift;
	my $fileName  = shift;
	my $no_scroll = 1;  # force no scrolling in CICS
	my $cics      = 1;  # force  call to CICS dump routine
	my $rc;
	$rc = verifyPanel ($session, $fileName, $no_scroll, $cics);
	return $rc;
}
sub verifyExpectedPanel {
	#-------------------------------------------------------------------------------------#
#      Compares the current panel with the expected panel in the expected folder.
#
#      If there are differences then write them to the difference folder and returns a
#      status of 1.
#
#      Input parms: a session to connect to and the file name you want to store the
#	   the differences in.
#
#	   Returns 0 if no diffs otherwise 1.
#
#-------------------------------------------------------------------------------------#

	my $session   = shift;
	my $exp       = shift;
	my $no_scroll = shift;
	my $cics      = shift;
	my $diffs;
	my $rc;

	my $configRef   = Cfg::getcfg();
    my $currentFile = "$configRef->{'CurrentFolderName'}/$fileName";
    my $fileName = "dynamic.txt";
	# verify that the expected and current folders exist. If they don't they will be created.
	Util::verifyFolder("./$currentFile");

	my @curr =
	  Common::capturePanel( $session, $fileName, $configRef, $no_scroll, $cics );


	# check to see if the expected file is ok. If not, no use doing the diffs.
	# the exp array will have a -1 in [0] if the directory isn't found.	     
	if (Common::doesArrayHaveRecords(\@exp, $expFile) == -1 ) {
		return -1;
	}
	( $diffs, $rc ) = Util::compareArrays( \@exp, \@curr );
	my $message = Util::printStatus( $rc, "verifyPanel $fileName" );
	
	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );

	# set verify panel status so that the script can continue to run
	#
	my $failed;
	if ( $rc != 0 ) {
		$failed = Cfg::get_verify_status();

		#only need to set once.
		if ( !$failed ) {
			Cfg::set_verify_status('-1');
		}
	}
	return $rc;
	
}
sub captureExpectedPanel {

#-------------------------------------------------------------------------------------#
#  
#
#-------------------------------------------------------------------------------------#

	my $session   = shift;
	my $no_scroll = shift;
	my $cics      = shift;
	my $diffs;
	my $rc;
	my @exp;

	my $configRef   = Cfg::getcfg();
	my $fileName = "dynamic";

	my @curr =
	  Common::capturePanel( $session, $fileName, $configRef, $no_scroll, $cics );

	return @curr;

}
sub verifyPanel {

#-------------------------------------------------------------------------------------#
#      Compares the current panel with the expected panel in the expected folder.
#
#      If there are differences then write them to the difference folder and returns a
#      status of 1.
#
#      Input parms: a session to connect to and the file name you want to store the
#	   the differences in.
#
#	   Returns 0 if no diffs otherwise 1.
#
#-------------------------------------------------------------------------------------#

	my $session   = shift;
	my $fileName  = shift;
	my $no_scroll = shift;
	my $cics      = shift;
	my $diffs;
	my $rc;
	my @exp;

	my $configRef   = Cfg::getcfg();
    my $currentFile = "$configRef->{'CurrentFolderName'}/$fileName";
    my $expFile     = "$configRef->{'ExpectedFolderName'}/$fileName";
	# verify that the expected and current folders exist. If they don't they will be created.
	Util::verifyFolder("./$currentFile");
	Util::verifyFolder("./$expFile");

	my @curr =
	  Common::capturePanel( $session, $fileName, $configRef, $no_scroll, $cics );
	@exp =
	  Util::convertFile2Array("./$expFile");

	# check to see if the expected file is ok. If not, no use doing the diffs.
	# the exp array will have a -1 in [0] if the directory isn't found.	     
	if (Common::doesArrayHaveRecords(\@exp, $expFile) == -1 ) {
		return -1;
	}
	( $diffs, $rc ) = Util::compareArrays( \@exp, \@curr );
	my $message = Util::printStatus( $rc, "verifyPanel $fileName" );
	
	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );

	# set verify panel status so that the script can continue to run
	#
	my $failed;
	if ( $rc != 0 ) {
		$failed = Cfg::get_verify_status();

		#only need to set once.
		if ( !$failed ) {
			Cfg::set_verify_status('-1');
		}
	}
	return $rc;

}

sub verifyCICSPanel {

#-------------------------------------------------------------------------------------#
#      Compares the current panel with the expected panel in the expected folder.
#
#      If there are differences then write them to the difference folder and return a
#      status of 1.
#
#      Input parms: a session to connect to and the file name you want to store the
#	   the differences in.
#
#	   Returns 0 if no diffs otherwise 1.
#
#-------------------------------------------------------------------------------------#

	my $session   = shift;
	my $fileName  = shift;
	my $no_scroll = shift;

	#todo fix config file lookup
	my $configRef = Cfg::getcfg();
	my @curr      = Common::captureCICSPanel( $session, $fileName, $configRef );
	my @exp       =
	  Util::convertFile2Array("./$configRef->{'ExpectedFolderName'}/$fileName");
	my ( $diffs, $rc ) = Util::compareArrays( \@exp, \@curr );
	my $message;

	$message = Util::printStatus( $rc, "verifyPanel $fileName" );

	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
	Util::reportResults( $message, "./results.log" );
	return $rc;

}

sub verifyPopup {

#-------------------------------------------------------------------------------------#
#  Determines the type of PopUp and calls the specialized routine for that PopUp type
#
#	Compares the current panel with the expected panel in the expected folder.
#
#
#
#	   Returns 0 if no diffs otherwise 1.
#
#-------------------------------------------------------------------------------------#

	my $session   = shift @_;
	my $fileName  = shift @_;
	my $configRef = Cfg::getcfg();
	my $aut        = $configRef->{'AUT'};
	my @curr;
	
	# be consistent 
	$aut = uc($aut);
	if ($aut eq "TRITUNE") {
		@curr      = Hllapi::newCapturePopUp( $session, $fileName );
		write2CommandLine( $session,  "top", '[enter]' )
		
	} else {
		@curr      = Hllapi::capturePopUp( $session, $fileName );
	}
	my @exp       =
	  Util::convertFile2Array("./$configRef->{'ExpectedFolderName'}/$fileName");
	my ( $diffs, $rc ) = Util::compareArrays( \@exp, \@curr );
	my $message;

	$message = Util::printStatus( $rc, "verifyPopup $fileName" );

	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
	Util::reportResults( $message, "./results.log" );
	
	if ($rc != 0 ) {

		Cfg::set_verify_status(-1);
	}
	return $rc;

}
sub verifyPopupMask {

#-------------------------------------------------------------------------------------#
#  Compares the current panel with the expected panel in the expected folder.
#      '#' characters in the expected file causes comparisons to be skipped. This is
#      usefull for userids, dataset name and dates.
#      If there are differences then write them to the difference folder and returns a
#      status of 1.
#
#      Input parms: a session to connect to and the file name you want to store the
#	   the differences in. 
#
#
#	   Returns 0 if no diffs otherwise 1.
#
#-------------------------------------------------------------------------------------#

	my $session   = shift @_;
	my $fileName  = shift @_;
	my $configRef = Cfg::getcfg();
	my @curr      = Hllapi::capturePopUp( $session, $fileName );
	my @exp       =
	  Util::convertFile2Array("./$configRef->{'ExpectedFolderName'}/$fileName");
	  
	my ($exp, $curr) = Util::stripMask ( \@exp, \@curr, '#'  );  

	my ( $diffs, $rc ) = Util::compareArrays( $exp, $curr, "skip" );
	
	my $message;

	$message = Util::printStatus( $rc, "verifyPopupMask $fileName" );

	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
	Util::reportResults( $message, "./results.log" );
	
	if ($rc != 0 ) {

		Cfg::set_verify_status(-1);
	}	
	return $rc;

}


sub verifyPanelReport {

#------------------------------------------------------------------------------#
# Takes the contents of a panel report and compares it with the expected file  #
#                                                  				               #
#------------------------------------------------------------------------------#

	my $session   = shift @_;
	my $fileName  = shift @_;
	my $configRef = Cfg::getcfg();

	# check and see if we have the expected and current folders and files.
	# if we don't create them now.

	Util::verifyFolder("./$configRef->{'CurrentFolderName'}/$fileName");
	Util::verifyFolder("./$configRef->{'ExpectedFolderName'}/$fileName");

	my @curr = Common::captureReport( $session, $fileName );
	my @exp =
	  Util::convertFile2Array("./$configRef->{'ExpectedFolderName'}/$fileName");

	my ( $diffs, $rc ) = Util::compareArrays( \@exp, \@curr );
	Util::printStatus( $rc, "verifyPanelReport $fileName" );
	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
	Util::reportResults( $message, "./results.log" );
	
	
	if ($rc != 0 ) {

		Cfg::set_verify_status(-1);
		
	}
	
	
	return $rc;
}
sub verifyPanelReportMask {

#----------------------------------------------------------------------------------#
# Takes the contents of a panel report and compares it with the expected file      #
#                                                                                  #
#  '#' characters in the expected file causes comparisons to be skipped. This is   #
#  usefull for userids, dataset name and dates.                                    #
#  If there are differences then write them to the difference folder and returns a #
#  status of 1.                                                                    #
#----------------------------------------------------------------------------------#

	my $session   = shift @_;
	my $fileName  = shift @_;
	my $configRef = Cfg::getcfg();

	# check and see if we have the expected and current folders and files.
	# if we don't create them now.

	Util::verifyFolder("./$configRef->{'CurrentFolderName'}/$fileName");
	Util::verifyFolder("./$configRef->{'ExpectedFolderName'}/$fileName");

	my @curr = Common::captureReport( $session, $fileName );
	my @exp =
	  Util::convertFile2Array("./$configRef->{'ExpectedFolderName'}/$fileName");

	my ($exp, $curr) = Util::stripMask ( \@exp, \@curr, '#'  ); 
	
	# pass the address of  clean arrays to the compare engine
	( $diffs, $rc ) = Util::compareArrays( $exp, $curr, "skip" );


	Util::printStatus( $rc, "verifyPanelReportMask $fileName" );
	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
	Util::reportResults( $message, "./results.log" );
	
	if ($rc != 0 ) {

		Cfg::set_verify_status(-1);
	}
	return $rc;
}

sub verifyDSN {

#------------------------------------------------------------------------------#
# Copies the dsn to the local machine  and compares it with the expected file  #
#                                                  				               #
#------------------------------------------------------------------------------#

	my $session   = shift;
	my $fileName  = shift;
	my $dsn       = shift;
	my $configRef = Cfg::getcfg();

	# check and see if we have the expected and current folders and files.
	# if we don't create them now.

	Util::verifyFolder("./$configRef->{'CurrentFolderName'}/$fileName");
	Util::verifyFolder("./$configRef->{'ExpectedFolderName'}/$fileName");

	my @curr = Common::captureDSN( $session, $fileName, $dsn );
	my @exp =
	  Util::convertFile2Array("./$configRef->{'ExpectedFolderName'}/$fileName");

	my ( $diffs, $rc ) = Util::compareArrays( \@exp, \@curr );
	Util::printStatus( $rc, "verifyPanelReport $fileName" );
	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
	Util::reportResults( $message, "./results.log" );
	return $rc;
}

sub write2Panel {

   # Used to write the data supplied in a hash (form) to a panel.
   # The caller must supply a tie hash with the labels and fields filled in with
   # data that will be entered on the panel.

	# get the hash reference in scalar format
	my $session  = shift @_;
	my $t        = shift @_;
	my $enterKey = shift @_;
	my @keys     = $t->Keys;
	my @value    = $t->Values;
	my $i        = 0;
	my $rc;

	foreach my $key (@keys) {
        # check for a value. zero is a valid value
		if ( $value[$i] || ($value[$i] == '0')) {
			my $uc = uc( $value[$i] );
			$rc = write2PanelField( $session, $key, $uc );
		}
		$i++;
	}
	if ($enterKey) {
		Hllapi::hitKey( $session, '[enter]' );
	}

	return $rc;
}

sub write2HFSPanel {

   # Used to write the data supplied in a hash (form) to a panel.
   # The caller must supply a tie hash with the labels and fields filled in with
   # data that will be entered on the panel.

	# get the hash reference in scalar format
	my $session  = shift @_;
	my $t        = shift @_;
	my $enterKey = shift @_;
	my @keys     = $t->Keys;
	my @value    = $t->Values;
	my $i        = 0;
	my $rc;

	foreach my $key (@keys) {
        # check for a value. zero is a valid value
		if ( $value[$i] || ($value[$i] == '0')) {
	        my $uc = $value[$i];
			$rc = write2PanelField( $session, $key, $uc );
		}
		$i++;
	}
	if ($enterKey) {
		Hllapi::hitKey( $session, '[enter]' );
	}

	return $rc;
}


sub pressKey {

	# Wrapper function for hitKey
	# Takes a session object and the key to press and
	# an optional action key like [enter] or [tab]
	# Returns pass or fail.

	my $session   = shift;
	my $key2press = shift;
	my $option    = shift;
	my $suppress  = shift;

	my $rc = Hllapi::hitKey( $session, $key2press, $option );
    if ($suppress != 1) {
    	Util::printStatus($rc, "pressKey \"$key2press\"" );	
    } 
	
	return $rc;

}

sub getCursorLocation {

	# Takes a session object and returns the cursor location
	#
	my $session = shift;
	my $pos;
	my $rc;

	$pos = Hllapi::queryCursorLocation($session);
	if ( $pos > 0 ) {
		$rc = 0;
	}
	else {
		$rc = -1;
	}

	#    Util::printStatus($rc, "getCursorLocation" );

	return $pos;
}

sub verifyCursorLocation {

	#
	# use this function to verify that 2 values are identical or different.
	# Takes cursor location 1 and compares it with cursor location 2.
	# Passing variables: Session, expectedlocation and a flag.
	# if the flag is passed then we test for the locations to be not equal.
	# if you don't pass a flag then we test if the locations to match 
	#
	#
	#
	my $session                = shift;
	my $expectedCursorLocation = shift;
	my $notequalflag = shift;
	my $currentCursorLocation ;
	my $rc;

	$currentCursorLocation = getCursorLocation($session);
	
	if ($notequalflag) { 
	   if ( $expectedCursorLocation == $currentCursorLocation ) {
			$rc = -1;
			}
		else {
			$rc = 0;
			}
	}
	else {
		if ( $expectedCursorLocation == $currentCursorLocation ) {
			$rc = 0;
			}
		else {
			$rc = -1;
			}
	}		
			
				
	Util::printStatus( $rc, "verifyCursorLocation" );
	return $rc;
}

sub pressKeyRepeat {

# Takes a session object and the key to press and the number of times
# you want to press the key and an optional char that you want to issue.
# e.g,
# pressKeyRepeat($session, [tab], '4');
# Would tab 4 times on the panel.
#
# pressKeyRepeat ($session, [tab], '4', 4);
#
# Would type 'd' on the on a panel list 4 times. See script RTS2/pc3a002.pl for an
# example.
# Returns pass or fail.

	my $session   = shift;
	my $key2press = shift;
	my $repeat    = shift;
	my $option    = shift;
	my $rc;
	if ( $repeat =~ /\d+/ ) {
		until ( $repeat == 0 ) {
			$rc = Hllapi::hitKey( $session, $key2press, $option );
			$repeat--;
		}
	}
	else {
		Util::printStatus( -1, "pressKeyRepeat \"$key2press\" $repeat" );
		return -1;
	}

	#    Util::printStatus($rc, "pressKeyRepeat \"$key2press\"" );
	return $rc;
}

sub pressKeys {

	# Wrapper function for keys2Press
	# Takes a session object and the keys to press
	# Returns pass or fail.
	my $session    = shift;
	my $keys2press = shift;
	my $enter      = shift;

	my $rc = Hllapi::keys2press( $session, $keys2press, $enter );
	Util::printStatus( $rc, "pressKeys: $keys2press" );
	return $rc;
}
sub panelListAction {

	( my $session, my $cmd_label, my $cmd, my $skipEnterKey, my $startPos ) = @_;

	my $rc;
	my $isBottomOfData = 0;
	my $failsafe       = 0;
	my $failsafeMax    = 50;
	
	# Make sure the session is searching all and forward
	Hllapi::setSessionParameters( $session, "SRCHALL, SRCHFRWD" );
	my $foundPos       = Hllapi::assert( $session, $cmd_label, $startPos);

	until ($isBottomOfData) {
		
		$isBottomOfData = Hllapi::assert( $session, "* Bottom of data *" );
		$failsafe++;
		if ($foundPos) {

			# make call passing the left tab flag.
			$rc = Hllapi::placeCursorOnInputField( $session, $foundPos, '', 1 );
			Hllapi::hitKey( $session, $cmd );
			if ( !$skipEnterKey ) {
				Hllapi::hitKey( $session, "[enter]" );
			}
			$rc = 0;
			last;
		}
		else {
			Hllapi::hitKey( $session, '[F8]' );
			$foundPos = Hllapi::assert( $session, $cmd_label );
		}

		if ( $failsafe == $failsafeMax ) {
			Util::printStatus( '-1', "panelListAction: Unable to find $cmd_label on Action List Panel." );
#			print "+++ Unable to find $cmd_label on Action List Panel. "
#			  . "Make sure you are using the correct routine. +++\n ";
			$rc = -1;
			last;
		}
	}
	if ( $foundPos == 0 ) {
		$rc = -1;
		Util::printStatus( $rc,
			"panelListAction $cmd_label not found on panel" );
	}
	else {
		Util::printStatus( $rc, "panelListAction $cmd_label found on panel" );
	}
	return $rc;
}

sub panelAction {

#-------------------------------------------------------------------------------------#
#     Use panelAction to update input fields on action panels without lists.
#
#     Takes:
#		Session
#       The label used to identify the input field
#       The command you want to place in the input field
#       The optional skip enter key value. If  value anything other
#          then null or zeoro is passed then the enter key will be skipped.
#	   Returns 0 for success or -1 for failure.
#
#-------------------------------------------------------------------------------------#

	my $session      = shift;
	my $cmd_label    = shift;
	my $cmd          = shift;
	my $skipEnterKey = shift;

	my $rc;
	my $foundPos       = Hllapi::assert( $session, $cmd_label );
	my $isBottomOfData = 0;
	my $failsafe       = 0;
	my $failsafeMax    = 50;

	if ($foundPos) {

		# make call passing the left tab flag.
		$rc = Hllapi::placeCursorOnInputField( $session, $foundPos, '', 1 );
		Hllapi::hitKey( $session, $cmd );
		if ( !$skipEnterKey ) {
			Hllapi::hitKey( $session, "[enter]" );
		}
		$rc = 0;
	}
	else {
		$cmd_label = $cmd_label . "not found on panel!";
		$rc        = -1;
	}
	Util::printStatus( $rc, "panelListAction $cmd_label" );
	return $rc;
}

sub startService {
	my $session     = shift;
	my $startedTask = shift;
	my $cmd         = shift;
	my $seconds     = shift;
	my $rc;

	return service( $session, $startedTask, $cmd, $seconds, "start" );

}

sub stopService {

	my $session     = shift;
	my $startedTask = shift;
	my $cmd         = shift;
	my $seconds     = shift;

	return service( $session, $startedTask, $cmd, $seconds, "stop" );

}

sub service {

#------------------------------------------------------------------------------
#  Function startService
#    Called by either startService or stopService to either start or stop the STC.
#
#
#  Parameters -
#
#      The Session ID and Started Task name to be stop or starced and the amount of time
#      to wait for that service to start or stop.
#
#  Returns:
#			0 if the service started or stop
#          -1 if the task failed.
#  Author: cjm
#------------------------------------------------------------------------------

	my $session     = shift;       # the session
	my $startedTask = shift;       # name of STC      
	my $cmd         = shift;       # the shutdown command for the STC
	my $seconds     = shift;       # max wait time before producing an error
	my $operation   = shift;       # either start or stop
	my $configRef   = Cfg::getcfg();
	my $aut         = $configRef->{'AUT'};
	my $sn          = Cfg::get_script_name();
	my $foundPos;
	my $status;
	my $rc;



    # upper case for mainframe
    $startedTask = uc($startedTask);
    $cmd = uc($cmd);
    
	# setup 20 second default for time-to-wait
	if ( !$seconds ) {
		$seconds = 20;
	}
    $status = write2CommandLine( $session,  "start =s;da", '[enter]' )  if ( not $status );
	$status = write2CommandLine( $session,  "OWNER *", '[enter]' )  if ( not $status );
	$status = write2CommandLine( $session, "PRE  $startedTask", '[enter]' );

	Hllapi::hitKey( $session, '[enter]' ) if ( not $status );

	if ( $status != 0 ) {
		Util::printStatus( $rc, "service Unable to naviagate to SDSF panel." );
		write2CommandLine( $session,  "=x", '[enter]' )  if ( not $status );
		return -1;
	}

	if ( $operation eq "start" ) {

		# Check if the started task is running
		if ( $foundPos = Hllapi::assert( $session, uc($startedTask) ) ) {
			Util::printStatus( 0, "$startedTask is up and running" );
			write2CommandLine( $session,  "=x", '[enter]' )  if ( not $status );
			return $status;
		}
		else {

			#In Pro/jcl we pass the script name to the started task.
			if ( $aut eq "PROJCL" ) {
				write2CommandLine( $session, "$cmd,osver=$sn",'[enter]' );
			}else {
				write2CommandLine( $session, $cmd, '[enter]' );
			}
		}

	  # Check if the started task shows in the list. Otherwise refresh the list.
		for ( $i = 0 ; $i < $seconds ; $i++ ) {
			sleep(1);
			Hllapi::hitKey( $session, '[enter]' );

			if ( $foundPos = Hllapi::assert( $session, $startedTask ) ) {
				Util::printStatus( 0, "$startedTask is up and running" );

				# always go back to ISPF primary
				write2CommandLine( $session,  "=x", '[enter]' )  if ( not $status );
				return $status;
			}
			Util::printStatus( '0', "service:  Waiting for $startedTask to start..." );

		}
		Util::printStatus( '-1', "service: $startedTask hasn't started after $i seconds. Exiting now!" );
		return -1;

	}
	else {

		# do stop service stuff
		$foundPos = Hllapi::assert( $session, $startedTask );
		if ( !$foundPos ) {
			Util::printStatus( '0', "service: $startedTask not running." );
			write2CommandLine( $session,  "=x", '[enter]' )  if ( not $status );
			return $status;
		}
		else {
			write2CommandLine( $session, "$cmd", '[enter]' );

	  # Check if the started task shows in the list. Otherwise refresh the list.
			for ( $i = 0 ; $i < $seconds ; $i++ ) {
				sleep(1);
				Hllapi::hitKey( $session, '[enter]' );
				$foundPos = Hllapi::assert( $session, $startedTask );
				if ($foundPos) {
					Util::printStatus( '0', "service: Waiting for $startedTask to terminate." );
#					print "*** Waiting for $startedTask to terminate. ***\n";
				}
				else { last; }
			}
			Util::printStatus( '0', "service: $startedTask had ended." );
			write2CommandLine( $session,  "=x", '[enter]' )  if ( not $status );
			return $status;
		}
	}
}

sub execPanelCmd {

#------------------------------------------------------------------------------#
#  Function execPanelCmd                                                       #
#    Passed a Label it will return the associated command.                     #
#  Parameters -                                                                #
#                                                                              #
#      The Session and Menu Command.                                           #
#                                                                              #
#  Returns:                                                                    #
#			0 if it found the command                                          #
#          -1 if no command was found                                          #
#  Author: cjm                                                                 #
#------------------------------------------------------------------------------#

	my $session    = shift;
	my $cmd        = shift;
	my $expPanelID = shift;
	my $cmdLine    = shift;
	my $popup      = shift;
	my $rc;
	my @panel = Hllapi::dumpPanel($session);

	# set default command line label
	if ( !$cmdLine ) {
		$cmdLine = "===>";
	}

	# loop thru array to find the command and it's respective option menu number
	##todo pull the value 42 from config file
	for ( $i = 0 ; $i <= 42 ; $i++ ) {

# if pattern with 1 or 2 spaces ,1 or 2 word, 1 or 2 spaces and the command is found write the
# number $1 associated with the command on the command line (1 or 2 word.) Make a note that
# we anchored the match to the begining of the string (^)
# $1 is contained in the first () of the pattern.
		if ($popup) {
			if ( $panel[$i] =~ /\se\s(\w{1,2})\s+$cmd.*\se\s/ ) {
				$status =
				  write2CommandLine( $session, $1, '[enter]', $cmdLine );

				# Make panelid an optional check.
				if ($expPanelID) {
					$rc = findStringOnPanel( $session, $expPanelID );
				}

				# didn't find the panelid make rc = -1
				return $rc;
			}
		}
		else {

			if ( $panel[$i] =~ /^\s+(\w{1,2})\s+$cmd/ ) {

				$status =
				  write2CommandLine( $session, $1, '[enter]', $cmdLine );

				# Make panelid an optional check.
				if ($expPanelID) {
					$rc = findStringOnPanel( $session, $expPanelID );
				}

				# didn't find the panelid make rc = -1
				return $rc;
			}
		}
	}
	Util::printStatus( $rc, "execPanelCmd: $cmd not found on Panel" );
	return -1;

}

sub verifyPanelID {
	##todo needs to be moved to Common.pm
	my $session    = shift @_;
	my $expPanelID = shift @_;

	my $currentPanelID;

	# get the current Panelid.

	if ($expPanelID) {

		# get the current Panel Id
		$currentPanelID = Common::getPanelID($session);

		# compare current panel with the expected Panel ID
		if ( $expPanelID ne $currentPanelID ) {
			Util::printStatus( '-1', "verifyPanelID: $currentPanelID does not match expect $expPanelID" );
			return -1;

		}
		else {
			return 0;
		}
	}
	  return -1;
}

sub typePopupActionListCmd {

	# Use this routine for products that have panel-list-actions inbedded in pop-ups.
	# So far only infox uses them. 
	# This routine will correctly issue the list action command
	
	my $session    = shift @_;
	my $findString = shift @_;
	my $action     = shift @_;
	my $page       = 1;          # turn paging on as the default
	my $found;
	my $rc;
	my $bot;

	# we must search from bottom to top otherwise we find the string in
	# the panel header.
	if ( $rc = Hllapi::setSessionParameters( $session, "SRCHFROM" ) == 0 ) {

		# we're at the end of the list when page becomes 0
		until ( $page == 0 ) {
			$found = Common::findStringPosition( $session, $findString, '960' );

			# did we find the string?
			if ( $found > 0 ) {

				#yes, move the cursor to the selection field and type the cmd
				Hllapi::placeCursorOnInputField( $session, $found, 0, 1 );
				Hllapi::keys2press( $session, $action, 1 );
				$page = 0;
			}
			else {

			   # didn't find string, let scrollPopupList do the paging and he'll
			   # return whether we're at the bottom of the list.
				$page = 1;

# check for bottom of data before calling scroll routine.
#				$bot = Common::findStringPosition( $session, "** Bottom of data ***", '960' );
#				if ($bot) {
#					last;
#				}
				Hllapi::hitKey( $session, '[F8]' );
				Common::scrollPopupList($session);
			}
		}

		# Check to see if we ever found the string
		if ( $found == 0 ) {

			# never found it
			$rc = -1;
			Util::printStatus( $rc, "typePopupActionListCmd: Unable to find $findString on panel list!" );
		
		}
		else { $rc = 0; }

		# set the search back to default.
		Hllapi::setSessionParameters( $session, "SRCHALL" );
	}
	else {
		$rc = -1;
		Util::printStatus( $rc, "typePopupActionListCmd: Unable to set session SRCHFROM parm" );
	}

	return $rc;
}
sub connectTOSession {
	
	
	( my $sessionAddr, my $sessionID) = @_;
	
	 $rc =  Hllapi::callAPI ($sessionAddr, 1, $sessionID);
  
	return $rc;	
}

sub startSessions {
	# Used to start multiple sessions for workload testing
	
	my $numOfSessions = shift;
	my $rc;
    my @sessionIDs = ("A".."Z");
   	my $session;
   	my @sessions;
   	my $i = 1;
   	my $sessionID;
   	
	# Loop to create each session
	for (; $i <= $numOfSessions; $i++) {
		$sessionID = $sessionIDs[$i+4];
		
		( $rc, $session ) = Hllapi::connect2Session($sessionID);
		if ( $rc == 1 ) {
			Hllapi::startPCOMsessions($sessionID, $i);
		}
		if ( !$session ) {
			$rc = '-1';
			Util::printStatus( $rc, "startSession: Unable to create session for session name: $sessionID" );
			return $rc;
		}
		Common::turnOnPanelID($session);
		if ($i < 1) {Common::turnOnPanelID($sessions[0]);}
		MAP::write2PanelField( $session, "Option ===>", "PFSHOW OFF", '[$enter]' );
		push @sessions, $session;
	}
	return @sessions;
	
}

sub startSession {
	my $sessionName = shift;
	my $rc;
	my $session;

	( $rc, $session ) = Hllapi::connect2Session($sessionName);
	if ( $rc == 1 ) {
		Hllapi::startPCOMsession($sessionName);
#		( $rc, $session ) = Hllapi::connect2Session($sessionName);
	}
	if ( !$session ) {
		$rc = '-1';
		Util::printStatus( $rc, "startSession: Unable to create session for session name: $sessionName" );
		return $rc;
	}
	Common::turnOnPanelID($session);
	MAP::write2PanelField( $session, "Option ===>", "PFSHOW OFF", '[$enter]' );
	return $session;
}

sub startCICSSession {
	my $sessionName = shift;
	my $applid      = shift;
	my $rc;
	my $session;
	
		# get logon info
	my $configRef 	= Cfg::getcfg();
	my $userID      = $configRef->{'UserID'};
	my $password    = $configRef->{'Password'};
	
	( $rc, $session ) = Hllapi::connect2Session($sessionName);
	if ( $rc == 1 ) {
		Hllapi::startPCOMCICSsession($sessionName, $applid);
		( $rc, $session ) = Hllapi::connect2Session($sessionName);
	
       # session already started but scope may be logged off	
	} else {
	   # see if we can just logon onto CICS anyway					
			Hllapi::keys2press( $session, "L APPLID=$applid", "[enter]" );
			
			sleep 5;
			Hllapi::keys2press( $session, "$userID", "[tab]" );
			Hllapi::keys2press( $session, "$password", "[enter]" );	
	}		
	if ( !$session ) {
        $rc = -1;
		Util::printStatus( $rc, "startCICSSession: Unable to create session for session name: $sessionName" );
		return $rc;
	}
	return $session;
}

sub startESHIPsession {
	my $sessionName = shift;
	my $applid      = shift;
	my $rc;
	my $session;
	( $rc, $session ) = Hllapi::connect2Session($sessionName);
	if ( $rc == 1 ) {
		Hllapi::startESHIPsession($sessionName, $applid);
		( $rc, $session ) = Hllapi::connect2Session($sessionName);
	}
	if ( !$session ) {
        $rc = -1;
		Util::printStatus( $rc, "startCICSSession: Unable to create session for session name: $sessionName" );
		return $rc;
	}
	return $session;
}

sub startScopeSession {
	my $sessionName = shift;
	my $applid      = shift;
	my $rc;
	my $session;
	
	# get logon info
	my $configRef 	= Cfg::getcfg();
	my $userID      = $configRef->{'UserID'};
	my $password    = $configRef->{'Password'};
		
	( $rc, $session ) = Hllapi::connect2Session($sessionName);
	if ( $rc == 1 ) {
		Hllapi::startPCOMCICSsession($sessionName, $applid);
		( $rc, $session ) = Hllapi::connect2Session($sessionName);
		
	# session already started but scope may be logged off	
	} else {
		# check to see if the scope session is already logged in
		$status = findStringOnPanel($session, "-- Main Menu --",0,1);
		if ($status != 0 ) {
					
			Hllapi::keys2press( $session, "L APPLID=$applid", "[enter]" );
			
			sleep 5;
			Hllapi::keys2press( $session, "$userID", "[tab]" );
			Hllapi::keys2press( $session, "$password", "[enter]" );
		}
	}
	if ( !$session ) {
        $rc = -1;
		Util::printStatus( $rc, "startScopeSession: Unable to create session for session name: $sessionName" );
		return $rc;
	}
	return $session;
}

sub stopSession {
	my $session = shift;
	my $rc = Hllapi::disconnectPresentationSpace($session);
	return;
}

sub write2PanelField {

#------------------------------------------------------------------------------#
#  Function write2PanelField                                                   #
#                                                                              #
#      Used to type a string to an input field on the panel.                   #
#                                                                              #
#  Parameters -                                                                #
#      The input panel field label.                                            #
#      The string to write in the field.                                       #
#                                                                              #
#  Returns: the rc from the API call.                                          #
#                                                                              #
#      None                                                                    #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#
	( my $session, my $label, my $typeIt, my $enter, my $tab ) = @_;
	my $rc;
	my $foundPos;
	my $foundPos2;

	# check to see if the key has the more than one occurrence symbol of &
	# if it does, write the second occurrence too.
	#

	# looking for @ characters and doubling them for api call.

	my @inputString = split( "", $typeIt );
	my @outputString;

	foreach my $char (@inputString) {
		if ( $char eq '@' ) {
			push( @outputString, $char );
			push( @outputString, $char );
		}
		else {
			push( @outputString, $char );
		}

	}
	$typeIt = join( "", (@outputString) );

	if ( $label =~ m/.*\&/ ) {

		# strip the & off the end of the string
		$label =~ s/&//g;
		$rc = Hllapi::setSessionParameters( $session, "SRCHFRWD,SRCHFROM" );
		$foundPos  = Hllapi::assert( $session, $label, 1 );
		$foundPos2 = Hllapi::assert( $session, $label, $foundPos + 1 );
		if ( $foundPos2 == 0 ) {
			$foundPos2 = $foundPos;
		}
		$rc = Hllapi::setSessionParameters( $session, "SRCHALL, SRCHFRWD" );

		Hllapi::placeCursorOnInputField( $session, $foundPos2 );
		if ( $tab == 1 ) {
			$rc = Hllapi::hitKey( $session, '[tab]' );
		}

		# EOF before typing
		$rc = Hllapi::hitKey( $session, '[eof]' );

		$rc = Hllapi::keys2press( $session, "$typeIt", $enter );

		# Only 1 occurrence, do the normal stuff
	}
	else {

		# Find label on panel
		$foundPos = Hllapi::assert( $session, $label, 1 );

		if ( !$foundPos ) {
			$rc = -1;
			Util::printStatus( $rc, "write2PanelField:  $label not found on Panel." );
            Cfg::set_verify_status(-1);
		}
		else {
			Hllapi::placeCursorOnInputField( $session, $foundPos );
			# some panels need a tab to get on the input field
			if ( $tab == 1 ) {
				Hllapi::hitKey( $session, '[tab]' );
			}

			# EOF before typing
			Hllapi::hitKey( $session, '[eof]' );
			Hllapi::keys2press( $session, "$typeIt", $enter );
			$rc = 0;
		}
	}

	#	Util::printStatus($rc, "write2PanelField" );
	return $rc;
}
sub findStringOnPanel {

#------------------------------------------------------------------------------#
#  Function findStringOnPanel
#  NOTE: This functions set the script's return code unless
#  the supress argument is set to 1. 
#
#      Used to find a string on a panel.
#  Parameters -
#      Session Object.
#      The String you want to locate
#      optional negate parm that allows you to get a "passed" status when
#      verifying that a string is not found on a panel.
#
#  Returns:
#         $rc:
#          		 0  Success
#          		-1  Unable to find string
#  Author: skb
#------------------------------------------------------------------------------#
	( my $session, my $string, my $negate, my $surpress ) = @_;
	my $foundPos;
	my $rc;
    my $configRef 		= Cfg::getcfg();
	if ($string) {

		# Look for the string on the panel
		$foundPos = Hllapi::assert( $session, $string, 1 );
		if ($foundPos) {
			$rc = 0;
		}
		else {
			$rc = -1;
		}
		if ( $negate && $foundPos == 0 ) {
			$rc = 0;
		}
		elsif ( $negate && $foundPos > 0 ) {
			$rc = -1;
		}

	}
	else {
		$rc = -1;
		Util::printStatus( $rc, "findStringOnPanel: You must supply a search for string. Exiting script" );
		return $rc;
	}
	if ($surpress) {
			# don't print messages.
	} else {
		Util::printStatus( $rc, "findStringOnPanel \"$string\"", 1, 1 );	
	}
	
	# set the script pass or fail flag
	if ($rc != 0 && $surpress != 1) {


		Cfg::set_verify_status(-1);
		
	}
    
	return $rc;
}

sub verifyStringNotFoundOnPanel {
	my $session = shift;
	my $string  = shift;
	my $negate  = 1;
	my $rc;

	$rc = findStringOnPanel( $session, $string, 1, 1 );
	Util::printStatus( $rc, "verifyStringNotFoundOnPanel \"$string\"" );
	return $rc;
}

#------------------------------------------------------------------------------#
#  Function verifyStringAtCursor
#
#      Used to verfiy the string of chars at the cursor location matches the expected string.
#
#  Parameters -
#      Session Object.
#      The String you want to compare against
#
#  Returns:
#         $rc:
#          		 0  if the expected string matches the string at the cursor location
#          		-1  if they don't match
# Example Script: scrollPopup.pl located in info/infox/examples
#------------------------------------------------------------------------------#
sub verifyStringAtCursor {
	my $session        = shift;
	my $string         = shift;
	my $cursorPosition = getCursorLocation($session);
	my $length         = length($string);
	my $data           =
	  Common::copyFromScreenLocation( $session, $cursorPosition, $length );

	if ( $data eq $string ) {
		$rc = 0;
	}
	else {
		$rc = -1;
	}

	Util::printStatus( $rc, "verifyStringAtCursor \"$string\"" );
	return $rc;
}

sub selectPopupLink {

	#
	# Used to scroll
	#
	$session = shift;
	$label   = shift;
	my $endOfData = 0;
	my $count     = 0;
	my $rc        = 0;
	my $pos;

	until ( $endOfData == 1 ) {
		$pos = Hllapi::assert( $session, $label );
		$count++;
		if ($pos) {
			Util::printStatus( 0, "selectPopupLink: String $find found at pos $pos" );
			Hllapi::placeCursorOnInputField( $session, $pos );
			Hllapi::hitKey( $session, '[back_tab]' );
			Hllapi::hitKey( $session, '[F1]' );
			$endOfData = 1;
		}
		else {
			Hllapi::hitKey( $session, '[enter]' );
		}
		if ( $count == 20 ) {
			Util::printStatus( -1, "selectPopupLink: $label not found in popup. Exiting script!" );
			$rc = exit;
		}
	}
	return $rc;
}

sub init {

	#
	# Script constructor
	#
	# Sets the script name in the Cfg object
	#
	#
	my $configRef = shift;
	my $sn;
	my $dir       = getcwd();
	
	# open log file
#	Util::open_script_log();
    # open the log file for writing
	# get the last node out of the path. This will be the script name
	# w/o the .pl extentsion
 	$dir =~ m/([a-zA-Z0-9\-]+$)/;
 
	# now add the .pl extentsion to complete the script name

 	$sn = $1 . ".pl";
    $sn = "'$sn'";
	# now set the script name in the config object
	Cfg::set_script_name("$sn");
#	my $start_time = Util::get_scalar_time();
#	my $time = localtime(); 
#	Util::printStatus( 2, "$time  ------- Test Case $sn.pl Started -------" );
}

sub end {
    # used to process the end status and report it. 
	my $rc           = shift;
	my $string       = shift;
	my $sn           = Cfg::get_script_name();
	my $sortStatus   = Cfg::get_sort_status();
	my $verifyStatus = Cfg::get_verify_status();

	# used to allow scripts to continue even if the sort failed.
	if ( $sortStatus == -1 || $verifyStatus == -1 ) {
		$rc = -1;

		# reset sort status for next script
		Cfg::set_sort_status(0);
		Cfg::set_verify_status(0);
	}
	Util::printStatus( $rc, "Ended with a status of: " );
#	my $time = localtime(); 
#	Util::printStatus( 2, "$time ------- Test Case $sn Ended. -------" );
	Cfg::set_line_num('0');
#	Util::close_script_log();
	return $rc;
}

sub ln {
	my $lineNum   = shift;
	my $configRef = Cfg::getcfg();
	Cfg::set_line_num($lineNum);
	return;
}

sub putCursorOnPanelSrting {

	my $session     = shift;
	my $panelString = shift;
	my $pos         =
	  Common::findStringPosition( $session, $panelString, $startSearchPos );
	my $rc = Hllapi::placeCursorOnPanel( $session, $pos );
	return $rc;
}

sub putCursorOnInputField {

	my $session     = shift;
	my $panelString = shift;
	my $configRef   = Cfg::getcfg();
	my $aut         = $configRef->{'AUT'};
	
	my $pos         =
	  Common::findStringPosition( $session, $panelString, $startSearchPos );
	  
	# if it's TriTune skip the tab.   
	my $rc = Hllapi::placeCursorOnPanel( $session, $pos );
    if (uc($aut) ne 'TRITUNE') {
    	$rc = pressKey( $session, '[tab]' );	
    } 
	
	return $rc;
}

#------------------------------------------------------------------------------#
#  Function putCursorAfterString
#
#      Used to place the cursor at the end of a String + a number of positions.
#
#  Parameters -
#      Session Object.
#      The String to want to put the cursor on
#      Number of additional positions (after the string) to the right you want to place
#      the cursor.
#  Returns:
#         $rc:
#          		 0  if the expected string matches the string at the cursor location
#          		-1  if they don't match
# Example Script: putcursorafterstring.pl located in info/infox/examples
#------------------------------------------------------------------------------#

sub putCursorAfterString {

	my $session       = shift;
	my $panelstring   = shift;
	my $nbrofposition = shift;
	my $lengthofString;

	$lengthofString = length($panelstring);
	my $nbrofkeys = ( $lengthofString - 1 ) + $nbrofposition;
	$rc = putCursorOnPanelSrting( $session, $panelstring );
	pressKeyRepeat( $session, '[right]', $nbrofkeys );
	return $rc;
}
sub putCursorBeforeString {

	my $session       = shift;
	my $panelstring   = shift;
	my $nbrofposition = shift;
	my $lengthofString;

	$lengthofString = length($panelstring);
	my $nbrofkeys = ( $lengthofString - 1 ) + $nbrofposition;
	$rc = putCursorOnPanelSrting( $session, $panelstring );
	pressKeyRepeat( $session, '[left]', $nbrofkeys );
	return $rc;
}
sub putCursorUnderString {

	my $session       = shift;
	my $panelstring   = shift;
	my $nbrofposition = shift;
	my $nbrofkeys     = 1; # default	
	my $lengthofString;
	
    $rc = putCursorOnPanelSrting( $session, $panelstring );

	
	pressKeyRepeat( $session, '[down]', $nbrofkeys );
	return $rc;
}
sub putCursorAboveString {

	my $session       = shift;
	my $panelstring   = shift;
	my $nbrofposition = shift;
	my $lengthofString;

	$lengthofString = length($panelstring);
	my $nbrofkeys = ( $lengthofString - 1 ) + $nbrofposition;
	$rc = putCursorOnPanelSrting( $session, $panelstring );
	pressKeyRepeat( $session, '[up]', $nbrofkeys );
	return $rc;
}
sub checkBatchStatus {
#------------------------------------------------------------------------------#
#  
# Check if the batch job has been submitted or Ended.                          #
# 
#  Parameters -                                                                #
#                                                                              #
#      session
#      StringStatus (for batch SUBMITTED and ENDED)
#  Returns:                                                                    #
#			Batch completion return code
#------------------------------------------------------------------------------#	

	my $session           = shift;
	my $stringStatus      = shift;
    
	my $wait     = 1;
	my $max  	 = 60;
	my $count 	 = 0;
	my $jclError = 1;
	my $status   = 0;
	 
	# submit and wait for  
	while ($wait != 0 && $count != $max ) {
		sleep (3);
	     
		$wait     = findStringOnPanel( $session, $stringStatus,0,1);
		$jclError = findStringOnPanel( $session, "JCL ERROR",0,1);
		
		pressKey( $session, '[enter]',0,1);
		
		if ($wait == -1) {
			Util::printStatus( 2, "checkBatchStatus: Waiting for job to end." );
		}
		else {
           Util::printStatus( 2, "checkBatchStatus: JOB $stringStatus" );
           if ($jclError == 0) {
           	  # we have a JCL error return bad status 
           	  Util::printStatus( 1, "checkBatchStatus: JOB Ended with JCL Error!" );
           	  $status = 1;
           }
        }   
		$count++;
	}
	if ($count == $max) { print "WWW Batch Job never returned a $stringStatus status. Ending check loop. WWW\n ";}

    return $status;
}

sub batchStatus {
# Check if the batch job has been submitted or Ended.                          #
#                                                                              #
#  Parameters -                                                                #
#      session             =  an address                                       # 
#      Jobname             =  Argument for jobname                             #
#      waitforcompletion   =  Pass a flag of one                               #
#      delete              =  to delete the output, pass a flag of 1           #
#      StringStatus (for batch SUBMITTED and ENDED)                            #
#                                                                              #
#  Returns:                                                                    #
#                 Batch completion return code                                 # 
#------------------------------------------------------------------------------#    

   my $session           = shift;
   my $jobName           = shift;
   my $waitForCompletion = shift;
   my $delete            = shift;
   my $rc;
    
    # make sure we have a clean panel
    pressKey( $session, '[enter]');
    pressKey( $session, '[enter]');
    # issue the tso STATUS command
    write2CommandLine($session, "TSO STATUS $jobName", '[enter]');

    $rc = findStringOnPanel( $session, "ON OUTPUT QUEUE",0, 1 ); 
    if ($waitForCompletion == 1 && $rc != 0) {
      while ($rc != 0 ) {
      	Util::printStatus( 0, "batchStatu:   $jobName still running" );
		sleep 3;
        write2CommandLine($session, "TSO STATUS $jobName","[enter]");
        $rc = findStringOnPanel( $session, "ON OUTPUT QUEUE",0,1 );
        pressKey( $session, '[enter]');
      }
    } else {
      pressKey( $session, '[enter]');
    }
       
    # Delete the output from SDSF
	if ($delete == 1) {        
		write2CommandLine($session, "tso output $jobName delete",'[enter]' ); 	
	}

    return $rc;
}

sub recycleTSO {
#------------------------------------------------------------------------------# 
# Exit and Relogon                                                             #
#                                                                              #
#  Parameters -                                                                #
#      session                                                                 # 
#                                                                              #
#  Returns:                                                                    #
#                                                                              # 
#------------------------------------------------------------------------------#    
	my $session     = shift;
    my $configRef   = Cfg::getcfg();
    my $userid      = $configRef->{'UserID'};
	my $password    = $configRef->{'Password'};
	my $proc        = $configRef->{'Logon_Procedure'}; 
    
        
	navigateBack2Panel( $session, 'ISP@MST1' );
	write2CommandLine($session, "=x","[enter]");
	pressKeys  ($session, "LOGON $userid");
	pressKeyRepeat  ($session, '[enter]',2);
	
	my $form = tie(
	%form, Tie::IxHash,
	'Password  ===>'     					  => $password,
	'Procedure ===>'          			      => $proc,
 
     );
	 write2Panel( $session, $form,'[enter]'   );
	
     pressKeyRepeat  ($session, '[enter]',2); 
     write2CommandLine($session, "PANELID","[enter]");	
     return;
}
sub deleteDataset {
	
    my $session = shift;
    my $dsn     = shift;
    
    # upper case dsn
    $dsn = uc($dsn);
    my $rc;
        	
	write2CommandLine( $session, "tso del '$dsn'", '[enter]',"===>" );
			
	if (MAP::findStringOnPanel($session, "$dsn ALREADY IN USE, TRY LATER",0,1) == 0) {
		Util::printStatus( -1, "$dsn ALREADY IN USE, TRY LATER - Exiting Script", 1, 1 );
		Hllapi::hitKey( $session, '[enter]' );
		write2CommandLine($session, "tso whohas '$dsn'", '[enter]' );
		exit;
		
	} elsif ((MAP::findStringOnPanel($session, "$dsn DELETED",0,1) == 0)|| (MAP::findStringOnPanel($session, "$dsn NOT FOUND",0,1) == 0))  {
		Util::printStatus( 0, "$dsn Deleted", 1, 1 );	
		Hllapi::hitKey( $session, '[enter]' );
		Hllapi::hitKey( $session, '[enter]' );
		$rc = 0;
	} else {
		Util::printStatus( -1, "Unable to delete $dsn. Reason unknown. ", 1, 1 );
		exit;
	}
	return $rc;
}
 
1;
