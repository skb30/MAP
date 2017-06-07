-- phpMyAdmin SQL Dump
-- version 2.11.9
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 15, 2012 at 03:17 PM
-- Server version: 5.0.45
-- PHP Version: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `MAP`
--

-- --------------------------------------------------------

--
-- Table structure for table `regressions`
--

CREATE TABLE IF NOT EXISTS `regressions` (
  `regressionID` int(11) NOT NULL auto_increment,
  `releaseID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `build` varchar(255) NOT NULL,
  `start` varchar(255) NOT NULL,
  `end` varchar(255) NOT NULL,
  `elapsed` varchar(255) NOT NULL,
  `rts` text NOT NULL,
  `notes` varchar(255) NOT NULL,
  PRIMARY KEY  (`regressionID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;
