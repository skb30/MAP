#!/bin/perl  -w
no warnings;
package SmartFile;
use Win32::API;
use Hllapi;
use Common;
use MAP;


sub initProfile {
#-------------------------------------------------------------------------------------#   
#  This routine deletes all ispf profile members associated with Pro/JCL and then
#  compress the ispf profile to prevent SD37 abends.	  
# 	
# Inputs: Session ID
# Returns: return code of the failing function otherwise zero
# 
#-------------------------------------------------------------------------------------#
	my $session   = shift;
	my $configRef = Cfg::getcfg();
	my $delCmd    = $configRef->{'DeleteProfileCMD'};
	my $execclist = $configRef->{'Exec'};
	my $product   = $configRef->{'AUT'};
	my $lpar      = $configRef->{'Host'};
	my $rc;
		
	Common::turnOnPanelID($session);	
	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' )if not $rc;
	$rc = MAP::write2CommandLine( $session, "PFSHOW OFF", '[$enter]' );
	
	$lpar = substr($lpar, -4);
	 
	# Execute Delprof exec. Exec deletes all profile members associated with Pro/JCL
	MAP::write2CommandLine( $session, "tso ex '$delCmd' '$lpar'", '[enter]' );
	
	# make sure the clist worked

    $rc = MAP::findStringOnPanel($session, "NOT IN DATASET",0,1);
	if ($rc == '0' ) {
		Util::printStatus(1, "$delCmd not found in dataset. Profile not deleted. Ending script.");
		exit;
	}
	
	Hllapi::hitKey( $session, '[enter]' );
	Hllapi::hitKey( $session, '[enter]' );

	$rc = MAP::write2CommandLine( $session, "TSO PROFILE NOWTPMSG", '[$enter]' ); 
###### END OF TICKET 807874	 TO BE REMOVED WHEN FIXED ON NEXT BUILD 5/19/2014

 	$rc = Common::compressISPFprofile($session);
 	if ($product eq 'smartFileDB2') {
 	 	 
	     $rc = MAP::write2CommandLine($session, "=6", '[enter]');
	     $rc = MAP::write2CommandLine($session, "ex '$execclist'", '[enter]');
	     $rc = MAP::execPanelCmd($session, "DB2", "SFD#MENU" );
	     # Set jobcard default
	     $rc = MAP::execPanelCmd($session, "Batch Submit Parameters", "SFMAOPLL" );
	     $rc = Hllapi::hitKey( $session, '[f3]' );
	     resetSmartfileDB2Userprof( $session);
	     $rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' );
 	}    
	return $rc;
}



sub resetSmartfileDB2Userprof {
	
	my $session 		  = shift;	
	my $configRef 		  = Cfg::getcfg();
	my $dB2Subsystem      = $configRef->{'DB2Subsystem'};
	
	
    MAP::execPanelCmd($session, "Profile Parameters", "PSEDD01S" ); 
    MAP::execPanelCmd($session, "USER", "PSEDD01" );
    
	# FILL VALUES FOR PANEL PSEDD01 
		my $db2form = tie(
			%form, Tie::IxHash,
	
		'DB2 SUBSYSTEM NAME  ===>' =>  $dB2Subsystem ,
	
		);
	
	  MAP::write2Panel( $session, $db2form, '[enter]' );
      MAP::navigateBack2Panel( $session, 'ISP@MST1' );
   return;  
}

sub deleteDataset {
	
	##########################################################################################
	# Deletes the datasets or members passed as parameters to this routine 
	#
	# Takes either a PDS or Sequential dataset and uses smartfile to 
	# delete the memember or dataset.
	#
	# Using this routine ensures that you won't hold an exclusive lock on the file
	# This routine supercedes the 'TSO delete' commands used in many scripts. 
	#
	##########################################################################################

	my $session    = shift; 
	my $configRef  = Cfg::getcfg();
	my $execclist  = $configRef->{'Exec'};
	my $status     = -1;
	my $sequential;

	MAP::execPanelCmd( $session, "Command","ISRTSO" );
    MAP::write2CommandLine( $session, "exec '$execclist'", '[enter]');

   # iterate through the parameter list. the parameter list should contain dataset names
   foreach my $dsn (@_) {
   	    if (!defined $dsn ) {
   	    	print "+++ Undefined dsn. Skipping to next. Please check your input dsn! +++\n";
   	    	next;
   	     }
		# determine if $dsn is either PDS or sequential
		if ($dsn =~ m/.*\(/) {
			MAP::write2CommandLine( $session, "3.1", '[enter]');
			$sequential = 0;
		} else {
			MAP::write2CommandLine( $session, "3.2", '[enter]');
			$sequential = 1;
		}
		my $form = tie(
		%form, Tie::IxHash,    
			"OPTION ===>        " 			=> 'd',         
	    	"DATASET NAME   ===>" 			=> "'$dsn'",
		);
	    MAP::write2Panel( $session, $form, '[enter]');
	    # sequential path.
	    # if it's sequential then we need to hit the enter key one more time
	    # to confirm deletetion.
	    if ($sequential) {
	    	MAP::pressKey($session, '[enter]');
	    	if (MAP::findStringOnPanel($session, "DATASET DELETED",0,1) == 0 ){
	    		print "*** $dsn successfully deleted. ***\n";
	    		$status = 0;;
	    	} else {
	    		# check to see if the dataset existed. If it didn't return a warning
	    		# otherwise return an error
	    		if (MAP::findStringOnPanel($session, "DATASET NOT FOUND IN CATALOG",0,1) == 0 ){
	    			print "WWW $dsn not cataloged. Continuing with a status of passed.  WWW\n";
	    			$status = 0; 
	    		} else {
		    		print "+++ Error deleting $dsn. Setting status to failed! +++\n";
		    		$status = -1; 
	    		}
	    	}
	    } else {
	    	# PDS path. 
		    if (MAP::findStringOnPanel($session, "PDS853E", 0,1 ) == 0 ) {
		    	print "WWW  deleteDataset($dsn) was unable to delete member because it wasn't found. WWW\n";
		    	$status = 0;
		    } elsif (MAP::findStringOnPanel($session, "PDS040I",0,1) == 0 ){
		    	print "*** deleteDataset($dsn) successfully deleted. ***\n";
		    	$status = 0;
		    } else {
		    	print "+++ deleteDataset($dsn)Error deleting dataset!  +++\n";
		    	$status = -1; 
		    }	
	    }
	    MAP::navigateBack2Panel( $session, 'PDSMENUS' );
   } 
   MAP::navigateBack2Panel( $session, 'ISP@MST1' );
   return $status;
}
sub copyDSN {
#-------------------------------------------------------------------------------------#   
#  This routine copies entire Dataset (PDS,Seq)
# Inputs: Session, Input dataset, Output Dataset, Flag=v or blank(v for Vsam)
# Returns: return code of the failing function otherwise zero
# 
#-------------------------------------------------------------------------------------#
	my $session   = shift; 
	my $inputDSN  = shift;
	my $outputDSN = shift; 
	
	$inputDSN  = uc($inputDSN);
	$outputDSN = uc($outputDSN);
	
	my $flag = shift;
	$flag = lc($flag);
	my $configRef = Cfg::getcfg();
	my $execclist         = $configRef->{'Exec'};
	my $rc;
		
    MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	MAP::execPanelCmd( $session, "Command","ISRTSO" );
	# Go to SmartFile Primary option menu PDSMENUS
	MAP::write2CommandLine( $session, "exec '$execclist'", '[enter]' );
	# Go to View/Edit Menu option
	MAP::execPanelCmd( $session, "Copy/Reformat","SFMASRCH" );
	
	my $form = tie(
	%form, Tie::IxHash,             
	
		'Function ===>'        => "A",
 		         'NAME ===>'   => "'$inputDSN'",
#		  'DATASET NAME ==='   => "'$inputDSN'",
		'VOLUME SERIAL ===>'   => " ",
		'     Autosave ===>'   => 'N',
			   'Edit? ===> '   => 'Y',
	);

  	MAP::write2Panel( $session, $form, '[enter]');	

		# Copy/Reformat Target Definition
		$form = tie(
			%form, Tie::IxHash,             
	    		'Output Dataset'    => "'$outputDSN'",
                  
       );

	MAP::write2Panel( $session, $form, '[enter]'); 
	
	 
	if ($flag eq 'v') {
		$rc = MAP::pressKeyRepeat( $session, '[ENTER]',2);
		$rc = MAP::findStringOnPanel( $session, "CLUSTER ALLOCATED" );
		$rc = MAP::pressKeyRepeat ( $session, '[ENTER]',1);
		$rc = MAP::findStringOnPanel( $session, "$outputDSN" )
	}
	else {
		$rc = MAP::pressKeyRepeat ( $session, '[ENTER]',1);
	    $rc = MAP::findStringOnPanel( $session, "RFMT FILE ALLOCATED" );
		$rc = MAP::pressKeyRepeat ( $session, '[ENTER]',2);
		$rc = MAP::findStringOnPanel( $session, "$outputDSN" )
	}	

	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	return $rc;
}
1;
