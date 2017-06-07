<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>MAP Script Listing</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
<!--
-->
</style>
</head>
<? include "./ssi/heading.php"; ?>
<div id='container'>
<div id=header>
<? $uc_release = strtoupper($release); ?>
<h1><? print "$productDisplayName $uc_release Regression $sub $suite/$script"; ?></h1>
</div>
<div id='sidebar'>
<p><a href="index.php">Home</a></p>
<p><a
	href="list_log.php
	<? print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
    ">View Run Log</a></p>
<p><a href="print_expected_content.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=E&script=$script"; ?>
    ">View Expected Folder</a></p>  
<p><a href="print_expected_content.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=C&script=$script"; ?>
	">View Current Folder</a></p> 
<p><a href="print_expected_content.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=D&script=$script"; ?>
	">View Difference Reports</a></p> 
<p><a href="list_all_scripts.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
	">Return</a></p>		  
<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);">  </INPUT></p>  
<p>&nbsp;</p>
</div>
<div id=main_content><?
$lines = file("./products/$product/$release/$sub/suite/$suite/$script/$script.pl");
$line_number = 0;
/*
 * Determine if the line is a comment, if it is then change the color by using 
 * the comment type css id.
 */
foreach ($lines as $line) {
	if($line[0] == '#') {
		/*
		 * change the color of the text by using the comment css tag.
		 */
		if ($last_line_was_comment == 0) {
			print "<pre id=\"comment_type\">$line_number $line";			
			$line_number++;
		/*
		 * if the last line was a comment then all we need to do is print 
		 * this line.
		 */	
		} else {
			print "$line_number $line";
			$line_number++;
		}
		$last_line_was_comment = 1;				
	}
	else {
		/*
		 * we know the last line was a comment so we
		 * must end the css tag and start the none css tag. In 
		 * effect, change the color back to normal.
		 */
		if ($last_line_was_comment) {
			print "</pre><pre>$line_number $line";
			$last_line_was_comment = 0;
			$line_number++;
		} else {
			print "$line_number $line";
			$line_number++;
		}
		$last_line_was_comment = 0;
	}
}
?>
</pre>
</div>
<br class="clearfloat" />
<div id='footer'><? include "footer.html"; ?></div>
</div>
</html>
