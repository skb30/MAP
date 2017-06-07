#!/bin/perl  
package ProJcl;
use Win32::API;
use Hllapi;
use PROJCL::PanelsMap;
use MAP;


sub dataReset {
#-------------------------------------------------------------------------------------#   
#  This routine is the first routine called before executing any functional group of 
#  MAP tests for Pro/JCL. It's purpose is to reset the environment to a known state.
# 
#  deletes all ispf profile members associated with Pro/JCL 
#  compress the ispf profile to prevent SD37 abends.  
#  sets the default RTS member to QARTS.
# 	
# Inputs: Session ID
# Returns: return code of the failing function otherwise zero
# 
#-------------------------------------------------------------------------------------#	
	my $session   = shift @_;
	my $rtsMember = shift @_;
	my $stcID     = shift @_;
	my $service   = shift @_;
	my $option    = shift @_;
	my $configRef = Cfg::getcfg();
	my $aut       = $configRef->{'AUT'};
	my $user      = $configRef->{'UserID'};
    my $rts       = $user.RT;
	my $rc        = 0;
	
	# set default AUT to ProJcl
    if (!$option){ $option = 'P';}
    Common::turnOnPanelID($session);
 
#	$rc = MAP::startService( $session, $service, 10 ) if not $rc;
	$rc = initProfile($session, $option) if not $rc;
# set the default RTS memeber
	if ((lc $aut) eq 'infox') {
		$rc = MAP::write2CommandLine( $session, "TSO QARTS1 QARTS I $stcID",'[$enter]' );
	} else {
		$rc = MAP::write2CommandLine( $session, "TSO QARTS1 QARTS $option $stcID",'[$enter]' ) if not $rc;
	}
	$rc = Hllapi::hitKey( $session, '[enter]' ) if not $rc;	
	
	# now create a unique RTS member to be used by the scripts
	
	if ((lc $aut) eq 'projcl') {
        $rc = initRTS ($session, $rts, $stcID );
	}		
	# $rc = Hllapi::hitKey( $session, '[enter]' ) if not $rc;	
	return $rc;
}
sub initRTS {
	my $session    = shift;
	my $rts        = shift;
	my $stcID      = shift;
	my $back2panel = shift;
	       #  initRTS ($session, $rts, $stcID );
		   #  delete users RTS member
   deleteRTS ($session, $rts, $stcID, $back2panel);
    
    #allocate a new users rts member
    MAP::navigate2Panel( $session, "Validation", "D0JPJVAL") ;
    # Open new RTS member
    MAP::navigate2DropDownList ($session, "Settings", "RTS Member" );
    MAP::navigate2DropDownList ($session, "File", "New" );
    MAP::write2PanelField( $session, "Member     :", $rts) ;
    MAP::write2PanelField( $session, "Description:", "MY RTS" ) ;
    MAP::pressKeyRepeat($session, '[f3]', 3);
    MAP::navigateBack2Panel( $session, 'ISP@MST1' );
    
    return $status;
	
}

sub backupPCFile {
	$session = shift;
	$rc = MAP::write2CommandLine( $session, "tso bkuppcf",'[enter]'); 
	$rc = Hllapi::hitKey( $session, '[enter]' ) ;
	return $rc;
}
sub restorePCfile { 
	print "restore PCFile was called from this script.\n"; 
	# restore PCfile is no longer used.  
	return 0;
 	my $session 	= shift;
 	my $service 	= shift;
    my $configRef 	= Cfg::getcfg();
 	my $release    	= $configRef->{'Release'};
 	my $pcfileID    = $configRef->{'PcfileID'};
	
	my $rc =0;
	print "*** Restoring PC file. ***\n";
 	$rc = MAP::stopService( $session, $service ) if not $rc;
 	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' )if not $rc; 
 	print "*** Issuing tso command: tso restpcf $release $pcfileID ***\n";
 	$rc = MAP::write2CommandLine( $session, "tso restpcf $release $pcfileID",'[enter]') if not $rc;
 	printIDCmessages($session);
 	$rc = MAP::findStringOnPanel( $session, "NOT IN CATALOG", 1,1); 
 	$rc = Hllapi::hitKey( $session, '[enter]' ) if not $rc;	
 	$rc = MAP::startService( $session, $service, 10 ) if not $rc;
 	if ($rc != 0) {
 		print "+++ Looks like the PC restore file is missing. +++\n";
 		print "+++ Restore PC file unsuccessful! +++\n"; 
 		print "+++ Exiting Script! +++ \n";
 		Hllapi::hitKey( $session, '[enter]' );
 		MAP::startService( $session, $service, 10 );
 		exit;
 	}
 	print "*** Restore PC file successful. ***\n"; 
	return $rc;
}

sub printIDCmessages {
	my $session = shift;
	my $error_txt = MAP::copyTextFromScreen($session,"IDC0550",800);
 	my @messages  = split(/\s\s\s/,$error_txt);
 	foreach my $line (@messages) {
 		if ($line =~ m/\w+/) {
 			print "    $line\n";
 		}
 	}
}
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
	my $option    = shift;
	my $configRef = Cfg::getcfg();
	my $delCmd    = $configRef->{'DeleteProfileCMD'};
	my $userid    = $configRef->{'UserID'};
	my $stcID     = $configRef->{'STCID'};
	my $aut       = $configRef->{'AUT'};
	my $host      = $configRef->{'Host'};
	my $rc;
		
	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' )if not $rc;
	$rc = MAP::write2CommandLine( $session, "PFSHOW OFF", '[$enter]' ); 
	# Execute Delprof exec. Exec deletes all profile members associated with Pro/JCL
	$rc = MAP::write2CommandLine( $session, "TSO DELPROF $userid $host",'[$enter]' );
	$rc = Hllapi::hitKey( $session, '[enter]' ) if not $rc;	
	$rc = Common::compressISPFprofile($session) if not $rc;
	
	return $rc;
}

sub setupPF12 {
#-------------------------------------------------------------------------------------#   
# Set the ISPF PFK 12 to cancel so that navigateBact2Panel will cancel instead exit/save. 
# 
#-------------------------------------------------------------------------------------#
	my $session   = shift;
	my $configRef = Cfg::getcfg();
	my $delCmd    = $configRef->{'DeleteProfileCMD'};
	my $stcID     = $configRef->{'STCID'};
	my $aut       = $configRef->{'AUT'};
	my $rc;
		
	$rc = MAP::navigateBack2Panel( $session, 'ISP@MST1' )if not $rc;
	$rc = MAP::write2CommandLine( $session, "keys", '[$enter]' ) if not $rc;;
	my $validationForm = tie(
		%form, Tie::IxHash,
		'F12  . .'      => 'cancel',
		);
    MAP::write2Panel( $session, $validationForm  );
    MAP::pressKey( $session, '[F3]') if not $rc;

	return $rc;
}


sub assignDefaultUserConfig {
	
	my $session   = shift;
	my $option    = shift;

	if (uc $option eq 'I') {
		$rc = MAP::execPanelCmd( $session, "ASG-INFO/X", "D0DPMAI0" )if  not $rc; 
		$rc = MAP::execPanelCmd($session, "Administration", "D0SPDIA1" )if  not $rc; 
		$rc = MAP::execPanelCmd( $session, "INFO/X Menus", "D0DPDIA2" )if  not $rc;
		MAP::pressKey( $session, '[tab]');
		MAP::pressKey( $session ,'[tab]');
		MAP::pressKey( $session ,'s');
		MAP::pressKey( $session ,'[enter]');
		# Select the first user configuration record
			
		my $UserConfigurationForm = tie(
		%form, Tie::IxHash,
		'Machine Name  . . . . . . .'  => '*',
		'User/Group ID . . . . . . .'  => 'QA*',
		'ID Type . . . . . . . . . .'  => 'U',
		'Authority . . . . . . . . .'  => 'A',
		'RTS Member  . . . . . . . .'  => '*ANY*',
		'Scheduler . . . . . . . . .'  => '*ANY*',	
		'Selection Exit  . . . . . .'  => '*ANY*',

		'Query . . . . . . . . . .'    => 'Y',	  
		'Update  . . . . . . . . .'    => 'Y',
		'Reports . . . . . . . . .'    => 'Y',
		'Text  . . . . . . . . . .'    => 'Y',
		'Directed Execution. . . .'    => 'Y',
		);
		# Write the form on the panel
		$rc = MAP::write2Panel( $session, $UserConfigurationForm, '[enter]')  if ( not $status );
		
		# ProJCL configuration 
	} else {
		$rc = MAP::execPanelCmd( $session, "ASG-PRO/JCL", "D0JPMAI0" )if  not $rc; 
		$rc = MAP::execPanelCmd($session, "Administration", "D0SPDIA1" )if  not $rc; 
		$rc = MAP::execPanelCmd( $session, "PRO/JCL Menus", "D0SPDIA2" )if  not $rc;
		MAP::pressKey( $session, '[tab]');
		MAP::pressKey( $session ,'[tab]');
		MAP::pressKey( $session ,'s');
		MAP::pressKey( $session ,'[enter]');
		# Select the first user configuration record
			
		my $UserConfigurationForm = tie(
		%form, Tie::IxHash,
		'Machine Name  . . . . . . .'  => '*',
		'User/Group ID . . . . . . .'  => 'QA*',
		'ID Type . . . . . . . . . .'  => 'U',
		'Administrator . . . . . . .'  => 'Y',
		'RTS Member  . . . . . . . .'  => '*ANY*',
		'Selection Exit  . . . . . .'  => '*ANY*',
		'JMP Program Data Set  . .'    => ' ',
		'JMP Program . . . . . . .'    => '*ANY*',
		'Reformatter Member  . . .'    => '*ANY*',
		'Scheduler . . . . . . . .'    => '*ANY*',
		'JMP . . . . . . . . . . .'    => 'Y',	  
		'Reformat  . . . . . . . .'    => 'Y',
		'Validation - ESP  . . . .'    => 'Y',
		'Validation - TWS  . . . .'    => 'Y',
		'Directed Execution. . . .'    => 'Y',
		);
		# Write the form on the panel
		$rc = MAP::write2Panel( $session, $UserConfigurationForm, '[enter]')  if ( not $status );
	}

	return $rc;
}
 
sub deleteRFM {
#*********************************************************************************
#   delete Reformat members in PRoJCL scripts. 
#   deleteRFM ($session, $rfm, $stcID );
#      
#*********************************************************************************
 
	my $session = shift;
	my $rfm     = shift;
	my $stcID   = shift;
	my $status;
	
	#  deleteRFM($session, $rfm, $stcID );
		   # delete users RTS member
    MAP::navigate2Panel( $session, "Command" );
    MAP::write2CommandLine( $session, "D0sedias $stcID", '[enter]' );

    MAP::navigate2Panel( $session, "ASG-PRO/JCL", "D0JPMAI0") ;
    MAP::navigate2Panel( $session, "Administration", "D0SPDIA1") ;
    MAP::navigate2Panel( $session, "PRO/JCL Reformatter Members", "D0SPDIA8") ;  
    
    #  suppress and negate the return code so it doesn't print, get reported. 
    $status = MAP::findStringOnPanel( $session, "$rfm", 0,1 );
    if ( $status == 0) {
        MAP::panelListAction($session, $rfm, "d");
        # confirm the pop up confirmation panel for the delete
        MAP::pressKey($session, "[enter]");
        MAP::pressKey($session, "[f3]") ;
    #  if its not found continue on by reseting the status to 0.     
   } else {
        $status = 0;
   }
        MAP::navigateBack2Panel( $session, 'ISP@MST1' );
        return $status;
}
sub delRtsInfox {
	my $session = shift;
	my $ixrts   = shift;
	my $stcID   = shift;
	my $status;
	
	       #  delRtsInfox ($session, $ixrts, $stcID );
		   #  delete users RTS member
    MAP::navigate2Panel( $session, "Command" );
    MAP::write2CommandLine( $session, "D0sedias $stcID", '[enter]' );

    MAP::navigate2Panel( $session, "ASG-INFO/X", "D0DPMAI0") ;
    MAP::navigate2Panel( $session, "Administration", "D0SPDIA1");
    MAP::navigate2Panel( $session, "INFO/X RTS Members", "D0SPDIA8") ;
    $status=MAP::findStringOnPanel( $session, "$ixrts", 0,1 );
  
    if ( $status == 0 ){ 
          MAP::panelListAction($session, $ixrts, "d", );
          # confirm the pop up confirmation panel for the delete
          MAP::pressKey( $session, '[enter]');
    }else { 
    	$status =0;
    	}
    MAP::navigateBack2Panel( $session, 'ISP@MST1' ); 
    return $status;
} 

sub delSelectList {
	my $session = shift;
	my $stcID   = shift;
	
	       #  delSelectList ($session, $stcID );
		   #  delete users RTS member
    MAP::navigate2Panel( $session, "Command" );
    MAP::write2CommandLine( $session, "D0sedias $stcID", '[enter]' );

    MAP::navigate2Panel( $session, "ASG-PRO/JCL", "D0JPMAI0") ;
    MAP::navigate2Panel( $session, "Validation", "D0JPJVAL");
    MAP::navigate2DropDownList ($session, "Settings", "Selection List" );
    MAP::pressKey ($session, '[tab]' );
    MAP::pressKeys ($session, "d", '[enter]' ) ;
#todo add code for multiple entries.  
#    my $status = MAP::panelListAction($session, $list, "d", );
    # confirm the pop up confirmation panel for the delete
    if ( $status == 0 ){ 
    	MAP::pressKeyRepeat ( $session, '[enter]','2') ;
    } 
    MAP::navigateBack2Panel( $session, 'ISP@MST1' );
   
    return $status;
} 
sub deleteRTS {
	my $session    = shift;
	my $rts        = shift;
	my $stcID      = shift;
	my $back2panel = shift;
	my $status;
	my $configRef = Cfg::getcfg();
	my $product   = $configRef->{'AUT'};
	
	       #  deleteRTS ($session, $rts, $stcID );
		   #  delete users RTS member
	MAP::navigate2Panel( $session, "Command" );
    MAP::write2CommandLine( $session, "D0sedias $stcID", '[enter]' );

    MAP::navigate2Panel( $session, "ASG-PRO/JCL", "D0JPMAI0") ;
    MAP::navigate2Panel( $session, "Administration", "D0SPDIA1") ;
    MAP::navigate2Panel( $session, "PRO/JCL RTS Members", "D0SPDIA8") ;
    $product = lc($product);
    # look for the rts without press enter
    MAP::panelListAction($session, $rts, "d",1 );

    # check if the rts is there and if status is 0 delete it
    $status = MAP::findStringOnPanel( $session, "$rts", 0,1 );
    if ( $status == 0 ) { 
	    MAP::panelListAction($session, $rts, "d" );
	    # confirm the pop up confirmation panel for the delete
	    MAP::pressKey( $session, '[enter]') ;
    } 
    MAP::navigateBack2Panel( $session, 'D0JPMAI0' );
    return 0;
}
sub unAssignUserPanel {
	my $session    = shift;
	my $stcID      = shift;
    #  unAssignUserPanel ($session, $stcID );
    MAP::navigate2Panel( $session, "Command" );
    MAP::write2CommandLine( $session, "D0sedias $stcID", '[enter]', ) ;
    MAP::execPanelCmd( $session, "ASG-PRO/JCL", "D0JPMAI0");
    MAP::execPanelCmd( $session, "Administration", "D0SPDIA1") ;
    MAP::navigate2Panel ($session, "PRO/JCL Menus", "D0SPDIA2");

        #select existing user configuration

    MAP::panelListAction($session, "*", "s") ;


        # unload the user configuration 
    my $form = tie(
	  %form, Tie::IxHash,
	  'Machine Name  . . . . . . .' => '*',
	  'User/Group ID . . . . . . .' => '*',
	  'ID Type . . . . . . . . . .' => 'U',
	  'Administrator . . . . . . .' => 'Y',
	  'RTS Member  . . . . . . . .' => '*ANY*',
	  'Selection Exit  . . . . . .' => '*ANY*', 
	  '  JMP Program Data Set  . .' => '                      ',
	  '  JMP Program . . . . . . .' => '*ANY*',
      '  Reformatter Member  . . .' => '*ANY*',
	  '  Scheduler . . . . . . . .' => '*ANY*',
	  '  JMP . . . . . . . . . . .' => 'Y',
	  '  Reformat  . . . . . . . .' => 'Y',
	  '  Validation - ESP  . . . .' => 'Y',
	  '  Validation - TWS  . . . .' => 'Y',
	  '  Directed Execution. . . .' => 'Y',

);
       # now write the fields onto the panel
   MAP::write2Panel( $session, $form );
   MAP::pressKey( $session,'[enter]') ;
   MAP::navigateBack2Panel( $session, 'ISP@MST1');
   return 0;
}
sub deleteMachDef {
	my $session    = shift;
	my $machid     = shift;
	my $stcID      = shift;
	my $status;     
	
	       #  deleteMachDef ($session, $machid, $stcID );
		
    MAP::navigate2Panel( $session, "Command" );
    MAP::write2CommandLine( $session, "D0sedias $stcID", '[enter]' );

    MAP::navigate2Panel( $session, "ASG-PRO/JCL", "D0JPMAI0") ;
    MAP::navigate2Panel( $session, "Machine Definitions", "D0JPDEX1") ;
    #  suppress and negate the return code so it doesn't print, get reported.     
    #  if the value is found follow these steps to delete the value 
    $status = MAP::findStringOnPanel( $session, "$machid", 0,1 );
    
    if ( $status == 0) {
        MAP::panelListAction($session, $machid, "d");
        MAP::pressKey($session, "[enter]");
        MAP::pressKey($session, "[f3]") ;
    #  if its not found continue on by reseting the status to 0.     
   } else {
        $status = 0;
        MAP::pressKey( $session,'[enter]') ;
   }   
       
    MAP::navigateBack2Panel( $session, 'ISP@MST1' );
    return 0;
}
1;