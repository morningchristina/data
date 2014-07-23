#!/bin/bash
source ../conf/config.sh
#echo "create table itz_stat_day_invest(name char(20),account float)"|$MYSQL
#echo "create table itz_stat_total(id int primary key not null auto_increment,k char(30),v float)"|$MYSQL 
#echo "create table itz_stat_week_invest(date char(10),account float)"|$MYSQL
#echo "create table itz_stat_week_guarantor(date char(10),guarantor_num int)"|$MYSQL
#echo "create table itz_stat_guarantor(province_id int,guarantor_num int)"|$MYSQL
#echo "create table itz_stat_person(province_id int,person_num int)"|$MYSQL

echo "CREATE TABLE IF NOT EXISTS itz_stat_day_invest (name char(20) DEFAULT NULL,account float DEFAULT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;"|$MYSQL
echo "CREATE TABLE IF NOT EXISTS itz_stat_guarantor (province_id int(11) DEFAULT NULL,guarantor_num int(11) DEFAULT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;"|$MYSQL
echo "CREATE TABLE IF NOT EXISTS itz_stat_person (province_id int(11) DEFAULT NULL,person_num int(11) DEFAULT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;"|$MYSQL
echo "CREATE TABLE IF NOT EXISTS itz_stat_total (id int(11) NOT NULL AUTO_INCREMENT,k char(30) DEFAULT NULL,v float DEFAULT NULL,PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;"|$MYSQL
echo "CREATE TABLE IF NOT EXISTS itz_stat_week_guarantor (date char(10) DEFAULT NULL,guarantor_num int(11) DEFAULT NULL ENGINE=InnoDB DEFAULT CHARSET=utf8;"|$MYSQL
echo "CREATE TABLE IF NOT EXISTS itz_stat_week_invest (date char(10) DEFAULT NULL,account float DEFAULT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;"|$MYSQL

