<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Mainframe Automation Project</title>
<link href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
<!--
-->
</style>
</head>
<body>
<div id='container'>
<div id=header><? //include "header.html"; ?>
<h1>Mainframe Automation Project</h1>
</div>

<div id='sidebar'>

<?

// dynamically build the sidebar by reading the products directory  
foreach(glob('./products/*', GLOB_ONLYDIR) as $product) {    
	$product = str_replace('./products/', '', $product);
	print "<p><a href=all-products.php?product=$product>" . strtoupper($product) . "</a></p>";    

}

print "<p><a href=all-products.php?product=all> All Regression Reports </a></p>";

?>
<p><a href="http://usmghcentosqa/map_training/">Training</a></p>
<p>&nbsp;</p>
</div>
<div id=main_content>
<form><!--this javascript ensures that anybody that doesnt use javascript wont see the menu-->
<script type="text/javascript">
<!--hide script from older browsers
document.write('<p>Welcome to the Mainframe Automation Project (MAP). This site is used to provide access to MAP related resources.</p>');
document.write('<p>As more mainframe products are migrated to MAP their resources can be found here.</p>');
document.write('<p>Please send comments and suggestions to: <a href="mailto:scott.barth@asg.com">email</a></p>');
-->
</script>
<noscript id="noScript"><!--this is shown only if you have disabled javascript--> <p> You
have either disabled javascript or have a browser that does not support
javascript... Please enable javascript now. </p>S</noscript>
</form>
</div>
<br class="clearfloat" />
<div id='footer'><? include "footer.html"; ?></div>

</div>
</body>
</html>

