ALTER TABLE adherents ADD jabber_adh varchar(150) default NULL AFTER msn_adh;
ALTER TABLE adherents ADD bool_display_info enum('1') default NULL AFTER bool_exempt_adh;
ALTER TABLE adherents ADD info_public_adh text AFTER info_adh;
ALTER TABLE adherents ADD pays_adh varchar(50) default NULL AFTER ville_adh;
ALTER TABLE adherents ADD adresse2_adh varchar(150) default NULL AFTER adresse_adh;

CREATE TABLE logs (
  id_log int(10) unsigned NOT NULL auto_increment,
  date_log datetime NOT NULL,
  ip_log varchar(30) NOT NULL default '',
  adh_log varchar(41) NOT NULL default '',
  text_log text,
  PRIMARY KEY  (id_log)
) TYPE=MyISAM;

DELETE FROM statuts;
INSERT INTO statuts VALUES (1,'Pr�sident',0);
INSERT INTO statuts VALUES (10,'Vice-pr�sident',5);
INSERT INTO statuts VALUES (2,'Tr�sorier',10);
INSERT INTO statuts VALUES (4,'Membre actif',30);
INSERT INTO statuts VALUES (5,'Membre bienfaiteur',40);
INSERT INTO statuts VALUES (6,'Membre fondateur',50);
INSERT INTO statuts VALUES (3,'Secr�taire',20);
INSERT INTO statuts VALUES (7,'Ancien',60);
INSERT INTO statuts VALUES (8,'Personne morale',70);
INSERT INTO statuts VALUES (9,'Non membre',80);

RENAME TABLE adherents TO galette_adherents;
RENAME TABLE cotisations TO galette_cotisations;
RENAME TABLE logs TO galette_logs;
RENAME TABLE preferences TO galette_preferences;
RENAME TABLE statuts TO galette_statuts;
RENAME TABLE types_cotisation TO galette_types_cotisation;
