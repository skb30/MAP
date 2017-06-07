#!/bin/perl
no warnings;
package DB2;

use Win32::API;
use Hllapi;
use Common;
use PROJCL::ProJcl;
use SMARTTOOLS::SmartFile;
use MAP;

sub dataReset_Panel {
#-------------------------------------------------------------------------------------#
#      Purge and load table
#      
#      Input parms: a session and the Execclist to go SmartFile.
#
#-------------------------------------------------------------------------------------#

  	(my $session, my $table, my $database)  =  @_;
  	
  	my $configRef          = Cfg::getcfg();
  	my $userid      	   = $configRef->{'UserID'};
	my $execclist    	   = $configRef->{'Exec'};
	my $cntlLib 	       = $configRef->{'CntlLib'};
  	my $empData  	       = $configRef->{'EmpDataBkup'};
	my $rc;
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	SmartFile::initProfile($session);
	MAP::execPanelCmd( $session, "Command","ISRTSO" );
	# go to Primary option menu PDSMENUS.
    MAP::write2CommandLine( $session, "exec '$execclist'", '[enter]' );
    # Select D for Menu of DB2 Services.
	MAP::execPanelCmd( $session, "DB2","SFD#MENU" );
	# Select 3 for Utilities
	MAP::execPanelCmd( $session, "Utilities","PSEDDCFM" );
	# Select 4 for Load
	MAP::execPanelCmd( $session, "LOAD","PSEDDLD" );
	
	my $form = tie(
	%form, Tie::IxHash,
	'PURGE TABLE ===>' 						=> 'Y',
	'LAYOUT LIBRARY   ===>'                 =>  "'$cntlLib'",
	'COPYBOOK MEMBER  ===>'		    		=> 'QASFCP02',
	'       LANGUAGE  ===>' 				=> "COB",
	'INPUT SEQUENTIAL DATASET NAME ===>'	=> "'$empData'",
	);
	
   	 MAP::write2Panel( $session, $form ,'[ENTER]');
   	 
   	 
   	my $form = tie(
	%form, Tie::IxHash,
	'DATABASE NAME    ==>'		 			=> $database,
	'TABLE OWNER      ==>'		    		=> $userid,
	'TABLE NAME       ==>' 		     		=> $table,
	
	);
	
   	 MAP::write2Panel( $session, $form ,'[ENTER]');
   	 
	 
	$rc = MAP::findStringOnPanel( $session, "TABLE LOADED" );

	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	
	if ($rc != 0) {
		print "+++ TABLE $table is missing. +++\n";
	}
	return $rc;
}	
	
sub naviguate_to_drop_menu {

#-------------------------------------------------------------------------------------#
#      Naviguate to the Create/Modify Object Drop Menu      
#
#      Input parms: a session 
#
#-------------------------------------------------------------------------------------#

   ( my $session) = @_;
	my $configRef 		  = Cfg::getcfg();
    my $execclist         = $configRef->{'Exec'};
    
	

	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	MAP::execPanelCmd( $session, "Command", "ISRTSO" );

	# go to Primary option menu PDSMENUS.
	MAP::write2CommandLine( $session, "exec '$execclist'", '[enter]' );

	# Select D for Menu of DB2 Services.
	MAP::execPanelCmd( $session, "DB2", "SFD#MENU" );
    
    # Select 4 for Create/Modify Objects
	MAP::execPanelCmd( $session, "Create/Modify Objects", "PSEDDGAR" );
    
	# Select 3 for DROP
	MAP::execPanelCmd( $session, "DROP", "PSEDDDOB" );
	
	
	
	return;
}	
  
	
sub dataReset_IVP {

#-------------------------------------------------------------------------------------#
#      Initialize and drop all Indexes, Tables, Database and Storage Group used.
#      for the acceptance test.(IVP).
#
#      Input parms: a session a 
#
#-------------------------------------------------------------------------------------#

	( my $session) = @_;

	my $rc;
	
	dropIndex( $session, "SFDBIVPI" );
	dropIndex( $session, "SFDBIVPI2" );
	dropTable( $session, "SFDBIVPT" );
	dropTable( $session, "SFDBIVPT2" );
	dropTable( $session, "SFDBIVPT3" );
	dropDatabase( $session, "SFDBIVPD" );
	dropStorGroup( $session, "SFDBIVPA" );
}

sub dropIndex {

#-------------------------------------------------------------------------------------#
#      Drop  Indexes
#
#      Input parms: a session and the Index name
#
#-------------------------------------------------------------------------------------#
	( my $session, my $index ) = @_;
	my $configRef = Cfg::getcfg();
	my $userid    = $configRef->{'UserID'};
	my $rc;

	# Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
	MAP::execPanelCmd( $session, "INDEX", "PSEDDDR4" );

	my $form = tie(
		%form, Tie::IxHash,
		'OWNER NAME  ===>' => $userID,
		'INDEX NAME  ===>' => $index,
	);

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[ENTER]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[ENTER]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "**** Index $index successfully dropped *****\n";
		$rc = 0;
	}
	else {
		print "**** INDEX $index was NOT DROPPED ***\n";
		$rc = -1;
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dropPackage {

#-------------------------------------------------------------------------------------#
#      Drop  PACKAGE
#
#      Input parms: a session and the collection ID and Package name, Version ID
#
#-------------------------------------------------------------------------------------#
	( my $session, my $collectionID,  my $package, my $versionID ) = @_;
	my $configRef = Cfg::getcfg();
	my $version = '"'.$versionID.'"';
	my $rc;

	# Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
	MAP::execPanelCmd( $session, "PACKAGE", "PSEDDDRC" );

	my $form = tie(
		%form, Tie::IxHash,
		'COLLECTION ID ===>' => $collectionID,
		'PACKAGE NAME  ===>' => $package,
	);

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[TAB]' );
	                           
	MAP::pressKeys( $session, $version );
	MAP::pressKey( $session, '[ENTER]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[ENTER]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "**** Package $package successfully dropped *****\n";
		$rc = 0;
	}
	else {
		print "**** Package $package was NOT DROPPED ***\n";
		$rc = -1;
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
}


sub dropTable {

#-------------------------------------------------------------------------------------#
#      Drop  Tables
#
#      Input parms: a session and the Table name
#   THIS utility assumes you are at the Smartfile DB2, SFD#MENU, MAIN MENU 
# 9/4/2011  JMG 
#-------------------------------------------------------------------------------------#
	( my $session, my $table ) = @_;
	my $configRef = Cfg::getcfg();
	my $userID    = $configRef->{'UserID'};
	my $rc;
   
       
  	# Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
    MAP::execPanelCmd($session, "TABLE ", "PSEDDDR3" ); 
       
	my $form = tie(
		%form, Tie::IxHash,
		'OWNER NAME  ===>' => $userID,
		'TABLE NAME  ===>' => $table,
	);

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[home]' );
	MAP::pressKey( $session, '[enter]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[enter]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "*** Table $table successfully dropped ***\n";
	}
	else {
		print "*** Table $table was NOT DROPPED ***\n";
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dropDatabase {

#-------------------------------------------------------------------------------------#
#      Drop  Database
#
#      Input parms: a session and the Database name
#
#-------------------------------------------------------------------------------------#

	( my $session, my $dataBase ) = @_;
	my $rc;
	
    # Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
	MAP::execPanelCmd( $session, "DATABASE", "PSEDDDR1" );

	my $form = tie( %form, Tie::IxHash, 'DATABASE NAME  ===>' => $dataBase, );

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[ENTER]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[ENTER]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "**** DATABASE $dataBase successfully dropped *****\n";
		$rc = 0;
	}
	else {
		print "**** DATABASE $dataBase was NOT DROPPED ***\n";
		$rc = -1;
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
}
sub createLargeObjectDatabase {

#-------------------------------------------------------------------------------------#
#      Drop  and then create Database and storage group for large object
#
#      Input parms: a session  
#-------------------------------------------------------------------------------------#

	( my $session ) = @_;
	 
    my $configRef  = Cfg::getcfg();
	my $userid     = $configRef->{'UserID'};
	my $db2ver     = $configRef->{'DB2Ver'};
	my $db2suf     = $configRef->{'DB2Suf'};
	my $db2Cntl    = $configRef->{'DB2CntlLib'};
	my $db2sub     = $configRef->{'DB2Subsystem'};
	my $rc = 0;
	$template = 'DB2VAS1T';
    $jobname  = "$userid"."T1";
	# start at the main ISPF Menu
	

	MAP::navigateBack2Panel( $session, 'ISP@MST1');

    MAP::execPanelCmd( $session, "Edit", "ISREDM01" );
	#       change JCl to drop and create Database
	MAP::write2PanelField($session, "Name . . . . .","'$db2Cntl(DB2VASF1)'" );
	
	MAP::pressKey( $session, '[enter]' ) ;
	
	copytemplate( $session, $template );
		
	MAP::write2CommandLine( $session, "C &USERID $userid", '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2SUF $db2suf ALL",   '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2VER $db2ver ALL", '[enter]' );
	
	
	#            SUBMIT THE JOB TO drop and create database
	MAP::write2CommandLine( $session, "sub", '[enter]' );
	MAP::checkBatchStatus( $session, "SUBMITTED");
	MAP::checkBatchStatus( $session, "ENDED");
	
	MAP::pressKeyRepeat( $session, '[F3]',1) ;
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	
	#  Verify the database is created.
	MAP::execPanelCmd( $session, "DB2 / Other", "DSNUTILS" );
	MAP::write2CommandLine( $session, "t", '[enter]' );
	MAP::write2CommandLine( $session, "1", '[enter]' );
	if (lc($db2sub) eq 'dbeq') {
		MAP::write2PanelField( $session, "Name  . . . .", "QAMDB99" );
		MAP::write2PanelField( $session, "Owner . . . .", "$userid" );
	} else {
		MAP::write2PanelField( $session, "Name     ===>", "QAMDB99" );
		MAP::write2PanelField( $session, "Owner    ===>", "$userid" );
	}
	MAP::write2CommandLine( $session, "D", 'enter' );
	# did we get to the record display panel? If not set a bad rc;
	$rc = MAP::findStringOnPanel( $session, "ADB21D" );
    if ($rc != 0) {
    	print "+++ QASMDB99 database not created. Check batch job output for errors. +++\n";
    	print "+++ Exiting Script run! +++";
    	exit;
    }
	MAP::findStringOnPanel( $session, "QAMDB99" ) if not $rc;

	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' ) if not $rc;
	return $rc;
}

sub createLargeObjectTable {

#------------------------------------------------------------------------------#
#  Function load large object Table                                            #
#    submit a batch job to Define the table and LOADs the data                 #
#  Parameters -                                                                #
#                                                                              #
#      The Session                                                             #
#                                                                              #
#  Author: cjm                                                                 #
#------------------------------------------------------------------------------#
	my $session  = shift;
	
	my $configRef  = Cfg::getcfg();
	my $userid     = $configRef->{'UserID'};
	my $db2ver     = $configRef->{'DB2Ver'};
	my $db2sub     = $configRef->{'DB2Subsystem'};
	my $db2suf     = $configRef->{'DB2Suf'};
	my $db2Cntl    = $configRef->{'DB2CntlLib'};
	my $rc = 0;
	my $table = 'QASFTB039112345678';
	$template = 'DB2VAS3T';

	# start at the main ISPF Menu
	

	MAP::navigateBack2Panel( $session, 'ISP@MST1');

    MAP::execPanelCmd( $session, "Edit", "ISREDM01" );
	#       change JCl to Load the DB2 table
	MAP::write2PanelField($session, "Name . . . . .","'$db2Cntl(DB2VASF3)'" );
	
	MAP::pressKey( $session, '[enter]' ) ;
	
	copytemplate( $session, $template );
	
	
	MAP::write2CommandLine( $session, "C &USERID $userid", '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2SUF $db2suf ALL",   '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2VER $db2ver ALL", '[enter]' );
	

	#            SUBMIT THE JOB TO Load the table
	MAP::write2CommandLine( $session, "sub", '[enter]' );
	MAP::checkBatchStatus( $session, "SUBMITTED");
	MAP::checkBatchStatus( $session, "ENDED");
	
	MAP::write2CommandLine( $session, "Cancel", '[enter]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	
	#  Verify the table is LOADED.
	MAP::execPanelCmd( $session, "DB2 / Other", "DSNUTILS" );
	MAP::write2CommandLine( $session, "t", '[enter]' );
	MAP::write2CommandLine( $session, "1", '[enter]' );
	if (lc($db2sub) eq 'dbeq') {
		MAP::write2PanelField( $session, "Name  . . . .", "$table" );
		MAP::write2PanelField( $session, "Owner . . . .", "$userid" );
	} else {
		MAP::write2PanelField( $session, "Name     ===>", "$table" );
		MAP::write2PanelField( $session, "Owner    ===>", "$userid" );
	}
	MAP::write2CommandLine( $session, "t", 'enter' );
	# did we get to the record display panel? If not set a bad rc;
	$rc = MAP::findStringOnPanel( $session, "ADB21T" );
    if ($rc != 0) {
    	print "+++ QASFTB$table not loaded. Check batch job output for errors. +++\n";
    	print "+++ Exiting Script run! +++";
    	exit;
    }
	MAP::findStringOnPanel( $session, "$table" ) if not $rc;

	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' ) if not $rc;
	return $rc;
}
sub dropLargeObjectAlias {

#-------------------------------------------------------------------------------------#
#      Drop  tables and Alias for large objects
#
#      Input parms: a session  
#-------------------------------------------------------------------------------------#

	( my $session ) = @_;
	 
    my $configRef  = Cfg::getcfg();
	my $userid     = $configRef->{'UserID'};
	my $db2ver     = $configRef->{'DB2Ver'};
	my $db2suf     = $configRef->{'DB2Suf'};
	my $db2Cntl    = $configRef->{'DB2CntlLib'};
	my $db2sub      = $configRef->{'DB2Subsystem'};
	my $rc = 0;
	my $table = 'QASFTB039112345678';
	$template = 'DB2VAS2T';
    $jobname  = "$userid"."T2";
	# start at the main ISPF Menu
	

	MAP::navigateBack2Panel( $session, 'ISP@MST1');

    MAP::execPanelCmd( $session, "Edit", "ISREDM01" );
	#       change JCl to drop table and alias
	MAP::write2PanelField($session, "Name . . . . .","'$db2Cntl(DB2VASF2)'" );
	
	MAP::pressKey( $session, '[enter]' ) ;
	
	copytemplate( $session, $template );
		
	MAP::write2CommandLine( $session, "C &USERID $userid", '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2SUF $db2suf ALL",   '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2VER $db2ver ALL", '[enter]' );
	
	
	#            SUBMIT THE JOB TO drop and create database
	MAP::write2CommandLine( $session, "sub", '[enter]' );
	MAP::checkBatchStatus( $session, "SUBMITTED");
	MAP::checkBatchStatus( $session, "ENDED");
	
	MAP::pressKeyRepeat( $session, '[F3]',1) ;
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	#  Verify the table is dropped.
	MAP::execPanelCmd( $session, "DB2 / Other", "DSNUTILS" );
	# Make sure to write the subsystem name. Sometimes it's missing
	MAP::write2PanelField( $session, "SELECT SUBSYSTEM==>", $db2sub);
	# put the cursor back on the command line
	MAP::pressKey( $session, '[enter]' );
	MAP::write2CommandLine( $session, "t", '[enter]' );
	# verify we're on the correct panel
	MAP::findStringOnPanel( $session, "DB2 Administration Menu" );
	MAP::write2CommandLine( $session, "1", '[enter]' );
	if (lc($db2sub) eq 'dbeq') {
		MAP::write2PanelField( $session, "Name  . . . .", "$table" );
		MAP::write2PanelField( $session, "Owner . . . .", "$userid" );
	} else {
		MAP::write2PanelField( $session, "Name     ===>", "$table" );
		MAP::write2PanelField( $session, "Owner    ===>", "$userid" );
	}

	
	MAP::write2CommandLine( $session, "t", 'enter' );
	$rc = MAP::findStringOnPanel( $session, "No rows returned" );
    if ($rc != 0) {
    	print "+++ $table Table not dropped. Check output from batch submit. +++\n";
    	print "+++ Exiting script! +++\n";
    	exit;
    }
	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	return $rc;
	
}

sub dropStorGroup {

#-------------------------------------------------------------------------------------#
#      Drop  Storage Group
#
#      Input parms: a session and the Storage Group name
#
#-------------------------------------------------------------------------------------#

	( my $session, my $storGroup ) = @_;
	my $rc;

	# Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
	MAP::execPanelCmd( $session, "STOGROUP", "PSEDDDR7" );

	my $form = tie( %form, Tie::IxHash, 'STOGROUP  NAME ===>' => $storGroup, );

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[ENTER]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[ENTER]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "**** STORAGE GROUP $storGroup successfully dropped *****\n";
		$rc = 0;
	}
	else {
		print "**** STORAGE GROUP $storGroup was NOT DROPPED ***\n";
		$rc = -1;
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	return ;
}

sub dropTableBatch {

#------------------------------------------------------------------------------#
#  Function droptable                                                          #
#    submit a batch job to drop a table used in smartfile.                     #
#  Parameters -                                                                #
#                                                                              #
#        Session, table,                                                       #
#                                                                              #
#                                                                              #
#  Author: jmg                                                                 #
#------------------------------------------------------------------------------#
	my $session   = shift;
	my $table     = shift;
	my $configRef       = Cfg::getcfg();
	my $userid          = $configRef->{'UserID'};
	my $db2ver          = $configRef->{'DB2Ver'};
	my $db2suf          = $configRef->{'DB2Suf'};
	my $db2Cntl         = $configRef->{'DB2CntlLib'};
	my $dB2Subsystem    = $configRef->{'DB2Subsystem'};

	my $rc;
 	my $template = 'MAPDRTBT';
  
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	#  To the edit panel to enter library and member name.
	MAP::execPanelCmd( $session, "Edit", "ISREDM01" );
	MAP::write2PanelField(
		$session,
		"Name . . . . .",
		"'$db2Cntl(MAPDRTB)'"
	);
	MAP::pressKey( $session, '[enter]' );
	copytemplate( $session, $template );
    
	#       change JCl to MAPDRTB
	MAP::write2CommandLine( $session, "C &USERID $userid", '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2VER $db2ver", '[enter]' );
	MAP::write2CommandLine( $session, "C &TABLE $table",   '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2SUF $db2suf",   '[enter]' );
	MAP::write2CommandLine( $session, "sub",               '[enter]' );
	MAP::checkBatchStatus( $session, "SUBMITTED");
	MAP::checkBatchStatus( $session, "ENDED");
	MAP::write2CommandLine( $session, "Cancel", '[enter]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	#  Verify the table is dropped.
	MAP::execPanelCmd( $session, "DB2 / Other", "DSNUTILS" );
	# Make sure to write the subsystem name. Sometimes it's missing
	MAP::write2PanelField( $session, "SELECT SUBSYSTEM==>", $dB2Subsystem);
	# put the cursor back on the command line
	MAP::pressKey( $session, '[enter]' );
	MAP::write2CommandLine( $session, "t", '[enter]' );
	# verify we're on the correct panel
	MAP::findStringOnPanel( $session, "DB2 Administration Menu" );
	MAP::write2CommandLine( $session, "1", '[enter]' );
	if (lc($dB2Subsystem) eq 'dbeq') {
		MAP::write2PanelField( $session, "Name  . . . .", "QASFTB$table" );
		MAP::write2PanelField( $session, "Owner . . . .", "$userid" );
	} else {
		MAP::write2PanelField( $session, "Name     ===>", "QASFTB$table" );
		MAP::write2PanelField( $session, "Owner    ===>", "$userid" );
	}

	
	MAP::write2CommandLine( $session, "t", 'enter' );
	$rc = MAP::findStringOnPanel( $session, "No rows returned" );
    if ($rc != 0) {
    	print "+++ QASFTB$table Table not dropped. Check output from batch submit. +++\n";
    	print "+++ Exiting script! +++\n";
    	exit;
    }
	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	return $rc;
}


sub loadTableBatch {

#------------------------------------------------------------------------------#
#  Function loadTableBatch                                                     #
#    submit a batch job to Define the table and LOADs the data                 #
#  Parameters -                                                                #
#                                                                              #
#      The Session, table                                                      #
#                                                                              #
#                                                                              #
#  Author: jmg                                                                 #
#------------------------------------------------------------------------------#
	my $session  = shift;
	my $table    = shift;
	my $database = shift;

	my $configRef  = Cfg::getcfg();
	my $userid     = $configRef->{'UserID'};
	my $db2ver     = $configRef->{'DB2Ver'};
	my $db2sub     = $configRef->{'DB2Subsystem'};
	my $db2suf     = $configRef->{'DB2Suf'};
	my $db2Cntl    = $configRef->{'DB2CntlLib'};
	my $rc = 0;
	my $template = 'MAPLOADT';

	# start at the main ISPF Menu
	

	MAP::navigateBack2Panel( $session, 'ISP@MST1');

    MAP::execPanelCmd( $session, "Edit", "ISREDM01" );
	#       change JCl to Load the DB2 table
	MAP::write2PanelField($session, "Name . . . . .","'$db2Cntl(MAPLOAD)'" );
	
	MAP::pressKey( $session, '[enter]' ) ;
	
	copytemplate( $session, $template );
	
	
	MAP::write2CommandLine( $session, "C &USERID $userid", '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2SUF $db2suf ALL",   '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2VER $db2ver ALL", '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2SUB $db2sub ALL", '[enter]' );
	MAP::write2CommandLine( $session, "C &DATABASE $database ALL", '[enter]' );
	MAP::write2CommandLine( $session, "C &TABLE $table ALL", '[enter]' );
	

	#            SUBMIT THE JOB TO Load the table
	MAP::write2CommandLine( $session, "sub", '[enter]' );
	MAP::checkBatchStatus( $session, "SUBMITTED");
	MAP::checkBatchStatus( $session, "ENDED");
	
	MAP::write2CommandLine( $session, "Cancel", '[enter]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	
	#  Verify the table is LOADED.
	MAP::execPanelCmd( $session, "DB2 / Other", "DSNUTILS" );
	MAP::write2CommandLine( $session, "t", '[enter]' );
	MAP::write2CommandLine( $session, "1", '[enter]' );
	if (lc($db2sub) eq 'dbeq') {
		MAP::write2PanelField( $session, "Name  . . . .", "QASFTB$table" );
		MAP::write2PanelField( $session, "Owner . . . .", "$userid" );
	} else {
		MAP::write2PanelField( $session, "Name     ===>", "QASFTB$table" );
		MAP::write2PanelField( $session, "Owner    ===>", "$userid" );
	}
	MAP::write2CommandLine( $session, "t", 'enter' );
	# did we get to the record display panel? If not set a bad rc;
	$rc = MAP::findStringOnPanel( $session, "ADB21T" );
    if ($rc != 0) {
    	print "+++ QASFTB$table not loaded. Check batch job output for errors. +++\n";
    	print "+++ Exiting Script run! +++";
    	exit;
    }
	MAP::findStringOnPanel( $session, "QASFTB$table" ) if not $rc;

	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' ) if not $rc;
	return $rc;
}

sub copytemplate{
	
	my $session  = shift;
	my $template = shift;
	
	if (!$template) {
    	print "+++ Template name is blank - Please check template name. +++\n";
    	print "+++ Exiting Script run! +++\n";
    	exit;
    } 
	
	MAP::write2CommandLine( $session, "delete nx all", '[enter]',"Command ===> " );
    MAP::write2CommandLine( $session, "copy $template", '[enter]',"Command ===> " );
	
}


sub unloadcompareTableBatch {

#------------------------------------------------------------------------------#
#  Function unload&compareTableBatch                                           #
#    submit a batch job to Unload table and compare it to the base             #
#  Parameters -                                                                #
#                                                                              #
#      The Session, table#, Base#, TCD#                                        #
#                                                                              #
#                                                                              #
#  Author: Cjm                                                                 #
#------------------------------------------------------------------------------#
	my $session  = shift;
	my $table    = shift;
	my $base     = shift;
    my $tcd      = shift;
    
	my $configRef = Cfg::getcfg();
	my $userid    = $configRef->{'UserID'};
	my $db2ver    = $configRef->{'DB2Ver'};
	my $db2Cntl    = $configRef->{'DB2CntlLib'};
	my $rc = 0 ;
	my $template = 'MAPUNLDT';
	my $jobname  =  "$userid"."UL";

	# start at the main ISPF Menu
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );



	# change JCl to UnLoad and compare the DB2 table
	MAP::execPanelCmd( $session, "Edit", "ISREDM01" );
	MAP::write2PanelField($session,	"Name . . . . .","'$db2Cntl(MAPUNLD)'", '[enter]');	  
	
	copytemplate( $session, $template );
	
	MAP::write2CommandLine( $session, "C &USERID $userid", '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2VER $db2ver", '[enter]' );
	MAP::write2CommandLine( $session, "C &BASE $base", '[enter]' );
	MAP::write2CommandLine( $session, "C &TABLE $table", '[enter]' );
	MAP::write2CommandLine( $session, "C &TCD $tcd", '[enter]' );

	#            SUBMIT THE JOB TO Load the table
	MAP::write2CommandLine( $session, "sub", '[enter]');     
	MAP::checkBatchStatus( $session, "SUBMITTED");
    MAP::checkBatchStatus( $session, "ENDED");
	MAP::write2CommandLine( $session, "Cancel", '[enter]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
    MAP::write2CommandLine( $session, "=s;st", '[enter]',"===>" );
    MAP::write2CommandLine( $session, "owner $userid", '[enter]',"COMMAND INPUT ===>" );
    MAP::write2CommandLine( $session, "pre $jobname", '[enter]',"COMMAND INPUT ===>" );
    MAP::panelListAction($session, "$jobname", "S");
    $status = MAP::findStringOnPanel( $session, "TCDUNLD  SUPERC      00" );
     
    if ($status == -1) {
    	$rc = -1;
    }
    
	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' ) if not $rc;
	return $rc;
}



sub createDataBaseBatch {

#------------------------------------------------------------------------------#
#  Function createDataBaseBatch                                                     #
#    submit a batch job to create the data base.                               #
#  Parameters -                                                                #
#                                                                              #
#        Session                                                               #
#                                                                              #
#  Author: jmg                                                                 #
#------------------------------------------------------------------------------#
	my $session   = shift;
	my $DataBase  = shift;
	my $configRef = Cfg::getcfg();
	my $userid    = $configRef->{'UserID'};
	my $db2ver    = $configRef->{'DB2Ver'};
	my $db2Cntl    = $configRef->{'DB2CntlLib'};
	my $rc;

	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	#  To the edit panel to enter library and member name.
	MAP::execPanelCmd( $session, "Edit", "ISREDM01" );
	MAP::write2PanelField(
		$session,
		"Name . . . . .",
		"'$db2Cntl(MAPCRDB)'"
	);
	MAP::pressKey( $session, '[enter]' ) ;;

	#       change JCl to MAPCRDB
	MAP::write2CommandLine( $session, "C &USERID $userid", '[enter]' )
	  ;
	MAP::write2CommandLine( $session, "C &DB2VER $db2ver", '[enter]' )
	  ;
	MAP::write2CommandLine( $session, "C &DATABASE $DataBase", '[enter]' )
	  ;
	MAP::write2CommandLine( $session, "sub", '[enter]' ) ;;
	MAP::pressKey( $session, '[enter]' ) ;;
	MAP::write2CommandLine( $session, "Cancel", '[enter]' ) ;;

	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	#  Verify the stoGrp is created.
	MAP::execPanelCmd( $session, "DB2 / Other", "DSNUTILS" );
	MAP::write2CommandLine( $session, "t", '[enter]' );
	MAP::write2CommandLine( $session, "d", '[enter]' );
	MAP::write2PanelField( $session, "Owner    ===>", "$userid" );
	MAP::write2CommandLine( $session, "d", 'enter' );
	$rc = MAP::findStringOnPanel( $session, "QASFDB$DataBase $userid" );

	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	return $rc;
}

sub createStoGrpBatch {

#------------------------------------------------------------------------------#
#  Function CreateStogrpBatch                                                       #
#    submit a batch job to create the stor group                               #
#  Parameters -                                                                #
#                                                                              #
#        Session                                                               #
#                                                                              #
#  Author: jmg                                                                 #
#------------------------------------------------------------------------------#
	my $session   = shift;
	my $configRef = Cfg::getcfg();
	my $userid    = $configRef->{'UserID'};
	my $db2ver    = $configRef->{'DB2Ver'};
	my $db2Cntl   = $configRef->{'DB2CntlLib'};
	my $rc;

	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	#       To the edit panel to enter library and member name.
	MAP::execPanelCmd( $session, "Edit", "ISREDM01" );
	MAP::write2PanelField(
		$session,
		"Name . . . . .",
		"'$db2Cntl(MAPCRSG)'"
	);
	MAP::pressKey( $session, '[enter]' ) ;

	#change JCl to MAPCRSG
	MAP::write2CommandLine( $session, "C &USERID $userid", '[enter]' );
	MAP::write2CommandLine( $session, "C &DB2VER $db2ver", '[enter]' );
	  ;;
	MAP::write2CommandLine( $session, "sub", '[enter]' ) ;
	MAP::pressKey( $session, '[enter]' ) ;;
	MAP::write2CommandLine( $session, "Cancel", '[enter]' ) ;

	#    back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

	#  Verify the stogrp is created.
	MAP::execPanelCmd( $session, "DB2 / Other", "DSNUTILS" );
	MAP::write2CommandLine( $session, "t", '[enter]' );
	MAP::write2CommandLine( $session, "1", '[enter]' );
	MAP::write2PanelField( $session, "Owner    ===>", "$userid" );
	MAP::write2CommandLine( $session, "g", 'enter' );
	$rc = MAP::findStringOnPanel( $session, "QASFST$stogrp $userid" );

	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	return $rc;
}

sub dropTablespace {

#-------------------------------------------------------------------------------------#
#      Drop  Tablespace
#
#      Input parms: a session and the Tablespace name and Database name
#
#-------------------------------------------------------------------------------------#

	( my $session, my $tablespace, $database ) = @_;
	my $rc;
	
	# Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
	MAP::execPanelCmd( $session, "TABLESPACE", "PSEDDDR2" );

	my $form = tie(
		%form, Tie::IxHash,
		'DATABASE NAME   ===>' => $database,
		'TABLESPACE NAME ===>' => $tablespace,
	);

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[ENTER]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[ENTER]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "**** Tablespace $tablespace successfully dropped *****\n";
		$rc = 0;
	}
	else {
		print "**** Tablespace $tablespace was NOT DROPPED ***\n";
		$rc = -1;
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dropView {

#-------------------------------------------------------------------------------------#
#      Drop  View
#
#      Input parms: a session and the View name and userid
#
#-------------------------------------------------------------------------------------#

	( my $session, my $view) = @_;
	my $configRef = Cfg::getcfg();
	my $userid    = $configRef->{'UserID'};
	my $rc;

	# Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
	MAP::execPanelCmd( $session, "VIEW", "PSEDDDR5" );

	my $form = tie(
		%form, Tie::IxHash,
		'OWNER NAME  ===>' => $userid,
		'VIEW NAME   ===>' => $view,
	);

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[ENTER]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[ENTER]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "**** View $view successfully dropped *****\n";
		$rc = 0;
	}
	else {
		print "**** View $view was NOT DROPPED ***\n";
		$rc = -1;
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dropSynonym {

#-------------------------------------------------------------------------------------#
#      Drop  Synonym
#
#      Input parms: a session and the synonym name
#
#-------------------------------------------------------------------------------------#

	( my $session, my $synonym ) = @_;
	my $rc;

	# Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
	MAP::execPanelCmd( $session, "SYNONYM", "PSEDDDR6" );

	my $form = tie(
		%form, Tie::IxHash,
		'SYNONYM  ===>' => $synonym,

	);

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[ENTER]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[ENTER]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "**** Synonym $synonym successfully dropped *****\n";
		$rc = 0;
	}
	else {
		print "**** Synonym $synonym was NOT DROPPED ***\n";
		$rc = -1;
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dropAlias {

#-------------------------------------------------------------------------------------#
#      Drop  Alias
#
#      Input parms: a session and the Alias name
#
#-------------------------------------------------------------------------------------#

	( my $session, my $alias ) = @_;
	my $configRef = Cfg::getcfg();
	my $userid    = $configRef->{'UserID'};
	my $rc;

   	# Naviguate to Drop Menu
	naviguate_to_drop_menu( $session);
    MAP::execPanelCmd( $session, "ALIAS", "PSEDDDRB" );
                                            
	my $form = tie(
		%form, Tie::IxHash,
		      'OWNER ===>' => $userid,
		'      NAME  ===>' => $alias,
	);

	MAP::write2Panel( $session, $form );
	MAP::pressKey( $session, '[ENTER]' );

	# Confirm Dropping of  Object
	MAP::pressKey( $session, '[ENTER]' );
	$status = MAP::findStringOnPanel( $session, "OBJECT DROPPED", 0, 1 );

	if ( !$status ) {
		print "**** Alias $alias successfully dropped *****\n";
		$rc = 0;
	}
	else {
		print "**** Alias $a was NOT DROPPED ***\n";
		$rc = -1;
	}
	MAP::pressKey( $session, '[F3]' );
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dataResetbatch {

#-------------------------------------------------------------------------------------#
#   Reset the tables running a batch job.
#   JMG   8/30/11
#
#                caller   $status = DB2::dataResetbatch($session,$table,$database);
#-------------------------------------------------------------------------------------#
	my $session   = shift;
	my $table     = shift;
	my $database  = shift;

	my $configRef = Cfg::getcfg();
	my $userid    = $configRef->{'UserID'};
	my $db2ver    = $configRef->{'DB2Ver'};
	my $rc;

	# start at the main ISPF Menu

	dropTableBatch( $session, $table );
	loadTableBatch( $session, $database, $table );

}

sub copyTable  {
#-------------------------------------------------------------------------------------#
#   COPY A TABLE 
#   JMG   10/4/11
#
#      caller   $status = DB2::dataResetbatch($session,$sowner,$otable,$ntable);
#-------------------------------------------------------------------------------------#
	my $session   = shift;
	my $sowner    = shift;
	my $otable    = shift;
	my $ntable    = shift;
	my $configRef = Cfg::getcfg();
	my $execclist = $configRef->{'Exec'};
	my $userID    = $configRef->{'UserID'};
	my $db2Cntl   = $configRef->{'DB2CntlLib'};
    my $dB2Subsystem      = $configRef->{'DB2Subsystem'};
	my $rc;

	
# start at the main ISPF Menu
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );

#       START THE SMART FILE PANELS.
        MAP::write2CommandLine($session, "=6", '[enter]'); 
        MAP::write2CommandLine($session, "ex '$execclist'", '[enter]');

        MAP::execPanelCmd($session, "DB2", "SFD#MENU" ) ; 
        MAP::execPanelCmd($session, "Utilities", "PSEDDCFM" ); 
        MAP::execPanelCmd($session, "COPY", "PSEDDCCO" ); 

#       FILL VALUES FOR OLD TABLE 
        my $db2copyo = tie(
	       %form, Tie::IxHash,
	       'TABLE/VIEW OWNER    ===>' =>  "$sowner",
	       'TABLE/VIEW NAME     ===>' =>  "$otable",
);
#       WRITE TO PANEL PSEDD20  
        MAP::write2Panel( $session, $db2copyo);
        MAP::pressKey( $session, '[enter]');

#       FILL VALUES FOR NEW TABLE
        my $db2copyn = tie(
        	%form, Tie::IxHash,
        	'TABLE OWNER      ==>' =>  "$userID",
	        'TABLE NAME       ==>' =>  "$ntable",
);
#       WRITE TO PANEL PSEDDTAC  
        MAP::write2Panel( $session, $db2copyn );
        MAP::pressKey( $session, '[enter]');
        MAP::pressKey( $session, '[f6]');
        MAP::write2PanelField( $session, 'INDEX NAME  ===>','index999');
        MAP::pressKeyRepeat( $session, '[tab]','19');
        MAP::pressKeys( $session, "asc");
        MAP::pressKey( $session,'[f6]');

	#  back to ISPF master
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	return $rc;
}

sub go2DB2SysCatalog {
	# A routine used by scripts that need to access the IBM DB2 admin panels. 
	# accommodates the DB2 version 11 panel change.
	# Parms: 
	#   a Session
	#   the database name
	#   the owner of the database 
	#   and one of the follown object option 
	#  
	#  AO - Authorization options                              DB2 SQL ID: QA05
	#  G - Storage groups                   P - Plans                         
	#  D - Databases                        L - Collections                   
	#  S - Table spaces                     K - Packages                      
	#  T - Tables, views, and aliases                                         
	#  V - Views                            H - Schemas                       
	#  A - Aliases                          E - User defined data types       
	#  Y - Synonyms                         F - Functions                     
	#  X - Indexes                          O - Stored procedures             
	#  C - Columns                          J - Triggers                      
	#  N - Constraints                      Q - Sequences                     
	# DS - Database structures            DSP - DS with plans and packages    
	#PDC - DB2 pending definition changes  GV - Global variables              
	#XCU - Index cleanup        
	                                              
	my $session = shift;
	my $name    = shift;
	my $owner   = shift;
	my $option  = shift;
	
	my $configRef = Cfg::getcfg();
    my $dB2Subsystem      = $configRef->{'DB2Subsystem'};
    
	package MAP;
	write2CommandLine( $session, "=D", '[enter]' ); 
	execPanelCmd( $session, "ADMIN Tool","ADB2" );
	execPanelCmd( $session, "- DB2 system catalog ","ADB21" );
	if (lc($dB2Subsystem) eq 'dbeq') {
		write2PanelField( $session, "Name  . . . .", "$name" );
		write2PanelField( $session, "Owner . . . .", "$owner" );
	} else {
		write2PanelField( $session, "Name     ===>", "$name" );
		write2PanelField( $session, "Owner    ===>", "$owner" );
	}
	
	if (lc($dB2Subsystem) eq 'dbeq' && lc($option) eq 'v') {
		write2CommandLine( $session, $option, '[enter]' );
		pressKey  ($session, '1');
		pressKey  ($session, '[enter]');
		
		
	} else {
		write2CommandLine( $session, $option, '[enter]' );
	}
	package;
	return 0;
}

sub viewDB2DatabasesPanel {
    # accesses the IBM DB2 system catalog view database panel
	my $session = shift;
	my $dbName  = shift;
	my $dbOwner = shift;
	my $rc = go2DB2SysCatalog($session, $dbName, $dbOwner, 'd');
	
	return $rc;
	
}
1;