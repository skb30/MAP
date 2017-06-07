<?
$parm_product    = $_GET['product'];
$product_cmd     = $_GET['cmd'];
$type            = $_GET['type'];
include "./ssi/heading.php"; 
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>MAP Listing</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
<!--

-->
</style>
</head>
<?
$uc_release = strtoupper($release); 
include "./ssi/heading.php";

if ($type == 'C') {

	$link_name = 'Current Folder Contents';

} elseif ($type == 'D') {
	$link_name = 'Difference Report';
} else {
	$link_name = 'Expected Folder Contents';
}
?>
<div id='container'>
<div id=header>
<h1><? print "$productDisplayName $uc_release Regression $sub $suite/$script $link_name"; ?></h1>
</div>
<div id='sidebar'>
<p><a href="index.php">Home</a></p>
<p><a
	href="list_log.php
	<? print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
    ">View Run Log</a></p>  
<?

// detemine whether the sidebar link will either be the expected or current display
if ($type == "E") {
 	$dir = "exp_data";
 	print "<p><a href=print_expected_content.php?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=C&script=$script>Current Folder</a></p>";
 	print "<p><a href=print_expected_content.php?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=D&script=$script>Difference Reports</a></p>";
} elseif ($type == "D") {
	$dir = "Differences";
 	print "<p><a href=print_expected_content.php?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=C&script=$script>Current Folder</a></p>";
 	print "<p><a href=print_expected_content.php?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=E&script=$script>Expected Folder</a></p>";
} else {
	$dir = "current_data";
 	print "<p><a href=print_expected_content.php?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=E&script=$script>Expected Folder</a></p>";
 	print "<p><a href=print_expected_content.php?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&type=D&script=$script>Difference Reports</a></p>";
}

?>  
<p><a
	href="print_script_content.php?
	<? print "&product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>		 
     ">View Script</a></p>  
<p><a 
    href="list_all_scripts.php?<? print "product=$product&rel=$release&sub=$sub&cmd=$product_cmd"; ?>">Return</a></p>    
<?      
//<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);"></INPUT></p>
//<p>&nbsp;</p>
?>
</div>
<div id=main_content>

<? 
// open this directory 
print "opening directory: ./products/$product/$release/$sub/suite/$suite/$script/$dir </ br> ";
$myDirectory = @opendir("./products/$product/$release/$sub/suite/$suite/$script/$dir");

// make sure the direcory is on the file system.

if ($myDirectory == 0 ) {

   print "<h3>Directory $dir not found on file system</h3> </ br>";
} else {
	while($entryName = readdir($myDirectory)) {
		$dirArray[] = $entryName;
	}
	
	// close directory
	closedir($myDirectory);
	
	//	count elements in array
	$indexCount	= count($dirArray);
	//Print ("$indexCount files<br>\n");
	
	// sort 'em
	sort($dirArray);
	
	// loop through the array of files and print the contents of each file
	print "<pre>";
	for($index=0; $index < $indexCount; $index++) {
	        if (substr("$dirArray[$index]", 0, 1) != "."){ // don't list hidden files
		        print "<h3> $dirArray[$index]</h3>";
		        $lines = file("./products/$product/$release/$sub/suite/$suite/$script/$dir/$dirArray[$index]");
				foreach ($lines as $line) {
			 		print $line;
				}
			}
	}
    print "</pre>";

}


// get each entry

?>
</div>
<br class="clearfloat" />
<div id='footer'><? include "footer.html"; ?></div>
</div>
</html>
