<?
/* collect the parameters */
$product = $_GET['product'];
$release = $_GET['rel'];
$sub     = $_GET['sub'];
$cmd     = $_GET['cmd'];
$build   = $_GET['build'];
$suite	 = $_GET['suite'];
$script	 = $_GET['script'];
/* convert the directory name to product name for displaying */

if ($product == 'infox') {
	$productDisplayName = 'INFO/X';
} elseif ($product == 'projcl') {
	$productDisplayName = 'PRO/JCL';
} elseif  ($product == 'smartfile') {
	$productDisplayName = 'SMARTFILE';
} else {
//  	print "Unknown product type: $product</br>";	
}
/* determine what type of report the user request. */
if ($cmd == 1) {
	$report_type = "Passed";
}
elseif ($cmd == 2) {
	$report_type = "Failed";
} else {
	$report_type = "All";
}
?>