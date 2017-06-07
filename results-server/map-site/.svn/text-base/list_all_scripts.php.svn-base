<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>List all Script</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
<!--

-->
</style>
</head>

<div id='container'>
<div id=header><? //include "header.html"; ?>
<? include "./ssi/heading.php"; ?>
<? $uc_release = strtoupper($release); ?>
<h1><? print" $productDisplayName $uc_release Regression $sub $report_type "; ?> Report</h1>
</div>
<div id='sidebar'>
<p><a href="index.php">Home</a></p>
<p><a href="regression-report.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
	">Return</a></p>
<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);"></INPUT></p> 

<p>&nbsp;</p>
</div>
<div id=main_content>

<table width="605" border="0">
	<tr>
		<th width="121" scope="col" align="left">Suite Name</th>
		<th width="121" scope="col" align="left">Script</th>
		<th width="121" scope="col" align="left">Start</th>
		<th width="121" scope="col" align="left">End</th>
		<th width="50" scope="col" align="left">Status</th>
	</tr>
	<?
	$lines = file("./products/$product/$release/$sub/suite/suitelog.txt");
    $header_line = 1;
	// process each line of the file$header_line = 1;
	foreach ($lines as $line) {
	    /* skip the header record. */
		if ($header_line == 1) {$header_line = 0; continue;}

		$suite_name  = substr($line, 1, 28);
		$script_name = substr($line, 29, 12);
		$start_time  = substr($line, 42, 20);
		$end_time    = substr($line, 64, 20);
		$status      = substr($line, 86, 6);
		$suite_name  = rtrim($suite_name);
		$suite_name  = ltrim($suite_name);
		$script_name = rtrim($script_name);
		$script_name = rtrim($script_name,'.pl');
	
		// list only passed scripts
		if ($cmd == 1) {
			/* build the passed script page */
			if ($status == "passed") {
				$css_id = "passed_type";
				$type = "PASSED";
				print_it($product, $release, $suite_name, $script_name, $start_time, $end_time, $sub, $cmd, $css_id, $type, $build);
			}
		// list only failed scripts	
		} elseif ($cmd == 2) {
			/* build the failed script page */
			if ($status == "failed") {
				$css_id = "failed_type";
				$type = "FAILED";
				print_it($product, $release, $suite_name, $script_name, $start_time, $end_time, $sub, $cmd, $css_id, $type, $build);
			}
		// list all scripts	
		} else {
			/* setup the css style for either passed or failed */
		    $type = $status;
		    if ($type == "passed") {
		    	$css_id = "passed_type";
		    } else {
		    	$css_id = "failed_type";
		    }
		    
			print_it($product, $release, $suite_name, $script_name, $start_time, $end_time, $sub, $cmd, $css_id, $type, $build);
		
			}
		}
	
		function print_it ($product, $release, $suite_name, $script_name, $start_time, $end_time, $sub, $cmd, $css_id, $type, $build) {
print <<< EOF
<tr id="$css_id">
<td width="200" scope="col">$suite_name</td>
<td width="200" scope="col">
<a id="$css_id" href="print_script_content.php?product=$product&rel=$release&suite=$suite_name&script=$script_name&sub=$sub&cmd=$cmd&build=$build" title="Display Script">
$script_name</a></td>
<td width="200" scope="col">$start_time</td>
<td width="200" scope="col">$end_time</td>
<td width="50" scope="col">
<a id="$css_id" href="list_log.php?product=$product&rel=$release&suite=$suite_name&script=$script_name&sub=$sub&cmd=$cmd&build=$build" title="Run Log">$type</a>
</td></tr>
EOF;
	}
	
	?>
</table>
</div>
<div id='footer'><? include "footer.html"; ?>
</div>
</div>
</html>
