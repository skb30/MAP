-- phpMyAdmin SQL Dump
-- version 2.11.9
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 15, 2012 at 03:38 PM
-- Server version: 5.0.45
-- PHP Version: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `MAP`
--

-- --------------------------------------------------------

--
-- Table structure for table `exp_files`
--

CREATE TABLE IF NOT EXISTS `exp_files` (
  `exp_filesID` int(11) NOT NULL auto_increment,
  `scriptID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `contents` text NOT NULL,
  PRIMARY KEY  (`exp_filesID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=91 ;

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE IF NOT EXISTS `files` (
  `fileID` int(11) NOT NULL,
  `scriptID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `expected` text NOT NULL,
  `current` text NOT NULL,
  `difference` text NOT NULL,
  `log` text NOT NULL,
  `visible` tinyint(1) NOT NULL,
  PRIMARY KEY  (`fileID`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `menuItems`
--

CREATE TABLE IF NOT EXISTS `menuItems` (
  `menuItemID` int(11) NOT NULL auto_increment,
  `position` int(4) NOT NULL,
  `menuName` varchar(40) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  `content` text NOT NULL,
  `notes` varchar(255) NOT NULL,
  PRIMARY KEY  (`menuItemID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=71 ;

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

-- --------------------------------------------------------

--
-- Table structure for table `platforms`
--

CREATE TABLE IF NOT EXISTS `platforms` (
  `platformID` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `extraVAR255` varchar(255) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  PRIMARY KEY  (`platformID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE IF NOT EXISTS `products` (
  `productID` int(11) NOT NULL auto_increment,
  `platformID` int(11) NOT NULL,
  `siteID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  PRIMARY KEY  (`productID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

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

-- --------------------------------------------------------

--
-- Table structure for table `releases`
--

CREATE TABLE IF NOT EXISTS `releases` (
  `releaseID` int(11) NOT NULL auto_increment,
  `productID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  PRIMARY KEY  (`releaseID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Table structure for table `scripts`
--

CREATE TABLE IF NOT EXISTS `scripts` (
  `scriptID` int(11) NOT NULL auto_increment,
  `suiteID` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `source` text NOT NULL,
  `start` varchar(255) NOT NULL,
  `end` varchar(255) NOT NULL,
  `elapsed` varchar(255) NOT NULL,
  `status` varchar(255) NOT NULL,
  `log` text NOT NULL,
  `visible` tinyint(1) NOT NULL,
  PRIMARY KEY  (`scriptID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=554 ;

-- --------------------------------------------------------

--
-- Table structure for table `sites`
--

CREATE TABLE IF NOT EXISTS `sites` (
  `siteID` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `extraText` text NOT NULL,
  `visible` tinyint(1) NOT NULL,
  PRIMARY KEY  (`siteID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

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

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `userID` int(11) NOT NULL auto_increment,
  `userName` varchar(50) NOT NULL,
  `hashedPassword` varchar(50) NOT NULL,
  PRIMARY KEY  (`userID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;
