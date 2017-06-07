<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>MAP Run Log</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
<!--

-->
</style>
</head>
<? include "./ssi/heading.php"; ?>
<? $uc_release = strtoupper($release); ?>
<div id='container'>
<div id=header>
<h1><? print "$productDisplayName $uc_release Regression $sub $suite/$script"; ?> Run Log</h1>
</div>
<div id='sidebar'>
<p><a href="index.php">Home</a></p>
<p><a
	href="print_script_content.php?
	<? print "&product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>		 
    ">View Script</a></p>
    
<p><a href="print_expected_content.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
    ">View Expected Folder</a></p>  
<p><a href="print_expected_content.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
	">View Current Folder</a></p> 
<p><a href="print_expected_content.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
	">View Difference Reports</a></p>    
<p><a href="list_all_scripts.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
	">Return</a></p>
<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);"></INPUT></p>
<p>&nbsp;</p>
</div>
<div id=main_content><?
$lines = file("./products/$product/$release/$sub/suite/$suite/$script/runlog.txt");

$line_number = 0;
foreach ($lines as $line) {
    /* change the color of the passed lines in the log */
	$passed = strpos($line, "Passed");
	if($line[0] == '+') {
		print "<p id=\"failed_type\">$line</p>";
		$line_number++;
//	}
//	elseif($passed > 0) {
//		$line_number++;
//		print "<p id=\"passed_type\">$line</p>";
	} else {
		$line_number++;
		print "$line <br/>";
	}
}
?>
</div>
<br class="clearfloat" />
<div id='footer'><? include "footer.html"; ?></div>
</div>
</html>
