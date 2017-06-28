###############################################################################
#
# TEST SCRIPT: CICS-prep for cobol510, assembler and PLI
#		
# Script  
# DESCRIPTION: CICS-prep for  cobol510, assembler and PLI.
# CJM 
# Updated to support older compilers - SKB
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
my $hlq               = uc($configRef->{'TestDataHLQ'. '.'});
my $akrcob            = uc( $configRef->{'AKRCOB'}); 
my $akrasm            = uc( $configRef->{'AKRCOB'}); 
my $akrpli            = uc( $configRef->{'AKRCOB'});         
my $loadcob           = uc( $configRef->{'LOADCOB'});                
my $loadasm           = uc( $configRef->{'LOADCOB'});              
my $loadpli           = uc( $configRef->{'LOADCOB'});
my $jcllib            = "QAL.PHX.ESWAUTO.JCL2";
<<<<<<< .mine
my $ulibpdse          = $loadcob;
=======
my $ulibpdse          = "QAL.PHX.ESW810AU.LOADPDSE";
>>>>>>> .r3452

<<<<<<< .mine
# Break up the dataset into nodes
my ($node1, $node2, $node3);
my ($hinode, $middlenode);
if ($cntlLib =~ m/(\w+)\.(\w+)\.(\w+)/) {
   $hinode = $1;
   $node2 = $2;
   $node3 = $3;
   $middlenode = "$2." . $3;
   
} else {
	print ("+++ Unable to break dataset $cntlLib into nodes. +++ \n");
	exit;
}
=======
# Hi level and middle nodes
my $hinode	    	  = "QAL";
my $middlenode        = "PHX.ESW810AU";
>>>>>>> .r3452

## cobol variables
my $cobmemb           = "VIAPCOB";
my $coblib            = "CEE.SCEELKED";
my $compilr           = "IGYCRCTL";


# 
# Uncomment the compiler you want to test with
#


#my $cobcomp           = "SYSP.IGY340.SIGYCOMP";
my $cobcomp           = "SYSP.IGY410.SIGYCOMP";      #<=======
#my $cobcomp           = "SYSP.IGY420.SIGYCOMP";
#my $cobcomp           = "SYSP.IGY510.SIGYCOMP";
#my $cobcomp           = "SYSP.IGY520.SIGYCOMP";
#my $cobcomp           = "SYSP.IGY610.SIGYCOMP";

## CICS Cobol Variables
my $cob2cic            = 'SYS1.COB2CICS';
my $cicscob            = 'SDFHCOB';
my $cicslib            = 'SDFHLOAD';
my $cicstrn            = 'DFHECP1$';
my $trnparm            = 'COBOL2';

## Assembler variable
my $asmname           = "ASMA90";                   # <=======
## CICS Assembler variables 
my $cicsmac            = 'SDFHMAC';
my $cicsliba           = 'SDFHLOAD';
my $cicstrna           = 'DFHEAP1$';

## PLI variables
my $plicomp           = 'SYSP.PLI440.SIBMZCMP';      # <========
my $plipgm            = 'IBMZPLI';
my $plilib            = 'CEE.SCEELKED';

## CICS PLI variables
my $cicsmac            = 'SDFHMAC';
my $cicslibp           = 'SDFHLOAD';
my $cicstrnp           = 'DFHEPP1$';

## CICS Version
my $cics               = 'CICSTS52.CICS';              # <=======




package MAP;
# Setup appropriate JCL templaLte for this release.
my $template =  $release < 800 ? "TIACCMPL" : "tiaccm51"; print ("*** Preping for release: $release - Compiler: $cobcomp ***\n");

init;
ln __LINE__; $session = startSession($sessionID);
ln __LINE__; $status = execPanelCmd( $session, "Edit", "ISREDM01" )if ( not $status );

############## Cobol JCL prep.
ln __LINE__; $status = write2PanelField( $session, "Name . . . . . ","'$jcllib(viaccmpl)'", '[enter]' ) if ( not $status );

# delete previous member
ln __LINE__; $status = write2CommandLine( $session, "delete nx all", '[enter]',"Command ===> " ) if ( not $status );
# copy TIAPCOBC Template to the empty member and make the necessary changes to run the job.
ln __LINE__; $status = write2CommandLine( $session, "copy $template", '[enter]',"Command ===> " ) if ( not $status );
#ln __LINE__; $status = write2CommandLine( $session, "copy tiaccm51", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *ULIB $ulibpdse all", '[enter]',"Command ===> " ) if ( not $status );
                                                                 
ln __LINE__; $status = write2CommandLine( $session, "c *HI-NODE $hinode all", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *MIDDLE-NODE $middlenode all", '[enter]',"Command ===> " ) if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "c *COB2CIC $cob2cic all", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *COMPILR $compilr all", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *COBCOMP $cobcomp all", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *COBLIB $coblib all", '[enter]',"Command ===> " ) if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "c *CICS $cics", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *CICSCOB $cicscob", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *CICSLIB $cicslib", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *CICSTRN $cicstrn", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *TRNPARM $trnparm", '[enter]',"Command ===> " ) if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "SUB", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]')  if ( not $status );
#
 
############# Assembler JCL prep.
ln __LINE__; $status = write2PanelField( $session, "Name . . . . . ","'$jcllib(viacjasm)'", '[enter]' ) if ( not $status );
# delete previous member
ln __LINE__; $status = write2CommandLine( $session, "delete nx all", '[enter]',"Command ===> " ) if ( not $status );
# copy TIAPCOBC Template to the empty member and make the necessary changes to run the job.
ln __LINE__; $status = write2CommandLine( $session, "copy tiacjasm", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *ULIB  $ulibpdse all", '[enter]',"Command ===> " ) if ( not $status );
                                                                 
ln __LINE__; $status = write2CommandLine( $session, "c *HI-NODE $hinode all", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *MIDDLE-NODE $middlenode all", '[enter]',"Command ===> " ) if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "c *ASMNAME $asmname", '[enter]',"Command ===> " ) if ( not $status );


ln __LINE__; $status = write2CommandLine( $session, "c *CICS $cics", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *CICSMAC $cicsmac", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *CICSLIBA $cicsliba", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *CICSTRNA $cicstrna", '[enter]',"Command ===> " ) if ( not $status );


ln __LINE__; $status = write2CommandLine( $session, "SUB", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]')  if ( not $status );


############ PLI JCL prep.
ln __LINE__; $status = write2PanelField( $session, "Name . . . . . ","'$jcllib(viacjpli)'", '[enter]' ) if ( not $status );
# delete previous member
ln __LINE__; $status = write2CommandLine( $session, "delete nx all", '[enter]',"Command ===> " ) if ( not $status );
# copy TIAPCOBC Template to the empty member and make the necessary changes to run the job.
ln __LINE__; $status = write2CommandLine( $session, "copy tiacjpli", '[enter]',"Command ===> " ) if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "c *HI-NODE $hinode all", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *MIDDLE-NODE $middlenode all", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *CICS $cics", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "c *ULIB  $ulibpdse all", '[enter]',"Command ===> " ) if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "c *PLICOMP $plicomp all", '[enter]',"Command ===> " ) if ( not $status );
#ln __LINE__; $status = write2CommandLine( $session, "c *PLIPGM $plipgm all", '[enter]',"Command ===> " ) if ( not $status );
#ln __LINE__; $status = write2CommandLine( $session, "c *PLILIB $plilib all", '[enter]',"Command ===> " ) if ( not $status );

ln __LINE__; $status = write2CommandLine( $session, "SUB", '[enter]',"Command ===> " ) if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "SUBMITTED") if ( not $status );
ln __LINE__; $status = checkBatchStatus( $session, "ENDED") if ( not $status );


ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
end ($status); 1;

