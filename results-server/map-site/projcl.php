<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>PRO/JCL Results</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
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
<h1>PRO/JCL Regression Page</h1>
</div>
<div id='sidebar'>
<p><a href="index.php">Home</a></p>
<p><a href="./projcl/readme.php">Suite Setup</a></p>
<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);"> </INPUT></p>
<p>&nbsp;</p>
</div>

<div id=main_content></div>
<form name="form" id="form"><select name="jumpMenu" id="jumpMenu"
	onchange="MM_jumpMenu('parent',this,0)">
	<option>Select a Regression Report</option>
	<option value="./projcl-all.php?<? print"product=projcl&rel=r300&sub=&build=";?>">PRO/JCL R300 All Regression Results</option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r300&sub=1&build=Release R300 created on 2010-06-28 09:21:59";?>">PRO/JCL R300-1 2010-06-28 09:21:59</option>  
	<option value="./projcl-all.php?<? print"product=projcl&rel=r290&sub=&build=";?>">PRO/JCL R290 All Regression Results</option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r290&sub=8&build=Release R290 created on 28 Dec 2009 at 16:09:10";?>">PRO/JCL R290-8 Tue Jun 15 10:20:52 2010</option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r290&sub=7&build=Release R290 created on 28 Dec 2009 at 16:09:10";?>">PRO/JCL R290-7 Mon Dec 28 16:53:35 2009</option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r290&sub=6&build=Release R290 created on 30 Nov 2009 at 13:03:57";?>">PRO/JCL R290-6 Mon Dec 14 16:39:12 2009</option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r290&sub=5&build=Release R290 created on 05 Nov 2009 at 17:59:08";?>">PRO/JCL R290-5 Wed Nov 11 13:36:41 2009 </option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r290&sub=4&build=Release R290 created on 20 Oct 2009 at 19:24:31";?>">PRO/JCL R290-4 Wed Oct 21 13:05:48 2009</option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r290&sub=3&build=Release R290 created on 1 Oct 2009 at 10:08:31";?>">PRO/JCL R290-3 Wed Oct 14 15:05:05 2009</option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r290&sub=2&build=Release R290 created on 9 Sep 2009 at 16:08:51";?>">PRO/JCL R290-2 Wed Sep 16 11:55:59 2009</option>
	<option value="./regression-report.php?<? print"product=projcl&rel=r290&sub=1&build=";?>">PRO/JCL Regression 1 Fri Sep 11 15:59:45 2009</option>  
    
</select></form>
<br class="clearfloat" />
<div id='footer'><? include "footer.html"; ?></div>
</div>
</html>
