<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Mainframe Automation Project (MAP)</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">

<!--
-->
</style>
</head>
<? include "./ssi/heading.php"; ?>
<div id='container'>
	<div id=header>
		<? //include "header.html"; ?>
		<h1><? $ucRelease = strtoupper($release); print "$productDisplayName $ucRelease Regression $sub Results"; ?></h1>
	</div>
	<div id='sidebar'>
		<p><a href="index.php">Home</a></p>
		 <p><a href="all-products.php<?print "?product=$product&rel=$release&suite=$suite&sub=$sub&cmd=$cmd&script=$script"; ?>
		 ">Return</a></p>
		<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);"> </INPUT></p>
		<p>&nbsp;</p>
	</div>

	<div id=main_content>
	

<?

process_logs("./products/$product/$release/$sub/suite/suitelog.txt", $sub, $build, $product, $release);

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

function print_html($total_run, $passed_cnt, $failed_cnt, $percent_passed, $submission, $build_date, $product, $release) {

print <<< HTML
          
	   <div align="center",id="table_format">
	     	
	       <table width="591" border="0">
                  <tr><h3>Regression $submission</h3> </tr>
                  <tr><h4>$build_date</h4> </tr>
  	          <tr>
		    <td id='table_cell_1' scope="row">Total scripts Run</td>
		    <td><a href="list_all_scripts.php?product=$product&rel=$release&sub=$submission" title="All Scripts">$total_run</a></td>
    		  </tr>
		  <tr>
		    <td id='table_cell_2' scope="row">Scripts passed</td>
		    <td><a href="list_all_scripts.php?product=$product&rel=$release&sub=$submission&cmd=1" title="Passed">$passed_cnt</a></td>
		  </tr>
		  <tr>
		    <td id='table_cell_1' scope="row">Scripts failed</td>
		    <td><a href="list_all_scripts.php?product=$product&rel=$release&sub=$submission&cmd=2" title="All Scripts">$failed_cnt</a></td>
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
	  <? include "footer.html"; ?>
	</div>
   </div>
</html>
