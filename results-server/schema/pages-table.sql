-- phpMyAdmin SQL Dump
-- version 2.11.9
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 15, 2012 at 03:35 PM
-- Server version: 5.0.45
-- PHP Version: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `MAP`
--

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE IF NOT EXISTS `pages` (
  `pageID` int(11) NOT NULL auto_increment,
  `menuItemID` int(11) NOT NULL,
  `menuName` varchar(30) NOT NULL,
  `position` int(3) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  `content` text NOT NULL,
  PRIMARY KEY  (`pageID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=40 ;

--
-- Dumping data for table `pages`
--

INSERT INTO `pages` (`pageID`, `menuItemID`, `menuName`, `position`, `visible`, `content`) VALUES
(1, 3, 'History', 1, 1, 'Company History'),
(2, 3, 'Our Mission', 2, 1, 'Our Mission statement ....'),
(4, 3, 'Our Team', 1, 1, 'Welcome to MAP'),
(31, 47, 'Test Page', 2, 1, '	Wed Sep 14 16:58:22 2011 ------- Test Case ic27001.pl.pl Started ------- \r\n*** 2011-09-14 16:58:24 ic27001.pl started *** \r\n*** 2011-09-14 16:58:31 ic27001.pl 45 - navigate2Panel Passed *** \r\n*** 2011-09-14 16:58:32 ic27001.pl 49 - findStringOnPanel "D0DPMAI0" Passed *** \r\n*** 2011-09-14 16:58:33 ic27001.pl 52 - findStringOnPanel "D0DPRPR0" Passed *** \r\n*** 2011-09-14 16:58:33 ic27001.pl 55 - findStringOnPanel "D0DPRPD0" Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 58 - navigate2DropDownList "Settings" Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 61 - pressKeys "" Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 64 - pressKeys "" Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 67 - pressKeys "" Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 70 - pressKeys "" Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 82 - panelListAction I/O Listing Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 83 - panelListAction PROC XREF Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 84 - panelListAction Program XREF Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 85 - panelListAction Data Set Name XREF Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 86 - panelListAction Sysout XREF Passed *** \r\n*** 2011-09-14 16:58:34 ic27001.pl 87 - panelListAction Job Components List Passed *** \r\n*** 2011-09-14 16:58:38 ic27001.pl 99 - findStringOnPanel "EXECUTION" Passed *** \r\n*** 2011-09-14 16:58:49 ic27001.pl 107 - panelListAction IC27001A found on panel Passed *** \r\n*** 2011-09-14 16:58:49 ic27001.pl 109 - panelListAction JDRPT found on panel Passed *** \r\n*** 2011-09-14 16:58:51 ic27001.pl 116 - findStringOnPanel "Components List Report" Passed *** \r\n*** 2011-09-14 16:58:51 ic27001.pl 120 - findStringOnPanel "REFERENCE FILES" Passed *** \r\n*** 2011-09-14 16:58:51 ic27001.pl 124 - findStringOnPanel "Control Cards" Passed *** \r\n\r\n+++ 2011-09-14 16:58:52 ic27001.pl 128 - findStringOnPanel "DB2 PACKAGES" Failed! +++ \r\n\r\n*** 2011-09-14 16:58:52 ic27001.pl 141 - pressKeys "" Passed *** \r\n\r\n+++ 2011-09-14 16:58:54 ic27001.pl 143 - Ended with a status of: Failed! +++ \r\n\r\nWed Sep 14 16:58:54 2011 ------- Test Case ic27001.pl.pl Ended. Elasped Time: 0 Days. 0 Hours. 0 Min. 32 Sec. ------ \r\n\r\n\r\n\r\n	'),
(19, 61, 'Team', 1, 1, '	Name of the Team Members	'),
(37, 47, 'Products Page Example', 1, 1, '																																																																								<h3> Products Table (Example) </h3>\r\n<table> \r\n <tr>\r\n     <th WIDTH="120" ALIGN=LEFT>PRODUCT</th>\r\n     <th WIDTH="80" ALIGN=LEFT>Site</th>\r\n     <th WIDTH="80" ALIGN=LEFT>Platform</th>\r\n </tr>\r\n <tr>\r\n    <td ><a href="content.php?page=38"> ProJCL</a></td>\r\n    <td> MGH </td>\r\n    <td>z/OS</td>\r\n </tr>\r\n\r\n <tr><td><a href=#>Infox</td><td>MGH</td><td>z/OS</td></tr>\r\n \r\n <tr><td><a href=#>Smartfile</td><td>PHX</td><td>z/OS</td></tr>\r\n \r\n</table>															     																																																																				'),
(38, 47, 'PROJCL Regressions', 1, 1, '																<h3> Regression Table Example </h3>\r\n\r\n<table> \r\n\r\n<tr><th>ASG Product</th><th>Regressions</th><th>Release</th><th>Platform</th></tr>\r\n\r\n<tr><td>ProJCL</td><td><a href="content.php?page=39">5</a></td><td>R290</td><td>z/os</td></tr>\r\n<tr><td>ProJCL</td><td><a href="#">7</a></td><td>R300</td><td>z/os</td></tr>\r\n<tr><td>ProJCL</td><td><a href="#">20</a></td><td>R310</td><td>z/os</td></tr>\r\n\r\n\r\n</table>\r\n																						'),
(39, 47, 'PRO/JCL Detail', 1, 1, '																															<h3> PRO/JCL R290 Regression Detail  </h3>	\r\n\r\n<table> \r\n <tr>\r\n     <th WIDTH="150" ALIGN=LEFT>Reg #</th>\r\n     <th WIDTH="600" ALIGN=LEFT>Build Time Stamp</th>\r\n     <th WIDTH="300" ALIGN=LEFT>Run Date/Time</th>\r\n     <th WIDTH="150" ALIGN=LEFT>Notes</th>\r\n     <th WIDTH="200" ALIGN=LEFT>Settings</th>\r\n </tr>\r\n<tr>\r\n    <td><a href=#>1</td> \r\n    <td ></td>\r\n    <td><a href=#>Fri Sep 11 15:59:45 2009</td>\r\n    <td>NOTES</td>\r\n    <td>RTS</td>\r\n </tr>\r\n\r\n <tr>\r\n    <td><a href=#>2</td> \r\n    <td >Created on 9 Sep 2009 at 16:08:51</a></td>\r\n    <td><a href=#>Wed Sep 16 11:55:59 2009</td>\r\n    <td><a href=#>NOTES</td>\r\n    <td><a href=#>RTS</td>\r\n </tr>\r\n\r\n<tr>\r\n   <td><a href=#>3</td> \r\n   <td>Created on 1 Oct 2009 at 10:08:31</td>\r\n   <td><a href=#>Wed Oct 14 15:05:05 2009</td>\r\n   <td><a href=#>NOTES</td>\r\n   <td><a href=#>RTS</td>\r\n</tr> \r\n\r\n<tr>\r\n    <td><a href=#>4</td> \r\n    <td>Created on 20 Oct 2009 at 19:24:31</td>\r\n    <td><a href=#>Wed Oct 21 13:05:48 2009</td>\r\n    <td><a href=#>NOTES</td> \r\n    <td><a href=#>RTS</td>\r\n</tr> \r\n\r\n<tr>\r\n    <td><a href=#>5</td> \r\n    <td>Created on 5 Nov 2009 at 17:59:08</td>\r\n    <td><a href=#>Wed Nov 11 13:36:41 2009</td>\r\n    <td><a href=#>NOTES</td> \r\n    <td><a href=#>RTS</td>\r\n</tr> \r\n\r\n \r\n</table>																																				');

 