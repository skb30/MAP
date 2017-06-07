<?php
//$lines = file("./index.xml");

//$line_number = 0;
//foreach ($lines as $line) {
//	list ($product, $release, $submission, $build) = explode("#", $line);
//	print "product = $product\n release = $release\n sub = $submission\n build = $build \n";
//}

$dirpath = getcwd();

//print "pwd = $dirpath\n";


// list only the directories 

$i = 0;
foreach(glob('../*', GLOB_ONLYDIR) as $dir) {    
	$dir = str_replace('../*', '', $dir);
	$products = array($i => $dir);    
//	echo "$dir\n";
	$i++;
}

foreach ($products as $product) {
 	print "$product </br>";
}
?>