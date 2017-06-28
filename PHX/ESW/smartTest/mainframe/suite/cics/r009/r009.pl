
###############################################################################
#
# TEST SCRIPT: QA-TCD-ST-7.7.1-R009.doc  
#		
# Script  
# DESCRIPTION: Test the IVP’s for SmartTest/PLI.
# DATE: 1/03/2013
# CJM 
# Before running the script uncomment line 810 based on CICS release .
#################################################################################
use Hllapi;
use PROJCL::ProJcl;
use Tie::IxHash;
use MAP;
use ESW::Eswtool;
 
my $configRef 		  = Cfg::getcfg();
my $sessionID  		  = $configRef->{'SessionID'};
my $sessionID2  	  = $configRef->{'SessionID2'};
my $userID            = $configRef->{'UserID'};
my $execclist         = $configRef->{'Exec'};
my $cntlLib 	      = $configRef->{'CntlLib'};
my $ispprof           = $configRef->{'Ispprof'};
my $hlq               = $configRef->{'TestDataHLQ'} . '.';
my $akrcob            = $configRef->{'AKRCOB'}; 
my $akrasm            = $configRef->{'AKRASM'}; 
my $akrpli            = $configRef->{'AKRPLI'};         
my $loadcob           = $configRef->{'LOADCOB'};                
my $loadasm           = $configRef->{'LOADASM'};              
my $loadpli           = $configRef->{'LOADPLI'};
my $cicsapplid        = $configRef->{'CICSApplid'}; 
my $status = 0;

package MAP;
ln __LINE__; init;

ln __LINE__; $session = startSession($sessionID);

ln __LINE__; $status = Eswtool::initProfile($session);

my $time = 3;

## Go option 6
ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);

ln __LINE__; $status = write2CommandLine( $session, "CENTER", '[enter]' ) if ( not $status );

#  $Step 4-6 navigate to the Test pull down menu and choose . Module/Transaction 
ln __LINE__; $status = navigate2DropDownList ($session, "Test", "Module/Transaction" ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG-ESW - Testing/Debugging" )if ( not $status );

#  $Step 7-8 navigate to the Test pull down menu and choose . Module/Transaction 

ln __LINE__; $status = navigate2DropDownList ($session, "File", "Compile/Analyze" ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG-ESW - Prepare Program" )if ( not $status ); 

#### Compile and load cobol repositary
$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        => "'qal.phx.eswauto.jcl2(viaccmpl)'",
    'Understand: ' 	   	   => 'Y',
    'Test:'   	           => 'Y',
    'Extended Analysis:'   => 'Y',
    'Document:'            => 'N',
#    'Re-engineer:'         => 'N',
    'AKR data set name'    => "'$akrcob'",
	'Compile? (Y/N) . . . . . . . . .'   => 'Y',
	'Link load module reusable? (Y/N)'   => 'Y',
		   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );

#### Compile and PLI  repositary
$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        => "'qal.phx.eswauto.jcl2(VIACJPLI)'",
    'Understand: ' 	   	   => 'Y',
    'Test:'   	           => 'Y',
    'Extended Analysis:'   => 'Y',
    'Document:'            => 'N',
#    'Re-engineer:'         => 'N',
    'AKR data set name'    => "'$akrpli'",
	'Compile? (Y/N) . . . . . . . . .'   => 'Y',
	'Link load module reusable? (Y/N)'   => 'Y',
		   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

#  $Step 12-13 navigate to the Test pull down menu and choose AKR utility

ln __LINE__; $status = navigate2DropDownList ($session, "File", "AKR utility" ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG-ESW - AKR Utility" )if ( not $status ); 

# Step 14
$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name . .'        => "'$akrpli'",
   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );

# Step 15
ln __LINE__; $status = write2CommandLine( $session, "ENV", '[enter]' ) if ( not $status );
# Step 16 L for Specify Libraries
ln __LINE__; $status = write2CommandLine( $session, "L", '[enter]' ) if ( not $status );


# Step 17 find first input field and Enter Repositories files.
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Knowledge Repositories (AKR):')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$akrpli'                ")  if ( not $status );

# find second input field and enter the load lib
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Load Libraries:')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$loadpli' ")  if ( not $status );

# Step 18
ln __LINE__; $status = pressKey( $session, '[f3]')  if ( not $status );

# Step 19 Select CICS Environment
ln __LINE__; $status = write2CommandLine( $session, "S1", '[enter]' ) if ( not $status );
# Step 20

$form = tie(
	%form, Tie::IxHash,
	'CICS Logon Region APPLID'    => "$cicsapplid",
	'Toggle PFKEY  . .'           => "PF12",
	'Break at Start (Y/N)  .'     => "Y",
	
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );

# step 21
ln __LINE__; $status = pressKey( $session, '[clear]')  if ( not $status );
# step 22
ln __LINE__; $status = pressKey( $session, '[f12]')  if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, 'ASG-SmartTest-CICS is active.')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[clear]')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[f12]')  if ( not $status );
sleep($time);
ln __LINE__; $status = write2CommandLine( $session, "NEWCOPY VIACPLI", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'NEWCOPY SUCCESSFUL')  if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "NEWCOPY VIACCOB", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'NEWCOPY SUCCESSFUL')  if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "NEWCOPY VIACCOB2", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'NEWCOPY SUCCESSFUL')  if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "t", '[enter]' ) if ( not $status );

# step 23
#ln __LINE__; $status = pressKey( $session, '[clear]')  if ( not $status );

# Step 24
ln __LINE__; $status = pressKeys( $session, "VPLI", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]')  if ( not $status );
sleep($time);

ln __LINE__; $status = findStringOnPanel( $session, 'STATUS: BREAK AT START OF TEST SESSION')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'VPPTGVPL')  if ( not $status );

####### Print compiler used.
ln __LINE__; $status = write2CommandLine( $session, "li comp", '[enter]' ) if ( not $status );
my $row = "Compiler  : ";
my $rowline = copyTextFromScreen($session,$row,35,0);
Util::printStatus( 0, "$rowline" );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
#########  

# Step 25
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULT", '[enter]' ) if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, 'TEST OPTIONS DEFAULTED')  if ( not $status );
# Step 26
ln __LINE__; $status = write2CommandLine( $session, "SET TRACK 2000", '[enter]' ) if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, 'TRACK SIZE SET')  if ( not $status );
# Step 27
ln __LINE__; $status = write2CommandLine( $session, "LIST TAILOR", '[enter]' ) if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, 'Test Session Tailoring')  if ( not $status );

  
ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',5) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKeys( $session, "NO NO ") if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
sleep($time);
ln __LINE__; $status = verifyPanel ( $session, "ListTailoring.txt",1 ) if (not $status);

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 30 
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN") if ( not $status );
sleep($time);
ln __LINE__; $status = pressKey( $session, '[enter]') if (not $status);
sleep($time);

# Step 31
ln __LINE__; $status = write2CommandLine( $session, "1", '[enter]', "==>") if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, 'BREAK AT START OF TEST SESSION')  if ( not $status );

# Step 32
ln __LINE__; $status = Eswtool::pressKeyF4( $session, 20) if ( not $status );

                                
ln __LINE__; $status = findStringOnPanel( $session, 'DATA_PACKED_DEC = DATA_PACKED_DEC + 1;')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STATUS: DATA EXCEPTION (0C7)')  if ( not $status );

# Step 33 Enter the ZOOMDATA command to display the current value of a specified dataname.
ln __LINE__; $status = putCursorOnPanelSrting ( $session, ">>>>>>       DATA_PACKED_DEC = DATA_PACKED_DEC + 1;") if ( not $status );
ln __LINE__; $status = pressKeys( $session, "ZD") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
# Step 34
ln __LINE__; $status = pressKeys( $session, "1") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'SUCCESSFUL MEMORY UPDATE')  if ( not $status );

# Step 35 SC04 ASRA demonstration.
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "S0C4_DEMO: PROC;                      /* PAUSE HERE */") if ( not $status );
                                                    
# Step 36 
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2PanelField( $session, "Storage protection ", "NO ",'[enter]' ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
sleep($time);
# Step 39 
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, "SEGMENT TRANSLATION EXCPTN (0C4)" ) if ( not $status );
                                                                        
# Step 40 Demonstrate stepping options
ln __LINE__; $status = write2CommandLine( $session, "GO TO S0C4FIX;RUN", '[enter]'  ) if ( not $status );
sleep(5);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    STEP_DEMO: PROC;                      /* PAUSE HERE */" ) if ( not $status );

# Step 41 Demonstrate stepping options
ln __LINE__; $status = write2CommandLine( $session, "KEEP STEP_VALUE", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "''''''   03 STEP_VALUE                      BIN FIX (31,0)      ADDR" ) if ( not $status );

# Step 42 Demonstrate stepping options
ln __LINE__; $status = write2CommandLine( $session, "STEP 10 AUTO", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 10 OF 10 EXECUTED." ) if ( not $status );

# Step 43 Enter ‘STEP OVER’ to execute the subroutine 5 times, but without actually stepping through it.
ln __LINE__; $status = write2CommandLine( $session, "STEP OVER", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED BY "STEP OVER" REQUEST' ) if ( not $status );

# Step 44 
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]'  ) if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       STEP_VALUE = 0;                    /* PAUSE HERE */" ) if ( not $status );

# Step 45 Close the Keep Window 
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP", '[enter]'  ) if ( not $status );

# Step 46 enable the display of the value of the data items on each verb as you step through them
ln __LINE__; $status = write2CommandLine( $session, "SET OPERANDS ON", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "OPERANDS ON " ) if ( not $status );

# Step 47 To step through the next 5 verbs and automatically display the values.
ln __LINE__; $status = write2CommandLine( $session, "STEP 5 AUTO", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I STEP_VALUE=-4"  ) if ( not $status );

# Step 48 To change the time interval between steps to 2 seconds.
ln __LINE__; $status = write2CommandLine( $session, "SET DELAY 2", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DELAY TIME SET "  ) if ( not $status );

# Step 49 To step through the next nine verbs with a 2 second delay between steps. 
ln __LINE__; $status = write2CommandLine( $session, "STEP 9 AUTO", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       STEP_VALUE = STEP_VALUE + 1; "  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I STEP_VALUE=+0"  ) if ( not $status );

# Step 50 Press PF8 you see the first ‘SUBTRACT 1’ statement
ln __LINE__; $status = write2CommandLine( $session, "F 'STEP_VALUE = STEP_VALUE - 1'",'[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STEP_VALUE = STEP_VALUE - 1; "  ) if ( not $status );

# Step 51 Press PF8 you see the first ‘SUBTRACT 1’ statement
ln __LINE__; $status = write2CommandLine( $session, "RUN TO"  ) if ( not $status );
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'STEP_VALUE = STEP_VALUE - 1;')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STEP_VALUE = STEP_VALUE - 1; "  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]' ) if ( not $status ); 

# Step 52 
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]'  ) if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       STEP_SUB   = 2;                    /* PAUSE HERE */"  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I STEP_SUB=-4 "  ) if ( not $status );

# Step 53 
ln __LINE__; $status = write2CommandLine( $session, "STEP LABEL", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    STEP_PROC_SUBROUTINE: PROC"  ) if ( not $status );

# Step 54 To execute the next 3 procedures redisplaying the source code at the first statement of each procedure.
ln __LINE__; $status = write2CommandLine( $session, "STEP 3 LABEL AUTO", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    STEP_PROC_SUB4: PROC; "  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 3 OF 3 EXECUTED."  ) if ( not $status );

# Step 55 Demonstration of address stop feature
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULTS;RUN", '[enter]'  ) if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       STOP_PAYEE = 1;                    /* PAUSE HERE */"  ) if ( not $status );

# Step 56  
ln __LINE__; $status = write2CommandLine( $session, "STOP STOP_PAY_TOTAL", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2324I ADDRESS STOP AT "  ) if ( not $status );   
ln __LINE__; $status = findStringOnPanel( $session, "FOR A LENGTH OF 12 HAS BEEN ASSIGNED."  ) if ( not $status );   

# Step 57  To see the ADSTOP screen
ln __LINE__; $status = write2CommandLine( $session, "LIST ADSTOP", '[enter]'  ) if ( not $status );
ln __LINE__; $status = verifyPanelMask ( $session, "Address-Stop-Entry.txt", 1) if ( not $status );
#ln __LINE__; $status = verifyPanel ( $session, "Address-Stop-Entry.txt", 1) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 59 RUN. The program will try to modify the field in question, but SmartTest will stop it from happening
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]'  ) if ( not $status ); 
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: STOPPED BEFORE ADDRESS MODIFIED"  ) if ( not $status );   

# Step 60 RUN. The next couple of RUN commands will stop at this same modification of STOP_PAY_TOTAL.
#  It will appear as if it is stuck.
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]'  ) if ( not $status ); 
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: STOPPED BEFORE ADDRESS MODIFIED"  ) if (not $status ); 
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]'  ) if ( not $status ); 
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: STOPPED BEFORE ADDRESS MODIFIED"  ) if (not $status ); 
sleep($time);
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]'  ) if ( not $status ); 
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: STOPPED BEFORE ADDRESS MODIFIED"  ) if ( not $status );   
 
# Step 61 If you enter the LIST TRACK command, you will see that verbs are actually being executed.
ln __LINE__; $status = write2CommandLine( $session, "LI TRACK", '[enter]'  ) if ( not $status ); 
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 63
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       STOP_10_NUMBERS (STOP_PAYEE) = 0;"  ) if ( not $status ); 

# Step 64 To bypass the corruption and continue to BACKTRACK demo
ln __LINE__; $status = write2CommandLine( $session, "GO TO STOPFIX;RUN", '[enter]'  ) if ( not $status ); 
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    BACKTRACK_DEMO: PROC;                 /* PAUSE HERE */"  ) if ( not $status ); 

# Step 65 
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK 500K", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "BACKTRACK SIZE=500K "  ) if ( not $status ); 

# Step 66 
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK ON", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "BACKTRACK ON"  ) if ( not $status ); 

# Step 67
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       RETURN_CODE = 0;                   /* PAUSE HERE */"  ) if ( not $status ); 

# Step 68
ln __LINE__; $status = write2CommandLine( $session, "RUN BACKWARD TO BACK_FLAG MOD", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "BKTR=>          BACK_FLAG = 'N';"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, ": * REVIEWING BACKTRACK HISTORY "  ) if ( not $status );

# Step 69 To see what value BACK_FLAG contained before it was modified
ln __LINE__; $status = write2CommandLine( $session, "KEEP BACK_FLAG", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "''''''   03 BACK_FLAG                       CHAR(1)"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "''''''        VALUE > Y <"  ) if ( not $status ); 

# Step 70 To watch the value of BACK_FLAG change to N
ln __LINE__; $status = write2CommandLine( $session, "STEP FORWARD", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "''''''   03 BACK_FLAG                       CHAR(1)"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "''''''        VALUE > N <"  ) if ( not $status ); 

# Step 71  
ln __LINE__; $status = write2CommandLine( $session, "STEP BACK 4 AUTO", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "''''''   03 BACK_FLAG                       CHAR(1)"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "''''''        VALUE > Y <"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "BKTR=>       IF RETURN_CODE > 4096 THEN"  ) if ( not $status ); 

# Step 72 To set BACKTRACK off and continue to the Disassembled Object Code Support demonstration. 
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK OFF;RUN", '[enter]'  ) if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    NOSOURCE_DEMO: PROC;                  /* PAUSE HERE */"  ) if ( not $status ); 

# Step 73 To remove the KEEP window.
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP", '[enter]'  ) if ( not $status );

# Step 74 To enable the display of the disassembled object code for non-analyzed program. 
# The programs can be written in any language.
ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW ON", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASMVIEW ON"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    NOSOURCE_DEMO: PROC;                  /* PAUSE HERE */"  ) if ( not $status ); 

# Step 75
ln __LINE__; $status = write2CommandLine( $session, "LIST TAILOR", '[enter]' ) if ( not $status );

ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',5) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESNO ") if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanel ( $session, "ListTailoring2.txt",1 ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 78
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
sleep($time);
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, "VIACPLI.VIACBR14"  ) if ( not $status );  
ln __LINE__; $status = findStringOnPanel( $session, "BREAK ON ENTRY TO A PROGRAM"  ) if ( not $status ); 

# Step 79
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    END NOSOURCE_DEMO"  ) if ( not $status );  
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 2 OF 2 EXECUTED."  ) if ( not $status ); 

# Step 80

ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW OFF;RUN", '[enter]' ) if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    LOOP_DEMO: PROC;                      /* PAUSE HERE */"  ) if ( not $status );  

# Step 81
ln __LINE__; $status = write2CommandLine( $session, "LIST TAILOR", '[enter]' ) if ( not $status );

# Step 82 With COUNTS set to YES on the LIST TAILOR screen, verb statistics are captured for
# each source statement.  Counts sorting demonstation
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    LOOP_DEMO: PROC;                      /* PAUSE HERE */"  ) if ( not $status ); 

# Step 83 
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING", '[enter]' ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "SORTED DESCENDING "  ) if ( not $status ); 

# Step 84 
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS ASCENDING", '[enter]' ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "SORTED ASCENDING "  ) if ( not $status ); 

# Step 85 
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING LABEL", '[enter]' ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "LABELS SORTED BY DESCENDING COUNT"  ) if ( not $status ); 

# Step 86 
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS LINE", '[enter]' ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "SORTED BY LINE"  ) if ( not $status ); 
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 88 
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status ); 
sleep(10);

# Step 89
ln __LINE__; $status = write2CommandLine( $session, "9", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI"  ) if ( not $status ); 

# Step 90
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2';           /* PAUSE HERE */"  ) if ( not $status ); 

# Step 91
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, "VIACCOB2.VIACCOB2"  ) if ( not $status ); 

# Step 92 SmartTest-CICS will detect a storage violation when any application program attempts
# to modify of move storage that isn’t exclusively owned by the current task.
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN",'[enter]') if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 018700     MOVE +49 TO MAX-COUNTER"  ) if ( not $status ); 

# Step 93-94
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS",'[enter]') if ( not $status );
ln __LINE__; $status = write2PanelField( $session, "Storage protection ", "YES",'[enter]' ) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "Storage protection YES"  ) if ( not $status ); 
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

# Step 95
ln __LINE__; $status = write2CommandLine( $session, "RUN",'[enter]') if ( not $status );
sleep($time); 
# Step 96
ln __LINE__; $status = write2CommandLine( $session, "GO TO SVFIX;RUN",'[enter]') if ( not $status );

# Step 97
ln __LINE__; $status = write2CommandLine( $session, "10", '[enter]', "==>") if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, "Program View"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI"  ) if ( not $status ); 

# Step 98
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2';           /* PAUSE HERE */"  ) if ( not $status ); 

# Step 99
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 012900 PROCEDURE DIVISION"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "BREAK ON ENTRY TO A PROGRAM"  ) if ( not $status ); 

# Step 100
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 023800     EXEC CICS GETMAIN SET(ADDRESS OF BLL1-DATA)"  ) if ( not $status ); 

# Step 101
ln __LINE__; $status = write2CommandLine( $session, "10") if ( not $status ); 
ln __LINE__; $status = pressKey( $session, '[F8]') if (not $status);

# Step 102
ln __LINE__; $status = putCursorOnPanelSrting( $session, "IF MONITORING = 'YES'")  if ( not $status );
ln __LINE__; $status = pressKeyRepeat ( $session, '[back_tab]',2) if (not $status);
ln __LINE__; $status = pressKeys ( $session, 'I') if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 103
ln __LINE__; $status = pressKeys( $session, "      MOVE 'YES' TO MONITORING") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]')if (not $status);

# Step 104
ln __LINE__; $status = write2CommandLine( $session, "RUN",'[enter]') if ( not $status ); 
sleep (3);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 025900        EXEC CICS FREEMAIN"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "INVALID FREEMAIN"  ) if ( not $status ); 

# Step 105
ln __LINE__; $status = write2CommandLine( $session, "GO FMEXIT;RUN",'[enter]') if ( not $status ); 
sleep($time);

# Step 106 Select Excessive CICCS Calls
ln __LINE__; $status = write2CommandLine( $session, "11", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "BREAK AT START OF TEST SESSION        "  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI"  ) if ( not $status ); 

# Step 107
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2';           /* PAUSE HERE */") if ( not $status );

# Step 108
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);
 
# Step 109
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 027400     MOVE +1001 TO MAX-COUNTER") if ( not $status );

# Step 110 
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]', "==>") if ( not $status );

# Step 111
ln __LINE__; $status = write2PanelField( $session, "Maximum calls  . . ", "1000",'[enter]' ) if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, "Maximum calls  . . 1000") if ( not $status );
# Step 112  
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 113
ln __LINE__; $status = write2CommandLine( $session, "RUN",'[enter]') if ( not $status ); 
sleep (3);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 029700     EXEC CICS ASKTIME END-EXEC.                          RETURN") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "POSSIBLE CICS CALL LOOP") if ( not $status );

# Step 114  
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]', "==>") if ( not $status );

# Step 115
ln __LINE__; $status = write2PanelField( $session, "Maximum calls  . . ", "5000",'[enter]' ) if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, "Maximum calls  . . 5000") if ( not $status );

# Step 116  
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 117
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);


# Step 118 Select 12 – Too much storage accumulated
ln __LINE__; $status = write2CommandLine( $session, "12", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI"  ) if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "|STATUS: BREAK AT START OF TEST SESSION") if ( not $status );

# Step 119               
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2';           /* PAUSE HERE */ ") if ( not $status );

# Step 120               
#ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
#sleep($time);
#ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 031100     MOVE +50   TO MAX-COUNTER") if ( not $status );

# Step 121 
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]', "==>") if ( not $status );

# Step 122
ln __LINE__; $status = write2PanelField( $session, "Max GETMAIN size   ", "4095",'[enter]' ) if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, "Max GETMAIN size   4095") if ( not $status );

# Step 123  
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

# Step 124 
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Max GETMAIN size   4095") if ( not $status );

# Step 125
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = write2PanelField( $session, "Max GETMAIN size   ", "     ",'[enter]' ) if (not $status); 
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 126
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);


# Step 127 Enter 13 to Select AEXX Abends(nohandle)
ln __LINE__; $status = write2CommandLine( $session, "13", '[enter]', "==>") if ( not $status );
########################################
##***************** Had to add a F3 to get to see >>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR) OPTIONS(MAIN REENTRANT);
#####################
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR) OPTIONS(MAIN" ) if ( not $status );
                                                            
# Step 128
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2';           /* PAUSE HERE */") if ( not $status );

# Step 129
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 012900 PROCEDURE DIVISION") if ( not $status );

# Step 130
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 049900     MOVE +0      TO MAX-COUNTER") if ( not $status );

# Step 131 Enter RUN to intercept an AEIL abend
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, 'ASG2850I EXECUTION MAY NOT BE CONTINUED FOR THIS "ABENDED" TRANSACTION. ') if ( not $status );

# Step 132 
ln __LINE__; $status = write2CommandLine( $session, "CANCEL;RUN VCOB", '[enter]', "==>") if ( not $status );
sleep($time);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PROCEDURE DIVISION") if ( not $status );

# Step 133
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);


# Step 134
ln __LINE__; $status = write2CommandLine( $session, "X", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PROCEDURE DIVISION") if ( not $status );

# Step 135
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, "THANK YOU FOR YOUR PARTICIPATION") if ( not $status );

# Step 136
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 137
ln __LINE__; $status = write2CommandLine( $session, "CANCEL;RUN VPLI", '[enter]', "==>") if ( not $status );
sleep 2;
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR) ") if ( not $status );

# Step 138
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);


# Step 139 Enter 14 Link to Viacasm (assembler
ln __LINE__; $status = write2CommandLine( $session, "14", '[enter]', "==>") if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR) OPTIONS(MAIN") if ( not $status );
# Step 140
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2';           /* PAUSE HERE */") if ( not $status );

# Step 141
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 012900 PROCEDURE DIVISION") if ( not $status );

# Step 142
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 053200     MOVE 'LINK'   TO ASMEIB.") if ( not $status );

# Step 143 DEMO: LINK TO OUR COMMAND LEVEL ASSEMBLER DEMO PROGRAM
ln __LINE__; $status = write2CommandLine( $session, "LIST TAILOR", '[enter]', "==>") if ( not $status );

ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[DOWN]',1) if (not $status);

# Step 144
ln __LINE__; $status = pressKeys( $session, "I") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[ENTER]',1) if (not $status);

# Step 145

ln __LINE__; $status = pressKeys( $session, "VIACASM.VIACASM  ") if (not $status);
ln __LINE__; $status = pressKeys( $session, 'YESYESYESYESYESNO YESYES')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
 
ln __LINE__; $status = verifyPanel ( $session, "ListTailoring3.txt",1 ) if (not $status);

# Step 146
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);     
ln __LINE__; $status = findStringOnPanel( $session, "053200     MOVE 'LINK'   TO ASMEIB") if ( not $status );

# Step 147
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACASM  DFHEIENT CODEREG=(12,8)") if ( not $status );

# Step 148
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

# Step 149
ln __LINE__; $status = write2CommandLine( $session, "X", '[enter]', "==>") if ( not $status );

# Step 150 Demo: Start Asynchronous task VCO3
ln __LINE__; $status = write2CommandLine( $session, "15", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: ") if ( not $status );

# Step 151
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2'") if ( not $status );

# Step 152
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 012900 PROCEDURE DIVISION") if ( not $status );

# Step 153
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

# Step 154
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, "PL/I Demonstration Program -----------------------") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "** PROGRAM (VIACCOB3) ASYNCHRONOUSLY STARTED **") if ( not $status );

# Step 155
ln __LINE__; $status = write2CommandLine( $session, "X", '[enter]', "==>") if ( not $status );
sleep(3);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR)") if ( not $status );

# Step 156
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

# Step 157
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR) ") if ( not $status );

# Step 158
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

# Step 159 Demo: Runaway task (AICA)
ln __LINE__; $status = write2CommandLine( $session, "16", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR)") if ( not $status );

# Step 160
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2';           /* PAUSE HERE */") if ( not $status );
                                                     
# Step 161
# bring up a CICS Session
my $cics = startCICSSession($sessionID2) if ( not $status );
sleep(10);
# Step 162
ln __LINE__; $status = pressKey( $cics, '[clear]')  if ( not $status );

# Step 163
ln __LINE__; $status = pressKeys( $cics, "CEMT INQ RUNAWAY") if (not $status);
ln __LINE__; $status = pressKey( $cics, '[ENTER]') if (not $status); 
#THIS IS FOR CICS 5.4 
#ln __LINE__; $status = findStringOnPanel( $cics, "Runaway( 0002000 )") if ( not $status );
#THIS IS FOR CICS 5.3 AND PRE RELEASES .
ln __LINE__; $status = findStringOnPanel( $cics, "Runaway( 0005000 )") if ( not $status );
# Step 164
ln __LINE__; $status = write2PanelField( $cics, "Runaway( ", "0001000 )",'[enter]' ) if (not $status); 
ln __LINE__; $status = findStringOnPanel( $cics, "Runaway( 0001000 )") if ( not $status );
# Step 165
# Switch back to ISPF
connectTOSession ($session,$sessionID);
ln __LINE__; $status = Eswtool::pressKeyF4( $session)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 012900 PROCEDURE DIVISION") if ( not $status );

# Step 166
ln __LINE__; $status = Eswtool::pressKeyF4( $session)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 039200     MOVE +0      TO MAX-COUNTER") if ( not $status );

# Step 167 - script fails in 790
ln __LINE__; $status = Eswtool::pressKeyF4( $session, 15)  if ( not $status );
sleep($time);
                                                            
ln __LINE__; $status = findStringOnPanel( $session, "MOVE ALL '|' TO BLL2-DATA.                           RETURN") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2850I EXECUTION MAY NOT BE CONTINUED FOR THIS "ABENDED" TRANSACTION') if ( not $status );

# Step 168
ln __LINE__; $status = write2CommandLine( $session, "CANCEL;RUN CEMT INQ RUNAWAY", '[enter]', "==>") if ( not $status );
sleep(3);
ln __LINE__; $status = findStringOnPanel( $session, "Runaway( 0001000 )") if ( not $status );

# Step 169
ln __LINE__; $status = write2PanelField( $session, "Runaway( ", "0005000 )",'[enter]' ) if (not $status); 

ln __LINE__; $status = findStringOnPanel( $session, "Runaway( 0005000 )") if ( not $status );
# Step 170
ln __LINE__; $status = pressKey( $session, '[F3]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, " STATUS:  SESSION ENDED ") if ( not $status );

# Step 171
ln __LINE__; $status = pressKey( $session, '[CLEAR]')  if ( not $status );

# Step 172
ln __LINE__; $status = pressKeys( $session, "VPLI")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR) OPTIONS(MAIN" ) if ( not $status );

# Step 173
ln __LINE__; $status = Eswtool::pressKeyF4( $session)  if ( not $status );


# Step 174  
ln __LINE__; $status = write2CommandLine( $session, "16", '[enter]', "==>") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACPLI: PROC(DFHEIPTR,COMMAREA_PTR) OPTIONS(MAIN" ) if ( not $status );


# Step 175
ln __LINE__; $status = Eswtool::pressKeyF4( $session)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PGMID      = 'VIACCOB2';           /* PAUSE HERE */ ") if ( not $status );

# Step 176
ln __LINE__; $status = Eswtool::pressKeyF4( $session)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 012900 PROCEDURE DIVISION") if ( not $status );
 
# Step 177
ln __LINE__; $status = Eswtool::pressKeyF4( $session)  if ( not $status );

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>> 039200     MOVE +0      TO MAX-COUNTER") if ( not $status );
 
# Step 178
ln __LINE__; $status = Eswtool::pressKeyF4( $session)  if ( not $status );


 # Step 179
ln __LINE__; $status = write2CommandLine( $session, "X", '[enter]', "==>") if ( not $status );

# Step 180
ln __LINE__; $status = write2CommandLine( $session, "CAN;Q CAN ALL", '[enter]', "==>") if ( not $status );

## Step 181 go back to CICS Native mode session
connectTOSession ($cics, $sessionID2);
#
## Step 182
ln __LINE__; $status = pressKey( $cics, '[F3]') if (not $status);  
ln __LINE__; $status = pressKey( $cics, '[CLEAR]') if (not $status);  
ln __LINE__; $status = pressKeys ( $cics, "CESF LOGOFF") if ( not $status );
ln __LINE__; $status = pressKey( $cics, '[ENTER]') if (not $status);  

## Step 183 go back to ISPF 
connectTOSession ($session, $sessionID);
#ISPF Abend makes script fails
ln __LINE__; $status = navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;