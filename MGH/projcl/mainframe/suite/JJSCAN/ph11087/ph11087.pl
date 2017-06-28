###############################################################################
#
# TEST SCRIPT:
#		PH11087
#
# DESCRIPTION: Need to add a call to termsession to JJSCAN.cmd.
#
# SPR: H11087
# 
# Last Update: 10/12/04 DSG - Re-recorded the checktext files since WR had trouble
#     finding them.
#
###############################################################################
use PROJCL::PanelsMap;
use PROJCL::ProJcl;
use Tie::IxHash;
use MAP;

my $configRef = Cfg::getcfg();
my $stcID = $configRef->{'STCID'};
my $sessionID = $configRef->{'SessionID'};

# Make connection to PComm session

my $status = 0;
my $userID = $configRef->{'UserID'};

package MAP;
init;
$session = startSession($sessionID);
ProJcl::dataReset($session, "QARTS", $stcID, $configRef->{'StartedTask'});
ln __LINE__; $status = navigate2Panel( $session, "Command" )if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "D0sedias $stcID", '[enter]' ) if ( not $status );
 
ln __LINE__; $status = execPanelCmd( $session, "System Info", "D0SPSTCX") if ( not $status );
# go to the active Users session
ln __LINE__; $status = execPanelCmd( $session, "Users", "D0SPSTC2") if ( not $status );
# for our test you should see only your testing
ln __LINE__;findStringOnPanel( $session, $userID ) ;
# move cursor to the top of the screen
ln __LINE__; $status = pressKeyRepeat( $session, '[UP]',9 )  if ( not $status );
# split screen
ln __LINE__; $status = pressKey ( $session, '[f2]' )  if ( not $status ); 
# Turn on the panelid
ln __LINE__; $status = write2CommandLine( $session, "PANELID", '[enter]',"Option ===>" )  if ( not $status );
# go to the edit panel
ln __LINE__; $status = execPanelCmd( $session, "Edit","ISREDM01" )if ( not $status ); 
ln __LINE__; $status = write2PanelField( $session, "Name . . . . .","'QAL.MGH.PGR.TESTBCKT(JOBCARD)'", '[enter]' );
# execute JJSCAN edit macro
ln __LINE__; $status = write2CommandLine( $session, "JJSCAN ID=$stcID", '[enter]',"Command ===>" )  if ( not $status );
# toggle back to the Users session screen and press enter
ln __LINE__; $status = pressKey ( $session, '[f9]', '[enter]' )  if ( not $status );
# You should see 2 sessions 
ln __LINE__; findStringOnPanel( $session, $userID );
# Toggle back to the edit session
ln __LINE__; $status = pressKey ( $session, '[f9]' )  if ( not $status );
# exit the the scan and stay in the edit mode
ln __LINE__; $status = pressKey ( $session, '[f3]' )  if ( not $status );
# toggle back to the Users session screen and press Enter
ln __LINE__; $status = pressKey ( $session, '[f9]','[enter]' )  if ( not $status );
# You should see only one user session 
ln __LINE__; $status = pressKeys( $session, "=x", "[enter]" ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat ( $session, '[f3]',2 )  if ( not $status );
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
	
end ($status); 1;
