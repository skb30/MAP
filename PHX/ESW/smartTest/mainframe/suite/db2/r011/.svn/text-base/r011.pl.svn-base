###############################################################################
#
# TEST SCRIPT: QA-TCD-ST-7.7.1-R011.doc  
#		
# Script  
# DESCRIPTION: Setup and Run the ST/DB2 (10.1) for a Batch program test.
# DATE: 6/13/2012
# CJM  DB2LIB for DBEQ should be "qal.phx.eswautoh.db2.jcl2"
# CJM  DB2LIB for DAEQ should be "qal.phx.eswautoh.db2.jcl"

# Make sure that STC QAPHXBCF is up. sysp.user.proclib
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
my $db2lib  	      = $configRef->{'db2lib'};
my $db2load	          = $configRef->{'db2load'};
my $ispprof           = $configRef->{'Ispprof'};
my $hlq               = $configRef->{'TestDataHLQ'. '.'};
my $akrcob            = $configRef->{'AKRCOB'}; 
my $clist             = $configRef->{'Clist'}; 
my $akrasm            = $configRef->{'AKRASM'}; 
my $akrpli            = $configRef->{'AKRPLI'};         
my $loadcob           = $configRef->{'LOADCOB'};                
my $loadasm           = $configRef->{'LOADASM'};              
my $loadpli           = $configRef->{'LOADPLI'};
my $db2subsys	      = $configRef->{'Db2subsys'};			
package MAP;
init;
my $status = 0;
ln __LINE__; $session = startSession($sessionID);
ln __LINE__; $status = Eswtool::initProfile($session);


# get the current date and return it in ddmmmyyyy (12JUN2012 for ej)
$date = Util::check_date; 
# Step 1-2
## Go option 6
ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);
# Step 3
ln __LINE__; $status = write2CommandLine( $session, "CENTER", '[enter]' ) if ( not $status );

# Step 4
ln __LINE__; $status = write2CommandLine( $session, "ST", '[enter]' ) if ( not $status );
ln __LINE__; $status = navigate2DropDownList ($session, "Options", "Log/list/punch..." ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[tab]',16) if (not $status);
ln __LINE__; $status = pressKeys ($session, "//QA056ALG") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[f3]',1) if (not $status);
# Step 5
ln __LINE__; $status = write2CommandLine( $session, "AN ", '[enter]' ) if ( not $status );

# Step 6 - 7
my $form = tie(
	%form, Tie::IxHash,             
	
#	'Data set name'        => "'$db2lib(CPLDBTCH)'",
 	'Data set name'        => "'$db2lib(CPLDBT51)'",
    'Understand: ' 	   	   => 'Y',
    'Test:'   	           => 'Y',
    'Extended Analysis:'   => 'Y',
    'Document:'            => 'N',
    'Re-engineer:'         => 'N',
    'AKR data set name'    => "'$akrcob'",
	'Compile? (Y/N) . . . . . . . . .'   => 'Y',
	'Link load module reusable? (Y/N)'   => 'Y',
		   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 8
ln __LINE__; $status = write2CommandLine( $session, "AKR", '[enter]' ) if ( not $status );

# Step 9
$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name . .'        => "'$akrcob'",
	   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
# check that VIAPCOB in the directory has  today’s date.
ln __LINE__;  findStringOnPanel( $session, "ESWDBTCH   __________            IN,STX    $date" );

# Step 10
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 11
ln __LINE__; $status = write2CommandLine( $session, "ENV", '[enter]' ) if ( not $status );

# Step 12
ln __LINE__; $status = write2CommandLine( $session, "L", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[TAB]') if (not $status);

# Step 13 Application Knowledge Repositaries (AKR)

ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Knowledge Repositories (AKR):')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$akrcob'")  if ( not $status );
# Application Load Libraries: 
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Load Libraries:')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$loadcob' ")  if ( not $status );
#ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
#ln __LINE__; $status = pressKeys( $session, "'$db2load'")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'CEE.SCEERUN' ")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);


#step 14
#  Environment Selection TSO DB2 Environment
ln __LINE__; $status = write2CommandLine( $session, "T2", '[enter]' ) if ( not $status );

# Step 15
$form = tie(
	%form, Tie::IxHash,             
	
	'Load module'        		 => "ESWDBTCH",
	'DB2 Plan name  '            => "ESWDBTCH",  
    'Break on entry (Y/N)'		 => "YES",
    'DB2 Subsystem  '            => "$db2subsys",
    'Deallocate after test  '	 => "NO",
    'Data set name  '            => "'$clist'",
	'Member . . . . '            => "JOBDBTCH",
	'Deallocate after test  '	 => "NO",	   
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
#  C Convert batch JCL to TSO CLIST
ln __LINE__; $status = write2CommandLine( $session, "W", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Test - Setup Wizards (Batch - JCL Specification)" )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "VPPWZBTJ" )if ( not $status );

# Step 16
$form = tie(
	%form, Tie::IxHash,             
	
	'JCL   : '        		        => "'$db2lib'",
    'Member: '				        => "JOBDBTCH",
    
	
);

ln __LINE__; $status = write2Panel( $session, $form,'[enter]') if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "VPPWZBST" )if ( not $status );

# Step 17
ln __LINE__; $status = panelListAction($session, "STEP1", "S") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "VPPWZBLM" )if ( not $status );

# Step 18
ln __LINE__; $status = write2PanelField( $session, "Load Module to test: ", "ESWDBTCH", ) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "VPPWZBLM" )if ( not $status );
ln __LINE__; $status = pressKey( $session, '[Enter]') if (not $status);

# Step 19 Confrim AKR and Loadlib verification
ln __LINE__; $status = findStringOnPanel( $session, "VPPWZBAV" )if ( not $status );
ln __LINE__; $status = pressKey( $session, '[Enter]') if (not $status);

# Step 20 
ln __LINE__; $status = findStringOnPanel( $session, "VPPWZBBP" )if ( not $status );
ln __LINE__; $status = write2PanelField( $session, "Setup break on entry for other program(s) (Y/N): ","Y", '[ENTER]' ) if (not $status);

# Step 21 Replace Test Session List Tailoring VIA*.VIA* to ESWDBTCH.ESWDBTCH
ln __LINE__; $status = findStringOnPanel( $session, "VPPSESSN" )if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[tab]', '4' )  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'ESWDBTCH.ESWDBTCH')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'no ')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'no ')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, 'yes')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ESWDBTCH.ESWDBTCH     YES    YES   YES   YES   NO    NO    YES    YES')  if ( not $status );


# step 22
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'VPPWZBFB')  if ( not $status );

# step 23 select 1.  TSO   - Set up test to run in TSO Foreground 1
ln __LINE__; $status = pressKeys( $session, "1") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'VPPWZBTD')  if ( not $status );

# Step 24
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'VPPALCL')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'Allocations from JCL')  if ( not $status );

# Step 25-26 INSERT SYSOUT, SYSTSPRT, VIAQUEUE (already inserted, no need to insert them)
ln __LINE__; $status = write2PanelField( $session, "Delete (Y/N)  ", "NO", ) if (not $status);
# 

# Step 27 
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "ASG2512I VERIFY PLAN NAME AND SUBSYSTEM ID AND ENTER 'R' TO RUN THE TEST.")  if ( not $status );

# Step 28 RUN : Begin DB2 test session
ln __LINE__; $status = write2CommandLine( $session, "R", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'BREAK AT START OF TEST SESSION')  if ( not $status );

# Step 29
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'DECLARE CURSOR SQL RC = 00000000:')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'OPEN CURSOR SQL RC    = 00000000:')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'FETCH ROW SQL RC      = 00000000:')  if ( not $status );

# Step 30
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'ADD 1 TO WS-COUNTER-NUM.')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, '10 WS-COUNTER-NUM                  PIC S9(5) COMP-3    ')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ' VALUE > ...                               <  * INVALID NUMERIC')  if ( not $status );

# Step 31 Set WS-COUNTER-NUM to +1
ln __LINE__; $status = write2PanelField( $session, "VALUE >", "+1 ",'[ENTER]' ) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "SUCCESSFUL MEMORY UPDATE") if ( not $status );

# Step 32
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "CLOSE CURSOR SQL RC   = 00000000:") if ( not $status );

# Step 33
ln __LINE__; $status = pressKey( $session, '[enter]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "TEST ENDED, RC=0 ") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>      GOBACK") if ( not $status );

# Step 34
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "Test/Program View Entry") if ( not $status ); 

# Step 35-36
ln __LINE__; $status = write2CommandLine( $session, "CAN;Q CAN ALL", '[enter]'  ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "Test/Program View Entry") if ( not $status );

# Step 37
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, "ASG-ESW - Testing/Debugging") if ( not $status );

# Step 38 Rerun the test using the Extended Batch Connect facility       
ln __LINE__; $status = write2CommandLine( $session, "ENV", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Environment Selection") if ( not $status );

# Step 39
ln __LINE__; $status = write2CommandLine( $session, "B2", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DB2 Batch Session Setup") if ( not $status );

# Step 40 Generate the JCL
$form = tie(
	%form, Tie::IxHash,             
	
	'Load module'        		 => "ESWDBTCH",
	'Break on entry (Y/N)'		 => "YES",
    'Break CSECT/Program  '      => "ESWDBTCH",
    'Step Name      '            => "STEP1",
    'Pgm Library    '            => "'$loadcob'",
    'Data set name  '            => "'$db2lib'",
	'Member . . . . '            => "JOBDBTC2",
    'Data set name&  '           => "'$db2lib'",
	'Member . . . .& '           => "JOBDBTCG",
	'Use ENV Libs (Y/N)' 	     => "NO",	   
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "G", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "JCL GENERATED" )if ( not $status ); 

# Step 41 Edit Generated JCL
ln __LINE__; $status = write2CommandLine( $session, "EG", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ISREDDE2" )if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 42-44 Submit Generated JCL
ln __LINE__; $status = write2CommandLine( $session, "SG", '[enter]' ) if ( not $status );

ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ASG2076I") if ( not $status );

sleep(1); 
# Step 45 Connect to submitted job
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status ); 

# Step 46
sleep(10);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 
ln __LINE__; $status = panelListAction($session, "JOBDBTC2", "S") if ( not $status );
sleep(3);

#ln __LINE__; $status = findStringOnPanel( $session, "ASG2087I ASG-SMARTTEST IS NOW CONNECTED TO THE BATCH REGION" )if ( not $status );
# Step 47
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "BREAK ON ENTRY TO A PROGRAM" )if ( not $status ); 
#first RUN handles the break on entry set in the DB2 SETUP, this RUN causes the OC7 
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
sleep(2);
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>      ADD 1 TO WS-COUNTER-NUM." )if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DATA EXCEPTION (0C7)" )if ( not $status );

# Step 48 Set WS-COUNTER-NUM to +1
ln __LINE__; $status = write2PanelField( $session, "VALUE >", "+1 ",'[ENTER]' ) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "SUCCESSFUL MEMORY UPDATE") if ( not $status );

# Step 49
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
sleep(4);
ln __LINE__; $status = findStringOnPanel( $session, "TEST ENDED, RC=0" )if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 

# Step 50
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
# wait for batch job to end 
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
# Step 51 Check that no jobs are waiting for connection
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status ); 
ln __LINE__; $status = pressKeyRepeat( $session, '[ENTER]',1) if (not $status); 
ln __LINE__; $status = verifyStringNotFoundOnPanel( $session, "WAITING FOR CONNECTION" )if ( not $status );
ln __LINE__; $status = verifyStringNotFoundOnPanel( $session, "JOBDBTC2" )if ( not $status );

# Step 52-55
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;