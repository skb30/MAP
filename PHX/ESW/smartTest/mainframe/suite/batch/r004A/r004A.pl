###############################################################################
#
# Release SmartTest 7.90.
#		
# Script  
# DESCRIPTION: Test COBOL demonstration program VIAMERGE with Enterprise 5.1 compiler.
# DATE: 5/28/2014
# CJM 
# 0C7 - ticket 808447 VIAMERGE fails with an 0C7 when it encounters invalid data 
# if SET LE=ON when compiled using Cobol 5.1.1, using LE=OFF it works OK.
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
my $status = 0;

package MAP;
ln __LINE__; init;
ln __LINE__; $session = startSession($sessionID);
ln __LINE__; $status = Eswtool::initProfile($session);


# get the current date and return it in ddmmmyyyy (12JUN2012 for ej)
$date = Util::check_date; 
# Step 6
## Go option 6
ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);
#ln __LINE__; $status = write2CommandLine( $session, "tso ex 'QAL.PHX.ESW790AU.SCNXCLST(VIASPROC)' 'ADD(QAL.PHX.ESW790AU.SESWCLST)'", '[enter]' )if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "CENTER", '[enter]' ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "ST", '[enter]' ) if ( not $status );
# Step 9
ln __LINE__; $status = write2CommandLine( $session, "AN ", '[enter]' ) if ( not $status );

# Step 10
my $form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        => "'qal.phx.eswauto.jcl2(VIAMERG4)'",
 #   'Understand: ' 	   	   => 'N',
    'Test:'   	           => 'Y',
    'Extended Analysis:'   => 'Y',
 #   'Document:'            => 'N',
 #   'Re-engineer:'         => 'N',
    'AKR data set name'    => "'$akrcob'",
	'Compile? (Y/N) . . . . . . . . .'   => 'Y',
	'Link load module reusable? (Y/N)'   => 'Y',
		   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 13
ln __LINE__; $status = write2CommandLine( $session, "AKR", '[enter]' ) if ( not $status );

# Step 14
my $form = tie(
	%form, Tie::IxHash,             
	
	'Data set name . .'        => "'$akrcob'",
	   
);

ln __LINE__; $status = write2Panel( $session, $form, '[enter]') if ( not $status );
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

my $form = tie(
	%form, Tie::IxHash,             
	
	'Load module'        		 => "VIAMERGE",
    'Break on entry (Y/N)'		 => "YES",
    'Deallocate'				 => "NO",
		   
);

ln __LINE__; $status = write2Panel( $session, $form,) if ( not $status );
#  C Convert batch JCL to TSO CLIST
ln __LINE__; $status = write2CommandLine( $session, "C", '[enter]' ) if ( not $status );

# Step 22
my $form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        		 => "'qal.phx.eswauto.jcl2'",
    'Member  . . .'				 => "VIAMEJCL",
    'Data set name&'        		 => "'$clist'   ",
    'Member  . . .&'				 => "VIAMEJCL",
	'Delete (Y/N)'					 => "NO",   
	'Step   (Y/N)'					 => "YES",
	'Subsystem'						 => "    ",
	'Step Name'						 => "MERGE"
	
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

ln __LINE__; $status = write2CommandLine( $session, "SET LE ON", '[enter]' ) if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, "LE ON" )  if ( not $status );;
# R - Begin TSO test session (RUN)
ln __LINE__; $status = write2CommandLine( $session, "R", '[enter]' ) if ( not $status );

# Step 25
ln __LINE__; $status = write2CommandLine( $session, "UP MAX", '[enter]' ) if ( not $status );


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


# Step 32
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# BREAK BEFORE PAUSE ALL;RUN  command WILL PLACE A BREAKPOINT AT PREDETERMINED LOCATIONS IN THE SOURCE
# THAT HAVE 'PAUSE' IN THE TEXT, THEN BEGIN THE TEST SESSION. 
# Step 33              
ln __LINE__; $status = write2CommandLine( $session, "BREAK BEFORE PAUSE ALL;RUN", '[enter]' ) if ( not $status );


####### Print compiler used.
ln __LINE__; $status = write2CommandLine( $session, "li comp", '[enter]' ) if ( not $status );
my $row = "Compiler  : ";
my $rowline = copyTextFromScreen($session,$row,35,0);
Util::printStatus( 0, "$rowline" );

ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
#########
# Change the value of DATA-PACKED-DEC
# Step 35                                                                 
ln __LINE__; $status = write2CommandLine( $session, "111111", '[enter]', "VALUE >") if ( not $status );
ln __LINE__; $status = findStringOnPanel( $session, 'SUCCESSFUL MEMORY UPDATE')  if ( not $status );

ln __LINE__; $status = pressKey( $session, '[F4]') if (not $status);
ln __LINE__; $status = findStringOnPanel( $session, 'TEST ENDED')  if ( not $status );


#ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status); 
ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;