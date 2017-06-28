###############################################################################
#
# TEST SCRIPT: QA-TCD-ST-7.7.1-R008.doc  
#		
# Script  
# DESCRIPTION: Execute the ST/CICS Assembler IVP
# DATE: 02/04/2013
# CJM 
#################################################################################
use Hllapi;
use PROJCL::ProJcl;
use Tie::IxHash;
use MAP;
use ESW::Eswtool;
 
my $time = 10;
my $configRef 		  = Cfg::getcfg();
my $sessionID  		  = $configRef->{'SessionID'};
my $userID            = $configRef->{'UserID'};
my $execclist         = $configRef->{'Exec'};
my $cntlLib 	      = $configRef->{'CntlLib'};
my $ispprof           = $configRef->{'Ispprof'};
my $akrcobol          = $configRef->{'AKRCOBOL'}; 
my $akrasm            = $configRef->{'AKRASM'}; 
my $akrpli            = $configRef->{'AKRPLI'};         
my $loadcobol         = $configRef->{'LOADCOBOL'};                
my $loadasm           = $configRef->{'LOADASM'};              
my $loadpli           = $configRef->{'LOADPLI'}; 
my $cicsapplid        = $configRef->{'CICSApplid'}; 
my $status = 0;
package MAP;
ln __LINE__; init;


package MAP;
ln __LINE__; $session = startSession($sessionID);
ln __LINE__; $status = Eswtool::initProfile($session);


# get the current date and return it in ddmmmyyyy (12JUN2012 for ej)
$date = Util::check_date; 

## Go option 6
ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);
ln __LINE__; $status = write2CommandLine( $session, "CENTER", '[enter]' ) if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "ST ", '[enter]' ) if ( not $status );

# Step 7
# navigate to the File pull down menu and choose Setup test environment
ln __LINE__; $status = navigate2DropDownList ($session, "File", "Compile/Analyze" ) if ( not $status );

# step 8-9

my $form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        => "'qal.phx.eswauto.jcl2(VIACJASM)'",
 #   'Understand: ' 	   	   => 'N',
    'Test:'   	           => 'Y',
    'Extended Analysis:'   => 'N',
#    'Document:'            => 'N',
    'AKR data set name'    => "'$akrasm'",
    # if the Re-engineer field is missing from the panel then check the 
    # the license key. The Encore product needs to licensed for this field
    # to display. 
#    'Re-engineer:'         => 'N',
	'Compile? (Y/N) . . . . . . . . .'   => 'Y',
	'Link load module reusable? (Y/N)'   => 'Y',
		   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );

# step 10
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 11
ln __LINE__; $status = write2CommandLine( $session, 'AKR', '[enter]' ) if ( not $status );

# Step 12
$form = tie(
	%form, Tie::IxHash,             
	
	'Data set name . .'        => "'$akrasm'",
   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
# make sure that VIACASM has today's date
ln __LINE__; $status = findStringOnPanel( $session, "$date" ) if ( not $status );
# Step 13
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 14
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 15
ln __LINE__; $status = write2CommandLine( $session, "ENV", '[enter]' ) if ( not $status );

# Step 16
ln __LINE__; $status = write2CommandLine( $session, "L", '[enter]' ) if ( not $status );

# Step 17 find first input field and Enter Repositories files.
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Knowledge Repositories (AKR):')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$akrasm'")  if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[tab]',4)  if ( not $status );
# find second input field and enter the load lib
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Load Libraries:')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$loadasm'")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

#   STEP 18 Transaction/ Other Environments S1 - CICS
ln __LINE__; $status = write2CommandLine( $session, 'S1', '[enter]' ) if ( not $status );

# Step 19

$form = tie(
	%form, Tie::IxHash,
	'CICS Logon Region APPLID'    => "$cicsapplid",
	'Toggle PFKEY  . .'           => "PF12",
	'Break at Start (Y/N)  .'     => "Y",
	
);
ln __LINE__; $status = write2Panel( $session, $form  ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );

# Step 20
ln __LINE__; $status = pressKey( $session, '[clear]')  if ( not $status );

# step 21
ln __LINE__; $status = pressKey( $session, '[f12]')  if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'ASG-SmartTest-CICS is active.')  if ( not $status );

# step 22
ln __LINE__; $status = pressKey( $session, '[clear]')  if ( not $status );

# Step 23
ln __LINE__; $status = pressKey( $session, '[f12]')  if ( not $status ); 
ln __LINE__; $status = findStringOnPanel( $session, 'CICS Session is connected')  if ( not $status );

# Step 24
ln __LINE__; $status = write2CommandLine( $session, "NEW VIACASM", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'NEWCOPY SUCCESSFUL ')  if ( not $status );

# Step 25
ln __LINE__; $status = write2CommandLine( $session, "T", '[enter]' ) if ( not $status );

# Step 26
ln __LINE__; $status = pressKeys( $session, "VASM", '[enter]' ) if ( not $status );

# Step 27 
ln __LINE__; $status = write2CommandLine( $session, "UP MAX", '[enter]' ) if ( not $status );

# Step 28 
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULT", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'TEST OPTIONS DEFAULTED ')  if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "SET GREGS ON", '[enter]' ) if ( not $status );

# Step 29 Enable execution tracking of 2,000 machine instructions
ln __LINE__; $status = write2CommandLine( $session, "SET TRACK 2000", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'TRACK SIZE SET ')  if ( not $status );

# Step 30
ln __LINE__; $status = write2CommandLine( $session, "LIST TAILOR", '[enter]' ) if ( not $status );

# Step 31 - Step 32
ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',6) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESNO ") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',3) if (not $status);
ln __LINE__; $status = pressKeys( $session, "I") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

ln __LINE__; $status = pressKeys( $session, "IEFBR14.IEFBR14  ") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYESYES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanel ( $session, "ListTailoring.txt",1 ) if (not $status);

# Step 33
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 34
# BREAK BEFORE PAUSE ALL;RUN  command WILL PLACE A BREAKPOINT AT PREDETERMINED LOCATIONS IN THE SOURCE
# THAT HAVE 'PAUSE' IN THE TEXT, THEN BEGIN THE TEST SESSION.               
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN", '[enter]' ) if ( not $status );

sleep($time);
#  Step 36 Execute 2 thru 12.
ln __LINE__; $status = pressKeys( $session, "1") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanelMask ( $session, "ProgramView.txt",1 ) if (not $status);

####### Print compiler used.
ln __LINE__; $status = write2CommandLine( $session, "li comp", '[enter]' ) if ( not $status );
my $row = "Compiler  : ";
my $rowline = copyTextFromScreen($session,$row,39,0);
Util::printStatus( 0, "$rowline" );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
#########  

# Step 37
ln __LINE__; $status =Eswtool::pressKeyF4( $session, 20) if (not $status);

ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>  S0C7     AP    S0C7WORK,=P'1'         TRY TO INCREMENT A " )if ( not $status );
                                               
# Step 38
ln __LINE__; $status = pressKeys( $session, "1") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "SUCCESSFUL MEMORY UPDATE" )if ( not $status );

# Step 39 S0C4 example
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status =  findStringOnPanel( $session, "STORAGE VIOLATION " )if ( not $status );


#  Step 40 to fix SC04 and continue
ln __LINE__; $status = write2CommandLine( $session, "MOVE R14 TO R15", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

#step 41
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

# Step 42  
ln __LINE__; $status = write2CommandLine( $session, "LIST TABLE GLOBAL STORAGE", '[enter]' ) if ( not $status );

# Check to see if we have leftover data on the panel. If we do then delete it before doing the ZA command. 
ln __LINE__; $status =  findStringOnPanel( $session, "PGM  VIACASM   00000   009184  YES",0,1 )if ( not $status );
ln __LINE__; if ($status == 0) {
	pressKey( $session, 'd'); 
	pressKey( $session, '[enter]'); 
} else {
	$status = 0;
}
#verify only one screen
ln __LINE__; $status =  verifyPanel( $session, "Storage-spec.txt",1) if (not $status);

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACK", '[enter]' ) if ( not $status );

# Step 43
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',24) if (not $status);
ln __LINE__; $status = pressKeys( $session, "S" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 44 
# This is the instruction that caused the incorrect address to be placed into R15. 
# It should be a LOAD ADDRESS (‘LA’) instead of a LOAD (‘L’) instruction.  Instead of pointing
# R15 to PATCH00, it loaded the instruction at PATCH00 into R15.  
# To display the disassembled object code for the offending instruction, enter a zoom assembler 
#(ZA) command on the following line in the program;
ln __LINE__; $status = pressKeyRepeat( $session, '[LEFT]',8) if (not $status); 
ln __LINE__; $status = pressKeys( $session, "ZA" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 

# Step 45 Enter ‘L’ on the 1st byte of the instruction offset to link to the ‘List Memory’
# screen and display the program at that offset
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status); 
ln __LINE__; $status = pressKeys( $session, "L" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "58F0C53C" )if (not $status);

# Step 46
ln __LINE__; $status = putCursorOnPanelSrting( $session, '58F0C53C')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "41" ) if ( not $status ); 
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "41F0C53C" ) if (not $status);
#######ln __LINE__; $status =  findStringOnPanel( $session, "SUCCESSFUL MEMORY UPDATE" ) if (not $status);

# Step 47
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 48
ln __LINE__; $status = write2CommandLine( $session, "Reset Zoom", '[enter]' ) if ( not $status );

# Step 49
ln __LINE__; $status = write2CommandLine( $session, "LIST TABLE GLOBAL STORAGE", '[enter]' )  if ( not $status ); 
ln __LINE__; $status = verifyPanel ( $session, "StorageSpec.txt",1 ) if (not $status);

# Step 51
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 52
ln __LINE__; $status = Eswtool::pressKeyF4( $session, 10) if (not $status);

# Step 53 
ln __LINE__; $status = pressKeyRepeat( $session, '[F7]',2) if (not $status);
 
#ln __LINE__; $status =  findStringOnPanel( $session, "001052  XPATCH   L     R15,PATCH00          POINT TO BRANCH LOCATION" );
ln __LINE__; $status =  findStringOnPanel( $session, "XPATCH   L     R15,PATCH00          POINT TO BRANCH LOCATION" );
                                                                
# Step 54
#ln __LINE__; $status = putCursorOnPanelSrting( $session, '001050  STOPFIX  B')  if ( not $status );
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'XPATCH   L     R15,PATCH00')  if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[left]',8) if (not $status);
ln __LINE__; $status = pressKeys( $session, "GO" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 55 'RUN’ to execute patched instruction and continue to the STEP example
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status =  findStringOnPanel( $session, "THIS EXAMPLE SHOWS SMARTTEST'S ADDRESS STEPPING FEATURES" ) if (not $status);

# Step 56 
ln __LINE__; $status = write2CommandLine( $session, "STEP 5 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>           BAL   R14,XSTEPSUB           PERFORM SUBROUTINE" ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG2163I STEP 5 OF 5 EXECUTED" ) if ( not $status );

# Step 57
ln __LINE__; $status = write2CommandLine( $session, "STEP OVER", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, ">>>>>>           B     COMPLETE               GO FINISH THIS TEST", '[enter]' ) if ( not $status );
 
 # Step 58
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACKING", '[enter]' ) if ( not $status );

# Step 59
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>           B     COMPLETE               GO FINISH THIS TEST") if ( not $status );

# Step 60
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status);

ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>  PAUSE001 L     R14,4(,R14)            POINT TO MIDDLE OF CHAIN") if ( not $status );

 # Step 61
ln __LINE__; $status = write2CommandLine( $session, "KEEP R14? LEN 16",'[ENTER]', ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "R14?                               DS CL16" ) if (not $status);

# Step 62
ln __LINE__; $status = write2CommandLine( $session, "KEEP R14?+4? LEN 16", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "R14?+4?                            DS CL16" ) if (not $status);

# Step 63
ln __LINE__; $status = write2CommandLine( $session, "KEEP R14?+0?+8 CHAR LEN 8 ", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "R14?+0?+8                          DS CL8" ) if (not $status); 

#  Step 64 To watch the values as R14 changes
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO ", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STEP 2 OF 2 EXECUTED" ) if (not $status);
 
# Step 65
ln __LINE__; $status = write2CommandLine( $session, "DI  R12?+X'3A' CHAR LEN 16", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I R12?+X'3A'='" ) if (not $status);
# Step 66
ln __LINE__; $status = write2CommandLine( $session, "ZD R15%%+X'C4'%+X'10' CHAR", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "R15%%+X'C4'%+X'10'                 DS CL4" ) if (not $status);
# Step 67                                                      
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP;RESET ZOOM;RUN ", '[enter]' ) if ( not $status );
sleep($time) ;
ln __LINE__; $status = findStringOnPanel( $session, "PAUSE999 ST    R0,LOOPCTR            SAVE LOOP COUNTER" ) if (not $status);

# Step 68
# This example shows processing of multiple DSECTS, as well as some data and 
# register viewing techniques.
ln __LINE__; $status = write2CommandLine( $session, "LIST REGS", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Reg    High       Low       Address identification      Data at address    >" ) if (not $status);

# Step 69
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 70
ln __LINE__; $status = write2CommandLine( $session, "SET REGS ON", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "REGISTERS ON" ) if (not $status);

# Step 71
ln __LINE__; $status = pressKeyRepeat( $session, '[tab]',32) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[down]',3) if (not $status);
#ln __LINE__; $status = pressKeyRepeat( $session, '[tab]',46) if (not $status);
ln __LINE__; $status = pressKeys( $session, "LX")  if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 72
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

#  step 73
ln __LINE__; $status = write2CommandLine( $session, "SET REGS OFF", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "REGISTERS OFF" ) if (not $status);


# Step 74 To keep an entire DSECT displayed as one data item at the top of the screen,
ln __LINE__; $status = write2CommandLine( $session, "KEEP CPYDSECT", '[enter]' ) if ( not $status );

# step 75
# To watch the value of the data items change with each instruction,
ln __LINE__; $status = write2CommandLine( $session, "SET OPERANDS ON", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "OPERANDS ON" ) if (not $status);

#  step 76 
ln __LINE__; $status = write2CommandLine( $session, "STEP 15 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>           BAL   R10,BLDENTRY           BUILD TABLE IN MEMORY" ) if (not $status);

# step 77
ln __LINE__; $status = write2CommandLine( $session, "SET OPERANDS OFF", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "OPERANDS OFF" ) if (not $status);

# Step 78
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP", '[enter]' ) if ( not $status );

# Step 79
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
sleep($time) ;

#Step 80
# This example will randomly corrupt one of the first 256 bytes of this program.
# To use SmartTest to identify the instruction that is corrupting the program, 
# set an address stop as follows, 
ln __LINE__; $status = write2CommandLine( $session, "STOP R12? LENGTH 256", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2324I ADDRESS STOP AT " ) if (not $status);

# Step 81
ln __LINE__; $status = write2CommandLine( $session, "LIST ADSTOP", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Address Stop Entry" ) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "R12?" ) if (not $status);

# Step 82
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 83
# Note:  the program will generate a random address to corrupt and ST will stop 
# the modification from happening.
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status); 
ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>           ST    R15,0(,R14)            CORRUPT THIS PROGRAM(OVERLAY)" ) if (not $status);

# Step 84
ln __LINE__; $status = write2CommandLine( $session, "WHERE R14", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG2057I ADDRESS " ) if (not $status);

# Step 85
ln __LINE__; $status = write2CommandLine( $session, "STEP", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>  STOPFIX  B     COMPLETE               GO FINISH THIS TEST"  ) if (not $status);

# Step 86
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
sleep($time) ;
ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>           XR    R15,R15" ) if (not $status);
 
#  step 87
ln __LINE__; $status = write2CommandLine( $session, "List Limits", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "Transaction Limits and Options" ) if (not $status);

# Step 88
ln __LINE__; $status = write2PanelField( $session, "Intercept SVCs . . ", "NO ",'[enter]' ) if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "Intercept SVCs . . NO      (YES or NO)" ) if (not $status); 

# Step 89
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 90
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
sleep($time) ;
ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>  PAUSE003 BALR  R14,R15                    'CALL' IEFBR14" ) if (not $status); 

# Step 91
ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW ON", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASMVIEW ON" ) if (not $status);

# Step 92
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status); 

ln __LINE__; $status =  findStringOnPanel( $session, "IEFBR14.IEFBR14 " ) if (not $status); 

# Step 93
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 2 OF 2 EXECUTED") if (not $status);

# Step 94
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACKING", '[enter]' ) if ( not $status );

# Step 95
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

# Step 96
ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW OFF;RUN", '[enter]' ) if ( not $status );
sleep($time) ;
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PAUSE006 SR    R0,R0                  ZERO WORK REG " ) if (not $status);

# Step 97
ln __LINE__; $status = write2CommandLine( $session, "LIST FLOAT;STEP 10 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2163I STEP 10 OF 10 EXECUTED" ) if (not $status);

# Step 98
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

# Step 99
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status); 

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PAUSE070 SR    R0,R0                  ZERO WORK REG " ) if (not $status);

# Step 100
ln __LINE__; $status = write2CommandLine( $session, "LIST LIMITS", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Transaction Limits and Options" ) if ( not $status );

# Step 101
ln __LINE__; $status = write2PanelField( $session, "Storage protection ","YES",'[enter]' ) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "Storage protection YES     (YES or NO)" ) if ( not $status );

# Step 102
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

# Step 103
ln __LINE__; $status = write2CommandLine( $session, "LIST TABLE GLOBAL STORAGE", '[enter]' ) if ( not $status );
ln __LINE__; $status = verifyPanel ( $session, "StorageSpec2.txt",1 ) if (not $status);

# Step 104
ln __LINE__; $status = pressKeys( $session, "PGMVIACASM") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',3) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanel ( $session, "StorageSpec3.txt",1 ) if (not $status);

# Step 105
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

# Step 106
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
sleep($time) ;
ln __LINE__; $status = findStringOnPanel( $session, "STATUS: STOR. VIOL. AGAINST PGM=VIACASM" ) if (not $status);

# Step 107
ln __LINE__; $status = write2CommandLine( $session, "WHERE R1", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2057I ADDRESS " ) if (not $status);

# Step 108
ln __LINE__; $status = write2CommandLine( $session, "STEP FORCE", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>           MVC   1(0,R14),0(R14)        PROPAGATE THRU REST OF RENTDATA" ) if (not $status);

# Step 109
ln __LINE__; $status = write2CommandLine( $session, "STEP", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  BREAK." ) if (not $status);

# Step 110
ln __LINE__; $status = write2CommandLine( $session, "LIST TABLE GLOBAL STORAGE", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "''' PGM  VIACASM   00000   009184  YES" ) if (not $status);

# Step 111 
ln __LINE__; $status = pressKeys( $session, "D") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanel ( $session, "StorageSpec4.txt",1 ) if (not $status);

# Step 112
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

# Step 113
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' ) if ( not $status );
sleep($time) ;

# Step 114
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status); 

ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  PAUSE004 B     COMPLETE               READY FOR 'LOOP' DEMO" ) if (not $status); 

 # Step 115 To sort statement counts on descending order
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "SORTED BY DESCENDING COUNT" ) if (not $status);

# Step 116 To sort unexecuted statements to the top
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS ASCENDING", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "SORTED BY ASCENDING COUNT" ) if (not $status);

# Step 117 To list the execution counts by ascending source line number
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS LINE", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STMTS SORTED BY LINE NUMBER" ) if (not $status);

# Step 118 To display only statements containing Assembler labels.  This can be used to see which routines
#          are executed the most (or least) amount of times, depending on the optional parms of ascending 
#           or descending.
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS LABEL DESCENDING", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "LABELS SORTED BY DESCENDING COUNT  " ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);    

#  Step 119
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status); 

# Step 120
ln __LINE__; $status = write2CommandLine( $session, "X", '[enter]',"==>" ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, ">>>>>>  VIACASM  DFHEIENT CODEREG=(12,8)" ) if (not $status);

#  Step 121
ln __LINE__; $status = Eswtool::pressKeyF4( $session) if (not $status); 

ln __LINE__; $status = findStringOnPanel( $session, "ASSEMBLER DEMONSTRATION" ) if (not $status);
ln __LINE__;  $status = findStringOnPanel( $session, "*COMPLETED*" ) if (not $status); 

#  Step 122
ln __LINE__; $status = pressKey( $session, '[CLEAR]') if (not $status); 

#  Step 123
ln __LINE__; $status = pressKey( $session, '[F12]') if (not $status); 

# Step 124
ln __LINE__; $status = write2CommandLine( $session, "CAN;Q CAN ALL", '[enter]'  ) if ( not $status );
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;