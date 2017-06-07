<?
$product = $_GET['product'];
$cmd     = $_GET['cmd'];
include "./ssi/heading.php"; 
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><? print "$productDisplayName " ?> Results Report</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
<!--

-->
</style>
<script type="text/javascript">
<!--
function MM_jumpMenu(targ,selObj,restore){ //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
}
//-->
</script>
</head>
<div id='container'>
<div id=header>
<h1><? print "$productDisplayName "; ?> Regression Reports</h1>
</div>
<div id='sidebar'>
<p><a href="index.php">Home</a></p>
<p><a href="#">Setup Instructions</a></p>
<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);">  </INPUT></p>  
<p>&nbsp;</p>
</div>

<div id=main_content></div>
<form name="form" id="form"><select name="jumpMenu" id="jumpMenu"
	onchange="MM_jumpMenu('parent',this,0)">
<?
// dynamically build the drop-down list by reading the infox directory  
$i = 0;
$j = 0;
$releases 		= array();
$submissions 	= array();
print "<option>Select a Regression Report</option>";
// get all the releases for the product
foreach(glob("./products/$product/*", GLOB_ONLYDIR) as $dir) {    
	$dir = str_replace("./products/$product/", '', $dir);
	$releases[$i] = $dir;    
	$i++;
}

//print_r($releases);

//build the options tags from the releases, submissions array and suitelog.txt
foreach ($releases as $release) {

	/* get all the submissions for infox */
	foreach(glob("./products/$product/$release/*", GLOB_ONLYDIR) as $dir) {    
		$dir = str_replace("./products/$product/$release/", '', $dir);
		$submissions[$j] = $dir;    
		$j++;			
	}

//	print_r($submissions);

	foreach ($submissions as $submission) {
		$fh = fopen("./products/$product/$release/$submission/suite/suitelog.txt",r);
		$header = fgets($fh);
		fclose($fh);
		/* get the build info and regression date and time from the header record */
		list ($build_info, $regression_info) = explode("#", $header);
		$build_info = ltrim ($build_info);
		print "<option value=";
		print ('"');
		print "./regression-report.php?product=$product&rel=$release&sub=$submission&build="; 
		print $build_info;
		print '"';
		print ">$productDisplayName $release $regression_info</option>";
	}		
}

?>		
	
</select></form>
<br class="clearfloat" />
<div id='footer'><? include "footer.html"; ?></div>
</div>
</html>
