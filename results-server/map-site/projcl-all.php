 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>PRO/JCL Results Report</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
</style>
</head>
<? 
$product = $_GET['product'];
$release = $_GET['rel'];
$sub     = $_GET['sub'];
$cmd     = $_GET['cmd'];

// get the file name so we can pass it to list_all_scripts.php

/*
$file = $_SERVER["SCRIPT_NAME"];
$break = Explode('/', $file);
$pfile = $break[count($break) - 1]; 
*/
//print "this page: $pfile </ br>";
?>
<div id='container'>
	<div id=header>
		<? //include "header.html"; ?>
		<h1>PRO/JCL Results</h1>
	</div>
	<div id='sidebar'>
		<p><a href="index.php">Home</a></p>
		<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);">  </INPUT></p>  
		<p>&nbsp;</p>
	</div>

	<div id=main_content>
	

<?
if ($release == "r300"){
##todo variablize the product and release then read that index file for parameters. 
	process_logs("./products/projcl/r300/sub1/suite/logs/sub1.log", '1', "Release R300 created on 2010-06-28 09:21:59",$product,$release);
}
else {
	process_logs("./products/projcl/r290/sub8/suite/suitelog.txt", '8', "GA Release Pre PR300 created on 15 Jun 2010 at 10:21:29",$product,$release);
	process_logs("./products/projcl/r290/sub7/suite/suitelog.txt", '7', "GA Release Candidate PR290 created on 28 Dec 2009 at 16:09:10",$product,$release);
	process_logs("./products/projcl/r290/sub6/suite/suitelog.txt", '6', "GA Release Candidate PR290 created on 30 Nov 2009 at 13:03:57",$product,$release);
	process_logs("./products/projcl/r290/sub5/suite/suitelog.txt", '5', "Release R290 created on 05 Nov 2009 at 17:59:08",$product,$release);
	process_logs("./products/projcl/r290/sub4/suite/suitelog.txt", '4', "Release R290 created on 20 Oct 2009 at 19:24:31",$product,$release);
	process_logs("./products/projcl/r290/sub3/suite/suitelog.txt", '3', "Release R290 created on 1 Oct 2009 at 10:08:31",$product,$release);
	process_logs("./products/projcl/r290/sub2/suite/suitelog.txt", '2', "Release R290 created on 9 Sep 2009 at 16:08:51",$product,$release);
	process_logs("./products/projcl/r290/sub1/suite/suitelog.txt", '1', " ",$product,$release);
}
function process_logs($log,$submission, $build_date, $product, $release) {
    $lines = file("$log");
	foreach ($lines as $line) {
	    
		$suite_name  = substr($line, 1, 28);
		$script_name = substr($line, 29, 12);
		$start_time  = substr($line, 42, 20);
		$end_time    = substr($line, 64, 20);
		$status      = substr($line, 86, 6);
		if ($status == "failed") {
			$failed_cnt++;
		}
		else {
			$passed_cnt++;
		}
	}
    $total_run = $failed_cnt + $passed_cnt;
    $percent_passed = ($passed_cnt /$total_run) * 100;
    $percent_passed = sprintf("%2d",$percent_passed);
    print_html($total_run, $passed_cnt, $failed_cnt,$percent_passed, $submission, $build_date, $product, $release);
        
}

function print_html($total_run, $passed_cnt, $failed_cnt, $percent_passed, $submission, $build_date,$product, $release) {

print <<< HTML
          
	   <div align="center",id="table_format">
	     	
	       <table width="591" border="0">
                  <tr><h3>PRO/JCL $release Regression $submission</h3> </tr>
                  <tr><h4>$build_date</h4> </tr>
  	          <tr>
		    <td id='table_cell_1' scope="row">Total scripts Run</td>
		    <td><a href="list_all_scripts.php?product=$product&rel=$release&sub=$submission&cmd=0,&back=1" title="All Scripts">$total_run</a></td>
    		  </tr>
		  <tr>
		    <td id='table_cell_2' scope="row">Scripts passed</td>
		    <td><a href="list_all_scripts.php?product=$product&rel=$release&sub=$submission&cmd=1,&back=1" title="Passed">$passed_cnt</a></td>
		  </tr>
		  <tr>
		    <td id='table_cell_1' scope="row">Scripts failed</td>
		    <td><a href="list_all_scripts.php?product=$product&rel=$release&sub=$submission&cmd=2,&back=1" title="All Scripts">$failed_cnt</a></td>
    		  </tr>
	          <tr>
		    <td id='table_cell_2' scope="row">Percentage Passed</td>
		    <td id='table_cell_1'>$percent_passed %</td>
    		  </tr>
  	     </table>
             <br />
          </div>
 
   
	
HTML;
}
?>
</div><br class="clearfloat" />
<div id='footer'> 
	  <? //include "footer.html"; ?>
	  <p>2010 ASG Quality Assurance</p>
	</div>
   </div>
</html>
 