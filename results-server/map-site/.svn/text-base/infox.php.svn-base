<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>INFO/X Results Report</title>
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
<?
$product = $_GET['product'];
$release = $_GET['rel'];
$sub     = $_GET['sub'];
$cmd     = $_GET['cmd'];

?>



<div id='container'>
<div id=header><? //include "header.html"; ?>
<h1>INFO/X Regression Reports</h1>
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
$releases = array();

// get all the releases for infox
foreach(glob('./products/infox/*', GLOB_ONLYDIR) as $dir) {    
	$dir = str_replace('./products/infox/', '', $dir);
	$releases[$i] = $dir;    
	$i++;
}

//build the options tags from the releases array, submissions array and suitelog.txt
foreach ($releases as $release) {
 	print "<option>Select a Regression Report</option>";
 	$uc_release = strtoupper($release);
 	print "<option value=./regression-report.php?product=$product&rel=$release>$uc_release</option>";
 	
}


?>	
	<option>Select a Regression Report</option>
	<option value="./regression-report.php?<? print"product=infox&rel=r290&sub=1&build=Release R290 created on 23 Dec 2009 at 18:29:46";?>">INFO/X R290 Regression 1 Wed Jun 16 2010 Results</option>
	<option value="./regression-report.php?<? print"product=infox&rel=r290&sub=2&build=Release R290 created on 23 Dec 2009 at 18:29:46";?>">INFO/X R290 Regression 2 Thu Jul 15 2010 Results</option>
</select></form>
<br class="clearfloat" />
<div id='footer'><? include "footer.html"; ?></div>
</div>
</html>
