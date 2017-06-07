#!/bin/perl -w
package Common;
no warnings;
use Win32::API;
use Cfg;
use Cwd;

# ASG's packages
use Util;
use Hllapi;
use PROJCL::PanelsMap;
use PROJCL::ProJcl;
use ESW::PanelsMap;

my $expectedFolderName    = $configRef->{'ExpectedFolderName'};
my $debug = 0;
sub getLabelOption {

#------------------------------------------------------------------------------#
#  Function getLabelOption
#                                                                              #
#      Used to find a label on a panel and return it's option.                 #
#                                                                              #
#  Parameters -                                                                #
#      Session Object.                                                         #
#      The input panel field label.                                            #
#                                                                              #
#  Returns: -1 if label isn't found otherwise the position where the label
#           was found.                                                         #
#                                                                              #
#
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#
	( my $session, my $label ) = @_;

	if ($debug) {
		print "Entering getLabelOption\n";
	}
	my $rc = 0;

	if ($label) {

		# Lookup label from panels map
		my $foundPos = Hllapi::assert( $session, $label );
		if ($foundPos) {

#			Hllapi::placeCursorOnInputField( $session, ( $foundPos - $moveCursorLeft ) );
			$rc = $foundPos;
		}
		else {
			print "+++ Unable to find $label on Panel! +++\n";
			$rc = -1;
		}
	}
	else {
		print "*** Warning - Nothing to write on Panel! ***\n";
		$rc = -1;
	}
	if ($debug) {
		print "Leaving getLabelOption\n";
	}
	return $rc;
}


sub findStringPosition { 

#------------------------------------------------------------------------------#
#  Function findStringPosition                                                  #
#                                                                              #
#      Used to find a string on a panel's and return it's posistion.
#                                                                              #
#  Parameters -                                                                #
#      Session Object.                                                         #
#      The String you want to locate                                           #
#                                                                              #
#  Returns: The position of the string or zero.                               #
#                                                                              #
#                                                                              #
#                                                                              #
#  Author: skb                                                                 #
#------------------------------------------------------------------------------#
	( my $session, my $string, my $startingFrom ) = @_;
	my $foundPos;
	my $rc;
	if ($debug) {
		print "Entering findStringPosition\n";
	}
	if ($string) {

		# Look for the string on the panel
		$foundPos = Hllapi::assert( $session, $string , $startingFrom);
		if ($foundPos) {
			$rc = $foundPos;
		}
		else {
			$rc = 0;
		}
	}
	else {
		print "+++ You must supply a search for string. Exiting script +++\n";
		$rc = -1;
	}
	if ($debug) {
		print "Leaving findStringPosition\n";
	}
	return $rc;
}




sub getPanelOption {

#------------------------------------------------------------------------------#
#                                                   				           #
#------------------------------------------------------------------------------#
	( my $panelID, my $option ) = @_;
	my %panelsMap = getPanelsRef();
	my ( $panel_id, my $panelCommand );
	my $panelTitle;
	my $panelOption;

	for my $panel ( keys %panelsMap ) {
		$panel_id = $panelsMap{$panel}->{'panelID'};
		if ( $panel_id eq $panelID ) {
			$panelOption = $panelsMap{$panel}->{$option};
			return $panelOption;
		}
		print "   $option not found in Map!\n";
		return -1;
	}
}

sub getPanelCommandField {

#------------------------------------------------------------------------------#
#   Uses the panel lookup to located a command on the panel
#   Takes a PanelID and looks up the input command field for that panel.
#
#   If the it can't be found in the map then -1 is returned else the command filed
#   posistion is return.
#
#------------------------------------------------------------------------------#

	( my $currentPanelID ) = @_;
	my %panelsMap = PROJCL::Map::getPanelsMap();
	my ($panel_id);
	my $panel_command_field;

	#
	for my $panel ( keys %panelsMap ) {
		$panel_id = $panelsMap{$panel}->{'panelID'};
		if ( $panel_id eq $currentPanelID ) {
			$panel_command_field = $panelsMap{$panel}->{'field_command'};
			return $panel_command_field;
		}
		print "   $panel_command_field not found in Map!\n";
		return -1;
	}
}


sub capturePanel {

# This routine copies the screen and puts it into an array.
# It checks the 'bottom of data' indicator to know when no more PF8's are needed.
# Returns an array containing the panel contents
#

	my $session            = shift;
	my $currentFileName    = shift;
	my $configRef          = shift;
	my $no_scroll          = shift;
	my $cics               = shift;
	my $initExpFile        = $configRef->{'InitExpFile'};
	my $currentFoldername  = $configRef->{'CurrentFolderName'};
	my $expectedFolderName = $configRef->{'ExpectedFolderName'};
	my $i;
	my $foundpos;
	my $start_display;
	my $end_display;
	my $bottomOfData;
	my $bottomOfData2;
	my $bottomOfData3;
	my @report;
	my @panel;

    # capture and return the current panel. Avoid scrolling.
	if ($no_scroll) {
		if ($cics == 1) {
			@panel = Hllapi::dumpCICSscreen($session);
		} else {
			@panel = Hllapi::dumpPanel($session);	
		}

		# loop thru the model 4 session )
		for ( $i = $start_display ; $i <= 42 ; $i++ ) {
			push( @report, $panel[$i] );
		}
		create_test_data( $currentFileName, \@report);
		return @report;
	}
	# check to see if this panel will need to be paged. Even though we found 
	# a page field the bottom of data indicator may be displayed. If it is,
	# then we don't need to page. 
	$foundpos = Hllapi::assert( $session, "Scroll ===>" );
	$bottomOfData = Hllapi::assert( $session, "* Bottom of data *" );
	
	# check for upper case 
	if (!$bottomOfData) {
		$bottomOfData = Hllapi::assert( $session, "* BOTTOM OF DATA *" );
	}
	
	if ( $foundpos && !$bottomOfData ) {
		MAP::write2PanelField( $session, "Scroll ===>", "PAGE", '[ENTER]' );
		# Turn off PF Keys display if they are on.
#		MAP::write2PanelField( $session, "Command ===>", "PFSHOW OFF", '[$enter]' );
		# Look for the bottom of data indicator
		$bottomOfData = Hllapi::assert( $session, "Bottom of " );
		$bottomOfData2 = Hllapi::assert( $session, "**End**" );
		$bottomOfData3 = Hllapi::assert( $session, "* END OF " );
		$start_display = 0; # dump after line 0
	} else {
		$bottomOfData = 1;
		$start_display = 0;
	}
	
    
	# check to see if this screen has the bottom of data indicator, if it does
	# then there's no need to page down.
	while ( !$bottomOfData && !$bottomOfData2 && !$bottomOfData3) {
		@panel = Hllapi::dumpPanel($session);

		# loop thru the model 4 session )
		for ( $i = $start_display ; $i <= 42 ; $i++ ) {
			push( @report, $panel[$i] );
		}

		# page down
		Hllapi::hitKey( $session, '[F8]' );
		$bottomOfData = Hllapi::assert( $session, "Bottom of " );
	}

	# found bottom of data, write the remaining lines to the array
	@panel = Hllapi::dumpPanel($session);
	for ( $i = $start_display ; $i <= 42 ; $i++ ) {
		last if ( $panel[$i] =~ /\* Bottom of Data \*/ );
		push( @report, $panel[$i] );
	}
     create_test_data( $currentFileName, \@report);
	return @report;
}


sub create_test_data {
	#
	# Use this routine to create the expected and current folders that will store 
	# the data for the verification routines 
	#
	my $currentFileName = shift;
	my $report = shift;
	my $sorted = shift;
	
	
	# convert array reference back to array
	my @report = @{$report};
	my $configRef = Cfg::getcfg();
	my $initExpFile        = $configRef->{'InitExpFile'};
	my $currentFoldername  = $configRef->{'CurrentFolderName'};
	my $expectedFolderName = $configRef->{'ExpectedFolderName'};
	
	# Check if current_data folder exists. Create it if not.
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
  	
  	# if we were called by the infox sorted routine then bypass the expected folder stuff
  	# because the expected folder stuff is generated dynamically.
    if ($sorted eq 'sorted') {
    	return;
    }
	# Check if exp_data Directory exists. Create it if not there.
	if ( !( -d $expectedFolderName ) ) {
		mkdir($expectedFolderName);
		print " Building $expectedFolderName Directory \n";
	}

	# Write the expected file if the config flag says so

	if ($initExpFile) {
		$rc = Util::createExpectedData( $configRef, $currentFileName );
	}

}	


sub captureCICSPanel {

# This routine copies the screen and puts it into an array.
# It checks the 'bottom of data' indicator to know when no more PF8's are needed.
# Returns an array containing the panel contents
#

	my $session            = shift @_;
	my $currentFileName    = shift @_;
	my $configRef          = shift @_;
	my $initExpFile        = $configRef->{'InitExpFile'};
	my $currentFoldername  = $configRef->{'CurrentFolderName'};
	my $expectedFolderName = $configRef->{'ExpectedFolderName'};
	my $i;
	my $foundpos;
	my $start_display;
	my $end_display;
	my $bottomOfData;
	my $bottomOfData2;
	my @report;
	my @panel;

	# This check only needs to check what is on the shown panel and 
	# nothing more.
	
	$foundpos = Hllapi::assert( $session, "Scroll ===>" );
	$bottomOfData = Hllapi::assert( $session, "* Bottom of data *" );
	
    
	# write screen lines to the array
	@panel = Hllapi::dumpPanel($session);

	# loop thru the model 4 session )
	for ( $i = $start_display ; $i <= 42 ; $i++ ) {
		push( @report, $panel[$i] );
	}

	# Check if current_data folder exists. Create it if not.
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
sub captureReport {


	my $session   = shift @_;
	my $fileName  = shift @_;
	my $configRef = Cfg::getcfg();

	my $i;
	my $dsn;
	my @panel;
	my $toDir  = $configRef->{'CurrentFolderName'};
	my $expDir = $configRef->{'ExpectedFolderName'};
	my $newerr;
	my $dir;
	my $ftpMsg;

	# dump the current panel to array
	@panel = Hllapi::dumpPanel($session);
	##TODO no need to loop thru 6 lines because we know which line contains DSN
	
	# loop through the first 6 lines of the panel looking for the report dsn.
	# If I find it, use it to FTP the contents of the report to the
	# local machine.
	for ( $i = 0 ; $i <= 5 ; $i++ ) {
		if ( $panel[$i] =~
m/\s+([a-zA-Z#\$@&][a-zA-Z0-9#\$@&]{1,7}[\.][a-zA-Z#\$@&][a-zA-Z0-9#\$@&]{1,7}.*?\s+)/
		  )
		{
			$dsn = $1;

			#remove trailing whitespace
			$dsn = Util::trim($dsn);
			last;
		}
	}

# if we found the DSN, FTP it into the well known directory (current_data) on the local machine.
	if ($dsn) {

		getRemoteFile( $dsn, $toDir, $fileName );
	}
	else {
		print "+++ Unable to locate report dataset name! +++ \n";
		$status = -1;
		return $status;
	}
	chdir("$toDir");
	$dir = getcwd();
	print "$dir/$fileName\n";
	my @currFile = Util::convertFile2Array("$dir/$fileName");
	chdir("..");

	# create the expected file?
	if ( $configRef->{'InitExpFile'} == 1 ) {
		$rc = Util::createExpectedData( $configRef, $fileName );
	}

	$dir = getcwd();
	return (@currFile);

}
sub captureDSN {


	my $session   = shift;
	my $fileName  = shift;
	my $dsn       = shift;
	my $configRef = Cfg::getcfg();

	my $i;
	my $toDir  = $configRef->{'CurrentFolderName'};
	my $expDir = $configRef->{'ExpectedFolderName'};
	my $newerr;
	my $dir;
	my $ftpMsg;



	getRemoteFile( $dsn, $toDir, $fileName );


	chdir("$toDir");
	$dir = getcwd();
	print "$dir/$fileName\n";
	my @currFile = Util::convertFile2Array("$dir/$fileName");
	chdir("..");

	# create the expected file?
	if ( $configRef->{'InitExpFile'} == 1 ) {
		$rc = Util::createExpectedData( $configRef, $fileName );
	}

	$dir = getcwd();
	return (@currFile);

}
##todo document getRemoteFile
#------------------------------------------------------------------------------#
#                                                   				           #
#------------------------------------------------------------------------------#

sub getRemoteFile {
	my $file2Get  = shift;
	my $toDir     = shift;
	my $fileName  = shift;
	my $configRef = Cfg::getcfg();

	my $iphostname = $configRef->{'IPHostname'};
	my $userID     = $configRef->{'UserID'};
	my $password   = $configRef->{'Password'};

#    Make sure that iphostname is not missing.
    if (!$iphostname) {
        Util::printStatus(1, "ftpGetFile missing iphostname in .ini file: $!");
        return -1;
	}
      
	# change into the current_file directory before calling FTP
	chdir($toDir);

	# Get the file from the remote host
	$newerr =
	  Util::ftpGetFile( $iphostname, $userID, $password, $file2Get, $fileName );

	# change back to the working directory
	chdir("..");

	return 0;

}

sub processPanelMap {

#------------------------------------------------------------------------------#
#                                                   				           #
#------------------------------------------------------------------------------#

	my $currentPanelID = shift;
	my $option         = shift;

	my %panelsMap = getPanelsRef();
	
	my $configRef = Cfg::getcfg();
	my $aut = $configRef->{'AUT'};
	my @panelKeys = ( keys %panelsMap );
	my $panel_id;
	my $cmdField;
	my $panelOption;
	my $rc;
	my $panelTitle;

	#
	#  find current panel map entry and return the fields from the map
	#

	# loop thru each map entry using panelID as the index
	foreach my $key (@panelKeys) {
		$panel_id = $panelsMap{$key}->{'panelID'};

		# found the entry in the map copy the map fields
		if ( $panel_id eq $currentPanelID ) {
			$panelTitle  = $panelsMap{$key}->{'panelTitle'};
			$cmdField    = $panelsMap{$key}->{'field_command'};
			$panelOption = $panelsMap{$key}->{$option};
			$tabForward = $panelsMap{$key}->{'tab_forward'};
			last;
		}
	}

	# Make sure we have option defined in the map for this panel
	# If we don't it's likely we're on not on the panel we think we are.
	if ( not $panelOption ) {
		print
              "*** Unable to locate  Panel $currentPanelID in $aut Panel MAP ***\n";
		return -1;                        
	}
	return ( $panelTitle, $cmdField, $panelOption, $tabForward );
}
###


sub lookupPanelTitle {

#
#------------------------------------------------------------------------------#
#  looks up a Panel Title using the PanelID.
#  returns the Panel Tile string or -1.                                                 				           #
#------------------------------------------------------------------------------#

	my $currentPanelID = @_;
	my %panelsMap      = getPanelsRef();
	my @panelKeys      = ( keys %panelsMap );
	my $panel_title    = '-1';

	#
	#  find panel title using panel id
	#

	foreach my $key (@panelKeys) {
		my $panel_id = $panelsMap{$key}->{'panelID'};
		if ( $panel_id eq $currentPanelID ) {

			# we have the map entry for the panel we are on
			# now check and see if it's the panel we think
			# we're on.

			$panelTitle = $panelsMap{$key}->{'panelTitle'};
			last;
		}
	}
	return ($panelTitle);
}

sub selectMenuMapItem {
##todo
#------------------------------------------------------------------------------#
#                                                   				           #
#------------------------------------------------------------------------------#

	( my $session, my $panelID, my $menu_name, my $menu_key ) = @_;
	my %panelsMap = getPanelsRef();
	
	my @panelKeys = ( keys %panelsMap );
	my $panel_id; 
	my $panel_option;
	my $found;
	my $rc;
	my $configRef = Cfg::getcfg();
	my $aut = $configRef->{'AUT'};
	my $panelTitle;

	#
	#  find current panel map entry, lookup the menu-item and return the value
	#

	foreach my $key (@panelKeys) {
		$panel_id = $panelsMap{$key}->{'panelID'};
		if ( $panel_id eq $panelID ) {

			# found the map entire
			$panelTitle = $panelsMap{$key}->{'panelTitle'};

			# get the menu key
			$panel_option = $panelsMap{$key}{$menu_name}->{$menu_key};
			if (!$panel_option) {
				print "+++ Unable to find key: $menu_key in $aut panels map +++ \n";
				$rc = -1;
			} else {
				$rc = 0;
				$found = 1;
			}
			last;
		}
	}
	if ($found != 1) {
		print "+++ Panel Map entry for panel $panelTitle not found. +++\n";
		$rc = -1;
	} 
	if ($debug) {
		print
		  "Leaving selectMenuMapItem with $panelTitle,$panelID,$panel_option\n";
	}

	Hllapi::keys2press( $session, $panel_option, 1 );
##todo set proper RC
	return $rc;
}

sub getPanelsRef {

	my $configRef = Cfg::getcfg();
	my $aut = $configRef->{'AUT'};	
	my %panelsMap;
	$aut = lc($aut);
	my $panelsMap;
	
	if ($aut eq 'esw' )  {
		$panelsMap = ESW::PanelsMap::getPanelsMap();
	} else{
		$panelsMap = PROJCL::PanelsMap::getPanelsMap();
	}	
	
	return %$panelsMap;
}

sub getPanelID {

	#
	# Get current Panel's panelID to be used to find current panels map entry.
	#

	my $session  = shift @_;
	my $panelID;
	my $location = 162;
	

	# So far all product panel IDs start at location 164 except for Smart File.
	$panelID = Hllapi::copyPresentationSpace( $session, $location, 8 );
	
	# 8 blanks indicates Smart File panel.
	if ($panelID eq '        ') {
		$panelID = Hllapi::copyPresentationSpace( $session, 1, 9 );
	} 
	if ($debug) {
		print " Leaving getPanelID with rc == $panelID\n";
	}
	$panelID =~ s/\s+$//;    # remove trailing spaces
	$panelID =~ s/\s+//;     # remove leading spaces
	# grab only the panlid. some short panelIDs pick up other chars from the title
	$panelID =~ s/(\s+\w)//; 
	
	return $panelID;
}

sub turnOnPanelID {

#------------------------------------------------------------------------------#
#  Issuses the PANELID command if the panel id isn't turned on. 
#  Note: SmartFile Panels no support for panelid yet. 
#------------------------------------------------------------------------------#

	my $session = shift @_;
	my $configRef = Cfg::getcfg();
	my $aut = $configRef->{'AUT'};
	my $enter   = 1;
	my $panelID;
	my $cmdLineLable = "===>";
	my $foundpos;
	

	# Get the Panel id on the assumed position 162. Get only the first 4 chars.
	$panelID = Hllapi::copyPresentationSpace( $session, 162, 4 );


	if ($debug) {
		print " Leaving getPanelID with rc == $panelID\n";
	}

	# turn panelID on for ISPF, SDSF and SmartFile panels
	if ( $panelID eq '    ' || $panelID eq 'SDSF' ) {
		$foundpos = Hllapi::assert( $session, $cmdLineLable );
		MAP::write2PanelField( $session, "===>", "PANELID", $cmdLineLable);
	}
	else {
#		print "Panel ID is already on.\n";
	}

	 
	return 0;
}
##todo need to log all message in a journal/log file
sub copyFromCursorLocation {
#------------------------------------------------------------------------------#
#  
#  Copies data starting from the cursor location for the length of the supplied
#  parameter.
#  Parameters -                                                                #
#                                                                              #
#      session
#      number of chars to copy 
#  Returns:                                                                    #
#			The copied data from the panel
#------------------------------------------------------------------------------#	

	my $session    = shift @_;
	my $len         = shift@_;

	my $pos =  Hllapi::queryCursorLocation($session);
	my $data = Hllapi::copyField2String($session, $pos, $len );

    return $data;

}
sub copyFromScreenLocation {
#------------------------------------------------------------------------------#
#  
#  Copies data starting from the $pos location for the length of $len.
#  Parameters -                                                                #
#                                                                              #
#      session
#      Position location to start the copy from
#      number of chars to copy 
#  Returns:                                                                    #
#			The copied data from the panel
#------------------------------------------------------------------------------#	

	my $session     = shift;
	my $pos         = shift;
	my $len         = shift;

	my $data = Hllapi::copyPresentationSpace($session, $pos, $len );

    return $data;

}

sub scrollPopupList {
## todo provide a fix to allow child popup scrolling
# This function scrolls a Popup Action List Panel like that of 'Select RTS Member'
# in Pro/JCl.
#
#
# It checks the 'Row XXX to XXX of XXX' indicator to know when to page thru the list.
#
#
# Returns  1 if the row is found otherwise 0
#

	my $session = shift @_;
	my $i =0;
	my $endOfPopup = 0;
	my $endOfList  = 1;
	my $page;

	my @panel;
	
	# pre-set endOf vars so that we fall into loop for the first time.
	# Once we're in the loop do:
	#     1) dump the panel into the panel array
	#     2) set the row and list vars for paging
	#     3) test the row and list vars to see if we need to page down
	#

	# dump the popup to an array
	@panel = Hllapi::dumpPanel($session);
	# get the length of the panel array
	my $max = @panel;

	# use the panel array to find the row tag because we can't do
	# regexp with hllapi
	foreach my $line (@panel) {

		# look for the 'row xxx to xxx of xxx' tag to determine if we
		# need to page.
		
		$i++;
		if ( $line =~
			m/\s+e.*Row\s+\d{1,10}\s+to\s+(\d{1,10})\s+of\s+(\d{1,10})/ )

		{
			$endOfPopup = $1;
			$endOfList  = $2;
			if ($endOfPopup == $endOfList) {
				$page = 0;
			}
			last;
		}

	}
	if ($i == $max){
		print "+++ Panel doesn't contain a 'Row Tag'! Make sure you're on the correct panel. +++\n";
 		$page = 0;
	}
	
	if ( $endOfPopup != $endOfList ) {
		$page = 1;
	}
	else {
		$page = 0;
	}
	return $page;
}

sub compressISPFprofile {
	
	my $session   = shift @_;
	my $configRef = Cfg::getcfg();
	
	my $host   	  = $configRef->{'Host'};
	
	my $rc;
	# navigate to utilities panel
	$rc = MAP::write2CommandLine($session, "=3.1", '[enter]');
	
	# select option 'C'
	$rc = MAP::write2CommandLine($session, "C"); 
	# fill out form to compress profile
	my $form = tie(
		%form, Tie::IxHash,
		'Name  . . . . . . .'      => "$host.ispf.ispprof",
	);
	# Write the form to the panel fields

	$rc = MAP::write2Panel( $session, $form, '[enter]');	
	
	
	# verify we got the compress successful message
	$rc = MAP::findStringOnPanel($session, "Compress successful",0,1);
	if ($rc != 0) {
		print "*** Warning, unable to compress profile dataset! ***\n";
	}
	# return to ISPF main
	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	
	return $rc 
}
sub compressFile {
	
	my $session   = shift @_;
	my $dsn       = shift @_;
	my $configRef = Cfg::getcfg();
	
	$dsn = "'" . $dsn . "'";
	my $rc;
	# navigate to utilities panel
	$rc = MAP::write2CommandLine($session, "=3.1", '[enter]');
	
	# select option 'C'
	$rc = MAP::write2CommandLine($session, "C"); 
	# fill out form to compress profile
	my $form = tie(
		%form, Tie::IxHash,
		'Name  . . . . . . .'      => $dsn,
	);
	# Write the form to the panel fields

	$rc = MAP::write2Panel( $session, $form, '[enter]');	
	
	
	# verify we got the compress successful message
	$rc = MAP::findStringOnPanel($session, "Compress successful",0,1);
	if ($rc != 0) {
		print "*** Warning, unable to compress profile dataset! ***\n";
	}
	# return to ISPF main
	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	
	return $rc 
}
sub find_element_in_array {
	my ($ref_array) = shift;
	my $find        = shift;
	my @array       = @{$ref_array};
	my $i           = 0;
	my $maxIndex    = $#array;

	# find the item in the array
	while ( ( $i <= $maxIndex ) && ( $array[$i] ne $find ) ) {
		++$i;
	}

	if ( $i <= $#array ) {    # searched it & eureka
		return 1;             # for true;
	}
	return 0;                 # for false;
}

sub scrollPanelList {
	
	( my $session, my $cmd_label ) = @_;

	my $rc;
	my $foundPos       = Hllapi::assert( $session, $cmd_label );
	my $isBottomOfData = 0;
	my $failsafe = 0;

	until ($isBottomOfData) {
		$isBottomOfData = Hllapi::assert( $session, "* Bottom of data *" );
		$failsafe++; 
		if ($foundPos) {

			# make call passing the left tab flag.
			$rc = Hllapi::placeCursorOnInputField( $session, $foundPos, '', 1 );
			last;
		}
		else {
			Hllapi::hitKey( $session, '[F8]' );
			$foundPos = Hllapi::assert( $session, $cmd_label );
			$rc = -1;
			if ($failsafe == 20) {
				last;	
			}
		}
	}
	Util::printStatus($rc, "common::scrollPanelList $cmd_label");
	return $rc;	
}
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
sub printHash {
	my $hash_ref = shift;
	my %theHash =  % { $hash_ref };
    
    foreach $key (sort keys %theHash) {
    	print "$key: $theHash{$key}\n";
    }
    # print to a file for the web server
    open( RTS, "+>./rts.txt" )or die("Couldn't open: $!\n");
    foreach $key (sort keys %theHash) {
     	write RTS;
    }
    close (RTS);

    
#	while (($key, $value) = each(%theHash)){
#	     print $key.", ".$value."\n";
#	}
format RTS =
   @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	 $key, $theHash{$key};	                 	 			   			   
.
}

sub doesArrayHaveRecords {
     # determines if the Expected file has data in it.
     # if it doesn't then  set the script status to fail and print error message.
     # return -1  for fail and 0 for pass
     
     my $file = shift;
     my $path = shift;
     my  @file = @$file;
     if ( $file[0] == -1 ) {
		print "+++ Verify failed because $path is missing. +++ \n";
		Cfg::set_script_status(-1);
		return -1;
	} else {
		return 0;
	}
}
1;