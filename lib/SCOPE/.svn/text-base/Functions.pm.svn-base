#!/bin/perl -w
package Functions;

use Win32::API;
use Hllapi;
use Common;
use MAP;

sub dataReset {

	my $configRef = Cfg::getcfg();
	my $sessionID = $configRef->{'SessionID'};
	my $userID    = $configRef->{'UserID'};
	my $execclist = $configRef->{'Exec'};
	my $cntlLib   = $configRef->{'CntlLib'};
	my $dbName    = $configRef->{'DBName'};
	my $lpar      = $configRef->{'Host'};
	my $hlq       = $configRef->{'TestDataHLQ'} . '.';
	my $autoHlq   = $configRef->{'AutoHLQ'} . '.';
	my $cics      = $configRef->{'CICSreqion'};
	my $password  = $configRef->{'Password'};
	my $batchJob1 = $configRef->{'BatchJob1'};
	my $batchJob2 = $configRef->{'BatchJob2'};
	my $exprtfbl  = $autoHlq . 'EXPRTFBL';
	my $exprtfbs  = $autoHlq . 'EXPRTFBS';
	my $exprtf    = $autoHlq . 'EXPRTF';
	my $exprtv    = $autoHlq . 'EXPRTV';
	my $exprtvb   = $autoHlq . 'EXPRTVB';
	my $stc       = $configRef->{'STC'};
	my $sscpcntl  = $configRef->{'SSCPCNTL'};
	my $dasdi     = $configRef->{'DASdi'};
	my $qaphx2akr = 'QAL.PHX.SSXAUTO.QAPHX2.AKR';

	package MAP;
	$session = startSession('t');

	# Delete the export files
	$rc = deleteDataset( $session, "$exprtfbl" );
	$rc = deleteDataset( $session, "$exprtfbs" );
	$rc = deleteDataset( $session, "$exprtf" );
	$rc = deleteDataset( $session, "$exprtv" );
	$rc = deleteDataset( $session, "$exprtvb" );

	# submit allocexp to allocate the export files
	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(allocexp)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );

	# use checkbatch status to verify the job completed
	$rc = checkBatchStatus( $session, "ENDED" );

	# delete all the output for the batchjob
	write2CommandLine( $session, "=s;/\$p JOBQ,JOBMASK=$batchJob1",
		'[enter]', "===>" );
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );

#	$rc = 	write2CommandLine($session, "tso output $batchJob1 delete",'[enter]' );

	# stop the smartscope server
	stopService( $session, $stc, "/p $stc", '10' );

	# deactivate smartscope
	write2CommandLine( $session, "=s.st", '[enter]', "===>" );

   #  write2CommandLine( $session, "/<sscp deactivate", '[enter]',"===>");
   #  findStringOnPanel($session, "SmartScope Batch Dump Capture Deactivated") ;

	# submit rsqaphx2 to restore the dump datasets
	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(rsqaphx2)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );

	# use checkbatch status to verify the job completed
	$rc = checkBatchStatus( $session, "ENDED" );

	# delete all the output for the batchjob
	write2CommandLine( $session, "=s;/\$p JOBQ,JOBMASK=$batchJob2",
		'[enter]', "===>" );
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );

#	$rc = 	write2CommandLine($session, "tso output $batchJob2 delete",'[enter]' );

	execPanelCmd( $session, "Edit", "ISREDM01" );
	write2PanelField( $session, "Name . . . . . ",
		"'$sscpcntl($dasdi)'", '[enter]' );

	# delete all lines
	write2CommandLine( $session, "delete nx all", '[enter]', "Command ===> " );

# copy BKUPT1DI Template to the empty member and make the necessary changes to run the job.
	write2CommandLine( $session, "copy 'QAL.PHX.SSXAUTO.CNTL(BKUPT1DI)'",
		'[enter]', "Command ===> " );
	write2CommandLine( $session, "c *AKRDSN $qaphx2akr all",
		'[enter]', "Command ===> " );

	# activate smartscope
	write2CommandLine( $session, "=s.st", '[enter]', "===>" );

	#  write2CommandLine( $session, "/<sscp activate", '[enter]',"===>");
	#  findStringOnPanel($session, "SmartScope Batch Dump Capture Activated") ;
	# start the smartscope server
	startService( $session, $stc, "/s $stc", '10' );

	# Go back to ISPF Main Menu
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );
}

sub recycleServer {

# use this function to recycle the SmartScope started task. Any sessions connected will be
# logged off.
	my $session   = shift;
	my $configRef = Cfg::getcfg();
	my $stc       = $configRef->{'STC'};
	my $rc;

	package MAP;
	$session = startSession('t');

	$rc = stopService( $session, $stc, "/p $stc", '10' );
	sleep 5;
	$rc = startService( $session, $stc, "/s $stc", '10' );

	$rc = navigateBack2Panel( $session, 'ISP@MST1' );
	return $rc;
}

sub dataReset2 {

	my $configRef = Cfg::getcfg();
	my $sessionID = $configRef->{'SessionID'};
	my $userID    = $configRef->{'UserID'};
	my $execclist = $configRef->{'Exec'};
	my $cntlLib   = $configRef->{'CntlLib'};
	my $dbName    = $configRef->{'DBName'};
	my $lpar      = $configRef->{'Host'};
	my $hlq       = $configRef->{'TestDataHLQ'} . '.';
	my $cics      = $configRef->{'CICSreqion'};
	my $password  = $configRef->{'Password'};
	my $batchJob2 = $configRef->{'BatchJob2'};
	my $stc       = $configRef->{'STC'};

	package MAP;
	$session = startSession('t');

	# stop the smartscope server
	stopService( $session, $stc, "/p $stc", '10' );
	write2CommandLine( $session, "=s.st", '[enter]', "===>" );

   #  write2CommandLine( $session, "/<sscp deactivate", '[enter]',"===>");
   #  findStringOnPanel($session, "SmartScope Batch Dump Capture Deactivated") ;

	# submit rsqaphx2 to restore the dump datasets
	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(rsqaph2p)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );

	# use checkbatch status to verify the job completed
	$rc = checkBatchStatus( $session, "ENDED" );

	# delete all the output for the batchjob
	write2CommandLine( $session, "=s;/\$p JOBQ,JOBMASK=$batchJob2",
		'[enter]', "===>" );
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );

#	$rc = 	write2CommandLine($session, "tso output $batchJob2 delete",'[enter]' );

	# activate smartscope
	write2CommandLine( $session, "=s.st", '[enter]', "===>" );

	#  write2CommandLine( $session, "/<sscp activate", '[enter]',"===>");
	#  findStringOnPanel($session, "SmartScope Batch Dump Capture Activated") ;

	# start the smartscope server
	startService( $session, $stc, "/s $stc", '10' );

	# Go back to ISPF Main Menu
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dataReset3 {

	my $configRef = Cfg::getcfg();
	my $sessionID = $configRef->{'SessionID'};
	my $userID    = $configRef->{'UserID'};
	my $execclist = $configRef->{'Exec'};
	my $cntlLib   = $configRef->{'CntlLib'};
	my $dbName    = $configRef->{'DBName'};
	my $lpar      = $configRef->{'Host'};
	my $hlq       = $configRef->{'TestDataHLQ'} . '.';
	my $cics      = $configRef->{'CICSreqion'};
	my $password  = $configRef->{'Password'};
	my $batchJob2 = $configRef->{'BatchJob2'};
	my $stc       = $configRef->{'STC'};
	my $sscpcntl  = $configRef->{'SSCPCNTL'};

	package MAP;
	$session = startSession('t');

	# stop the smartscope server
	stopService( $session, $stc, "/p $stc", '15' );
	write2CommandLine( $session, "=s.st",             '[enter]', "===>" );
	write2CommandLine( $session, "/<sscp deactivate", '[enter]', "===>" );
	findStringOnPanel( $session, "SmartScope Batch Dump Capture Deactivated" );

	$rc = navigateBack2Panel( $session, 'ISP@MST1' );
	execPanelCmd( $session, "Edit", "ISREDM01" );
	write2PanelField( $session, "Name . . . . . ",
		"'$sscpcntl(dast1di)'", '[enter]' );
	write2CommandLine( $session, "c 'QAPHX2.AKR' 'ST.AKR' all",
		'[enter]', "Command ===> " );
	pressKey( $session, '[F3]' );

	$rc = navigateBack2Panel( $session, 'ISP@MST1' );

	# activate smartscope
	write2CommandLine( $session, "=s.st",           '[enter]', "===>" );
	write2CommandLine( $session, "/<sscp activate", '[enter]', "===>" );
	findStringOnPanel( $session, "SmartScope Batch Dump Capture Activated" );

	# start the smartscope server
	startService( $session, $stc, "/s $stc", '10' );

	# Go back to ISPF Main Menu
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dataReset4 {

	my $configRef = Cfg::getcfg();
	my $sessionID = $configRef->{'SessionID'};
	my $userID    = $configRef->{'UserID'};
	my $execclist = $configRef->{'Exec'};
	my $cntlLib   = $configRef->{'CntlLib'};
	my $dbName    = $configRef->{'DBName'};
	my $lpar      = $configRef->{'Host'};
	my $hlq       = $configRef->{'TestDataHLQ'} . '.';
	my $cics      = $configRef->{'CICSreqion'};
	my $password  = $configRef->{'Password'};
	my $batchJob2 = $configRef->{'BatchJob2'};
	my $stc       = $configRef->{'STC'};

	package MAP;
	$session = startSession('t');

	# stop the smartscope server
	stopService( $session, $stc, "/f $stc,shutdown,immediate", '10' );

	# submit rsqaphx2 to restore the dump datasets
	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(rsqaph2p)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );

	# use checkbatch status to verify the job completed
	$rc = checkBatchStatus( $session, "ENDED" );

	# delete all the output for the batchjob
	write2CommandLine( $session, "=s;/\$p JOBQ,JOBMASK=$batchJob2",
		'[enter]', "===>" );
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );

#	$rc = 	write2CommandLine($session, "tso output $batchJob2 delete",'[enter]' );

	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(viapcobj)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );

	# use checkbatch status to verify the job completed
	$rc = checkBatchStatus( $session, "ENDED" );

	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(viapasmj)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );

	# use checkbatch status to verify the job completed
	$rc = checkBatchStatus( $session, "ENDED" );

	# start the smartscope server
	startService( $session, $stc, "/s $stc", '10' );

	# Go back to ISPF Main Menu
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );
}

sub dataReset5 {

	my $configRef = Cfg::getcfg();
	my $sessionID = $configRef->{'SessionID'};
	my $userID    = $configRef->{'UserID'};
	my $execclist = $configRef->{'Exec'};
	my $cntlLib   = $configRef->{'CntlLib'};
	my $dbName    = $configRef->{'DBName'};
	my $lpar      = $configRef->{'Host'};
	my $hlq       = $configRef->{'TestDataHLQ'} . '.';
	my $cics      = $configRef->{'CICSreqion'};
	my $password  = $configRef->{'Password'};
	my $batchJob2 = $configRef->{'BatchJob2'};
	my $batchJob3 = $configRef->{'BatchJob3'};
	my $stc       = $configRef->{'STC'};
	$stc = uc($stc);
	my $parmlib   = $configRef->{'ParmLib'};
	my $sscpcntl  = $configRef->{'SSCPCNTL'};
	my $dasdi     = $configRef->{'DASdi'};

	package MAP;
	$session = startSession('t');

	execPanelCmd( $session, "Edit", "ISREDM01" );

	write2PanelField( $session, "Name . . . . . ",
		"'$parmlib(asgssb01)'", '[enter]' );

	# enable DAE by uncommenting parms, etc
	write2CommandLine( $session, "c *DAE DAE all", '[enter]', "Command ===> " );
	write2CommandLine( $session, "c 'DAE=NO' 'DAE=YES' all",
		'[enter]', "Command ===> " );
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );
	execPanelCmd( $session, "Edit", "ISREDM01" );

	# enable the DAE reset feature when dumps are deleted
	write2PanelField( $session, "Name . . . . . ",
		"'$sscpcntl($dasdi)'", '[enter]' );

	# enable DAEDELETE feature
	write2CommandLine( $session, "c 'DAEDELETE=NO' 'DAEDELETE=YES'",
		'[enter]', "Command ===> " );

	# stop the smartscope server
	stopService( $session, $stc, "/p $stc" );

	# deactivate and then activate smartscope
	write2CommandLine( $session, "=s.st",             '[enter]', "===>" );
	write2CommandLine( $session, "/<sscp deactivate", '[enter]', "===>" );
	findStringOnPanel( $session, "SmartScope Batch Dump Capture Deactivated" );
	write2CommandLine( $session, "/<sscp activate", '[enter]', "===>" );
	findStringOnPanel( $session, "SmartScope Batch Dump Capture Activated" );

	# delete all of the old output for VIAPCOBJ
	write2CommandLine( $session, "=s;/\$p JOBQ,JOBMASK=$batchJob3",
		'[enter]', "===>" );

	# start the smartscope server
	startService( $session, $stc, "/s $stc", '10' );
   
	# make sure the server is completly up before submitting jobs.
	write2CommandLine( $session, "da", '[enter]' );

	#	panelListAction($session, "$stc", "s");
	#	write2CommandLine($session, "m",'[enter]' );
	#	checkBatchStatus( $session, "AKR Server Ready.", '[f8]') ;

	sleep(30);

	# submit viapcobj multiple times to test dump elimination

	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(viapcobj)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );
	$rc = checkBatchStatus( $session, "ENDED" );
	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(viapcobj)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );
	$rc = checkBatchStatus( $session, "ENDED" );
	$rc =
	  write2CommandLine( $session, "tso sub \'qal.phx.ssxauto.cntl(viapcobj)\'",
		'[enter]' );
	$rc = findStringOnPanel( $session, "SUBMITTED" );
	$rc = checkBatchStatus( $session, "ENDED" );

	#write2CommandLine( $session, '=s.st;pre viapcob*', '[enter]' );
	write2CommandLine( $session, '=s.st;pre viapcobj', '[enter]' );
	pressKeyRepeat( $session, '[tab]', 6 );
	pressKey( $session, 's' );
	pressKey( $session, '[enter]' );
	findStringOnPanel( $session, "SmartScope dump suppressed D" );

	# Go back to ISPF Main Menu
	$rc = navigateBack2Panel( $session, 'ISP@MST1' );
}
1;
