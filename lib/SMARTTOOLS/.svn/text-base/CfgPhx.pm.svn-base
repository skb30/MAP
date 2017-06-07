#!/bin/perl
package CfgPhx;
sub spawn { bless {}; }
my $name   = "Unknown"; 
my $status = "Unknown";
my $suite_pass_cnt = 0;
my $suite_fail_cnt = 0;
my $suite_run_cnt  = 0; 
my $line_number    = 0;
my $suite_not_run_cnt = 0;
my %cfg = (
	'UserID'                  => 'QA023A',  # change to your userid 
	'Password'                => 'jennie',
	'Host'                    => 'mvssysb',
	'Port'                    => '1278',
	'DeleteProfileCMD'  	  => 'QAL.MGH.PGR.CLIST(DELPROF)',
	'CurrentFolderName'       => 'current_data',     
	'ExpectedFolderName'      => 'exp_data',
	'ResultsFolderName'       => 'Results',
	'DifferencesFolderName'   => 'Differences',
	'LPAR'                    => 'TSOQ',
	'SessionID'               => 'T',        # name of the pcomm session 
	'STCID'                   => '8',
	'StartedTask'			  => 'DSSISKB9', # your stc name
	'MapLibPath'              => 'D:/Eclipse_projects/map2.0/perl_automation/lib',     
	'RtsMember'               => 'QARTS',    # should be set to QARTS for test runs
	'Testbucket'              => 'QAL.MGH.PGR.TESTBCKT',
	'TerminalEmulator'        => 'PComm',
	'PCOM_Profile_Name'       => 'pcom',   # name of  your PCOMM .ws file
	'Logon_Procedure'		  => 'QAPXPROC',   # Name of the TSO logon procduere to us/e 
	'AUT'                     => 'SMARTFILE',  # application under test  
	'COPYRIGHT'               => 'Copyright (c) 2009',
	'Release'                 => 'SFM810',
	'InitExpFile' 			  => '0', # set to 1 to created the expected file.
	'sfClist'                 => 'ASGSF819',
	'sfRelease'               => 'SFM810',
	'ssClist'                 => 'VIASPROC',
	'ssRelease'               => 'ESW75CP',
	'ssVersion'               => 'SP110',
	'ssStartedTask'           => 'SSQAPHX1',
	'HLQ'                     => 'QAL.PHX',
	'CICS'                    => 'T32PHXQ1',
);
sub set_script_status {
	$status = shift;
}
sub set_suite_run_cnt {
	$suite_run_cnt = shift;
}
sub get_suite_run_cnt {
	return $suite_run_cnt;
}

sub set_suite_not_run_cnt {
	$suite_not_run_cnt = shift;
}
sub get_suite_not_run_cnt {
	return $suite_not_run_cnt;
}

sub set_suite_pass_cnt {
	$suite_pass_cnt = shift;
}
sub get_suite_pass_cnt {
	return $suite_pass_cnt;
}
sub set_suite_fail_cnt {
	$suite_fail_cnt = shift;
}
sub get_suite_fail_cnt {
	return $suite_fail_cnt;
}
sub get_script_status {
	return $status;
}
sub set_script_name {
	$name = shift;
}
sub get_script_name {
	return $name;
}
sub set_line_num {
	$line_number = shift;
}
sub get_line_num {
	return $line_number;
}
sub getcfg {
	return \%cfg;
}
1;
