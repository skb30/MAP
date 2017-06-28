###############################################################################
#
# TEST SCRIPT: QA-TCD-ST-7.7.1-R005.doc  
#		
# Script  
# DESCRIPTION: Test the IVP’s for SmartTest/ASM.
# DATE: 11/01/2012
# CJM 
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
my $hlq               = $configRef->{'TestDataHLQ.'};
my $clist             = $configRef->{'Clist'};
my $akrcob            = $configRef->{'AKRCOB'}; 
my $akrasm            = $configRef->{'AKRASM'}; 
my $akrpli            = $configRef->{'AKRPLI'};         
my $loadcob           = $configRef->{'LOADCOB'};                
my $loadasm           = $configRef->{'LOADASM'};              
my $loadpli           = $configRef->{'LOADPLI'};
my $compileJCL        = 'qal.phx.eswauto.jcl2';

package MAP;
init;;
$session = startSession($sessionID);
my $status = 0;
ln __LINE__; $status = Eswtool::initProfile($session);

## Go option 6
ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);
#ln __LINE__; $status = write2CommandLine( $session, "tso ex 'QAL.PHX.ESW790AU.SCNXCLST(VIASPROC)' 'ADD(QAL.PHX.ESW790AU.SESWCLST)'", '[enter]' )if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "CENTER", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "ST ", '[enter]' ) if ( not $status );

# File analyze
ln __LINE__; $status = write2CommandLine( $session, "AN ", '[enter]' ) if ( not $status );

my $form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        => "'qal.phx.eswauto.jcl2(VIAPASMA)'",
 #   'Understand: ' 	   	   => 'Y',
    'Test:'   	           => 'Y',
    'Extended Analysis:'   => 'Y',
 #   'Document:'            => 'N',
 #   'Re-engineer:'         => 'N',
    'AKR data set name'    => "'$akrasm'",
	'Compile? (Y/N) . . . . . . . . .'   => 'Y',
	'Link load module reusable? (Y/N)'   => 'N',
		   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status = write2CommandLine( $session, "AKR", '[enter]' ) if ( not $status );

my $form = tie(
	%form, Tie::IxHash,             
	
	'Data set name . .'        => "'$akrasm'",
   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "ENV", '[enter]' ) if ( not $status );


#  Environment Selection MVS    (PGM=program) T1
ln __LINE__; $status = write2CommandLine( $session, "T1", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "SET DEFAULT", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "SET TRACK 9999", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "LIST TAILOR", '[enter]' ) if ( not $status );


ln __LINE__; $status = pressKey( $session, '[HOME]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',6) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',3) if (not $status);
ln __LINE__; $status = pressKeys( $session, "I") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

ln __LINE__; $status = pressKeys( $session, "IEFBR14.IEFBR14  ") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status);
ln __LINE__; $status = pressKeys( $session, "YESYESYES") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
#ln __LINE__; $status = verifyPanel ( $session, "ListTailoring.txt",1 ) if (not $status);

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "LIST INTERCEPT", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',1) if (not $status);
ln __LINE__; $status = pressKeys( $session, "IEFBR14") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "ENV", '[enter]' ) if ( not $status );

# Had to add the L option in order to get to AKR panel whereas before we got put into AKR just by entering ENV
ln __LINE__; $status = write2CommandLine( $session, "l", '[enter]' ) if ( not $status );
# Application Knowledge Repositaries (AKR)
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Knowledge Repositories (AKR):')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$akrasm'")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status ); 

# find second input field and enter the load lib
ln __LINE__; $status = putCursorOnPanelSrting( $session, 'Application Load Libraries:')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[tab]')  if ( not $status );
ln __LINE__; $status = pressKeys( $session, "'$loadasm'")  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[enter]')  if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
# Use Current Environement
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );
my $form = tie(
	%form, Tie::IxHash,             
	
	'Load module'        		 => "VIAPASM",
    'Break on entry (Y/N)'		 => "NO ",
    'Execution parameters: '     => "ALL",
    'Deallocate'				 => "NO",
		   
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
#  C Convert batch JCL to TSO CLIST
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );

my $form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        		 => "'qal.phx.eswauto.jcl2'",
    'Member  . . .'				 => "VIAPASMJ",
    'Data set name&'        		 => "'$clist'",
    'Member  . . .&'				 => "VIAPASMJ",
	'Delete (Y/N)'					 => "NO",   
	'Step   (Y/N)'					 => "YES",
	'Subsystem'						 => "    ",
	'Step Name'						 => "STEP1"
	
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
# Step 30 R - Begin TSO test session (RUN)
ln __LINE__; $status = write2CommandLine( $session, "R", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "DEMONSTRATION OF: S0C7" )if ( not $status );
# Step 31
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "ALLOCATION SUCCESSFUL" )if ( not $status );

####### Print compiler used.
ln __LINE__; $status = write2CommandLine( $session, "li comp", '[enter]' ) if ( not $status );
my $row = "Compiler  : ";
my $rowline = copyTextFromScreen($session,$row,39,0);
Util::printStatus( 0, "$rowline" );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
#########

# BREAK BEFORE PAUSE ALL;RUN  command WILL PLACE A BREAKPOINT AT PREDETERMINED LOCATIONS IN THE SOURCE
# THAT HAVE 'PAUSE' IN THE TEXT, THEN BEGIN THE TEST SESSION.               
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN", '[enter]' ) if ( not $status );

#  Step 33 Change the value of DATA-PACKED-DEC
ln __LINE__; $status = pressKeys( $session, "1") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "SUCCESSFUL MEMORY UPDATE" )if ( not $status );
ln __LINE__; $status = verifyPanelMask( $session, "SC07.txt",1 )if (not $status);

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "DEMONSTRATION OF: S0C4" )if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanelMask ( $session, "S0C4.txt",1 )if (not $status);

# Go to fix SC04 and continue
ln __LINE__; $status = write2CommandLine( $session, "GO TO S0C4FIX;RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Use the following information to pass the Invalid Branch:
# Note: This example shows how to dynamically 'PATCH' an instruction.      
# SmartTest has stopped at a branch instruction that was going to branch to the address contained
# in register 15, but that address is not within a valid program.  We can use SmartTest’s dynamic
# execution tracking information to find out where R15 was set, then dynamically PATCH the ‘BUGGY’ code.     

ln __LINE__; $status = write2CommandLine( $session, "LIST TRACK", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',20) if (not $status);
# Select
ln __LINE__; $status = pressKeys( $session, "S" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
 
# This is the instruction that caused the incorrect address to be placed into R15. 
# It should be a LOAD ADDRESS (‘LA’) instead of a LOAD (‘L’) instruction.  Instead of pointing
# R15 to PATCH00, it loaded the instruction at PATCH00 into R15.  
# To display the disassembled object code for the offending instruction, enter a zoom assembler 
#(ZA) command on the following line in the program;
ln __LINE__; $status = pressKeyRepeat( $session, '[LEFT]',17) if (not $status); 
ln __LINE__; $status = pressKeys( $session, "ZA" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status); 
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',2) if (not $status); 
# Step 42 Enter ‘L’ on the 1st byte of the instruction offset to link to the ‘List Memory’
# screen and display the program at that offset
ln __LINE__; $status = pressKeys( $session, "L" ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "58F0C5B0" )if (not $status);

ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',6) if (not $status);
ln __LINE__; $status = pressKeys( $session, "41" ) if ( not $status ); 
ln __LINE__; $status =  findStringOnPanel( $session, "41F0C5B0" ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
# Step 45
ln __LINE__; $status = write2CommandLine( $session, "Reset Zoom", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',3) if (not $status);
ln __LINE__; $status = pressKeys( $session, "GO" ) if ( not $status ); 
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 47
ln __LINE__; $status = write2CommandLine( $session, "RUN", '[enter]' )  if ( not $status ); 
ln __LINE__; $status =  findStringOnPanel( $session, "DEMONSTRATION OF: STEP" );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "PAUSE005 LA    R14,1" )if (not $status);
ln __LINE__; $status = write2CommandLine( $session, "STEP 5 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "STEP 5 OF 5 EXECUTED" );
# Step 50 
ln __LINE__; $status = write2CommandLine( $session, "STEP OVER", '[enter]' ) if ( not $status );
ln __LINE__; $status = verifyPanel ( $session, "Stepover.txt",1 );
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACKING", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
# Step 53
ln __LINE__; $status = pressKey( $session, '[F8]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "SR    R15,R15                'RUN TO' THIS INSTRUCTION");
  
# Step 54
ln __LINE__; $status = write2CommandLine( $session, "RUN TO" ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[down]',33) if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
# Step 56
ln __LINE__; $status = write2CommandLine( $session, "SET GEN ON", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "GENERATED ON" )if (not $status);
# Step 57
ln __LINE__; $status = write2CommandLine( $session, "STEP LABEL", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "STEP LABEL" ) if (not $status);
# Step 58 
ln __LINE__; $status = write2CommandLine( $session, "SET GEN OFF", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "GENERATED OFF" )if (not $status);
# Step 59
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "DEMONSTRATION OF: ADDREXP" )if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# Step 61
#   At this point R14 points to the first entry in a circular chain of control blocks. 
#   The 1st full word in the block points to the prior entry in the chain, the 2nd full
#   word points to the next entry, and the remaining 8 bytes of each entry are the text
#   identifying the entry.
ln __LINE__; $status = write2CommandLine( $session, "KEEP R14? LEN 16", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "R14?                               DS CL16" ) if (not $status);
ln __LINE__; $status = write2CommandLine( $session, "KEEP R14?+4? LEN 16", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "R14?+4?                            DS CL16" ) if (not $status);
ln __LINE__; $status = write2CommandLine( $session, "KEEP R14?+0?+8 CHAR LEN 8 ", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "R14?+0?+8                          DS CL8" ) if (not $status); 

#  Step 64 To watch the values as R14 changes
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO ", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "STEP 2 OF 2 EXECUTED" ) if (not $status);
 
# Step 65
ln __LINE__; $status = write2CommandLine( $session, "DISPLAY R13%+4%+24%%+2 CHAR LEN 8", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASG2172I R13%+4%+24%%+2='ALL....." ) if (not $status);
# Step 66
ln __LINE__; $status = write2CommandLine( $session, "ZD R15%%+X'C4'%+X'10' CHAR", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "R15%%+X'C4'%+X'10'                 DS CL4" ) if (not $status);
# Step 67                                                      
ln __LINE__; $status = write2CommandLine( $session, "RESET KEEP;RESET ZOOM;RUN ", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: DSECT" );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "PAUSE999 ST    R0,LOOPCTR            SAVE LOOP COUNTER" );

# Step 69
# This example shows processing of multiple DSECTS, as well as some data and 
# register viewing techniques.
ln __LINE__; $status = write2CommandLine( $session, "LIST REGS", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Reg    High       Low       Address identification      Data at address    >" ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "SET REGS ON", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "REGISTERS ON" ) if (not $status);
#ln __LINE__; $status = pressKeyRepeat( $session, '[tab]',32) if (not $status);
#ln __LINE__; $status = pressKeyRepeat( $session, '[down]',3) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[tab]',46) if (not $status);
ln __LINE__; $status = pressKeys( $session, "L")  if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
###############################  step 72

ln __LINE__; $status = write2CommandLine( $session, "SET REGS OFF", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "REGISTERS OFF" ) if (not $status);
# To keep an entire DSECT displayed as one data item at the top of the screen,
ln __LINE__; $status = write2CommandLine( $session, "KEEP CPYDSECT", '[enter]' ) if ( not $status );
############################### step 75

# To watch the value of the data items change with each instruction,
ln __LINE__; $status = write2CommandLine( $session, "SET OPERANDS ON;STEP 15 AUTO", '[enter]' ) if ( not $status );
###############################  step 76 
ln __LINE__; $status = write2CommandLine( $session, "SET OPERANDS OFF;RESET KEEP;RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: STOP   " ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

# This example will randomly corrupt one of the first 256 bytes of this program.
# To use SmartTest to identify the instruction that is corrupting the program, 
# set an address stop as follows, 
ln __LINE__; $status = write2CommandLine( $session, "STOP R12? LENGTH 256", '[enter]' ) if ( not $status );
############################### step 79

ln __LINE__; $status = write2CommandLine( $session, "LIST ADSTOP", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "Address Stop Entry" ) if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, "R12?" ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
###############################  step 80

# Note:  the program will generate a random address to corrupt and ST will stop 
# the modification from happening.
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
ln __LINE__; $status =  findStringOnPanel( $session, "STOPPED BEFORE ADDRESS MODIFIED" ) if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "WHERE R14", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "STC   R14,0(,R14)            CORRUPT THIS PROGRAM" ) if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "GO TO STOPFIX;RUN", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "DEMONSTRATION OF: NOSOURCE " ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
###############################   step 85

ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW ON", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASMVIEW ON" ) if (not $status);

#To execute through the call to IEFBR14 and stop at the entry point,
###############################  step 87
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 

###############################  step 88
ln __LINE__; $status = write2CommandLine( $session, "STEP 2 AUTO", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "LTR   R15,R15                DID WE GET ZERO RETURN" ) if (not $status);

###############################  step 89 
ln __LINE__; $status = write2CommandLine( $session, "LIST TRACKING", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

ln __LINE__; $status = write2CommandLine( $session, "SET ASMVIEW OFF", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "ASMVIEW OFF" ) if (not $status);

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: LOOP" ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
###############################  step 94
ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS DESCENDING", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "SORTED BY DESCENDING COUNT" ) if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS ASCENDING", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "SORTED BY ASCENDING COUNT" ) if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS LINE", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "SORTED BY LINE NUMBER" );

ln __LINE__; $status = write2CommandLine( $session, "LIST COUNTS LABEL D", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "LABELS SORTED BY DESCENDING COUNT  " ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);    

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
ln __LINE__; $status = findStringOnPanel( $session, "DEMONSTRATION OF: DATASPC" ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

###############################  step 101
# This example shows SmartTest’s ability to monitor instructions which update data in a STATSPACE
# and to display data in a DATASPACE
ln __LINE__; $status = write2CommandLine( $session, "SET GEN OFF", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);  
ln __LINE__; $status = findStringOnPanel( $session, "PAUSE011 DSPSERV CREATE" ) if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "KEEP DSPNAME", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[tab]',5) if (not $status);
ln __LINE__; $status = pressKeys( $session, "CAROL01 ") if (not $status); 
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "SUCCESSFUL MEMORY UPDATE" ) if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "DSPNAME                               DS CL8" ) if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "VALUE > CAROL01  <" ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F6]') if (not $status);  

ln __LINE__; $status = write2CommandLine( $session, "LIST REGS", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "R15  00000010 - 00000000" ) if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status); 
ln __LINE__; $status =  findStringOnPanel( $session, "PAUSE012 MVC   DSPCHAR(7),=CL7'ASG'" ) if (not $status);


ln __LINE__; $status = write2CommandLine( $session, "KEEP DSPCHAR", '[enter]' ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "DSPCHAR                USING AR6      DS CL8" ) if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "VALUE > ........ <" ) if (not $status);

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, ">>>>>>           MVC   DSPCHAR(4),=C'XXXX'   SHOULD S0C4" ) if (not $status);
ln __LINE__;  $status = findStringOnPanel( $session, "STATUS: PROTECTION EXCEPTION (0C4)" ) if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "GO ALESERV;RUN", '[enter]'  ) if ( not $status );
ln __LINE__;  $status = findStringOnPanel( $session, "INPUT PARAMETER WAS: ALL" ) if (not $status);
ln __LINE__;  $status = findStringOnPanel( $session, "*COMPLETED*" ) if (not $status); 
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);

ln __LINE__; $status = write2CommandLine( $session, "CAN;Q CAN ALL", '[enter]'  ) if ( not $status );
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;