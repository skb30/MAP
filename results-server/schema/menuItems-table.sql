-- phpMyAdmin SQL Dump
-- version 2.11.9
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 15, 2012 at 03:34 PM
-- Server version: 5.0.45
-- PHP Version: 5.1.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `MAP`
--

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

--
-- Dumping data for table `menuItems`
--

INSERT INTO `menuItems` (`menuItemID`, `position`, `menuName`, `visible`, `content`, `notes`) VALUES
(47, 1, 'MAP Site Layout', 1, 'ProJCL content', ''),
(61, 1, 'About MAP', 1, '', ''),
(70, 3, 'Script History', 1, '', '');
