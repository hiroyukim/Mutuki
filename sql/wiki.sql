CREATE TABLE wiki (
  id             int(10) unsigned NOT NULL auto_increment,
  title          varchar(255) NOT NULL,
  body           TEXT,
  deleted_fg     tinyint(1) NOT NULL default '0',
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 

CREATE TABLE wiki_history (
  id             int(10) unsigned NOT NULL auto_increment,
  wiki_id        int(10) unsigned NOT NULL, 
  title          varchar(255) NOT NULL,
  body           TEXT,
  created_at   datetime         NOT NULL,
  updated_at   TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8; 
