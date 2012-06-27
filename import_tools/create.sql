create database miui_market;
use miui_market;

CREATE TABLE list (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  name varchar(255) DEFAULT NULL,
  moduleId varchar(255) DEFAULT NULL,
  fileSize bigint(20) DEFAULT NULL,
  moduleType varchar(255) DEFAULT NULL,
  assemblyId varchar(255) DEFAULT NULL,
  frontCover varchar(255) DEFAULT NULL,
  playTime varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
);
