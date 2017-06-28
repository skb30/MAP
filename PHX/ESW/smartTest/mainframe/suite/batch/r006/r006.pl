###############################################################################
#
# TEST SCRIPT: QA-TCD-ST-7.7.1-R006.doc  
#		
# Script  
# DESCRIPTION: Test the IVP’s for SmartTest/PLI
# DATE: 12/06/2012
# CJM 
#################################################################################
use Hllapi;
use MAP;
use PROJCL::ProJcl;
use Tie::IxHash;
use ESW::Eswtool;
use ESW::PanelsMap;
 

my $configRef 		  = Cfg::getcfg();
my $sessionID  		  = $configRef->{'SessionID'};
my $userID            = $configRef->{'UserID'};
my $execclist         = $configRef->{'Exec'};
my $cntlLib 	      = $configRef->{'CntlLib'};
my $ispprof           = $configRef->{'Ispprof'};
my $clist             = $configRef->{'Clist'};
my $hlq               = $configRef->{'TestDataHLQ'} . '.';
my $akrcob            = $configRef->{'AKRCOB'}; 
my $akrasm            = $configRef->{'AKRASM'}; 
my $akrpli            = $configRef->{'AKRPLI'};         
my $loadcob           = $configRef->{'LOADCOB'};                
my $loadasm           = $configRef->{'LOADASM'};              
my $loadpli           = $configRef->{'LOADPLI'};
my $status = 0;

package MAP;
ln __LINE__;init;

#my $map_hash = Common::selectMenuMapItem();
ln __LINE__;$session = startSession($sessionID);
ln __LINE__; $status = Eswtool::initProfile($session);

## Go option 6
ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);
#ln __LINE__; $status = write2CommandLine( $session, "tso ex 'QAL.PHX.ESW790AU.SCNXCLST(VIASPROC)' 'ADD(QAL.PHX.ESW790AU.SESWCLST)'", '[enter]' )if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "CENTER", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "ST ", '[enter]' ) if ( not $status );
# File analyze
ln __LINE__; $status = write2CommandLine( $session, "AN ", '[enter]' ) if ( not $status );

$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        => "'qal.phx.eswauto.jcl2(VIAPPLIC)'",
 #  'Understand: ' 	   	   => 'Y',
    'Test:'   	           => 'Y',
    'Extended Analysis:'   => 'Y',
 #   'Document:'            => 'N',
 #   'Re-engineer:'         => 'N',
    'AKR data set name'    => "'$akrpli'",
	'Compile? (Y/N) . . . . . . . . .'   => 'Y',
	'Link load module reusable? (Y/N)'   => 'Y',
		   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
# navigate to the File pull down menu and choose Skeleton Processing
ln __LINE__; $status = navigate2DropDownList ($session, "File", "AKR utility" ) if ( not $status );


$form = tie( 
	%form, Tie::IxHash,             
	
	'Data set name . .'        => "'$akrpli'",
   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "ENV", '[enter]' ) if ( not $status );

#  # Step 14 Select MVS TSO Environment
ln __LINE__; $status = write2CommandLine( $session, "T1", '[enter]' ) if ( not $status );

# Step 14 Library Specification
ln __LINE__; $status = write2CommandLine( $session, "L", '[enter]' ) if ( not $status );

# Step 15
# Application Knowledge Repositaries (AKR)
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',1) if (not $status);
ln __LINE__; $status = pressKeys( $session, "'$akrpli'") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',5) if (not $status);
# Application Load Libraries:
ln __LINE__; $status = pressKeys( $session, "'$loadpli'") if (not $status);
ln __LINE__; $status = pressKey ( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Convert Batch Jcl to TSO CLIST
$form = tie(
	%form, Tie::IxHash,             
	
	'Load module'        		 => "VIAPPLI",
	'Break on entry (Y/N)'		 => "YES",
    'Execution parameters: '     => "ALL",
    'Data set name'              => "'$clist'",
	'Member'                     => "PLIBATCH",
    'Deallocate'				 => "NO",
		   
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
#  C Convert batch JCL to TSO CLIST
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );

# Step 17
$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        		 => "'qal.phx.eswauto.jcl2'",
    'Member  . . .'				 => "VIAPPLIJ",
    'Data set name&'        		 => "'$clist'",
    'Member  . . .&'				 => "PLIBATCH",
	'Delete (Y/N)'					 => "NO",   
	'Step   (Y/N)'					 => "YES",
	'Subsystem'						 => "    ",
	'Step Name'						 => "STEP1"
	
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
#  C Convert batch JCL into CLIST
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "CLIST GENERATED" ) if ( not $status) ;
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 19
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULTS", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "TEST OPTIONS DEFAULTED" ) if ( not $status) ;
ln __LINE__; $status = write2CommandLine( $session, "SET TRACK 9999", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "LIST TAILOR", '[enter]' ) if ( not $status );

# Step 22
ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',6) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',3) if (not $status);
ln __LINE__; $status = pressKeys( $session, "R2") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
                                               
ln __LINE__; $status = pressKeys( $session, "IEFBR14.IEFBR14  ") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYESYES") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',4) if (not $status);
ln __LINE__; $status = pressKeys( $session, "VIAPLIS.VIAPLIS  ") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYESYES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanel( $session, "ListTailor.txt",1 )if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
# Step 28
ln __LINE__; $status = write2CommandLine( $session, "LIST INTERCEPTS", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',1) if (not $status);
ln __LINE__; $status = pressKeys( $session, "IEFBR14") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
# Step 29 Begin TSO Test Session (RUN)
ln __LINE__; $status = write2CommandLine( $session, "R", '[enter]' ) if ( not $status );
#ln __LINE__; $status = findStringOnPanel( $session, "ALLOCATION SUCCESSFUL" ) if ( not $status) ;

# Step 30  
ln __LINE__; $status = write2CommandLine( $session, "LI COMP", '[enter]' ) if ( not $status );
#ln __LINE__; $status = findStringOnPanel( $session, "ALLOCATION SUCCESSFUL" ) if ( not $status) ;
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 32
# BREAK BEFORE PAUSE ALL;RUN  command WILL PLACE A BREAKPOINT AT PREDETERMINED LOCATIONS IN THE SOURCE
# THAT HAVE 'PAUSE' IN THE TEXT, THEN BEGIN THE TEST SESSION.               
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: S0C7" ) if ( not $status) ;  
my $row = "Compiler  :";
# Step 33
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 
####### Print compiler used.
ln __LINE__; $status = write2CommandLine( $session, "li comp", '[enter]' ) if ( not $status );
$row = "Compiler  : ";
my $rowline = copyTextFromScreen($session,$row,35,0);
Util::printStatus( 0, "$rowline" );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
#########
ln __LINE__; $status = findStringOnPanel( $session, "S0C7_DEMO: PROC;                   /* PAUSE HERE */" ) if ( not $status) ;

# Step 34
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);              
ln __LINE__; $status = findStringOnPanel( $session, "DATA_PACKED_DEC = DATA_PACKED_DEC + 1;" ) if ( not $status) ;
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: DATA EXCEPTION (0C7)" ) if ( not $status) ;

# step 35
ln __LINE__; $status = pressKey( $session, '[F8]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, " <  * INVALID NUMERIC" ) if ( not $status) ;

#Step 36  Change the value of DATA-PACKED-DEC
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',6) if (not $status);
ln __LINE__; $status = pressKeys( $session, "100") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "SUCCESSFUL MEMORY UPDATE" ) if ( not $status) ;

# Step 37
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: S0C4") if ( not $status) ;
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "S0C4_DEMO: PROC;                   /* PAUSE HERE */" ) if ( not $status) ;

# Setp 39 Produce the S0C4
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "PROTECTION EXCEPTION (0C4)") if ( not $status) ;
ln __LINE__; $status = findStringOnPanel( $session, "BASED_VAR = 'S0C4'" ) if ( not $status) ;

# Step 40. To bypass the s0C4 , Go to fix SC04 and continue
ln __LINE__; $status = write2CommandLine( $session, "GO TO S0C4FIX;RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "STEP_DEMO: PROC;                   /* PAUSE HERE */" ) if ( not $status) ;

# Step 42.  
ln __LINE__; $status = write2CommandLine( $session, "KEEP COUNTER", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "03 COUNTER                         BIN FIX (31,0)" ) if ( not $status) ;

# Step 43.  
ln __LINE__; $status = write2CommandLine( $session, "STEP 10 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 10 OF 10 EXECUTED" ) if ( not $status) ;

# Step 44.  
ln __LINE__; $status = write2CommandLine( $session, "STEP OVER", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STEP_SUB = STEP_SUB + 1;" ) if ( not $status) ;

# Step 45.  
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP", '[enter]' ) if ( not $status );

# Step 46.
ln __LINE__; $status = pressKey( $session, '[F6]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>          IF ON_COMMISSION = TRUE THEN" ) if ( not $status );

# Step 47.
ln __LINE__; $status = pressKey( $session, '[F6]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>              IF Q1_SALES < Q2_SALES | Q3_SALES < Q4_SALES"  ) if ( not $status );

# Step 48.
ln __LINE__; $status = pressKey( $session, '[F6]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>                 IF SUM(Q_SALES) > Q_SALES_MIN THEN") if ( not $status );

# Step 49.
ln __LINE__; $status = pressKey( $session, '[F6]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>          STEP_SUB = STEP_SUB +1;") if ( not $status );

# Step 50.
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       COUNTER = 0;                    /* PAUSE HERE */") if ( not $status );

# Step 51.
ln __LINE__; $status = write2CommandLine( $session, "SET OPERANDS ON" , '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "OPERANDS ON") if ( not $status );

# Step 52. To step through the next 5 verbs and automatically display the values,.
ln __LINE__; $status = write2CommandLine( $session, "STEP 5 AUTO" , '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I COUNTER=-2") if ( not $status );

# Step 53. To change the time interval between steps.
ln __LINE__; $status = write2CommandLine( $session, "SET DELAY 2" , '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DELAY TIME SET") if ( not $status );

# Step 54. To step through the next 9 verbs with a 2 second delay between steps.
ln __LINE__; $status = write2CommandLine( $session, "STEP 9 AUTO" , '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I COUNTER=+0") if ( not $status );

# Step 56. The next steps will demonstrate how to ‘RUN’ to a specific line without having to step through each statement
ln __LINE__; $status = write2CommandLine( $session, "RUN TO" ,  ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "000853       COUNTER = COUNTER - 1;") if ( not $status );
ln __LINE__; $status = putCursorOnPanelSrting ( $session, "COUNTER = COUNTER - 1;") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I COUNTER=+6") if ( not $status );

# Step 57. 
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       STEP_SUB   = 2;                 /* PAUSE HERE */") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I STEP_SUB=-2 ") if ( not $status );

# Step 58. To execute the next 7 statements, then stop at the first statement of the STEP_PROC_SUBROUTINE
ln __LINE__; $status = write2CommandLine( $session, "STEP LABEL" , '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    STEP_PROC_SUBROUTINE: PROC") if ( not $status );

# Step 59. To execute the next 3 procedures, redisplaying the source code at the first statement of each procedure,
ln __LINE__; $status = write2CommandLine( $session, "STEP 3 LABEL AUTO" , '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 3 OF 3 EXECUTED") if ( not $status );

# Step 60. 
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULTS;RUN" , '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: STOP") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PAYEE = 1;                      /* PAUSE HERE */") if ( not $status );

# Step 62. Enter an address stop so that any modification on the field will be identified.
ln __LINE__; $status = write2CommandLine( $session, "STOP PAY_TOTAL" , '[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2324I ADDRESS STOP AT ") if ( not $status );

# Step 63. 
ln __LINE__; $status = write2CommandLine( $session, "LIST ADSTOP" , '[enter]') if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "        06            6  PAY_TOTAL") if ( not $status );

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);  

# Step 65
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PAY_TOTAL = PAY_TOTAL") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STOPPED BEFORE ADDRESS MODIFIED ") if ( not $status );

#STEP 66-67 The next 2 RUN commands will stop at the same modification of PAY_TOTAL.  It may appear stuck.
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PAY_TOTAL = PAY_TOTAL") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STOPPED BEFORE ADDRESS MODIFIED ") if ( not $status );

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PAY_TOTAL = PAY_TOTAL") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STOPPED BEFORE ADDRESS MODIFIED ") if ( not $status );

#STEP 68: If you enter  'LIST TRACK', you will see that the additional verbs ate actually being executed
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACK" , '[enter]') if ( not $status ); 
ln __LINE__; $status = verifyPanelMask  ( $session, "ListTrack.txt",1 )  if ( not $status );

# Step 69
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 70
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>       PAY_TABLE (PAYEE) = 0;") if ( not $status );  

# Step 71
ln __LINE__; $status = pressKey( $session, '[F6]') if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    END INIT_PAYEE_TABLE") if ( not $status ); 

# Step 72-73
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: BACKTRAC") if ( not $status ); 

ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    BACKTRACK_DEMO: PROC") if ( not $status ); 

# Step 74 To enable the collection of data, 
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK ON" , '[enter]') if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "BACKTRACK ON ") if ( not $status );   

# Step 75 To enable the collection of data
ln __LINE__; $status = write2CommandLine( $session, "KEEP TAX_CALC" , '[enter]') if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "02 TAX_CALC                        BASED CHAR(1)") if ( not $status );    

# Step 76
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);

# Step 77 At this point, over 2000 statements have executed.  Two of those statements modified
#         the field TAX_CALC.  To determine which statement was statement was the last to modify 
#         that field:  
ln __LINE__; $status = write2CommandLine( $session, "RUN BACKWARD TO TAX_CALC  MOD" , '[enter]') if ( not $status ); ; 
ln __LINE__; $status = findStringOnPanel( $session, "BKTR=>          TAX_CALC = 'N'") if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "REVIEWING BACKTRACK HISTORY") if ( not $status ); 

# Step 78
ln __LINE__; $status = write2CommandLine( $session, "STEP BACK 5 AUTO", '[enter]') if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "BKTR=>       CALL BACK_PROC6") if ( not $status ); 

# Step 79
ln __LINE__; $status = write2CommandLine( $session, "RUN TO TAX_CALC MOD", '[enter]') if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, "BKTR=>       UNEMPL_TAX = 'Y';") if ( not $status ); 

# Step 80
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP", '[enter]') if ( not $status ); 
 
# Step 81
ln __LINE__; $status = write2CommandLine( $session, "SET BACKTRACK OFF;RUN", '[ENTER]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: NOSOURCE") if ( not $status ); 
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    NOSOURCE_DEMO: PROC;               /* PAUSE HERE */") if ( not $status ); 

# Step 83
ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW ON",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASMVIEW ON ") if ( not $status ); 

# Step 84
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);

# Step 85
ln __LINE__; $status = write2CommandLine( $session, "STEP 4 AUTO",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STEP 4 OF 4 EXECUTED") if ( not $status ); 

# Step 86
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: LOOP") if ( not $status ); 

# Step 87
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    LOOP_DEMO: PROC;                   /* PAUSE HERE */ ") if ( not $status );
 
# Step 88
ln __LINE__; $status = write2CommandLine( $session, "RUN",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    END LOOP_DEMO;                     /* PAUSE HERE */") if ( not $status );

# Step 89
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STMTS SORTED BY DESCENDING COUNT") if ( not $status ); 

# Step 90
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS ASCENDING",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STMTS SORTED BY ASCENDING COUNT") if ( not $status ); 

# Step 91
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING LABEL",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "LABELS SORTED BY DESCENDING COUNT") if ( not $status ); 

# Step 92
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS LINE",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "LABELS SORTED BY LINE NUMBER") if ( not $status ); 

# Step 93
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 94
ln __LINE__; $status = write2CommandLine( $session, "RUN",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: SUBPROG") if ( not $status ); 
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>    CALL_PLI_SUBPROG: PROC;            /* PAUSE HERE */") if ( not $status ); 

# Step 96 The next steps will demonstrate the ability of SmartTest to track the load and execution
# of a separately compiled and linked PLI program (VIAPLIS).
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "VIAPLIS.VIAPLIS1") if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>   VIAPLIS: PROC OPTIONS(FETCHABLE);") if ( not $status ); 

# Step 97
ln __LINE__; $status = write2CommandLine( $session, "BREAK CALL",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "1 BREAK(S) INSERTED ") if ( not $status ); 

# Step 98 To establish addressability.
ln __LINE__; $status = pressKey( $session, '[F6]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>     WD_PTR = ADDR(WEATHERDATA);") if ( not $status ); 

# Step 99 -100 
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[DOWN]',25) if (not $status);
ln __LINE__; $status = pressKeys( $session, "ZD") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 101 
ln __LINE__; $status = write2CommandLine( $session, "SET STATUS OFF",'[ENTER]' ) if ( not $status );

# Step 102 
ln __LINE__; $status = write2CommandLine( $session, "STEP 10 AUTO",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 10 OF 10 EXECUTED") if ( not $status ); 

# Step 103 
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "ASG2412I 2ND SUBSCRIPT OF HIGH_TEMP ABOVE MAX(12).") if ( not $status );

# Step 104 
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 2 OF 2 EXECUTED") if ( not $status );  

# Step 105 
ln __LINE__; $status = write2CommandLine( $session, "KEEP MSGA; KEEP MSGB",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "01 MSGA                            BASED CHAR(15)") if ( not $status );  

# Step 106 
ln __LINE__; $status = write2CommandLine( $session, "STEP 6 AUTO",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 6 OF 6 EXECUTED") if ( not $status );  

# Step 107 
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 2 OF 2 EXECUTED") if ( not $status );  

# Step 108 
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP",'[ENTER]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>     INIT_BLK_PTR -> SWITCHES = 'TFF'") if ( not $status );  

# Step 109
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[DOWN]',13) if (not $status);
ln __LINE__; $status = pressKeys( $session, "ZD") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 110
ln __LINE__; $status = pressKey( $session, '[F6]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "01 INIT_BLK_PTR                    PTR") if ( not $status );		
ln __LINE__; $status = findStringOnPanel( $session, "01 SWITCHES                        BASED CHAR(10") if ( not $status );

# Step 111
ln __LINE__; $status = write2CommandLine( $session, "SET STATUS ON",'[ENTER]' ) if ( not $status );

# Step 112
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 113
ln __LINE__; $status = findStringOnPanel( $session, "TEST ENDED, RC=0") if ( not $status );

# Step 114
ln __LINE__; $status = write2CommandLine( $session, "CAN;Q CAN ALL", '[enter]'  ) if ( not $status );
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;