<?
$parm_product = $_GET['product'];
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
<h1><? print "$productDisplayName All Regressions"; ?></h1>
</div>
<div id='sidebar'>


<?
/*
 *  Don't build the 'Setup Instructions' link if it's the all products page.
 */

if ($parm_product != 'all'){
	print "<p><a href=./products/setup.php?product=$parm_product>Setup Instructions</a></p>";
}

?>
<p><a href="index.php">Return</a></p>
<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);">  </INPUT></p>  
<p>&nbsp;</p>
</div>



<div align=center,id=table_format>
<table width=591 border=0>
<tr>
	<td id='table_cell_1' scope="col">Product</td>
	<td id='table_cell_2' scope="col">Release</td>
	<td id='table_cell_1' scope="col">Regression Run Date/Time</td>
</tr>
<? 

/*
 *  drill into the directory tree until I can build the options tag for the form.
 *  The first record in: 
 *  product/release/submission/suite/suitelog.txt 
 *  contains the build date and regression run time needed for the headings.
 */

/* print the first options tag */

//print "<option value=#>Select a Regression Report</option>";
/* now let's start to drill */
foreach(glob("./products/*", GLOB_ONLYDIR) as $product) { 
	/* get rid of the . and .. directories */  
	$product = str_replace("./products/", '', $product);
	 /* determine if we need to process a given product or all products */
	if ($parm_product == 'all'){
	 
	} elseif ($parm_product != $product){
	  	continue ;		
    }
	foreach(glob("./products/$product/*", GLOB_ONLYDIR) as $release) {    
		$release = str_replace("./products/$product/", '', $release);
		foreach(glob("./products/$product/$release/*", GLOB_ONLYDIR) as $submission) {    
			$submission = str_replace("./products/$product/$release/", '', $submission);
			$fh = fopen("./products/$product/$release/$submission/suite/suitelog.txt",r);
			$header = fgets($fh);
			fclose($fh);
			/* get the build info and regression date and time from the header record */
			list ($build_info, $regression_info) = explode("#", $header);
			$build_info = ltrim ($build_info);
			$uc_product = strtoupper($product);
			$uc_release = strtoupper($release);
			print_html($build_info,$uc_product,$uc_release, $regression_info, $product, $release, $submission);	
		}
	}
}
  
function print_html($build_info, $uc_product, $uc_release, $regression_info, $product, $release, $submission) {

print <<< HTML

<tr>
  <td id='table_cell_1' scope="row">$uc_product</td>
  <td id='table_cell_2' scope="row">$uc_release</td>
  <td id='table_cell_1' scope="row"><a href="./regression-report.php?product=$product&rel=$release&sub=$submission&build=$build_info">$regression_info</a></td>
</tr>
HTML;
}
?>    
</table><br />
</div>		
</select></form>
<br class="clearfloat" />
<div id='footer'><? include "footer.html"; ?></div>
</div>
</html>
