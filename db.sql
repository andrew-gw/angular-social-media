-- phpMyAdmin SQL Dump
-- version 4.4.10
-- http://www.phpmyadmin.net
--
-- Host: localhost:8889
-- Generation Time: Sep 18, 2015 at 07:11 AM
-- Server version: 5.5.42
-- PHP Version: 5.6.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `jrnlbeta`
--

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `commentID` int(11) NOT NULL,
  `entryID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `content` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`commentID`, `entryID`, `userID`, `date`, `content`) VALUES
(3, 15, 1, '2015-09-17 00:00:00', 'Original comment');

-- --------------------------------------------------------

--
-- Table structure for table `entry`
--

CREATE TABLE `entry` (
  `entryID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `shared` tinyint(1) NOT NULL DEFAULT '0',
  `content` text NOT NULL,
  `flagCount` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `entry`
--

INSERT INTO `entry` (`entryID`, `userID`, `date`, `shared`, `content`, `flagCount`) VALUES
(1, 1, '2015-04-15 22:03:00', 0, 'Why hello there, empty week.', 0),
(2, 1, '2015-04-13 13:24:00', 0, 'Uncomfortably warm.<br/>Not looking forward to summer.', 0),
(3, 1, '2015-04-11 16:30:00', 1, '*sigh*', 0),
(4, 1, '2015-04-11 00:47:00', 1, 'I''m hip, right?<br/>&hellip; guys?', 0),
(5, 1, '2015-04-01 08:56:00', 1, 'There''s a sign on the wall at Mohawk that says:<br/>&ldquo;There is absolutely no dancing and no tap shoes in hallways.&rdquo;<br/>My urge to dance has never been greater.', 0),
(6, 1, '2015-03-30 21:02:00', 1, 'Windows Update.<br/>Am I right?', 0),
(7, 1, '2015-03-27 02:08:00', 0, 'Whenever Obama does someone a solid, it must be pretty hard to thank him without sounding sarcastic.', 0),
(8, 1, '2015-03-26 09:13:00', 0, 'Fucking taxes, man.', 0),
(9, 1, '2015-03-24 20:52:00', 0, 'I have a Grape Crush&trade;.', 0),
(10, 1, '2014-12-23 12:00:00', 1, 'This should be from 2014', 0),
(11, 1, '2014-11-24 11:49:00', 0, 'Another from 2014', 0),
(12, 1, '2015-09-13 23:12:21', 0, 'Hi everybody!', 0),
(15, 1, '2015-09-17 01:13:00', 0, 'Woo!', 0);

-- --------------------------------------------------------

--
-- Table structure for table `friendship`
--

CREATE TABLE `friendship` (
  `friendshipID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `friendID` int(11) NOT NULL,
  `accepted` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `link`
--

CREATE TABLE `link` (
  `linkID` int(11) NOT NULL,
  `entryID` int(11) NOT NULL,
  `href` text NOT NULL,
  `title` text,
  `description` text,
  `thumbnail` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `location`
--

CREATE TABLE `location` (
  `locationID` int(11) NOT NULL,
  `entryID` int(11) NOT NULL,
  `name` text,
  `longitude` decimal(8,6) NOT NULL,
  `latitude` decimal(8,6) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `location`
--

INSERT INTO `location` (`locationID`, `entryID`, `name`, `longitude`, `latitude`) VALUES
(1, 15, 'The Tower', '43.723056', '10.396417'),
(4, 12, 'Colosseum', '41.890210', '12.492231');

-- --------------------------------------------------------

--
-- Table structure for table `photo`
--

CREATE TABLE `photo` (
  `photoID` int(11) NOT NULL,
  `entryID` int(11) NOT NULL,
  `path` text NOT NULL,
  `thumbnail` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `starred`
--

CREATE TABLE `starred` (
  `starredID` int(11) NOT NULL,
  `userID` int(11) NOT NULL,
  `entryID` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `starred`
--

INSERT INTO `starred` (`starredID`, `userID`, `entryID`) VALUES
(2, 2, 12),
(144, 1, 12);

-- --------------------------------------------------------

--
-- Table structure for table `tag`
--

CREATE TABLE `tag` (
  `tagID` int(11) NOT NULL,
  `entryID` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tag`
--

INSERT INTO `tag` (`tagID`, `entryID`, `name`) VALUES
(1, 15, 'cats'),
(2, 15, 'poo'),
(3, 12, 'cats');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `userID` int(11) NOT NULL,
  `firstName` text NOT NULL,
  `lastName` text NOT NULL,
  `avatar` text,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `securityQuestion` text NOT NULL,
  `securityAnswer` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`userID`, `firstName`, `lastName`, `avatar`, `email`, `password`, `securityQuestion`, `securityAnswer`) VALUES
(1, 'Andrew', 'Goodrick-Werner', '1.png', 'andrew.gw@me.com', 'e10adc3949ba59abbe56e057f20f883e', 'Name of first pet', 'eadb83a60cbee6383fed50796b69eac6640d3ef2'),
(2, 'Jane', 'Goodall', NULL, 'jane.goodall@example.com', '123456', 'What''s happening?', 'Nothing');

-- --------------------------------------------------------

--
-- Table structure for table `weather`
--

CREATE TABLE `weather` (
  `weatherID` int(11) NOT NULL,
  `locationID` int(11) NOT NULL,
  `degreesCelcius` decimal(4,2) NOT NULL,
  `weatherCondition` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `weather`
--

INSERT INTO `weather` (`weatherID`, `locationID`, `degreesCelcius`, `weatherCondition`) VALUES
(1, 1, '16.70', 'Clouds');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`commentID`),
  ADD KEY `entryID` (`entryID`),
  ADD KEY `userID` (`userID`);

--
-- Indexes for table `entry`
--
ALTER TABLE `entry`
  ADD PRIMARY KEY (`entryID`),
  ADD KEY `FOREIGN` (`userID`) USING BTREE;

--
-- Indexes for table `friendship`
--
ALTER TABLE `friendship`
  ADD PRIMARY KEY (`friendshipID`),
  ADD KEY `userID` (`userID`),
  ADD KEY `friendID` (`friendID`);

--
-- Indexes for table `link`
--
ALTER TABLE `link`
  ADD PRIMARY KEY (`linkID`),
  ADD KEY `entryID` (`entryID`);

--
-- Indexes for table `location`
--
ALTER TABLE `location`
  ADD PRIMARY KEY (`locationID`),
  ADD UNIQUE KEY `entryID_2` (`entryID`),
  ADD KEY `entryID` (`entryID`);

--
-- Indexes for table `photo`
--
ALTER TABLE `photo`
  ADD PRIMARY KEY (`photoID`),
  ADD KEY `entryID` (`entryID`);

--
-- Indexes for table `starred`
--
ALTER TABLE `starred`
  ADD PRIMARY KEY (`starredID`),
  ADD UNIQUE KEY `userID` (`userID`) USING BTREE,
  ADD KEY `entryID` (`entryID`);

--
-- Indexes for table `tag`
--
ALTER TABLE `tag`
  ADD PRIMARY KEY (`tagID`),
  ADD KEY `entryID` (`entryID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`userID`),
  ADD UNIQUE KEY `userID` (`userID`);

--
-- Indexes for table `weather`
--
ALTER TABLE `weather`
  ADD PRIMARY KEY (`weatherID`),
  ADD UNIQUE KEY `locationID_2` (`locationID`),
  ADD KEY `locationID` (`locationID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `commentID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `entry`
--
ALTER TABLE `entry`
  MODIFY `entryID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `friendship`
--
ALTER TABLE `friendship`
  MODIFY `friendshipID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `location`
--
ALTER TABLE `location`
  MODIFY `locationID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `photo`
--
ALTER TABLE `photo`
  MODIFY `photoID` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `starred`
--
ALTER TABLE `starred`
  MODIFY `starredID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=148;
--
-- AUTO_INCREMENT for table `tag`
--
ALTER TABLE `tag`
  MODIFY `tagID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `weather`
--
ALTER TABLE `weather`
  MODIFY `weatherID` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`entryID`) REFERENCES `entry` (`entryID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `entry`
--
ALTER TABLE `entry`
  ADD CONSTRAINT `entry_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `friendship`
--
ALTER TABLE `friendship`
  ADD CONSTRAINT `friendship_ibfk_2` FOREIGN KEY (`friendID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `friendship_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `link`
--
ALTER TABLE `link`
  ADD CONSTRAINT `link_ibfk_1` FOREIGN KEY (`entryID`) REFERENCES `entry` (`entryID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `location`
--
ALTER TABLE `location`
  ADD CONSTRAINT `location_ibfk_1` FOREIGN KEY (`entryID`) REFERENCES `entry` (`entryID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `photo`
--
ALTER TABLE `photo`
  ADD CONSTRAINT `photo_ibfk_1` FOREIGN KEY (`entryID`) REFERENCES `entry` (`entryID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `starred`
--
ALTER TABLE `starred`
  ADD CONSTRAINT `starred_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `starred_ibfk_2` FOREIGN KEY (`entryID`) REFERENCES `entry` (`entryID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `tag`
--
ALTER TABLE `tag`
  ADD CONSTRAINT `tag_ibfk_1` FOREIGN KEY (`entryID`) REFERENCES `entry` (`entryID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `weather`
--
ALTER TABLE `weather`
  ADD CONSTRAINT `weather_ibfk_1` FOREIGN KEY (`locationID`) REFERENCES `location` (`locationID`) ON DELETE CASCADE ON UPDATE CASCADE;
