###############################################################################
#
# TEST SCRIPT:
#		PC26009
#
# DESCRIPTION: JJSCAN produces ISRB107       Empty data set or member 	   
# DESCRIPTION:  Empty PDS member or sequential data set has been requested.
#
# SPR: C26009
#
# 03/18/2009 CJM Map Conversion
###############################################################################
use PROJCL::PanelsMap;
use PROJCL::ProJcl;
use Tie::IxHash;
use MAP;

my $configRef = Cfg::getcfg();
my $stcID = $configRef->{'STCID'};
my $sessionID = $configRef->{'SessionID'};
my $userid = $configRef->{'UserID'};

my $status = 0;

package MAP;
init;
$session = startSession($sessionID);
#ProJcl::restorePCfile($session, $configRef->{'StartedTask'});
ProJcl::dataReset($session, "QARTS", $stcID, $configRef->{'StartedTask'});
ln __LINE__; $status = navigate2Panel( $session, "Command" )if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "D0sedias $stcID", '[enter]' ) if ( not $status );

ln __LINE__; $status = navigate2Panel( $session, "ASG-PRO/JCL", "D0JPMAI0") if ( not $status );

ln __LINE__; $status = navigate2Panel( $session, "Validation", "D0JPJVAL") if ( not $status );

# navigate to the Setting pull down menu and choose RTS Member Option
ln __LINE__; $status = navigate2DropDownList ($session, "Settings", "RTS Member" ) if ( not $status );
# Select JCL Listing Report Option 4
ln __LINE__; $status = navigate2Panel ($session, "JCL Listing Report","D0SPRUN0") if ( not $status );
# Select Error Summary
ln __LINE__; $status = panelListAction($session, "Error Summary", "s") if ( not $status );
# Select BYJOBFIRST 
ln __LINE__; $status = write2PanelField( $session, "RTS  . . . ", "BYJOBFIRST", '[ENTER]' ) if not $status;
# Return to the Validation Panel
ln __LINE__; $status = navigateBack2Panel( $session, 'D0JPJVAL ' ) if ( not $status );

# fill up the validation panel form  
my $validationForm = tie(
	%form, Tie::IxHash,
	'RTS Member . .'      => 'QARTS',
	'Input Library  . .'  => "'QAL.MGH.PGR.TESTBCKT'",
	'Member  . . . . .'   => 'PC26009',
	'Show Directory'      => ' ',
	'Exclude Member '     => ' ',
	'Show Directory'      => ' ',
	'Type  . . . . . .'   => 'PDS',
	'Listname . . . . .'  => ' ',
	'Processing Mode'     => 'JOB',
	'First PROCLIB  . .'  => ' ',
	'Lib type  . . . .'   => 'PDS',
	'JMP Library. . . .'  => ' ',
	'JMP Name . . . . .'  => ' ',
	'Parm . . '           => ' ',
	'Reformat'            => 'OFF',
	'Overwrite Input Lib' => 'N',
	'Reformat Member. .'  => 'DEFAULT',
	'SJL Hardcopy . . .'  => 'N',
	'Keep SJL Data Set'   => 'N',
	'Save Error Summary'  => 'N',
	'using ID'            => ' ',
);

# Write the form on the panel
ln __LINE__; $status = write2Panel( $session, $validationForm  ) if ( not $status );
#Select "E" for EDIT  and press enter
ln __LINE__; $status = write2CommandLine( $session, "E", '[enter]' ) if ( not $status );
# Execute a JJSCAN
ln __LINE__; $status = write2CommandLine( $session, "JJSCAN ID=$stcID", '[enter]' )  if ( not $status );
ln __LINE__; my $filename = copyTextFromScreen($session,"$userid.SJL.SCAN.TEMP",22);
print "filename=$filename\n";
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
# Verify that the dataset were deleted.
ln __LINE__; $status = write2CommandLine( $session, "TSO listds '$userid.error.summary.first'", '[enter]' )  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "'$userid.ERROR.SUMMARY.FIRST' NOT IN CATALOG"  )  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
$filename = Util::trim($filename);
ln __LINE__; $status = write2CommandLine( $session, "TSO listds " . "'" . $filename . "'",  '[enter]' )  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "'$filename' NOT IN CATALOG"  )  if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[F3]',2) if (not $status);
# navigate to the Setting pull down menu and choose RTS Member Option
ln __LINE__; $status = navigate2DropDownList ($session, "Settings", "RTS Member" ) if ( not $status );
# Select JCL Listing Report Option 4
ln __LINE__; $status = navigate2Panel ($session, "JCL Listing Report","D0SPRUN0") if ( not $status );
# Select Error Summary
ln __LINE__; $status = panelListAction($session, "Error Summary", "s") if ( not $status );
# Reset
ln __LINE__; $status = write2PanelField( $session, "RTS  . . . ", "            ", '[ENTER]' ) if not $status;
# Return to the Validation Panel
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;