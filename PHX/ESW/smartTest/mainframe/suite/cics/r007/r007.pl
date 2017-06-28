###############################################################################
#
# TEST SCRIPT: QA-TCD-ST-7.7.1-R007.doc  
#		
# Script  
# DESCRIPTION: Test COBOL-CICS IVP VIACCOB .
# DATE: 11/28/2012
# SKB 
#################################################################################
use Hllapi;
use PROJCL::ProJcl;
use Tie::IxHash;
use MAP;
use ESW::Eswtool;
   

my $configRef 		  = Cfg::getcfg();
my $sessionID  		  = $configRef->{'SessionID'};
my $userID            = $configRef->{'UserID'};
my $execclist         = $configRef->{'Exec'};
my $cntlLib 	      = $configRef->{'CntlLib'};
my $ispprof           = $configRef->{'Ispprof'};
my $akrcob            = $configRef->{'AKRCOB'}; 
my $akrasm            = $configRef->{'AKRASM'}; 
my $akrpli            = $configRef->{'AKRPLI'};         
my $loadcob           = $configRef->{'LOADCOB'};                
my $loadasm           = $configRef->{'LOADASM'};              
my $loadpli           = $configRef->{'LOADPLI'};
my $cicsapplid        = $configRef->{'CICSApplid'}; 
my $ENV               = $configRef->{'ENV'}; 
my $status = 0;
my $no_scroll = 1;

package MAP;
ln __LINE__; init;

ln __LINE__; $session = startSession($sessionID);

# set the CICS sleep time. If CICS is running slow you should increase this value.

$delay = 10;
ln __LINE__; $status = Eswtool::initProfile($session);

ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);
#ln __LINE__; $status = write2CommandLine( $session, "tso ex 'QAL.PHX.ESW790AU.SCNXCLST(VIASPROC)' 'ADD(QAL.PHX.ESW790AU.SESWCLST)'", '[enter]' )if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "center", '[enter]' ) if ( not $status );
#ln __LINE__; $status = verifyPanelMask( $session, "Welcome-Screen.txt" );
ln __LINE__; $status = write2CommandLine( $session, "st", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "an", '[enter]' ) if ( not $status );

# Fill out the Prepare Program Popup 

$form = tie(
	%form, Tie::IxHash,
	'Data set name'        => "'qal.phx.eswauto.jcl2(viaccmpl)'",
	'Understand:'          => 'y',
	'Test:'                => 'y',
	'Extended Analysis:'   => 'y',
#	'Document:'            => 'y',
	'AKR data set name'    =>  "'$akrcob'",
	'Compile? (Y/N) . .'   =>  'y',
	'Link load module'     =>  'y',
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
# The dataset name remains populated from the allocate.   
ln __LINE__; $status = write2CommandLine( $session, "akr", '[enter]' ) if ( not $status );

# Fill out the AKR Utility Panel
my $form = tie(
	%form, Tie::IxHash,
	'Data set name . .'    => "'$akrcob'",
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
#ln __LINE__; $status = verifyPopupMask ( $session, "AKR-Directory-Popup.txt" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]')  if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "an", '[enter]' ) if ( not $status );
#ln __LINE__; $status = verifyPopup ( $session, "Prepare-Progam-Popup.txt" ) if ( not $status );


# Fill out the Prepare Program Panel 

$form = tie(
	%form, Tie::IxHash,
	'Data set name'        => "'qal.phx.eswauto.jcl2(VIACJASM)'",
	'Understand:'          => 'y',
	'Test:'                => 'y',
	'Extended Analysis:'   => 'y',
#	'Document:'            => 'n',
#	'Re-engineer:'         => 'n',
	'AKR data set name'    =>  "'$akrasm'",
	'Compile? (Y/N) . .'   =>  'y',
	'Link load module'     =>  'y',
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "akr", '[enter]' ) if ( not $status );

# Fill out the AKR Utility Panel
$form = tie(
	%form, Tie::IxHash,
	'Data set name . .'    => "'$akrasm'",
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
#ln __LINE__; $status = verifyPopup ( $session, "AKR-Directory-List.txt" ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "env", '[enter]' ) if ( not $status );
#ln __LINE__; $status = verifyPopupMask ( $session, "Environment-Selection.txt" ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "l", '[enter]' ) if ( not $status );
# find first input field
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Knowledge Repositories (AKR):')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$akrcob'")  if ( not $status );

# find second input field
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Load Libraries:')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$loadcob' ")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$loadasm'        ")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
# step 21 
ln __LINE__; $status = write2CommandLine( $session, "s1", '[enter]' ) if ( not $status );
# step 22

# if CICS is down issue sdsf cmd /s T42PHXQ1
# Fill out the AKR Utility Panel
$form = tie(
	%form, Tie::IxHash,
	'CICS Logon Region APPLID'    => "$cicsapplid",
	'Toggle PFKEY  . .'           => "PF12",
	'Break at Start (Y/N)  .'     => "Y",
	
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c", '[enter]' ) if ( not $status );
sleep(1);
ln __LINE__; $status = findStringOnPanel( $session, "$ENV")  if ( not $status );

# step 23
ln __LINE__; $status = pressKey( $session, '[clear]')  if ( not $status );
# step 24
ln __LINE__; $status = pressKey( $session, '[f12]')  if ( not $status );
sleep(5);
ln __LINE__; $status = findStringOnPanel( $session, 'ASG-SmartTest-CICS is active.')  if ( not $status );

# step 25
ln __LINE__; $status = pressKey( $session, '[clear]')  if ( not $status );
# step 27
ln __LINE__; $status = pressKey( $session, '[f12]')  if ( not $status );
# step 27
ln __LINE__; $status = write2CommandLine( $session, "NEWCOPY VIACCOB", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'NEWCOPY SUCCESSFUL')  if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "NEWCOPY VIACCOB2", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'NEWCOPY SUCCESSFUL')  if ( not $status );
# step 28
ln __LINE__; $status = write2CommandLine( $session, "NEWCOPY VIACASM", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'NEWCOPY SUCCESSFUL')  if ( not $status );
# step 29 Toggles back to CICS blank screen
ln __LINE__; $status = write2CommandLine( $session, "t", '[enter]' ) if ( not $status );

# step 30 
ln __LINE__; $status = write2CommandLine( $session, "vcob", '[enter]', " ") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'PROCEDURE DIVISION')  if ( not $status );
# step 31
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULT", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'TEST OPTIONS DEFAULTED')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'BREAK AT START OF TEST SESSION')  if ( not $status );

# step 32 
ln __LINE__; $status = write2CommandLine( $session, "SET TRACK 2000", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'TRACK SIZE SET')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'BREAK AT START OF TEST SESSION')  if ( not $status );

# step 33 
ln __LINE__; $status = write2CommandLine( $session, "LIST TAILOR", '[enter]') if ( not $status );
# put the cursor on the Monitor Act input field
ln __LINE__; $status = pressKeyRepeat( $session, '[tab]', '5' )  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'no ')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
# step 34
ln __LINE__; $status = findStringOnPanel( $session, 'VIA*.VIA*             YES    YES   YES   YES   YES   NO    YES    YES')  if ( not $status );
# step 35
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'PROCEDURE DIVISION')  if ( not $status );
# step 36
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMIT", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'Maximum calls')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'Storage protection')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'Intercept abends')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'Instruction count')  if ( not $status );

# step 37
$form = tie(
	%form, Tie::IxHash,
	'Storage protection'      => 'no',
	
);
#step 38
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );	
#step 39
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN", '[enter]') if ( not $status );
sleep($delay);
#step 40
ln __LINE__; $status = write2CommandLine( $session, "1", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'PROCEDURE DIVISION')  if ( not $status );

####### Print compiler used.
ln __LINE__; $status = write2CommandLine( $session, "li comp", '[enter]' ) if ( not $status );
my $row = "Compiler  : ";
my $rowline = copyTextFromScreen($session,$row,35,0);
Util::printStatus( 0, "$rowline" );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
#########

#step 41
ln __LINE__; Eswtool::pressKeyF4( $session, 20)  if ( not $status );
# Sorry but I have to sleep here because CICS doesn't block the session.
# If this step fails it may be due to the cics seesions is slow. Try increasing the sleep


#step 42
ln __LINE__; $status = findStringOnPanel( $session, 'DATA EXCEPTION (0C7)')  if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "1", '[enter]', "VALUE >") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'SUCCESSFUL MEMORY UPDATE')  if ( not $status );

#step 43
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, 'SET ADDRESS OF BLL1-DATA TO NULL.')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED AFTER BREAK')  if ( not $status );

#step 44 
ln __LINE__; $status = write2CommandLine( $session, "GO TO S0C4FIX", '[enter]') if ( not $status );
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, 'PERFORM STEP-VALUE-SUBROUTINE.')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED AFTER BREAK')  if ( not $status );

#step 45 - Open KEEP window
ln __LINE__; $status = write2CommandLine( $session, "KEEP STEP-VALUE", '[enter]') if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, 'PERFORM STEP-VALUE-SUBROUTINE.')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED AFTER BREAK')  if ( not $status );

#step 46 - To watch next 4 verbs execute
ln __LINE__; $status = write2CommandLine( $session, "STEP 4 AUTO", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2163I STEP 4 OF 4 EXECUTED.')  if ( not $status );
#step 47 - After the 4 verbs have executed,
ln __LINE__; $status = findStringOnPanel( $session, 'PERFORM STEP-VALUE-SUBROUTINE')  if ( not $status );
#step 48 - To execute the subroutine 5 times but without actually stepping through it. 
ln __LINE__; $status = write2CommandLine( $session, "STEP OVER ", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'VALUE > +5')  if ( not $status );

#step 49 - To close the KEEP window
ln __LINE__; $status = write2CommandLine( $session, "STEP OVER", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +0 TO STEP-VALUE.')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED BY STEP REQUEST')  if ( not $status );

#step 50  - To enable the display of the value of the data items on each verb as you step through them 
ln __LINE__; $status = write2CommandLine( $session, "SET OPERANDS ON", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'OPERANDS ON')  if ( not $status );
#step 51 - To step through the next 5 verbs and automatically display the values
ln __LINE__; $status = write2CommandLine( $session, "STEP 5 AUTO", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2163I STEP 5 OF 5 EXECUTED.')  if ( not $status );

#step 52- To change the step interval between steps to 3 seconds
ln __LINE__; $status = write2CommandLine( $session, "SET DELAY 3", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'DELAY TIME SET')  if ( not $status );

#step 53- To step through the next 5 verbs with a 3 second delay between steps
my $startTestTime = time();
ln __LINE__; $status = write2CommandLine( $session, "STEP 5 AUTO", '[enter]') if ( not $status );
my $endTestTime = time();
my $diff = $endTestTime - $startTestTime;
if ($diff < 10) {
	$status = -1;
	print "+++ Delay time set to 15 seconds. Actual delay was $diff seconds.+++\n";
}else {
	print "*** Delay time set to 15 seconds. Actual delay was $diff seconds.***\n";
}
# This is the final panel displayed after all five verbs have executed.  
ln __LINE__; $status = findStringOnPanel( $session, 'ADD +1 TO STEP-VALUE')  if ( not $status );
#step 54-55 To ‘RUN’ to a specific line number
ln __LINE__; $status = write2CommandLine( $session, "RUN TO") if ( not $status );
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'SUBTRACT +1 FROM STEP-VALUE')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-VALUE=+11')  if ( not $status );
#step 56 - To execute the next set of instructions
ln __LINE__; $status = write2CommandLine( $session, "run", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-SUB=+12')  if ( not $status );
#step 57 - To execute the next 7 statements
ln __LINE__; $status = write2CommandLine( $session, "STEP PARA", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-VALUE=+6')  if ( not $status );
#step 58 - To execute the next 3 paragraphs, redisplaying the source code at the first statement of each paragraph
ln __LINE__; $status = write2CommandLine( $session, "STEP 3 PARA AUTO", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-VALUE=+3')  if ( not $status );
#step 59 - Demonstration of STOP
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULTS;RUN", "[enter]") if ( not $status );
sleep($delay); # due to the display message
ln __LINE__; $status = findStringOnPanel( $session, 'PERFORM STOP-BUILD-PAYEE-TABLE')  if ( not $status );
#step 60- Note: This portion of the DEMONSTRATION will simulate an intermittent storage corruption error especially hard to track down without SMARTTEST, 
# an intermittent storage corruption
ln __LINE__; $status = write2CommandLine( $session, "STOP STOP-PAY-TOTAL", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2324I ADDRESS STOP AT')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'FOR A LENGTH OF 11 HAS BEEN ASSIGNED')  if ( not $status );
#step 61
ln __LINE__; $status = write2CommandLine( $session, "LIST ADSTOP", "[enter]") if ( not $status );
ln __LINE__; $status = verifyPanelMask ( $session, "Address-Stop-Entry.txt", $no_scroll) if ( not $status );
#step 62
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'PERFORM STOP-BUILD-PAYEE-TABLE')  if ( not $status );
#step 63
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ADD STOP-PAY-AMOUNT (STOP-PAYEE)')  if ( not $status );
#step 64 - The next couple of ‘RUN’ commands will stop this same modification of STOP-PAY-TOTAL.  
# It may appear stuck but if you LIST TRACK, you will see that verbs are actually being executed.
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status );
#step 65
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status );
#step 66
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACK", "[enter]") if ( not $status );
ln __LINE__; $status = verifyPanelMask ( $session, "Execution-Tracking.txt", $no_scroll) if ( not $status );
#step 67
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ADD STOP-PAY-AMOUNT (STOP-PAYEE)')  if ( not $status );
#step 68
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE 0 TO STOP-10-NUMBERS (STOP-PAYEE).')  if ( not $status );
#step 69 - The display of  Demonstration of Backtrack flashes
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +0 TO RETURN-CODE')  if ( not $status );
#step 70 - 
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK 500K", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'BACKTRACK SIZE=500K')  if ( not $status );
#step 71 - To enable the collection of data
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK ON", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'BACKTRACK ON')  if ( not $status );
#step 72
ln __LINE__; $status = write2CommandLine( $session, "RUN", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED AFTER BREAK')  if ( not $status );
#step 73
ln __LINE__; $status = write2CommandLine( $session, "RUN BACKWARD TO BACK-FLAG MOD", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'REVIEWING BACKTRACK HISTORY')  if ( not $status );
#step 74
ln __LINE__; $status = write2CommandLine( $session, "KEEP BACK-FLAG", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, '10 BACK-FLAG                       PIC X ')  if ( not $status );
#step 75 - This command causes ISPF abend 2435 when leaving the product
ln __LINE__; $status = write2CommandLine( $session, "STEP FORWARD", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'DIRECTION: FWD')  if ( not $status );
#step 76
ln __LINE__; $status = write2CommandLine( $session, "STEP BACK 4 AUTO", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STEP 4 OF 4 EXECUTED')  if ( not $status );
#step 77
ln __LINE__; $status = write2CommandLine( $session, "RUN TO BACK-FLAG MOD", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'Y' TO BACK-REDEFINED-FLAG")  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'REVIEWING BACKTRACK HISTORY')  if ( not $status );
#step 78 - The BACK-FLAG keep window disappears
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'Y' TO BACK-REDEFINED-FLAG.")  if ( not $status );
#step 79 - Demonstration of NOSOURCE
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK OFF;RUN", "[enter]") if ( not $status );
sleep($delay);
ln __LINE__; $status = findStringOnPanel( $session, "CALL 'VIACBR14'")  if ( not $status );
#step 80 - To enable the display of the disassembled object code for any non-analyzed
ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW ON", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASMVIEW ON")  if ( not $status );
#step 81 - To enable the display of the disassembled object code for any non-analyzed
ln __LINE__; $status = write2CommandLine( $session, "RUN", "[enter]") if ( not $status );
sleep($delay);
ln __LINE__; $status = findStringOnPanel( $session, "VIACCOB.VIACBR14")  if ( not $status );
#step 82 - 
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "GO TO MAIN-ROUTINE-CHECK-ALL")  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 2 OF 2 EXECUTED")  if ( not $status );
#step 83
ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW OFF", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASMVIEW OFF")  if ( not $status );
#step 84 - Demonstration of LOOP
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "GO TO MAIN-ROUTINE-CHECK-ALL")  if ( not $status );
#step 85 
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "GO TO MAIN-ROUTINE-CHECK-ALL.")  if ( not $status );
#step 86
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "GO TO MAIN-ROUTINE-CHECK-ALL.")  if ( not $status );
#step 87 - SORTED ASCENDING 
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS ASCENDING", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "SORTED ASCENDING")  if ( not $status );
#step 88 - 
ln __LINE__; $status = write2CommandLine( $session, "M", "[enter]") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[f8]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STMTS SORTED BY ASCENDING COUNT    ")  if ( not $status );
#step 89 -  Display the most frequently executed paragraphs (hotspots).
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING PARA", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "PARAS SORTED BY DESCENDING COUNT")  if ( not $status );
#step 90 
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS LINE", "[enter]") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "PARAS SORTED BY LINE NUMBER")  if ( not $status );
#step 91 
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "GO TO MAIN-ROUTINE-CHECK-ALL")  if ( not $status );
#step 92
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status ); 
ln _LINE__; $status = verifyCICS ( $session, "COBOL-Demo-PGM.txt", $no_scroll) if ( not $status );
#step 93
ln __LINE__; $status = write2CommandLine( $session, "9", '[enter]', "==>") if ( not $status );
#step 94
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status );
sleep(3);
ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'VIACCOB2' TO PGMID")  if ( not $status );
#step 95
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status );
sleep(3);
ln __LINE__; $status = findStringOnPanel( $session, "012900 PROCEDURE DIVISION")  if ( not $status );
#step 96
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN", '[enter]') if ( not $status );
sleep($delay);
ln __LINE__; $status = findStringOnPanel( $session, "018700     MOVE +49 TO MAX-COUNTER")  if ( not $status );
#step 97
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Storage protection NO")  if ( not $status );
#step 98 - 
$form = tie(
	%form, Tie::IxHash,
	'Storage protection'      => 'yes',
	
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );	
ln __LINE__; $status = findStringOnPanel( $session, "MOVE +49 TO MAX-COUNTER")  if ( not $status );
#step 99 
ln __LINE__; $status = write2CommandLine( $session, "run", '[enter]') if ( not $status );
sleep($delay);
ln __LINE__; $status = findStringOnPanel( $session, "MOVE BLL1-BYTE (COUNTER) TO BLL1-BYTE")  if ( not $status );
#step 100
ln __LINE__; $status = write2CommandLine( $session, "GO TO SVFIX;RUN", '[enter]') if ( not $status );
sleep($delay); 
ln __LINE__; $status = verifyCICS ( $session, "COBOL-Demo-Pgm.txt", $no_scroll) if ( not $status );
#step 101 - Invalid Freemain
ln __LINE__; $status = write2CommandLine( $session, "10", '[enter]', "==>") if ( not $status );
#step 102
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'VIACCOB2' TO PGMID")  if ( not $status );
#step 103
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "PROCEDURE DIVISION")  if ( not $status );
#step 104
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );
	
ln __LINE__; $status = findStringOnPanel( $session, "CICS GETMAIN SET(ADDRESS OF BLL1-DATA)")  if ( not $status );
#step 105
ln __LINE__; $status = putCursorOnPanelSrting( $session, "     IF MONITORING = 'YES'", '[enter]') if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[back_tab]', '2')  if ( not $status );
ln __LINE__; $status = pressKey( $session, 'i')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
#step 106 - Insert a line BEFORE ‘IF MONITORING = YES'
ln __LINE__; $status = pressKeys( $session, "      MOVE 'YES' TO MONITORING.")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );	
#step 107
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "INVALID FREEMAIN")  if ( not $status );
#step 108
ln __LINE__; $status = write2CommandLine( $session, "GO FMEXIT;RUN", '[enter]', "==>") if ( not $status );
#step 109
ln __LINE__; $status = write2CommandLine( $session, "11", '[enter]', "==>") if ( not $status );
sleep($delay);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: BREAK AT START OF TEST SESSION")  if ( not $status);
#step 110
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "STATUS: STOPPED AFTER BREAK")  if ( not $status);
#step 111
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "STATUS: BREAK ON ENTRY TO A PROGRAM       PROGRAM: VIACCOB2")  if ( not $status);
#step 112
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "    MOVE +1001 TO MAX-COUNTER")  if ( not $status);
#step 113 -  Maximum call count s/b 0 but it's displaying as 5000. Data reset is needed to reset back to 0
# after the test has completed. 
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Maximum calls  . . ")  if ( not $status);
#step 114
$form = tie(
	%form, Tie::IxHash,
	'Maximum calls'      => '1000',
	
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
#step 115
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );	
ln __LINE__; $status = findStringOnPanel( $session, "EXEC CICS ASKTIME END-EXEC")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "POSSIBLE CICS CALL LOOP")  if ( not $status);  
#step 116
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]') if ( not $status );
#step 117
$form = tie(
	%form, Tie::IxHash,
	'Maximum calls'      => '5000',
	
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );

ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "EXEC CICS ASKTIME END-EXEC")  if ( not $status);
#step 118 
ln __LINE__; $status = write2CommandLine( $session, "run", '[enter]') if ( not $status );
#step 119
ln __LINE__; $status = write2CommandLine( $session, "12", '[enter]', "==>") if ( not $status );
sleep($delay);	
#step 120
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'VIACCOB2' TO PGMID.")  if ( not $status);
#step 121
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "STATUS: BREAK ON ENTRY TO A PROGRAM       PROGRAM: VIACCOB2")  if ( not $status);
#step 122
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 031100     MOVE +50   TO MAX-COUNTER")  if ( not $status);
#step 123
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]') if ( not $status );
#step 124
$form = tie(
	%form, Tie::IxHash,
	'Max GETMAIN size'      => '4095',
	
);

ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
#step 125
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "EXEC CICS GETMAIN SET(ADDRESS OF BLL2-DATA)")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: GETMAIN MAX-ENTER \"LIST LIMITS\"   PROGRAM: VIACCOB2")  if ( not $status);
#step 126
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]') if ( not $status );
#step 127
$form = tie(
	%form, Tie::IxHash,
	'Max GETMAIN size'      => '65520',
	
);
ln __LINE__; $status = write2Panel($session, $form  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "034200     EXEC CICS GETMAIN SET(ADDRESS OF BLL2-DATA)")  if ( not $status);
#step 128
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status );

#step 129
ln __LINE__; $status = write2CommandLine( $session, "13", '[enter]', "==>") if ( not $status );	
sleep($delay);
ln __LINE__; $status = findStringOnPanel( $session, "PROCEDURE DIVISION")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: BREAK AT START OF TEST SESSION    PROGRAM: VIACCOB")  if ( not $status);
#step 130
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'VIACCOB2' TO PGMID")  if ( not $status);
#step 131
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 012900 PROCEDURE DIVISION")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: BREAK ON ENTRY TO A PROGRAM       PROGRAM: VIACCOB2")  if ( not $status);
#step 132
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "   MOVE +0      TO MAX-COUNTER")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: STOPPED AFTER BREAK")  if ( not $status);
#step 133
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "     EXEC CICS READ DATASET('VIACXXXX')")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "ASG2850I EXECUTION MAY NOT BE CONTINUED FOR THIS \"ABENDED\" TRANSACTION")  if ( not $status);
#step 134
ln __LINE__; $status = write2CommandLine( $session, "CANCEL;RUN VCOB", '[enter]') if ( not $status );
sleep($delay);
ln __LINE__; $status = findStringOnPanel( $session, "PROCEDURE DIVISION")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: BREAK AT START OF TEST SESSION    PROGRAM: VIACCOB")  if ( not $status);
#step 135
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

#step 136
ln __LINE__; $status = write2CommandLine( $session, "14", '[enter]', "==>") if ( not $status );	
sleep($delay);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PROCEDURE DIVISION")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: BREAK AT START OF TEST SESSION    PROGRAM: VIACCOB")  if ( not $status);
#step 137
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>      MOVE 'VIACCOB2' TO PGMID")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: STOPPED AFTER BREAK               PROGRAM: VIACCOB")  if ( not $status);
#step 138
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, " PROCEDURE DIVISION")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, "BREAK ON ENTRY TO A PROGRAM")  if ( not $status);
#step 139 
ln __LINE__; $status = write2CommandLine( $session, "LI TAIL", '[enter]') if ( not $status );
#step 140
ln __LINE__; $status = findStringOnPanel( $session, 'VIA*.VIA*             YES    YES   YES   YES   YES   NO    YES    YES')  if ( not $status );
#step 140
ln __LINE__; $status = putCursorOnPanelSrting( $session, "''''", '[enter]') if ( not $status );
ln __LINE__; $status = pressKey( $session, 'i')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );

#step 141
ln __LINE__; $status = pressKey( $session, '[eof]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'VIACASM.VIACASM')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );

ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'no ')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
#step 142
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "BREAK ON ENTRY TO A PROGRAM")  if ( not $status);
#step 143
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'LINK'   TO ASMEIB.")  if ( not $status);
  
#step 144  - The COBOL program links to the assembler program, VIACASM.
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "VIACASM.VIACASM")  if ( not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACASM  DFHEIENT CODEREG=(12,8)")  if ( not $status);

#step 145 
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = verifyCICS ( $session, "Assembler-Demonstration-Program.txt") if ( not $status );
#step 146
ln __LINE__; $status = write2CommandLine( $session, "X", '[enter]', '==>') if ( not $status );
#step 147 
ln __LINE__; $status = write2CommandLine( $session, "15", '[enter]', '==>') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PROCEDURE DIVISION")  if ( not $status);
#step 148
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'VIACCOB2' TO PGMID")  if ( not $status);
sleep($delay) ;
#step 149
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, " PROCEDURE DIVISION")  if ( not $status);
#step 150 
ln __LINE__; $status = pressKey( $session, '[f4]')  if ( not $status );
sleep($delay) ;
ln __LINE__; $status = findStringOnPanel( $session, "  PERFORM STARTASYNC")  if ( not $status);
#step 151
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "** PROGRAM (VIACCOB3) ASYNCHRONOUSLY STARTED **")  if ( not $status);
#step 152 - NOTE:  We are not exercising the asynchronous task – remote test setup.
ln __LINE__; $status = write2CommandLine( $session, "X", '[enter]', '==>') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PROCEDURE DIVISION")  if ( not $status);
#step 153
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = verifyCICS ( $session, "COBOL-Completed.txt", $no_scroll) if ( not $status );
#step 154 - Start Test Over
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: BREAK AT START OF TEST SESSION    PROGRAM: VIACCOB")  if ( not $status);
#step 155
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

#step 156
ln __LINE__; $status = write2CommandLine( $session, "16", '[enter]', '==>') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PROCEDURE DIVISION")  if ( not $status);
#step 157
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "MOVE 'VIACCOB2' TO PGMID.")  if ( not $status);
#step 158
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, " PROCEDURE DIVISION")  if ( not $status);
#step 159
ln __LINE__; Eswtool::pressKeyF4( $session, $delay)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "     MOVE +0      TO MAX-COUNTER")  if ( not $status);
ln __LINE__; $status = write2CommandLine( $session, "CAN", '[enter]', '==>') if ( not $status );
#ln __LINE__; $status = write2CommandLine( $session, "CAN;Q CAN ALL", '[enter]'  ) if ( not $status );
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1; 