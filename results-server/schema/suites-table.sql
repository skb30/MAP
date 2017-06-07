 -- phpMyAdmin SQL Dump
-- version 2.11.9
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 15, 2012 at 03:30 PM
-- Server version: 5.0.45
-- PHP Version: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `MAP`
--

-- --------------------------------------------------------

--
-- Table structure for table `suites`
--

CREATE TABLE IF NOT EXISTS `suites` (
  `suiteID` int(11) NOT NULL auto_increment,
  `regressionID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `start` varchar(255) NOT NULL,
  `end` varchar(255) NOT NULL,
  `elapsed` varchar(255) NOT NULL,
  `passed` int(11) NOT NULL,
  `failed` int(11) NOT NULL,
  `notes` varchar(255) NOT NULL,
  PRIMARY KEY  (`suiteID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=34 ;

 