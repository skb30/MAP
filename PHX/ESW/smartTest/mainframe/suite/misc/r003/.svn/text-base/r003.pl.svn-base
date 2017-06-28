###############################################################################
#
# TEST SCRIPT: QA-TCD-ST-7.7.1-R003.doc  
#		
# Script  
# DESCRIPTION: Create and expand an AKR, testing online function only
# DATE: 2/13/2013
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
my $akr               = 'QAL.PHX.ESWAUTO.AKR';
my $jobname           =  "AKRALLOC";
package MAP;
init;
$session = startSession($sessionID);
my $status = Eswtool::initProfile($session);
$status = 0;
# DELETE some datasets  
ln __LINE__; $status = write2CommandLine( $session, "TSO DELETE '$akr'", '[enter]' ) if ( not $status );
ln __LINE__; $status = pressKey  ($session, '[enter]') if (not $status);

# get the current date and return it in ddmmmyyyy (12JUN2012 for ej)
#$date = Util::check_date; 
# Step 6
## Go option 6
ln __LINE__; $status = Eswtool::accessProduct($session, $execclist);
ln __LINE__; $status = write2CommandLine( $session, "CENTER", '[enter]' ) if ( not $status );

#  $Step 5 navigate to the Test pull down menu and choose . Module/Transaction 
ln __LINE__; $status = navigate2DropDownList ($session, "Test", "Module/Transaction" ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG-ESW - Testing/Debugging" )if ( not $status );

#  $Step 6 navigate to the File pull down menu and choose . AKR utility
ln __LINE__; $status = navigate2DropDownList ($session, "File", "AKR utility" ) if ( not $status );
ln __LINE__; $status =  findStringOnPanel( $session, "ASG-ESW - AKR Utility" )if ( not $status );


# Step 8
my $form = tie(
	%form, Tie::IxHash,             
	
	'Data set name'        => "'$akr'",
 
);

ln __LINE__; $status = write2Panel( $session, $form, ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "A", '[enter]' ) if ( not $status );

# Step 9
$form = tie(
	%form, Tie::IxHash,             
	'Expand existing AKR . . .'        => "NO ",
	'AKR data set name . . . .'        => "'$akr'",
      'Unit  . . . . .'                => "SYSDA",
      'Primary space . '               => "500", 
      'Secondary space .'              => "500",
      
      
);

ln __LINE__; $status = write2Panel( $session, $form, ) if ( not $status );
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',1) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[RIGHT]',2) if (not $status);
ln __LINE__; $status = pressKeys( $session, "$jobname JOB (QAPHX),'ESW AKR ALLOC',") if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[TAB]',1) if (not $status);
ln __LINE__; $status = pressKeyRepeat( $session, '[RIGHT]',5) if (not $status);
ln __LINE__; $status = pressKeys( $session, "MSGCLASS=A,NOTIFY=&SYSUID") if (not $status);
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
# Step 10-11
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );

# Step 12
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);
ln __LINE__; $status =  findStringOnPanel( $session, "ASG-ESW - AKR Utility" )if ( not $status );

# Step 13
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanel  ( $session, "NewAKR.txt",1 );

# Step 14
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 15 To expand the existing AKR
ln __LINE__; $status = write2CommandLine( $session, "A", '[enter]' ) if ( not $status );

# Step 16
$form = tie(
	%form, Tie::IxHash,  
	           
	'Expand existing AKR . . .'        => "YES",
	'AKR data set name . . . .'        => "'$akr'",
      'Unit  . . . .'                  => "SYSDA",
      'Primary space . . '             => "2000", 
      'Secondary space . .'            => "1000",
);

ln __LINE__; $status = write2Panel( $session, $form, ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "S", '[enter]' ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );

# Step 18
ln __LINE__; $status = pressKey( $session, '[F3]') if (not $status);

# Step 19
ln __LINE__; $status =  findStringOnPanel( $session, "ASG-ESW - AKR Utility" )if ( not $status );
ln __LINE__; $status = pressKey( $session, '[ENTER]') if (not $status);
ln __LINE__; $status = verifyPanel  ( $session, "NewAKR2.txt",1 );

ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;