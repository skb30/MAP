#!/bin/perl  -w
package SmartTools;
use Win32::API;
use Hllapi;
use Common;
use MAP;
no warnings;


sub dataReset {

	my $session = shift @_;
	my $dsn     = shift @_;
	my $rc;
	Common::turnOnPanelID($session);

	# delete audit data set
	MAP::navigateBack2Panel( $session, 'ISP@MST1' );
	MAP::write2CommandLine( $session, "tso del '$dsn'", '[enter]' );
	Hllapi::hitKey( $session, '[enter]');
	Hllapi::hitKey( $session, '[enter]');
	return 0;
}

sub copyDataSet {
    my $session = shift @_;
    my $input = shift @_;
    my $output = shift @_;
    my $form;
	MAP::execPanelCmd($session, "Copy/Reformat","SFMASRCH" );
# Create the panel form 
	    $form = tie(
		%form, Tie::IxHash,
		'Function ===>'     => "A",
		'DATASET NAME'      => "'".$input."'",
);
# Write the form to the panel fields
	MAP::write2Panel( $session, $form, '[enter]');
	
	$form = tie(
	%form, Tie::IxHash,
	'Output Dataset'     => "'".$output."'",
);
# Write the form to the panel fields
	MAP::write2Panel( $session, $form, '[enter]');
    MAP::pressKey($session, '[enter]'); 
    $rc = MAP::findStringOnPanel( $session, "PROCESSING COMPLETED" );
    MAP::pressKey($session, '[F3]');
    return $rc; 
}

sub deleteDataset {
    my $session = shift @_;
    my $dsn = shift @_;
    my $form;
	Hllapi::hitKey( $session, '[f2]' );
	MAP::write2CommandLine( $session, "tso del '$dsn'", '[enter]',"Option ===>" );
	Hllapi::hitKey( $session, '[enter]' );
	Hllapi::hitKey( $session, '[enter]' );
	Hllapi::keys2press( $session, "=x", '[enter]' );
	return 0;
}

sub buildFileName { 
#------------------------------------------------------------------------------#
#  Function buildFileName                                                      #
#                                                                              #
#      Use this function to build a file name                                  #
#                                                                              #
#  Parameters -                                                                #
#      Session Object                                                          #
#      Array of nodes to process                                               #
#                                                                              #
#  Returns -                                                                   #
#      $dsn - fully qualified dataset                                          #
#                                                                              #
#  Author: fra                                                                 #
#------------------------------------------------------------------------------#

#    my $session = shift @_;
#    local(*nodes) = @_;
    
#    my @nodes = shift @_;
    my $segment;
    my $session   = shift;
    my $ref_nodes = shift;
    
    # deref the nodes array reference 
    my @nodes     = @{$ref_nodes};
    my $node;
    my $dsn;

    foreach $node(@nodes)

	{
	   $dsn = $dsn.$node.".";	
	}
	# chop off the trailing . on the DSN
	chop($dsn);
	return $dsn;
}

sub startSmartFile {

    my $session = shift @_;
    my $configRef = Cfg::getcfg();	
       
# determine the PCOM session ID to connect to.
   my $version   = $configRef->{'Version'};
   my $release   = $configRef->{'Release'};
   my $clistName = $configRef->{'Clist'};
   my $sessionID = $configRef->{'SessionID'};
   my $hlq       = $configRef->{'HLQ'};

#
## Navigate to the ISPF command shell
   $status = MAP::navigate2Panel( $session, "Command", "ISRTSO" ) if ( not $status );
#
## STEP 2 - Launch the product
   $status =
        MAP::write2CommandLine( $session,
    	"ex 'QAL.PHX." . $release . ".clist(" . $clistName . ")'", '[enter]' );
}

sub IVPView {
		my $session = shift @_;
		my $viewMode = shift @_;
		my $fileType = shift @_;
	    my $counter = shift @_;
    	my $configRef = Cfg::getcfg();	
  		my $release   = $configRef->{'Release'};
   		my $hlq       = $configRef->{'HLQ'};

		# STEP 3 - View a dataset in Unformated Mode
		#
		# Build work file name
		my @fileName = ( $hlq, $release, "IVP", $fileType );
		my $infile = SmartTools::buildFileName( $session, \@fileName );

		$status =  MAP::navigateBack2Panel( $session, "PDSMENUS" );

		# Navigate to panel PDSM04E
		$status =  MAP::execPanelCmd( $session, "View/Edit", "PDSM04E");

		# Create the panel form
		my $form = tie(
			%form, Tie::IxHash,
			'DATASET NAME'    => "'$infile'",
			'DISPOSITION'     => "SHR",
			'View mode'       => "$viewMode",
			'Use copybook'    => 'NO',
			'Record select'   => 'NO',
			'Audit changes'   => 'NO',
			'Extended prompt' => 'NO',
		);

		# Write the form to the panel fields
		 MAP::ln(__LINE__);
		$status = MAP::write2Panel( $session, $form, '[enter]' ) if ( not $status );

		# verify panel here.
		$panelFile = "AIVP$counter" . "_file.panel";
		$counter++;
		 MAP::ln(__LINE__);
		$status = MAP::verifyPanel( $session, "'$panelFile'" ) if ( not $status );

		 MAP::ln(__LINE__);
		$status = MAP::pressKey( $session, '[f3]' ) if ( not $status );

# MAP::ln(__LINE__); $status = findStringOnPanel($session, 'PDSPVEND     Exit option for PVIEW', '[enter]') if ( not $status );
# MAP::ln(__LINE__); $status = pressKey($session, '[enter]') if ( not $status );
#
# STEP 4 - View a dataset in Formated Mode
#
# checking VIEW with COPYBOOK
		  $form = tie(
			%form, Tie::IxHash,
			'DATASET NAME'    => "'$infile'",
			'DISPOSITION'     => "SHR",
			'View mode'       => 'VIEW',
			'Use copybook'    => 'YES',
			'Record select'   => 'NO',
			'Audit changes'   => 'NO',
			'Extended prompt' => 'NO',
		);

		# Write the form to the panel fields
		 MAP::ln(__LINE__);
		$status = MAP::write2Panel( $session, $form, '[enter]' ) if ( not $status );

		#  build cpybook name
		  @fileName = ( $hlq, $release, "CNTL" );
		my $cpybook = SmartTools::buildFileName( $session, \@fileName )
		  if ( not $status );
		 $form = tie(
			%form, Tie::IxHash,
			'Display format'  => 'COPYBOOK',
			'Dataset name'    => "'$cpybook'",
			'Member name'     => "SFMIVPC1",
			'Dataset type'    => "MVS",
			'Language type'   => 'EITHER',
			'Starting column' => '1',
			'Data Map Member' => '',
		);

		# Write the form to the panel fields
		 MAP::ln(__LINE__);
		$status =  MAP::write2Panel( $session, $form, '[enter]' ) if ( not $status );
		$panelFile = "AIVP$counter" . "_file.panel";
		$counter++;
		 MAP::ln(__LINE__);
		$status =  MAP::verifyPanel( $session, "'$panelFile'" ) if ( not $status );
		 MAP::ln(__LINE__);
		$status =
		   MAP::write2CommandLine( $session, "NEXT", '[enter]', "COMMAND ===>" )
		  if ( not $status );

		# Now match the current panel data to the expected panel data
		$panelFile = "AIVP$counter" . "_file.panel";
		$counter++;
		 MAP::ln(__LINE__);
		$status =  MAP::verifyPanel( $session, "'$panelFile'" ) if ( not $status );
		 MAP::ln(__LINE__);
		$status =
		   MAP::write2CommandLine( $session, "NEXT 5", '[enter]', "COMMAND ===>" )
		  if ( not $status );
		$panelFile = "AIVP$counter" . "_file.panel";
		$counter++;
		 MAP::ln(__LINE__);
		$status =  MAP::verifyPanel( $session, "'$panelFile'" ) if ( not $status );
		 MAP::ln(__LINE__);
		$status =
		   MAP::write2CommandLine( $session, "PREV", '[enter]', "COMMAND ===>" )
		  if ( not $status );
		$panelFile = "AIVP$counter" . "_file.panel";
		$counter++;
		 MAP::ln(__LINE__);
		$status =  MAP::verifyPanel( $session, "'$panelFile'" ) if ( not $status );
		 MAP::ln(__LINE__);
		$status =  MAP::write2CommandLine( $session, "SC", '[enter]', "COMMAND ===>" )
		  if ( not $status );
		$panelFile = "AIVP$counter" . "_file.panel";
		$counter++;
		 MAP::ln(__LINE__);
		$status =  MAP::verifyPanel( $session, "'$panelFile'" ) if ( not $status );
		 MAP::ln(__LINE__);
		$status =  MAP::navigateBack2Panel( $session, "PDSM04E" ) if ( not $status );
		 MAP::ln(__LINE__);
		$status = MAP::pressKey( $session, '[enter]' ) if ( not $status );

		#
		# STEP 5 - View a dataset in Formated Mode using Assembler Copybook
		#
		  $form = tie(
			%form, Tie::IxHash,
			'Display format'  => 'COPYBOOK',
			'DATASET NAME'    => "'$cpybook'",
			'Member name'     => "SFMIVPA1",
			'Dataset type'    => 'MVS',
			'Language type'   => 'ASM     ',
			'Starting column' => '1',
			'Data Map Member' => '',
		);

		# Write the form to the panel fields
		 MAP::ln(__LINE__);
		$status =  MAP::write2Panel( $session, $form, '[enter]' ) if ( not $status );
		 MAP::ln(__LINE__);
		$status =  MAP::pressKey( $session, '[enter]' ) if ( not $status );

		$panelFile = "AIVP$counter" . "_file.panel";
		$counter++;
		 MAP::ln(__LINE__);
		$status =  MAP::verifyPanel( $session, "'$panelFile'" ) if ( not $status );
		return (0, $counter);
}

sub addCopybookToDatamap {
#    
#   This routine will find a copybook member or dashes on screen and then insert  
#   a line.  It will then enter passed copybook name and parms onto panel
#    
    my $session  = shift;
    my $copybook = shift;
    my $lang     = shift;
    my $type     = shift;
    my $prevCopybook = shift;	#

	$status = putCursorOnPanelSrting( $session, $prevCopybook )
  		if ( not $status );

	$status = pressKey( $session, '[back_tab]', ) if ( not $status );		
	$status = pressKey( $session, 'I', '[enter]' ) if ( not $status );		
	$status = putCursorOnPanelSrting( $session, "_   ________ " ) if ( not $status );
	$status = pressKey( $session, 'S' ) if ( not $status );		
	$status = pressKeys( $session, $copybook ) if ( not $status );		
	$status = pressKeys( $session, $lang ) if ( not $status );		
	$status = pressKeys( $session, $type, '[enter]' ) if ( not $status );		
#
}
sub execDatamapCriteria {
#    
#   This routine will find a field in a copybook member then insert  
#   passed operand and value 
#    

    my $session  = shift;
    my $field	 = shift;
    my $operand  = shift;
    my $value    = shift;

	$status = putCursorOnPanelSrting( $session, $field ) if ( not $status );
	$status = pressKey( $session, '[tab]', ) if ( not $status );		
	$status = pressKeys( $session, $operand ) if ( not $status );		
	$status = pressKeys( $session, $value, '[enter]' ) if ( not $status );		
	$status = pressKey( $session, '[f3]', ) if ( not $status );
		
}

sub selectMemberInPDS {
#    
#   This routine will accept a member name and will first find it in a member list and then 
#   select it 
# 
    my $session  = shift;
    my $member	 = shift;
    my $status   = 0;
    
	write2CommandLine( $session, "L $member", '[enter]', "COMMAND ===>" );

	$status = putCursorOnPanelSrting( $session, $member );
	$status = pressKey( $session, '[back_tab]', ) if ( not $status );		
	$status = pressKey( $session, 'S', '[enter]' ) if ( not $status );		
	
	return $status;
	
}

sub startIAM {
	
	my $configRef 		  = Cfg::getcfg();
	my $batchJob1		  = $configRef->{'BatchJob1'};
	my $iamfile           = 'QAL.PHX.SFAUTO.TEMPIAM';
	my $rc = 0;
	 
	package MAP;
	
	# Delete the temporary test IAM file 
	write2CommandLine( $session, "tso del '$iamfile'", '[enter]' );
	pressKey( $session, '[enter]' );
	# submit iamstart to start iam, verify job completion, and purge output 
	$rc = write2CommandLine($session, "tso sub \'qal.phx.sfxtest.cntl(iamstart)\'",'[enter]' ); 
	$rc = findStringOnPanel($session, "SUBMITTED");
	
	# use checkbatch status to verify the job completed
	$rc = checkBatchStatus( $session, "ENDED") ;

	# delete all the output for the batchjob
	$rc = write2CommandLine( $session, "=s;/\$p JOBQ,JOBMASK=$batchJob1", '[enter]',"===>");
	$rc = navigateBack2Panel( $session, 'ISP@MST1');
	
	return;

}
sub copyIAM {
	
	my $configRef 		  = Cfg::getcfg();
	my $sessionID  		  = $configRef->{'SessionID'};
	my $execclist         = $configRef->{'Exec'};
	my $iamfile           = 'QAL.PHX.SFAUTO.TEMPIAM';
	my $masteriamfile     = 'QAL.PHX.SFAUTO.AMBSDATA.IAM';
	my $form;
	my $rc = 0;
	
	package MAP;
	# Go to SmartFile
	$rc = execPanelCmd($session, "Command","ISRTSO" );

	# go to Primary option menu PDSMENUS
	$rc = write2CommandLine( $session, "exec '$execclist'", '[enter]' );

	# using smartfile, copy the master iam to the temp version
	$rc = execPanelCmd( $session, "Copy/Reformat","SFMASRCH" );

	    $form = tie(
		%form, Tie::IxHash,             
	
		'Function ===>'                  => "a",
		'Batch Submit? ===>'             => "n",
		'NAME ===>'		                 => "'$masteriamfile'",
		'Autosave ===>'		             => "N",
		'Edit? ===>'	                 => "Y",
	);

	$rc = write2Panel( $session, $form, '[enter]');
 
	# fill in copy/reformat target definition panel
	    $form = tie(
		%form, Tie::IxHash,             
	
		'Output Dataset  ===>'            => "'$iamfile'",
		'Disposition    ===>'             => "new",
		'Retain Output  ===>'		      => "N",
		'Replace members ===>'		      => "N",
		'Member option   ===>'	          => "Y",
		'VSAM ?         ===>'	          => "Y",
		'Model dataset   ===>'	          => "'$masteriamfile'",
	);

	$rc = write2Panel( $session, $form, '[enter]');
#	$rc = pressKey( $session, '2' );
	$rc = pressKeyRepeat( $session, '[enter]',4 );
	$rc = findStringOnPanel( $session, "RECORDS WRITTEN  - 1,001" );
	$rc = pressKeyRepeat( $session, '[f3]',2 );
	$rc = findStringOnPanel( $session, "Primary Options" );

	# verify that dataset was created as IAM
	$rc = write2PanelField( $session, "OPTION  ===>", "3;5;12", '[enter]' );

	    $form = tie(
		%form, Tie::IxHash,             
	
		'Entry to list            ==>'    => "'$iamfile'",
		'Level to list            ==>'    => "all",
		'Fields to list           ==>'    => "all",

	);

	$rc = write2Panel( $session, $form, '[enter]');
	$rc = findStringOnPanel( $session, "IAM FILE ANALYSIS - DSN=QAL.PHX.SFAUTO.TEMPIAM" );
	$rc = pressKeyRepeat( $session, '[f3]',6 );
	
	return;
}
1;
