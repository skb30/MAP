<?
$parm_product = $_GET['product'];
$cmd     = $_GET['cmd'];
include "../ssi/heading.php"; 
$uc_product = strtoupper($parm_product);
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title><? print "$productDisplayName " ?> Setup Instructions</title>
<link  href='../css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
<!--

-->
</style>
<div id='container'>
	<div id=header>
		<h1><? print "$productDisplayName Suite Setup Instructions"; ?> </h1>
	</div>
	<div id='sidebar'>
		<p><a href="../index.php">Home</a></p>
        <? print  "<p><a href=../all-products.php?product=$parm_product>Back</a></p>";?>
		<p>&nbsp;</p>
	</div>

	<div id=main_content><pre>
<?
	    $lines = file("./$parm_product/setup.txt");
                
		$line_number = 0;
		foreach ($lines as $line) {
             
		  $line_number++;
		  print "$line";
                    
		}           
?> </pre></div><br class="clearfloat" />
<div id='footer'> 
	  <? include "../footer.html"; ?>
   </div>
</html>
