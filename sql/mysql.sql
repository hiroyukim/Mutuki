DROP   DATABASE if exists yayoi;
CREATE DATABASE yayoi DEFAULT CHARACTER SET utf8;

use yayoi;

CREATE TABLE IF NOT EXISTS sessions (
    id           CHAR(72) PRIMARY KEY,
    session_data TEXT
);

CREATE TABLE wiki (
  id             int(10) unsigned NOT NULL auto_increment,
  title          varchar(255) NOT NULL,
  body           TEXT,
  user_id        int(10) unsigned NOT NULL, 
  wiki_group_id  int(10) unsigned NOT NULL, 
  deleted_fg     tinyint(1) NOT NULL default '0',
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX wiki_group_id_deleted_fg (wiki_group_id,deleted_fg)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

CREATE TABLE wiki_history (
  id             int(10) unsigned NOT NULL auto_increment,
  user_id        int(10) unsigned NOT NULL, 
  wiki_id        int(10) unsigned NOT NULL, 
  title          varchar(255) NOT NULL,
  body           TEXT,
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX wiki_id (wiki_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

CREATE TABLE wiki_group (
  id             int(10) unsigned NOT NULL auto_increment,
  title          varchar(255) NOT NULL,
  body           TEXT,
  deleted_fg     tinyint(1) NOT NULL default '0',
  last_updated_wiki_id  int(10) unsigned NOT NULL, 
  last_updated_user_id  int(10) unsigned NOT NULL, 
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX deleted_fg (deleted_fg)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

CREATE TABLE wiki_group_history (
  id             int(10) unsigned NOT NULL auto_increment,
  title          varchar(255) NOT NULL,
  body           TEXT,
  wiki_group_id  int(10) unsigned NOT NULL, 
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX wiki_group_id (wiki_group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

CREATE TABLE user (
  id             int(10) unsigned NOT NULL auto_increment,
  name           varchar(255)   NOT NULL,
  nickname       varchar(255)   NOT NULL,
  passwd         varchar(30)    NOT NULL,
  deleted_fg     tinyint(1)     NOT NULL default '0',
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE name(name),
  INDEX deleted_fg (deleted_fg)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

CREATE TABLE user_attribute_group (
  id             int(10) unsigned NOT NULL auto_increment,
  user_id        int(10) unsigned NOT NULL, 
  user_group_id  int(10) unsigned NOT NULL, 
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX user_group_id ( user_group_id ),
  UNIQUE user_id_user_group_id(user_id,user_group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

CREATE TABLE user_group (
  id             int(10) unsigned NOT NULL auto_increment,
  name           varchar(255) NOT NULL,
  deleted_fg     tinyint(1) NOT NULL default '0',
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX deleted_fg (deleted_fg)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

CREATE TABLE wiki_group_attribute_user_group (
  id             int(10) unsigned NOT NULL auto_increment,
  wiki_group_id  int(10) unsigned NOT NULL, 
  user_group_id  int(10) unsigned NOT NULL, 
  write_fg       tinyint(1) NOT NULL default '0',
  read_fg        tinyint(1) NOT NULL default '0',
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX wiki_group_id ( wiki_group_id ),
  UNIQUE user_group_id_wiki_group_id(user_group_id,wiki_group_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 
