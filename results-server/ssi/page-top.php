<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>List all Script</title>
<link  href='./css/styles.css' rel="stylesheet" media="screen" />
<style type="text/css">
<!--

-->
</style>
</head>
<?php include_once ("./ssi/get-parms.php"); ?>
<div id='container'>
<div id=header><? //include "header.html"; ?>
<? include "./ssi/heading.php"; ?>
<? $uc_release = strtoupper($release); ?>
<h1><? print" $productDisplayName $uc_release Regression $sub $report_type "; ?> Report</h1>
</div>
<div id='sidebar'>
<p><a href="index.php">Home</a></p>

<p><INPUT TYPE="button" VALUE="Back" onClick="history.go(-1);"></INPUT></p> 

<p>&nbsp;</p>
</div>