###############################################################################
#
# TEST SCRIPT:
#		PR13125
#
# DESCRIPTION: JJSCAN should not write out to any OUTPUT libs when running JMP or Reformat.
# DESCRIPTION:    But, the warning message DSS03041 is issued in JPSEL.
#
# SPR: 13125
# 03/02/2009  CJM Map Conversion
#
############################################################################### 
use PROJCL::PanelsMap;
use PROJCL::ProJcl;
use Tie::IxHash;
use MAP;

my $configRef = Cfg::getcfg();
my $stcID = $configRef->{'STCID'};
my $sessionID = $configRef->{'SessionID'};

# Make connection to PComm session

my $status = 0;

package MAP;
init;
$session = startSession($sessionID);
ProJcl::dataReset($session, "QARTS", $stcID, $configRef->{'StartedTask'});
ln __LINE__; $status = navigate2Panel( $session, "Command" )if ( not $status );
ln __LINE__; $status = write2CommandLine( $session, "D0sedias $stcID", '[enter]' ) if ( not $status );

ln __LINE__; $status = navigate2Panel( $session, "ASG-PRO/JCL", "D0JPMAI0") if ( not $status );

ln __LINE__; $status = navigate2Panel( $session, "Validation", "D0JPJVAL") if ( not $status );

my $validationForm = tie(
	%form, Tie::IxHash,
	'RTS Member . .'      => 'QARTS',
	'Input Library  . .'  => "'QAL.MGH.PGR.TESTBCKT'",
	'Member  . . . . .'   => 'JOBCARD2',
	'Show Directory'      => 'N',
	'Show Directory'      => 'N',
	'Type  . . . . . .'   => 'PDS',
	'Processing Mode'     => 'JOB',
	'Lib type  . . . .'   => 'PDS',
	'Reformat'            => 'OFF',
	'Overwrite Input Lib' => 'N',
	'Reformat Member. .'  => 'DEFAULT',
	'SJL Hardcopy . . .'  => 'N',
	'Keep SJL Data Set'   => 'N',
	'Save Error Summary'  => 'N',
);

# Write the form on the panel
ln __LINE__; $status = write2Panel( $session, $validationForm  ) if ( not $status );
#Select "E" for Edit and press enter
ln __LINE__; $status = write2CommandLine( $session, "E", '[enter]' ) if ( not $status );
# issue the JJ command
ln __LINE__; $status = write2CommandLine( $session, "JJ ID=$stcID OPT", '[enter]' ) if ( not $status );

# Fill up form.
my $jjmacroform = tie(
	%form, Tie::IxHash,
	'RTS Member . .'  	=> 'QARTS',
	'Processing Mode  . .' 		=> 'JOB',
    'Reformat . . . . . .'		=> 'OFF ',
	'Reformat Member  . .'		=> 'DEFAULT ',
);

# Write the form on the panel
ln __LINE__; $status = write2Panel( $session, $jjmacroform, '[enter]')  if ( not $status );
# Return to the Member in Edit mode
ln __LINE__; $status = navigateBack2Panel( $session, 'ISREDDE2' ) if ( not $status );
# issue the JJ command
ln __LINE__; $status = write2CommandLine( $session, "JJSCAN ID=$stcID", '[enter]' ) if ( not $status );
# find if a DSS03041E has been issued
ln __LINE__; $status = write2CommandLine( $session, "F DSS03041", '[enter]',"Command ===>" ) if ( not $status );
# CHECK IS THE DSS3041e HAS BEEN FOUND
ln __LINE__; $status = findStringOnPanel( $session, "No CHARS 'DSS03041'") if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]' )  if ( not $status );
# issue the JJ command
ln __LINE__; $status = write2CommandLine( $session, "JJ ID=$stcID OPT", '[enter]' ) if ( not $status );

# Fill up form and adding a jmp program.
my $jjmacroform = tie(
	%form, Tie::IxHash,
	'RTS Member . .'  	=> 'QARTS',
	'Processing Mode  . .' 		=> 'JOB',
	'First PROCLIB  . . .'		=> ' ',
  		'Lib type . . . . .'    => ' ',
  	'JMP Library  . . . .'		=> "'QAL.MGH.PGR.JMPEXEC'",
	'JMP Name . . . . . .'		=> 'APICMT ',
	'JMP Parm . . . . . .'		=> ' ',
    'Reformat . . . . . .'		=> 'OFF ',
	'Reformat Member  . .'		=> 'DEFAULT ',
);
# Write the form on the panel
ln __LINE__; $status = write2Panel( $session, $jjmacroform, '[enter]')  if ( not $status );
# Return to the Member in Edit mode
ln __LINE__; $status = navigateBack2Panel( $session, 'ISREDDE2' ) if ( not $status );
# issue the JJ command
ln __LINE__; $status = write2CommandLine( $session, "JJSCAN ID=$stcID", '[enter]' ) if ( not $status );
# Capture Text output produce by Jmp.
ln __LINE__; $status = verifyPanel($session, "pr13125Jmpmsg") if ( not $status );
ln __LINE__; $status = pressKey( $session, '[F3]' )  if ( not $status );
# find if a DSS03041E has been issued
ln __LINE__; $status = write2CommandLine( $session, "F DSS03041", '[enter]',"Command ===>" ) if ( not $status );
# CHECK IS THE DSS3041e HAS BEEN FOUND
ln __LINE__; $status = findStringOnPanel( $session, "No CHARS 'DSS03041'") if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]' )  if ( not $status ); 

# issue the JJ command
ln __LINE__; $status = write2CommandLine( $session, "JJ ID=$stcID OPT", '[enter]' ) if ( not $status );

# Fill up form and adding a jmp program.
my $jjmacroform = tie(
	%form, Tie::IxHash,
	'RTS Member . .'  	=> 'QARTS',
	'Processing Mode  . .' 		=> 'JOB',
	'First PROCLIB  . . .'		=> ' ',
  		'Lib type . . . . .'    => ' ',
  	'JMP Library  . . . .'		=> '                  ',
	'JMP Name . . . . . .'		=> '       ',
	'JMP Parm . . . . . .'		=> ' ',
    'Reformat . . . . . .'		=> 'ON',
	'Reformat Member  . .'		=> 'DEFAULT ',
);
# Write the form on the panel
ln __LINE__; $status = write2Panel( $session, $jjmacroform, '[enter]')  if ( not $status );
# Return to the Member in Edit mode
ln __LINE__; $status = navigateBack2Panel( $session, 'ISREDDE2' ) if ( not $status );
# issue the JJ command
ln __LINE__; $status = write2CommandLine( $session, "JJSCAN ID=$stcID", '[enter]' ) if ( not $status );
# find if a DSS03041E has been issued
ln __LINE__; $status = write2CommandLine( $session, "F DSS03041", '[enter]',"Command ===>" ) if ( not $status );
# CHECK IS THE DSS3041e HAS BEEN FOUND
ln __LINE__; $status = findStringOnPanel( $session, "No CHARS 'DSS03041'") if (not $status);
ln __LINE__; $status = pressKey( $session, '[F3]' )  if ( not $status ); 
# issue the JJ command
ln __LINE__; $status = write2CommandLine( $session, "JJ ID=$stcID OPT", '[enter]' ) if ( not $status );

# Fill up form and adding a jmp program.
my $jjmacroform = tie(
	%form, Tie::IxHash,
	'RTS Member . .'  	=> 'QARTS',
	'Processing Mode  . .' 		=> 'JOB',
	'First PROCLIB  . . .'		=> ' ',
  		'Lib type . . . . .'    => ' ',
  	'JMP Library  . . . .'		=> '                  ',
	'JMP Name . . . . . .'		=> '       ',
	'JMP Parm . . . . . .'		=> ' ',
    'Reformat . . . . . .'		=> 'OFF',
	'Reformat Member  . .'		=> 'DEFAULT ',
);
# Write the form on the panel
ln __LINE__; $status = write2Panel( $session, $jjmacroform, '[enter]')  if ( not $status );

ln __LINE__; navigateBack2Panel( $session, 'ISP@MST1' );
	
end ($status); 1;



 