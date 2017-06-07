#!/bin/perl  -w
package Infox;
use Win32::API;
use Hllapi;
use Common;
use Convert::EBCDIC;
use MAP;


##########################################################################################################
#
# verifyColumnData
# A specialized routine for scrolling an Infox panel column and verify the contents of that column.
# The column data is compared to the expected column data file and reports the differences if there are any.
#
# Parameters:
#     - Session Object
#     - Name of column title that you want to scroll
#     - Name of file you want the column data stored in. This file will be stored in the Expected folder of the TC
#     - Optional length indicator. Used to determine the amount of chars to copy from the column. If no
#       value is set the default length is set to 8 chars
#     - Optional row number used to place the cursor on a paticular row. NOTE: this value is the number of
#       times you want to hit the down arrow key to get to the row/column you want to verify.
# Returns:
#     -  0 for a pass and -1 for failure
##########################################################################################################
sub verifyColumnData {

	my $session         = shift;
	my $colTitle        = shift;
	my $fileName        = shift;
	my $len             = shift;
	my $rowNumber       = shift;
	my $safetySwitch    = 0;
	my $safteySwitchMax = 50;
	my $rc;
	my $colData;
	my $pos;
	my @col;

	# use scrollPanel to position the cursor on the column data
	scrollPanelColumnLeft( $session, $colTitle, 0 );

# check to see if the user wants to place the cursor on specific row for verification
# otherwis cursor stays at the top row colunm position
	if ( defined($rowNumber) ) {

		# decrement the row number so we have the correct value
		$rowNumber = $rowNumber - 1;
		MAP::pressKeyRepeat( $session, '[down]', $rowNumber );
	}
	my $dataPos = MAP::getCursorLocation($session);

	# if the cursor is setting at least 300 chars into the screen there's a
	# good chance we have a valid colunm location.
	if ( $dataPos > 300 ) {
		my $colSize = getPanelColumnSize( $session, $colTitle );

		# place the cursor on the column data
		scrollPanelColumnLeft( $session, $colTitle, 0 );
		my $recordLength = getRecordLength( $session, $colTitle, $colSize );

		$colData =
		  Common::copyFromScreenLocation( $session, $dataPos + $offset,
			$colSize );

		$recordLength = $recordLength - $colSize;

		while ( $foundPos =
			Hllapi::assert( $session, "Start of field", 1 ) == 0 )
		{
			MAP::pressKey( $session, '[f4]' );

			# no need to copy if 'end of field' msg is present.
			if ( $foundPos =
				Hllapi::assert( $session, "Start of field", 1 ) != 0 )
			{
				last;
			}
			if ( $recordLength < $colSize ) {
				$colSize = $recordLength;
			}
			$colData =
			  Common::copyFromScreenLocation( $session, $dataPos + $offset,
				$colSize )
			  . $colData;
			$recordLength = $recordLength - $colSize;
		}

		# write column data to the current file
		# put the string in an array so we can use the create_test_data routine
		$col[0] = $colData;

		Common::create_test_data( $fileName, \@col );

		# compare the column data with the expected file
		$rc = compareColumnData( $session, $fileName, $colData );

		# scroll the column back to the start of data
		$safetySwitch = 0;
		while ( $foundPos =
			Hllapi::assert( $session, "Start of field", 1 ) == 0 )
		{
			$safetySwitch++;
			MAP::pressKey( $session, '[f4]' );
			if ( $safetySwitch > $safteySwitchMax ) { last; }
			$safetySwitch++;

		}
	}

	Util::printStatus( $rc, "Infox::verifyColumnData" );

	return $rc;
}

sub getRecordLength {

	my $session  = shift;
	my $colTitle = shift;
	my $colSize  = shift;
	my $i        = 0;
	my $columnLength;
	my $digits;
	my $dashes;
	my $rulerPos;
	my $ruler;
	my $safetySwitch;
	my $countAfter;
	my $safteySwitchMax = 40;

	# Position the column to 'End of Field'
	$safetySwitch = 0;
	while ( $foundPos = Hllapi::assert( $session, "End of field", 1 ) == 0 ) {
		$safetySwitch++;
		MAP::pressKey( $session, '[f5]' );
		if ( $safetySwitch > $safteySwitchMax ) { last; }
		$safetySwitch++;
	}

	# move the cursor to the ruler
	MAP::pressKey( $session, '[up]' );
	$rulerPos = MAP::getCursorLocation($session);
	$ruler    =
	  Common::copyFromScreenLocation( $session, $rulerPos + $offset, $colSize );

# Make sure we have a ruler. First byte must be either a dash, digit or plus sign.
	if ( $ruler =~ m/[-\+\d]/ ) {

		$ruler = reverse($ruler);

		# Now grab the digits for the caculation
		if ( $ruler =~ m/(\d+)/ ) {
			$digits = $1;

			# check to see if we have a ruler starting with digits.
			if ( $ruler =~ m/^\d+/ ) {
				$countAfter = 1;
			}

			if ($countAfter) {

				# count the bytes before the digits
				$ruler =~ m/\d+/;
				$dashes       = $';
				$columnLength = $digits * 10 + length($dashes);
			}
			else {
				$digits = reverse($digits);

				# count the bytes before the digits
				$ruler =~ m/\d+/;
				$dashes       = $`;
				$columnLength = ( $digits * 10 ) + length($dashes);
			}

		}
		else {

	# we didn't find a digit so we need to scroll to the right to look for them.
			MAP::pressKey( $session, '[down]' );
			MAP::pressKey( $session, '[f4]' );
			MAP::pressKey( $session, '[up]' );
			$rulerPos = MAP::getCursorLocation($session);
			$ruler    =
			  Common::copyFromScreenLocation( $session, $rulerPos + $offset,
				$colSize );
			$ruler = reverse($ruler);

			# Now grab the digits for the caculation
			if ( $ruler =~ m/(\d+)/ ) {
				$digits = $1;

				# check to see if we have a ruler starting with digits.
				if ( $ruler =~ m/^\d+/ ) {
					$digits = reverse($digits);

					# count the bytes after the digits
					$ruler =~ m/\d+/;
					$dashes       = $';
					$columnLength = $digits * 10 + $colSize;
				}

	   # ruler doesn't start with digits, count the bytes before the first match
				else {
					$digits = reverse($digits);

					# count the bytes before the digits
					$ruler =~ m/\d+/;
					$dashes       = $`;
					$columnLength = ( $digits * 10 ) + length($dashes);
				}

				# Scroll back to the end of data so all data will be copied
				MAP::pressKey( $session, '[down]' );
				MAP::pressKey( $session, '[f5]' );
				MAP::pressKey( $session, '[up]' );

			}
			else {

				# we never found any digits. Give up and return error.
				$columnLength = -1;
				print "+++ No digits found on this ruler! +++\n";
			}
		}
	}
	else {
		$columnLength = -1;
		print "+++ $parse not matched! +++\n";
	}

	MAP::pressKey( $session, '[down]' );
	print "*** Record Lenght for $colTitle is $columnLength ***\n";
	return $columnLength;
}

sub getPanelColumnSize {
	my $session = shift;
	my $pos     = shift;
	my $ruler;
	my $size;

 # the caller should have positioned us on the column now we must put the cursor
 # on the ruler
	MAP::pressKey( $session, '[up]' );

	$pos   = MAP::getCursorLocation($session);
	$ruler = Common::copyFromScreenLocation( $session, $pos + $offset, 70 );

	# determine the length of the display area of the ruler

	#
	$ruler =~ m/^([-\+\d\<]+)/;
	$ruler = $1;
	$size  = length($ruler);

	return $size;

}

sub verifyPopupField {
	my $session         = shift;
	my $fieldName       = shift;
	my $fileName        = shift;
	my $startSearchPos  = 100;
	my $safetySwitchMax = 20;
	my $safetySwitch    = 0;
	my $rc;
	my $field;
	my @field;
	my $isAscrollField = 0;
	my $fieldLenght = 54;    # the number of bytes to copy from the panel field

	# place the cursor on the scrollable field
	my $pos =
	  Common::findStringPosition( $session, $fieldName, $startSearchPos );

	# now bump past the string and put the cursor on the scroll field
	my $len = length($fieldName);
	$pos = $pos + $len + 1;
	
	# turn on scrolling beacuse we didn't find the '>' char which indicates scrolling.
    if ($fieldName =~ m/>/) {
    	$isAscrollField = 1;
    }
	if ( $pos > $startSearchPos ) {
		Hllapi::placeCursorOnPanel( $session, $pos );
        
        # Not a scrollable field just collect the 54 bytes and be done with it.
		if ($isAscrollField == 0) {
			$field = $field
			  . Common::copyFromScreenLocation( $session, $pos + $offset,
				$fieldLenght );

		 # put the string in an array so we can use the create_test_data routine
			$field[0] = $field;

			Common::create_test_data( $fileName, \@field );

			# compare the column data with the expected file
			$rc = compareColumnData( $session, $fileName, $field );

		}
		else {
			while ( $foundPos =
				Hllapi::assert( $session, "End of field", 1 ) == 0 )
			{
				$field = $field
				  . Common::copyFromScreenLocation( $session, $pos + $offset,
					$fieldLenght );
				MAP::pressKey( $session, '[f5]' );
				if ( $safetySwitch > $safetySwitchMax ) {
					$rc = '-1';
					last;
				}
				$safetySwitch++;
			}

		 # put the string in an array so we can use the create_test_data routine
			$field[0] = $field;

			Common::create_test_data( $fileName, \@field );

			# compare the column data with the expected file
			$rc = compareColumnData( $session, $fileName, $field );

			while ( $foundPos =
				Hllapi::assert( $session, "Start of field", 1 ) == 0 )
			{
				MAP::pressKey( $session, '[f4]' );
				if ( $safetySwitch > $safetySwitchMax ) { $rc = '-1'; last; }
				$safetySwitch++;
			}

			#
		}

	}
	else {
		$rc = '-1';
		Util::printStatus( $rc,
			"Infox::verifyPopupField - $fieldName not found!" );
		return $rc;
	}
	Util::printStatus( $rc, "verifyPopupField" );
	return 0;
}

##########################################################################################################
#
# scrollPanelColumnLeft
# A specialized routine for scrolling an Infox panel column to the right.
#
#
# Parameters:
#     - Session Object
#     - Name of column title that you want to scroll
#     - Number of times you want the F5 key hit
#     - Use this optional parameter to start the search for the column name at a specific start location. For example
#       you might want to skip over the headings and panel title because they may contain the column name in them.
#
# Returns:
#     -  0 for a pass and -1 for failure
##########################################################################################################
sub scrollPanelColumnLeft {
	my $session        = shift;
	my $col            = shift;
	my $numOfTimes     = shift;
	my $startSearchPos = shift;
	my $rc;

	$rc = scrollPanelColumn( $session, $col, $numOfTimes, $startSearchPos );
	return $rc;
}
##########################################################################################################
#
# scrollPanelColumnRight
# A specialized routine for scrolling an Infox panel column to the right.
#
#
# Parameters:
#     - Session Object
#     - Name of column title that you want to scroll
#     - Number of times you want the F5 key hit
#     - Use this optional parameter to start the search for the column name at a specific start location. For example
#       you might want to skip over the headings and panel title because they may contain the column name in them.
#
# Returns:
#     -  0 for a pass and -1 for failure
##########################################################################################################
sub scrollPanelColumnRight {
	my $session        = shift;
	my $col            = shift;
	my $numOfTimes     = shift;
	my $startSearchPos = shift;

	$rc = scrollPanelColumn( $session, $col, $numOfTimes, $startSearchPos );
	return $rc;
}

sub scrollPanelColumn {
	my $session        = shift;
	my $col            = shift;
	my $numOfTimes     = shift;
	my $startSearchPos = shift;
	my $rc             = 0;
	my $pos;

	# determine what subroutine called me
	my @caller     = caller 1;
	my $subroutine = $caller[3];
	$subroutine =~ s/^.*:://;    # remove package name

	# set default to 300 to skip over menu and headings.
	if ( !defined($startSearchPos) ) {
		$startSearchPos = 500;
	}
	
	# you must set the seach parms in the session because we're using a starting at position search
    Hllapi::setSessionParameters( $session, "SRCHFROM,SRCHFRWD" );
	$pos = Common::findStringPosition( $session, $col, $startSearchPos );

	# If we found the column title then place the cursor below it
	if ( $pos > $startSearchPos ) {
		Hllapi::placeCursorOnPanel( $session, $pos );
		MAP::pressKeyRepeat( $session, '[down]', 2 );
	}
	else {
		$rc = '-1';
		Util::printStatus( $rc,
			"Infox::scrollPanelColumnLeft - $col not found!" );
		return $rc;
	}

	# make sure the user supplied the 'number of times' param.
	if ( !defined($numOfTimes) ) {
		$rc = '-1';
		Util::printStatus( $rc,
			"Infox::scrollPanelColumnLeft - No F5 keys to press." );
		return $rc;
	}

	# setup left or right
	if ( $subroutine eq 'scrollPanelColumnLeft' ) {
		MAP::pressKeyRepeat( $session, '[F5]', $numOfTimes );

	}
	elsif ( $subroutine eq 'scrollPanelColumnRight' ) {
		MAP::pressKeyRepeat( $session, '[F4]', $numOfTimes );
	}

	return $rc;
}

sub compareColumnData {

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

	my $session       = shift;
	my $fileName      = shift;
	my $currentString = shift;
	my $rc;
	my $exp;

	my $configRef = Cfg::getcfg();

# verify that the expected and current folders exist. If they don't they will be created.
	Util::verifyFolder("./$configRef->{'CurrentFolderName'}/$fileName");
	Util::verifyFolder("./$configRef->{'ExpectedFolderName'}/$fileName");

	my @curr;
	$curr[0] = $currentString;
	my @exp =
	  Util::convertFile2Array("./$configRef->{'ExpectedFolderName'}/$fileName");

	# check to see if we need to load the expected folder with the data
	if ($initExpFile) {
		$rc = Util::createExpectedData( $configRef, $currentFileName );
	}
	( $diffs, $rc ) = Util::compareArrays( \@exp, \@curr );

	my $message;

	$message = Util::printStatus( $rc, "compareColumnData $fileName" );

	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
	Util::reportResults( $message, "./results.log" );

	Util::printStatus( $rc, "compareColumnData" );
	
	if ($rc != 0 ) {

		Cfg::set_verify_status(-1);
	}	
	
	
	return $rc;

}

sub getPanelRowCounts {

	my $session = shift;
	my $endOfPanelRows;
	my $endOfRows;
	my @panel;
	my $line;
	my $rc = 0;

	# dump the popup to an array
	@panel = Hllapi::dumpPanel($session);

	# get the length of the panel array
	my $max = @panel;

	# use the panel array to find the row tag
	foreach $line (@panel) {
		if ( $line =~ m/\s.*Row\s+\d{1,10}\s+to\s+(\d{1,10})\s+of\s+(\d.*\s)/ )
		{
			$endOfPanelRows = $1;
			$endOfRows      = $2;

			# strip the comma if out if there is one.
			$endOfRows =~ s/,//;
			chomp($endOfRows);
			$endOfRows = Util::trim($endOfRows);
			last;
		}

	}

	# check to see if we found the row tag, if not return error.
	if ( $endOfPanelRows < 1 || $endOfRows < 1 ) {
		$rc = -1;
	}
	return ( $endOfPanelRows, $endOfRows, $rc );
}
###############################################################################
# verifySortedColumnData
# 
#
# DESCRIPTION: Use this function to verify the infox sort menu items. This function
# assumes that the sort has already been issued on the panel and will verify the 
# the sorted panel column data with perl's sorted column data. 
#
# If you want to verify a panel sort command use the sortAndVerifyColumnData 
# function.
###############################################################################
sub verifySortedColumnData {
	
	my $session    = shift;
	my $columnName = shift;
	my $fileName   = shift;
	my $sortType   = shift;
	my $columnRows;
	my $post;
	my $rc;
	my $i;
	my $type;
	my $ebcdic;

	my @columnRows;
	my @sortedArray;
	my @printArray;
	my @post;
	my @diffs;
	my $sortFailed;
   # get access to the config object
	my $configRef = Cfg::getcfg();
	my $currentFolderName  = $configRef->{'CurrentFolderName'};
	my $expectedFolderName = $configRef->{'ExpectedFolderName'};
	
	Util::verifyFolder("./$configRef->{'CurrentFolderName'}/$fileName");
	Util::verifyFolder("./$configRef->{'ExpectedFolderName'}/$fileName");

	# getColumnData returns a reference of an array
	( $columnRows, $rc ) = getColumnData( $session, $columnName );

	# convert the array reference to an array so that I can sort
	@columnRows = @{$columnRows};

	# determine what type of perl sort we need to do.
	if ( $sortType eq 'a' ) {
		@sortedArray = sort(@columnRows);
	}
	else {
		@sortedArray = reverse sort (@columnRows);
	}

	# convert the sorted ebcdic back to ascii
	$i = 0;
	foreach $ebcdic (@sortedArray) {
		$sortedArray[$i] = Convert::EBCDIC::ebcdic2ascii($ebcdic);
		$i++;
	}
	
	# convert the columns ebcdic back to ascii
	$i = 0;
	foreach $ebcdic (@columnRows) {
		$columnRows[$i] = Convert::EBCDIC::ebcdic2ascii($ebcdic);
		$i++;
	}
	
	# make array printable for the current folder
	$i = 0;
	foreach my $line (@columnRows) {
		$printArray[$i] = "$line\n";
		$i++;
	}
	# load the expected folder
	open( CUR, ">./$currentFolderName/$fileName")
	  or die("Couldn't open $currentFolderName: $!\n"); 
	print CUR @printArray;
	close(CUR);

    # make array printable for the expected folder
	$i = 0;
	foreach my $line (@sortedArray) {
		$printArray[$i] = "$line\n";
		$i++;
	}
	# 
	# write to the expected folder
	open( EXP, ">./$expectedFolderName/$fileName")
	  or die("Couldn't open $expectedFolderName: $!\n");
	print EXP @printArray;
	close(EXP);


	( $diffs, $rc ) = Util::compareArrays( \@sortedArray, \@columnRows );
	
	# convert reference back to arrary
	@diffs = @{$diffs};
	
	# report the differences
	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );
		
    my $diffStatus = $rc;
	Util::printStatus( $rc, "verifySortedColumnData $columnName" );
	# if we have diffs on the sort it is okay to run the rest of the script. 
    if ($diffStatus != 0) {
    	Cfg::set_sort_status(-1);
    	$rc = 0;
    } 
	return $rc;
}
###############################################################################
# sortAndVerifyColumnData
# 
#
# DESCRIPTION: Use this function to verify the infox sort panel commands. 
# This function will issue the panel column sort command provided in the 2nd 
# parameter to this function. 
#
# *Note* Use the long  column name for this parameter not the menu item sort 
# name.
#
# If you want to verify a menu sort command use the verifySortedColumnData 
# function.
###############################################################################
sub sortAndVerifyColumnData{

	my $session    = shift;
	my $columnName = shift;
	my $fileName   = shift;
	my $sortType   = shift;
	my $columnRows;
	my $post;
	my $rc;
	my $i;
	my $type;
	my $ebcdic;

	my @columnRows;
	my @sortedArray;
	my @ascii;
	my @pascii;
	my @printArray;
	my @post;
	my @diffs;

	# get access to the config object
	my $configRef          = Cfg::getcfg();
	my $expectedFolderName = $configRef->{'ExpectedFolderName'};

	# getColumnData returns a reference of an array
	( $columnRows, $rc ) = getColumnData( $session, $columnName );

	# convert the array reference to an array so that I can sort
	@columnRows = @{$columnRows};

	# determine what type of perl sort we need to do.
	if ( $sortType eq 'a' ) {
		@sortedArray = sort(@columnRows);
	}
	else {
		@sortedArray = reverse sort (@columnRows);
	}

	# convert the sorted ebcdic back to ascii
	$i = 0;
	foreach $ebcdic (@sortedArray) {
		$ascii[$i] = Convert::EBCDIC::ebcdic2ascii($ebcdic);
		$i++;
	}

	# make array printable for the expected folder
	$i = 0;
	foreach my $line (@ascii) {
		$printArray[$i] = "$line\n";
		$i++;
	}

	# Check if current_data folder exists. Create it if not.
	if ( !( -d $expectedFolderName ) ) {
		mkdir($expectedFolderName);
		print "*** Building $expectedFolderName Directory *** \n";
	}

	# load the expected folder
	open( EXP, ">./$expectedFolderName/$fileName" )
	  or die("Couldn't open $expectedFolderName: $!\n");
	print EXP @printArray;
	close(EXP);

	# now sort the panel either in descending or acending order
	if ( $sortType eq 'd' ) {
		$type = 'd';
	}
	elsif ( $sortType eq 'a' ) {
		$type = 'a';
	}
	else {
		my $message = "+++ Unknown sort parameter $sortType! +++\n";
		$rc = -1;
		Util::reportResults( $message, "./results.log" );
		Util::printStatus( $rc,
			"sortColumnData Unknown sort parameter = $sortType" );
		return $rc;
	}
	MAP::write2CommandLine( $session, "sort $columnName $type", '[enter]' );

	# getColumnData returns a reference of an array
	( $post, $rc ) = getColumnData( $session, $columnName );

	# make sure we have column data otherwise return error.
	if ( $rc != 0 ) {
		return $rc;
	}

	# all systems go
	@post = @{$post};

	# convert the post sort command array back to ascii
	$i = 0;
	foreach $ebcdic (@post) {
		$pascii[$i] = Convert::EBCDIC::ebcdic2ascii($ebcdic);
		$i++;
	}

	# make array printable for the current folder
	$i = 0;
	foreach my $line (@pascii) {
		$printArray[$i] = "$line\n";
		$i++;
	}

	# load the current folder
	Common::create_test_data( $fileName, \@printArray, 'sorted' );

	( $diffs, $rc ) = Util::compareArrays( \@ascii, \@pascii );

	# convert reference back to arrary
	@diffs = @{$diffs};

	# report the differences
	$rc =
	  Util::writeDiffs2File(
		"./$configRef->{'DifferencesFolderName'}/$fileName",
		\@$diffs, $rc );

	Util::printStatus( $rc, "sortColumnData" );
	Hllapi::setSessionParameters( $session, "SRCHALL,SRCHFRWD" );
	return $rc;
}

###############################################################################
# getColumnData
# 
# DESCRIPTION: Use this function to collect all the values in a column and convert 
# the data to EBCIDIC to be used for sorting. 
# 
# INPUTS Parms:
# 	$session  - The PCOMM session 
#	$col      - The title of the column that you want to collect
# RETURNS:
#   A reference to the EBCIDIC array. 
###############################################################################
sub getColumnData {
	my $session = shift;
	my $col     = shift;
	my $colSize;
	my $pos;
	my $i;
	my $rc;
	my $endOfPanelRows;
	my $endOfRows;
	my $index;
	my @sorted;
	my @records;

	# use scrollPanelColumn to position the cursor on the column
	scrollPanelColumnLeft( $session, $col, 0 );
	
	
	$colSize = getPanelColumnSize( $session, $col );

	( $endOfPanelRows, $endOfRows, $rc ) = getPanelRowCounts($session);

	# we got the counts, let's collect the data
	if ( $rc == 0 ) {
		$index = 0;
		while ( $index != $endOfRows ) {
			scrollPanelColumnLeft( $session, $col, 0 );

			for ( $i = 0 ; $i < $endOfPanelRows ; $i++ ) {
				if ( $index == $endOfRows ) { last; }
				$pos = MAP::getCursorLocation($session);

				if ( $i != 0 ) {
					$pos = $pos + 80;
				}

				Hllapi::placeCursorOnPanel( $session, $pos );
				$records[$index] =
				  Convert::EBCDIC::ascii2ebcdic(
					Common::copyFromScreenLocation( $session, $pos, $colSize )
				  );
				$index++;
			}

			MAP::pressKey( $session, '[f8]', 0, 1);

			# use scrollPanelColumn to position the cursor on the column
			scrollPanelColumnLeft( $session, $col, 0 );
		}
		MAP::write2CommandLine( $session, 'top', '[enter]' );

		# No row count. report and return error.
	}
	else {
		print "+++ Unable to find $col on panel "
		  . Common::getPanelID($session)
		  . " +++\n";
	}
	return ( \@records, $rc );
}


sub verifyBottomOfList {
	
	##############################################################################################
	#
	# Verify that we are at the bottom of a list after issuing a Locate of an Item that does not 
	# exist. Examine Row xxx to yyy of zzz and verify if xxx is equal to zzz.
	# Variable passed: $session.
	# Return: Status code = 0 if xxx = zzz.
	#         Status code = -1 if xxx not equal zzz.
	##############################################################################################
	my $session   = shift;
	my $rowline;
	my $row;
	my $ofrow;
	
				
    #  Get the member count from Row 00001 of  on the right corner of the PDS
	$rowline = MAP::copyTextFromScreen($session,"Row",60);
	
	if  ($rowline =~ m/Row\s+(\d.*)\s+to\s+\d.*\s+of\s+(\d.*)\s\sCommand/)  {
		           
		$row   = $1;
		$ofrow = $2;
				
		if ($row eq $ofrow)  {
			$rc = 0;
	      }	
	     else {
	     	$rc = -1;
	     } 
	}
	 else {
		print "+++ No Match found for $rowline! +++\n";
		$rc = -1;
	 }	
	 
  return $rc; 
} 	

sub verifyConfirmationCount {	
#------------------------------------------------------------------------------------
#
#  verifyConfirmationCount subroutine is checking if the confirmation panel Total for 
#  JOB, PGM, EXEC, PROC, SYSOUT etc (see D0DPXRF0 panel) is equal to the actual 
#  Total for chosen component on the panel list (Row xxxx to yyyy of zzzzz).
# 
#  Parameters -                                                                 
#      Session Object                                                           
#      String "The number of" 
#                                                                               
#  Returns -                                                                    
#      Success = 0                                                               
#      Failure = 1                                                              
#                                                                               
#  Author: cjm             
#------------------------------------------------------------------------------------------
	my $session  = shift;
    my $string   = shift;
    my $confTotCnt;
    my $rowTot; 
    
	$confTotCnt = getTotalListCount ($session, $string, 60);
	
	# Press enter to go to the actual list display
	$status = MAP::pressKey ($session, '[enter]')  if ( not $status );
	
    $rowTot = getRowTotal($session, "Row ");
    
    if ($confTotCnt == $rowTot) {
    	$rc = 0;
    }
    else {
    	print " +++++ Total count from confirmation panel and Total Rows are mismatch ++++++";
    	print "confirmation total $confTotCnt not equal to $rowTot\n";
    	$rc = -1;
    }
 return $rc;   
}
sub getTotalListCount {	
#------------------------------------------------------------------------------------
#
#  getTotalListCount subroutine is getting the confirmation List Total for 
#  JOB, PGM, EXEC, PROC, SYSOUT etc (see D0DPXRF0 panel) 
#  Parameters -                                                                 
#      Session Object                                                           
#      String "The number of" 
#      Max Length                                                                         
#  Returns -                                                                    
#      Success = value other than -1                                                               
#      Failure = -1                                                              
#                                                                               
#  Author: cjm             
#------------------------------------------------------------------------------------------
	
	my $session  		= shift;
	my $rowCountLine  	= shift;
	my $confTotCnt;
	 
				
    #  Get the member count from Row 00001 of  on the right corner of the PDS
	$rowCountLine = MAP::copyTextFromScreen($session,$rowCountLine,60);
	if  ($rowCountLine =~ m/Number of.+\s(\d+)/)  {
		$confTotCnt = $1;
		}
	else {
		$confTotCnt = -1;
	}
	return $confTotCnt;
}	

sub getRowTotal {

#------------------------------------------------------------------------------------
#
#  getRowTotal the Total number of Rows from the LIST panel for JOB, PGM, EXEC, PROC,
#  SYSOUT etc..... 
#  Parameters -                                                                 
#      Session Object                                                           
#      String "Row " (Row xxxx to yyyy to zzzz on right corner of panel)
#                                                                          
#  Returns -                                                                    
#      Success = value other than -1                                                               
#      Failure = -1                                                              
#                                                                               
#  Author: cjm            
#------------------------------------------------------------------------------------------		
	
    my $session   = shift;
	my $mystrg    = shift;
	my $ofrow;
	 
				
    #  Get the member count from Row 00001 of  on the right corner of the PDS
	$mystrg = MAP::copyTextFromScreen($session,$mystrg,60);
	
	if  ($mystrg =~ m/Row.*\s(\d.*)\s\sCommand/)  {
		$ofrow = $1;
		#substitute the ',' to a null //
        $ofrow =~ s/,//;
				}
	 else {
		print "+++ No Match found for $mystrg! +++\n";
		$ofrow=-1;
		 }	
	 
  return $ofrow; 
} 	
sub deleteInfoxRTS {
	my $session    = shift;
	my $rts        = shift;
	my $stcID      = shift;
#	my $back2panel = shift;
	my $status;
	my $configRef = Cfg::getcfg();
	my $product   = $configRef->{'AUT'};
	
	       #  deleteRTS ($session, $rts, $stcID );
		   #  delete users RTS member
	MAP::navigate2Panel( $session, "Command" );
    MAP::write2CommandLine( $session, "D0sedias $stcID", '[enter]' );

    MAP::navigate2Panel( $session, "ASG-INFO/X", "D0DPMAI0") ;
    MAP::navigate2Panel( $session, "Administration", "D0SPDIA1") ;
    MAP::navigate2Panel( $session, "INFO/X RTS Members", "D0SPDIA8") ;
    
    
    $status = MAP::findStringOnPanel( $session, "$rts", 0,1 );
    if ( $status == 0 ) { 
	    MAP::panelListAction($session, $rts, "d" );
	    # confirm the pop up confirmation panel for the delete
	    MAP::pressKey( $session, '[enter]') ;
    } 
    MAP::navigateBack2Panel( $session, 'D0DPMAI0' );
    return 0;
}

1;
