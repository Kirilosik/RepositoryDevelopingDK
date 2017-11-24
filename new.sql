-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Хост: 127.0.0.1
-- Время создания: Ноя 24 2017 г., 23:17
-- Версия сервера: 5.5.25
-- Версия PHP: 5.3.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `new`
--

-- --------------------------------------------------------

--
-- Структура таблицы `accs`
--

CREATE TABLE IF NOT EXISTS `accs` (
  `nick` varchar(24) CHARACTER SET cp1251 NOT NULL,
  `pass` varchar(32) CHARACTER SET cp1251 NOT NULL,
  `sex` int(11) NOT NULL,
  `email` varchar(40) CHARACTER SET cp1251 NOT NULL,
  `referral` varchar(24) CHARACTER SET cp1251 NOT NULL,
  `promocode` int(11) NOT NULL,
  `country` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `accs`
--

INSERT INTO `accs` (`nick`, `pass`, `sex`, `email`, `referral`, `promocode`, `country`) VALUES
('test', '', 0, '', '', 0, 0);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
