###############################################################################
#
# TEST SCRIPT: QA-TCD-ST-7.7.1-R004.doc  
#		
# Script  
# DESCRIPTION: Test COBOL demonstration program VIAPCOB with Enterprise 4.2 compiler.
# DATE: 6/13/2012
# CJM 
#################################################################################
use Hllapi;
use PROJCL::ProJcl;
use Tie::IxHash;
use MAP;
use ESW::Eswtool;
use ESW::PanelsMap; 

my $configRef 		  = Cfg::getcfg();
my $sessionID  		  = $configRef->{'SessionID'};
my $userID            = $configRef->{'UserID'};
my $execclist         = $configRef->{'Exec'};
my $cntlLib 	      = $configRef->{'CntlLib'};
my $ispprof           = $configRef->{'Ispprof'};
my $hlq               = $configRef->{'TestDataHLQ'. '.'};
my $akrcob            = $configRef->{'AKRCOB'}; 
my $clist             = $configRef->{'Clist'}; 
my $akrasm            = $configRef->{'AKRASM'}; 
my $akrpli            = $configRef->{'AKRPLI'};         
my $loadcob           = $configRef->{'LOADCOB'};                
my $loadasm           = $configRef->{'LOADASM'};              
my $loadpli           = $configRef->{'LOADPLI'};
my $compileJCL        = 'qal.phx.eswauto.jcl2';
my $status = 0;
package MAP;
ln __LINE__; init;
ln __LINE__; $session = startSession($sessionID);
ln __LINE__; $status = Eswtool::initProfile($session);

# get the current date and return it in ddmmmyyyy (12JUN2012 for ej)
ln __LINE__; $date = Util::check_date; 
# Step 6
## Go option 6
ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);
ln __LINE__; $status = write2CommandLine( $session, "CENTER", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "ST", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "SET LE OFF ", '[enter]' ) if ( not $status );
# Step 9
ln __LINE__; $status = write2CommandLine( $session, "AN ", '[enter]' ) if ( not $status );

# Step 10
my $form = tie(
	%form, Tie::IxHash,             
#	'Data set name'        => "'" . "$compileJCL(VIAPCOBC)" . "'",
	'Data set name'        => "'" . "qal.phx.eswauto.jcl2(VIAPCOBC)" . "'",
 #  'Understand: ' 	   	   => 'N',
    'Test:'   	           => 'Y',
    'Extended Analysis:'   => 'Y',
 #  'Document:'            => 'N',
 #  'Re-engineer:'         => 'N',
    'AKR data set name'    => "'$akrcob'",
	'Compile? (Y/N) . . . . . . . . .'   => 'Y',
	'Link load module reusable? (Y/N)'   => 'Y',
		   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 13
ln __LINE__; $status = write2CommandLine( $session, "AKR", '[enter]' ) if ( not $status );

# Step 14
$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name . .'        => "'$akrcob'",
	   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "L VIAPCOB", '[enter]' ) if ( not $status );
# check that VIAPCOB in the directory has  today’s date.
ln __LINE__;  findStringOnPanel( $session, "$date" );

# Step 15 
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 16
ln __LINE__; $status = write2CommandLine( $session, "ENV", '[enter]' ) if ( not $status );

# Step 17
ln __LINE__; $status = write2CommandLine( $session, "L", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[TAB]') if (not $status);

# Step 18
# Application Knowledge Repositaries (AKR)
ln __LINE__; $status = pressKeys( $session, "'$akrcob'") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',5) if (not $status);
# Application Load Libraries:
ln __LINE__; $status = pressKeys( $session, "'$loadcob'") if (not $status);
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

#step 21
#  Environment Selection MVS    (PGM=program) T1
ln __LINE__; $status = write2CommandLine( $session, "T1", '[enter]' ) if ( not $status );

$form = tie(
	%form, Tie::IxHash,             
	
	'Load module'        		 => "VIAPCOB",
    'Break on entry (Y/N)'		 => "YES",
    'Deallocate'				 => "NO",
		   
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
#  C Convert batch JCL to TSO CLIST
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );

# Step 22
$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        		 => "'qal.phx.eswauto.jcl2'",
    'Member  . . .'				 => "VIAPCOBJ",
    'Data set name&'        		 => "'$clist'   ",
    'Member  . . .&'				 => "VIAPCOBJ",
	'Delete (Y/N)'					 => "NO",   
	'Step   (Y/N)'					 => "YES",
	'Subsystem'						 => "    ",
	'Step Name'						 => "STEP1"
	
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
#  C Convert batch JCL to TSO CLIST
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );
ln __LINE__;  findStringOnPanel( $session, "CLIST GENERATED" );

# Step 23
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 24
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',4) if (not $status);
ln __LINE__; $status = pressKeys( $session, "ALL/ALL31(OFF) STACK(,,BELOW)") if (not $status);

# R - Begin TSO test session (RUN)
ln __LINE__; $status = write2CommandLine( $session, "R", '[enter]' ) if ( not $status );

# Step 25
ln __LINE__; $status = write2CommandLine( $session, "UP MAX", '[enter]' ) if ( not $status );

# Step 26
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULT", '[enter]' ) if ( not $status );

# Step 27
# ENABLES EXECUTION TRACKING OF ALMOST 10,000 MACHINE INSTRUCTIONS.   
# Enter'LIST TRACK' AT ANY TIME DURING THE  TEST TO SEE THE PROGRESS OF THE DEMO.
ln __LINE__; $status = write2CommandLine( $session, "SET TRACK 9999", '[enter]' ) if ( not $status );

# 'LIST TAILOR' SCREEN, INSERT THESE ENTRIES:
#     'VIA*.VIA*'        SET 'COUNTS ACTIVE' TO YES   
#     'IEFBR14.IEFBR14'  SET 'BREAK ON ENTRY' TO YES  
ln __LINE__; $status = write2CommandLine( $session, "LI TA", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',6) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);

ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',3) if (not $status);
ln __LINE__; $status = pressKeys( $session, "I") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

ln __LINE__; $status = pressKeys( $session, "IEFBR14.IEFBR14  ") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',4) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 32
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# BREAK BEFORE PAUSE ALL;RUN  command WILL PLACE A BREAKPOINT AT PREDETERMINED LOCATIONS IN THE SOURCE
# THAT HAVE 'PAUSE' IN THE TEXT, THEN BEGIN THE TEST SESSION. 
# Step 33              
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN", '[enter]' ) if ( not $status );
ln __LINE__;  $status = findStringOnPanel( $session, "DEMONSTRATION OF: S0C7" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

####### Print compiler used.
ln __LINE__; $status = write2CommandLine( $session, "li comp", '[enter]' ) if ( not $status );
my $row = "Compiler  : ";
my $rowline = copyTextFromScreen($session,$row,35,0);
Util::printStatus( 0, "$rowline" );

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
########
# Change the value of DATA-PACKED-DEC
# Step 35
ln __LINE__; $status = write2CommandLine( $session, "111111", '[enter]', "VALUE >") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'SUCCESSFUL MEMORY UPDATE')  if ( not $status );

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'DEMONSTRATION OF: S0C4')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
#ln __LINE__; $status = findStringOnPanel( $session, 'S0C4-DEMO')  if ( not $status );


# ENTER 'LIST TRACKING' TO VIEW THE EXECUTION TRACKING HISTORY.
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACKING", '[enter]' ) if ( not $status );
# step 39
ln __LINE__; $status = write2CommandLine( $session, "DISPLAY S0C4-INDEX", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG2172I S0C4-INDEX=" ) if ( not $status );	


#IT DISPLAYS AS '* INVALID *', SO WE KNOW THAT IT HAS SOMEHOW BEEN ASSIGNED AN INCORRECT VALUE.  
# Step 40
ln __LINE__; $status = write2CommandLine( $session, "DISPLAY S0C4-INDEX-INCREMENT", '[enter]' ) if ( not $status );
#ln __LINE__; $status =  findStringOnPanel( $session, "ASG2172I S0C4-INDEX-INCREMENT=*INVALID*" ) if ( not $status );;

# Find every statement that modifies the variable
# step 41
ln __LINE__; $status = write2CommandLine( $session, "FX S0C4-INDEX-INCREMENT MOD ALL", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG0443I 2 DATA MODS: 1 PARENT, FOUND FOR S0C4-INDEX-INCREMENT" ) if ( not $status );;

# Step42
ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeys( $session, "C") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',1) if (not $status);
ln __LINE__; $status = pressKeys( $session, "A") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
#######################################################################################################
###### Problem with Go to S0C4-DEMO;RUN. Added a 2nd RUN to be able to reach DEMONSTRATION OF: STEP
#######################################################################################################
# Step 43
ln __LINE__; $status = write2CommandLine( $session, "GO TO S0C4-DEMO;RUN", '[enter]' ) if ( not $status );
#ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step demonstration
ln __LINE__; $status = findStringOnPanel( $session, "PERFORM STEP-VALUE-SUBROUTINE" )if ( not $status );

# Step 45
# Open a Keep Window
ln __LINE__; $status = write2CommandLine( $session, "KEEP STEP-VALUE", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "10 STEP-VALUE " )if ( not $status );

# Step 46
# Watch the next 4 verbs execute
ln __LINE__; $status = write2CommandLine( $session, "STEP 4 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 4 OF 4 EXECUTED" )if ( not $status );

# Step 47
# STEP OVER to execute the subroutine 5 times without stepping through it
ln __LINE__; $status = write2CommandLine( $session, "STEP OVER", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED BY "STEP OVER" REQUEST' )if ( not $status );

# Step 48
# close the Keep window
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +0 TO STEP-VALUE' )if ( not $status );

# Step 49
# SET OPERANDS ON to enable the display of the data items on each verb as you step through them.
ln __LINE__; $status = write2CommandLine( $session, "SET OPERANDS ON", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'OPERANDS ON ' )if ( not $status );

# Step 50
# STEP 5 AUTO TO STEP THROUGH THE NEXT 5 VERBS AND AUTOMATICALLY DISPLAY THE VALUES.
ln __LINE__; $status = write2CommandLine( $session, "STEP 5 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-VALUE=+13' )if ( not $status );

# Step 51
# change the time interval to 3 seconds
ln __LINE__; $status = write2CommandLine( $session, "SET DELAY 3", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'DELAY TIME SET' )if ( not $status );

# Step 52
# STEP 5 AUTO TO STEP THROUGH THE NEXT 5 VERBS with a 3 second delay between step
#  AND AUTOMATICALLY DISPLAY THE VALUES.
my $startTestTime = time();
ln __LINE__; $status = write2CommandLine( $session, "STEP 5 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-VALUE=+0' )if ( not $status );

my $endTestTime = time();
my $diff = $endTestTime - $startTestTime;
if ($diff < 10) {
	$status = -1;
	print "+++ Delay time set to 15 seconds. Actual delay was $diff seconds.+++\n";
}else {
	print "*** Delay time set to 15 seconds. Actual delay was $diff seconds.***\n";
}

#Step 53
# Type RUN to on commmand line and position cursonr anywhere on SUBTRACT + 1 statement.
ln __LINE__; $status = write2CommandLine( $session, "RUN TO",  ) if ( not $status );
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'SUBTRACT +1 FROM STEP-VALUE')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED BY "RUN ' )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-VALUE=+11' )if ( not $status );

# Step 55
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +2 TO STEP-SUB' )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-SUB=+13' )if ( not $status );

# Step 56 
# To execute the next 7 statements, then stop at the first statement of STEP-PARA-SUBROUTINE
ln __LINE__; $status = write2CommandLine( $session, "STEP PARA", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +3 TO STEP-VALUE' )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-VALUE=+6' )if ( not $status );


# Step 57
# To execute the next 3 paragraphs, redisplaying the source code at the first statement
#  of each paragraph,                                            
ln __LINE__; $status = write2CommandLine( $session, "STEP 3 PARA AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2172I STEP-VALUE=+3' )if ( not $status );

# step 58
# continue the test
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULTS;RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'DEMONSTRATION OF: STOP' )if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[ENTER]',2) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'PERFORM STOP-BUILD-PAYEE-TABLE' )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED AFTER BREAK' )if ( not $status );

# Step 60
# To place an address stop on the field so that any modification of the field will be identified
ln __LINE__; $status = write2CommandLine( $session, "STOP STOP-PAY-TOTAL", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG2324I ADDRESS STOP AT' )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'FOR A LENGTH OF 11 HAS BEEN ASSIGNED' )if ( not $status );

# Step 61
# to view the ADSTOP Screen
ln __LINE__; $status = write2CommandLine( $session, "LIST ADSTOP", '[enter]' ) if ( not $status );
################################################ change to verifyPanelMask
ln __LINE__; verifyPanelMask ( $session, "ListAddStop.txt",1 );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 63
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ADD STOP-PAY-AMOUNT (STOP-PAYEE) TO STOP-PAY-' )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED BEFORE ADDRESS MODIFIED' )if ( not $status );

# Step 64
# The next couple of 'RUN' commands will stop at this same modification of STOP-PAY-TOTAL. 
# It may appear ‘stuck.’
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'ADD STOP-PAY-AMOUNT (STOP-PAYEE) TO STOP-PAY-' )if ( not $status );

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'ADD STOP-PAY-AMOUNT (STOP-PAYEE) TO STOP-PAY-' )if ( not $status );

# Step 65
# 'LIST TRACK' you will see that verbs are actually executed.
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACK", '[enter]' ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "ListTrack.txt",1 );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Enter ‘RUN’ to execute the add and continue the demo. 
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' );

# Step 68
# bypass the corruption and continue,
ln __LINE__; $status = write2CommandLine( $session, "GO TO STOPFIX;RUN ", '[enter]' );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; verifyPanelMask ( $session, "StopFix.txt",1 );

# Step 70
# To see every reference to the field 'FIND-VALUE'
ln __LINE__; $status = write2CommandLine( $session, "X ALL;FX FIND-VALUE", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG0443I 6 DATA REFS: 3 DEFS, 1 USE, 2 MODS, FOUND FOR FIND-VALUE' )if ( not $status );

# Step 71
# To restore the source display to the current line,
ln __LINE__; $status = write2CommandLine( $session, "RESET;LOCATE *", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +0 TO FIND-VALUE' )if ( not $status );

# Step 72 
#To see only the field’s modifications
ln __LINE__; $status = write2CommandLine( $session, "X ALL;FX FIND-VALUE MOD", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG0443I 2 DATA MODS FOUND FOR FIND-VALUE' )if ( not $status );

# To restore the source display to the current line,
ln __LINE__; $status = write2CommandLine( $session, "RESET;LOCATE *", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +0 TO FIND-VALUE' )if ( not $status );

# Step 74
# To see only the field’s references in conditional statements
ln __LINE__; $status = write2CommandLine( $session, "X ALL;FX FIND-VALUE USE IN COND", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG0443I 1 DATA USE FOUND FOR FIND-VALUE IN COND' )if ( not $status );

# To restore the source display to the current line,
ln __LINE__; $status = write2CommandLine( $session, "RESET;LOCATE *", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +0 TO FIND-VALUE' )if ( not $status );

# Step 76
# To see only the field’s references in conditional statements
ln __LINE__; $status = write2CommandLine( $session, "X ALL;FX DEADCODE", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'UNREFERENCED-SUBROUTINE.                                       DEADCODE' )if ( not $status );

# To restore the source display to the current line,
ln __LINE__; $status = write2CommandLine( $session, "RESET;LOCATE *", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKey( $session, '[F8]') if (not $status);

# Step 79
# Place cursor under dataname FIND-VALUE
ln __LINE__; $status = write2CommandLine( $session, "FX %",  ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[DOWN]',11) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[RIGHT]',15) if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE +0 TO FIND-VALUE' )if ( not $status );

# Step 80
#  set an automatic breakpoint in every statement where 'FIND-VALUE' is used in a conditional statement
ln __LINE__; $status = write2CommandLine( $session, "BREAK FIND-VALUE IN CONDITIONAL ALL", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "FindValuebreak.txt",1 );

# To execute up to the breakpoint that was established with the prior ‘BREAK’ command
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "FindValuebreak2.txt",1 );

# Step 82
# RUN
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'DEMONSTRATION OF: BACKTRACK' )if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
 
# Step 84 
# enable the collection of data
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK ON", '[enter]'  );
ln __LINE__; $status = findStringOnPanel( $session, 'BACKTRACK ON' )if ( not $status );
 
# Step 85
# Execute several statements to build an execution history
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);

# Step 86
# To determine which statement was the last to modify BACK-FLAG 
ln __LINE__; $status = write2CommandLine( $session, "RUN BACKWARD TO BACK-FLAG MOD", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask  ( $session, "backflag.txt",1 );

# To see what value  'BACK-FLAG' contained before it was modified
ln __LINE__; $status = write2CommandLine( $session, "KEEP BACK-FLAG ", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "backflagvalue.txt",1 ); 

# To watch BACK-FLAG change to N
ln __LINE__; $status = write2CommandLine( $session, "STEP FORWARD", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask  ( $session, "backflagvalue2.txt",1 );

# watch it change back to 'Y' and continue execution in reverse,
ln __LINE__; $status = write2CommandLine( $session, "STEP BACK 4 AUTO", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "backflagvalue3.txt",1 );
 
# To run backwards to where the prior modification took place
ln __LINE__; $status = write2CommandLine( $session, "RUN TO BACK-FLAG MOD", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask  ( $session, "backflagvalue4.txt",1 );

# Close the KEEP window
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP", '[enter]'  ) if ( not $status );

# To exit BACKTRACK mode and continue
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK OFF;RUN", '[enter]'  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);  
ln __LINE__; verifyPanelMask  ( $session, "Nosource.txt",1 );

# step 94
# To enable the display of the disassembled object code for any non-analyzed program
ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW ON", '[enter]'  ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASMVIEW ON" ) if (not $status);

# Step 95
# To break at entry to 'IEFBR14'
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);  
ln __LINE__; $status =  findStringOnPanel( $session, "BREAK ON ENTRY TO A PROGRAM           PGM: IEFBR14" ) if (not $status);


# Step 96
# To step through IEFBR14's disassembled object code and back to VIAPCOB
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "IEFBR14Step.txt",1 ) if (not $status); 

# Step 97
# To display the execution tracking
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACKING", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, '000000  1BFF            SR    R15,R15' )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "000002  07FE" )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "VIAPCOB.VIAPCOB" )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "NOSOURCE-DEMO" )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "SOURCE: MOVE +1 TO RETURN-CODE." )if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

# Step 99
ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW OFF;STEP", '[enter]'  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'MOVE ZONED-ZERO TO RETURN-CODE' )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'STOPPED BY STEP REQUEST' )if ( not $status );

# Step 100 
# To enable the ASM mode
ln __LINE__; $status = write2CommandLine( $session, "SET ASM ON", '[enter]'  ) if ( not $status );
ln __LINE__;  $status = findStringOnPanel( $session, "ASM ON" ) if (not $status);

# Step 101
# To watch the individual statements execute
ln __LINE__; $status = write2CommandLine( $session, "STEP 3 AUTO ", '[enter]'  ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG2163I STEP 3 OF 3 EXECUTED" ) if (not $status);

# Step 102
# To exit ASM  mode and continue
ln __LINE__; $status = write2CommandLine( $session, "SET ASM OFF;RUN", '[enter]'  ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "DEMONSTRATION OF: LOOP" ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 

# Step 104
# List counts Descending
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "ListCountDesc.txt",1 ) if (not $status);

# Step 105
# List counts ascending
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS ASCENDING", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "ListCountAsc.txt",1 ) if (not $status);

# Step 106
# List counts D Paragraph
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS D PARA", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "ListCountDPara.txt",1 )if (not $status);

# Step 107
# List counts Line
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS LINE", '[enter]'  ) if ( not $status );
ln __LINE__; verifyPanelMask ( $session, "ListCountLine.txt",1 )if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 

# To complete the Test session
ln __LINE__; $status = write2CommandLine( $session, "CANCEL", '[enter]'  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 
ln __LINE__;  findStringOnPanel( $session, "TEST SESSION CANCELLED" ) if (not $status);
ln __LINE__; $status = write2CommandLine( $session, "Q CAN ALL", '[enter]'  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;