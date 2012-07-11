--
--  Comment Meta Language Constructs:
--
--  #IfNotTable
--    argument: table_name
--    behavior: if the table_name does not exist,  the block will be executed

--  #IfTable
--    argument: table_name
--    behavior: if the table_name does exist, the block will be executed

--  #IfMissingColumn
--    arguments: table_name colname
--    behavior:  if the table exists but the column does not,  the block will be executed

--  #IfNotColumnType
--    arguments: table_name colname value
--    behavior:  If the table table_name does not have a column colname with a data type equal to value, then the block will be executed

--  #IfNotRow
--    arguments: table_name colname value
--    behavior:  If the table table_name does not have a row where colname = value, the block will be executed.

--  #IfNotRow2D
--    arguments: table_name colname value colname2 value2
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2, the block will be executed.

--  #IfNotRow3D
--    arguments: table_name colname value colname2 value2 colname3 value3
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2 AND colname3 = value3, the block will be executed.

--  #IfNotRow4D
--    arguments: table_name colname value colname2 value2 colname3 value3 colname4 value4
--    behavior:  If the table table_name does not have a row where colname = value AND colname2 = value2 AND colname3 = value3 AND colname4 = value4, the block will be executed.

--  #IfNotRow2Dx2
--    desc:      This is a very specialized function to allow adding items to the list_options table to avoid both redundant option_id and title in each element.
--    arguments: table_name colname value colname2 value2 colname3 value3
--    behavior:  The block will be executed if both statements below are true:
--               1) The table table_name does not have a row where colname = value AND colname2 = value2.
--               2) The table table_name does not have a row where colname = value AND colname3 = value3.

--  #IfRow2D
--    arguments: table_name colname value colname2 value2
--    behavior:  If the table table_name does have a row where colname = value AND colname2 = value2, the block will be executed.

--  #IfIndex
--    desc:      This function is most often used for dropping of indexes/keys.
--    arguments: table_name colname
--    behavior:  If the table and index exist the relevant statements are executed, otherwise not.

--  #IfNotIndex
--    desc:      This function will allow adding of indexes/keys.
--    arguments: table_name colname
--    behavior:  If the index does not exist, it will be created

--  #EndIf
--    all blocks are terminated with a #EndIf statement.


#IfNotIndex lists type
CREATE INDEX `type` ON `lists` (`type`);
#EndIf

#IfNotIndex lists pid
CREATE INDEX `pid` ON `lists` (`pid`);
#EndIf

#IfNotIndex form_vitals pid
CREATE INDEX `pid` ON `form_vitals` (`pid`);
#EndIf

#IfIndex forms pid
DROP INDEX `pid` ON `forms`;
#EndIf

#IfIndex form_encounter pid
DROP INDEX `pid` ON `form_encounter`;
#EndIf

#IfNotIndex forms pid_encounter
CREATE INDEX `pid_encounter` ON `forms` (`pid`, `encounter`);
#EndIf

#IfNotIndex form_encounter pid_encounter
CREATE INDEX `pid_encounter` ON `form_encounter` (`pid`, `encounter`);
#EndIf

#IfNotIndex immunizations patient_id
CREATE INDEX `patient_id` ON `immunizations` (`patient_id`);
#EndIf

#IfNotIndex procedure_order patient_id
CREATE INDEX `patient_id` ON `procedure_order` (`patient_id`);
#EndIf

#IfNotIndex pnotes pid
CREATE INDEX `pid` ON `pnotes` (`pid`);
#EndIf

#IfNotIndex transactions pid
CREATE INDEX `pid` ON `transactions` (`pid`);
#EndIf

#IfNotIndex extended_log patient_id
CREATE INDEX `patient_id` ON `extended_log` (`patient_id`);
#EndIf

#IfNotIndex prescriptions patient_id
CREATE INDEX `patient_id` ON `prescriptions` (`patient_id`);
#EndIf

#IfNotIndex openemr_postcalendar_events pc_eventDate
CREATE INDEX `pc_eventDate` ON `openemr_postcalendar_events` (`pc_eventDate`);
#EndIf

#IfMissingColumn version v_realpatch
ALTER TABLE `version` ADD COLUMN `v_realpatch` int(11) NOT NULL DEFAULT 0;
#EndIf

#IfMissingColumn prescriptions drug_info_erx
ALTER TABLE `prescriptions` ADD COLUMN `drug_info_erx` TEXT DEFAULT NULL;
#EndIf

#IfNotRow2D list_options list_id lists option_id nation_notes_replace_buttons
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('lists','nation_notes_replace_buttons','Nation Notes Replace Buttons',1);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('nation_notes_replace_buttons','Yes','Yes',10);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('nation_notes_replace_buttons','No','No',20);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('nation_notes_replace_buttons','Normal','Normal',30);
INSERT INTO `list_options` (`list_id`, `option_id`, `title`, `seq`) VALUES ('nation_notes_replace_buttons','Abnormal','Abnormal',40);
#EndIf

#IfMissingColumn insurance_data policy_type
ALTER TABLE `insurance_data` ADD COLUMN `policy_type` varchar(25) NOT NULL default '';
#EndIf

#IfMissingColumn drugs max_level
ALTER TABLE drugs ADD max_level float NOT NULL DEFAULT 0.0;
ALTER TABLE drugs CHANGE reorder_point reorder_point float NOT NULL DEFAULT 0.0;
#EndIf

#IfNotTable product_warehouse
CREATE TABLE `product_warehouse` (
  `pw_drug_id`   int(11) NOT NULL,
  `pw_warehouse` varchar(31) NOT NULL,
  `pw_min_level` float       DEFAULT 0,
  `pw_max_level` float       DEFAULT 0,
  PRIMARY KEY  (`pw_drug_id`,`pw_warehouse`)
) ENGINE=MyISAM;
#EndIf

#IfNotColumnType billing modifier varchar(12)
   ALTER TABLE `billing` MODIFY `modifier` varchar(12);
   UPDATE `code_types` SET `ct_mod` = '12' where ct_key = 'CPT4' OR ct_key = 'HCPCS';
#Endif

#IfMissingColumn billing notecodes
ALTER TABLE `billing` ADD `notecodes` varchar(25) NOT NULL default '';
#EndIf

#IfNotTable dated_reminders
CREATE TABLE `dated_reminders` (
            `dr_id` int(11) NOT NULL AUTO_INCREMENT,
            `dr_from_ID` int(11) NOT NULL,
            `dr_message_text` varchar(160) NOT NULL,
            `dr_message_sent_date` datetime NOT NULL,
            `dr_message_due_date` date NOT NULL,
            `pid` int(11) NOT NULL,
            `message_priority` tinyint(1) NOT NULL,
            `message_processed` tinyint(1) NOT NULL DEFAULT '0',
            `processed_date` timestamp NULL DEFAULT NULL,
            `dr_processed_by` int(11) NOT NULL,
            PRIMARY KEY (`dr_id`),
            KEY `dr_from_ID` (`dr_from_ID`,`dr_message_due_date`)
          ) ENGINE=MyISAM AUTO_INCREMENT=1;
#EndIf

#IfNotTable dated_reminders_link
CREATE TABLE `dated_reminders_link` (
            `dr_link_id` int(11) NOT NULL AUTO_INCREMENT,
            `dr_id` int(11) NOT NULL,
            `to_id` int(11) NOT NULL,
            PRIMARY KEY (`dr_link_id`),
            KEY `to_id` (`to_id`),
            KEY `dr_id` (`dr_id`)
          ) ENGINE=MyISAM AUTO_INCREMENT=1;
#EndIf

#IfMissingColumn x12_partners x12_gs03
ALTER TABLE `x12_partners` ADD COLUMN `x12_gs03` VARCHAR(15) NOT NULL DEFAULT '';
#EndIf

#IfNotTable payment_gateway_details
CREATE TABLE `payment_gateway_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(100) DEFAULT NULL,
  `login_id` varchar(255) DEFAULT NULL,
  `transaction_key` varchar(255) DEFAULT NULL,
  `md5` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
#EndIf

#IfNotRow2D list_options list_id lists option_id payment_gateways
insert into `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) values('lists','payment_gateways','Payment Gateways','297','1','0','','');
insert into `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) values('payment_gateways','authorize_net','Authorize.net','1','0','0','','');
#EndIf

#IfNotRow2D list_options list_id payment_method option_id authorize_net
insert into `list_options` (`list_id`, `option_id`, `title`, `seq`, `is_default`, `option_value`, `mapping`, `notes`) values('payment_method','authorize_net','Authorize.net','60','0','0','','');
#EndIf

#IfMissingColumn patient_access_offsite authorize_net_id
ALTER TABLE `patient_access_offsite` ADD COLUMN `authorize_net_id` VARCHAR(20) COMMENT 'authorize.net profile id';
#EndIf

#IfMissingColumn facility website
ALTER TABLE `facility` ADD COLUMN `website` varchar(255) default NULL;
#EndIf

#IfMissingColumn facility email
ALTER TABLE `facility` ADD COLUMN `email` varchar(255) default NULL;
#EndIf

#IfMissingColumn code_types ct_active
ALTER TABLE `code_types` ADD COLUMN `ct_active` tinyint(1) NOT NULL default 1 COMMENT '1 if this is active';
#EndIf

#IfMissingColumn code_types ct_label
ALTER TABLE `code_types` ADD COLUMN `ct_label` varchar(31) NOT NULL default '' COMMENT 'label of this code type';
UPDATE `code_types` SET ct_label = ct_key;
#EndIf

#IfMissingColumn code_types ct_external
ALTER TABLE `code_types` ADD COLUMN `ct_external` tinyint(1) NOT NULL default 0 COMMENT '0 if stored codes in codes tables, 1 or greater if codes stored in external tables';
#EndIf

#IfNotRow code_types ct_key DSMIV
DROP TABLE IF EXISTS `temp_table_one`;
CREATE TABLE `temp_table_one` (
  `id` int(11) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM ;
INSERT INTO `temp_table_one` (`id`, `seq`) VALUES ( IF( ((SELECT MAX(`ct_id`) FROM `code_types`)>=100), ((SELECT MAX(`ct_id`) FROM `code_types`) + 1), 100 ) , IF( ((SELECT MAX(`ct_seq`) FROM `code_types`)>=100), ((SELECT MAX(`ct_seq`) FROM `code_types`) + 1), 100 )  );
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external ) VALUES ('DSMIV' , (SELECT MAX(`id`) FROM `temp_table_one`), (SELECT MAX(`seq`) FROM `temp_table_one`), 2, '', 0, 0, 0, 1, 0, 'DSMIV', 0);
DROP TABLE `temp_table_one`;
#EndIf

#IfNotRow code_types ct_key ICD10
DROP TABLE IF EXISTS `temp_table_one`;
CREATE TABLE `temp_table_one` (
  `id` int(11) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM ;
INSERT INTO `temp_table_one` (`id`, `seq`) VALUES ( IF( ((SELECT MAX(`ct_id`) FROM `code_types`)>=100), ((SELECT MAX(`ct_id`) FROM `code_types`) + 1), 100 ) , IF( ((SELECT MAX(`ct_seq`) FROM `code_types`)>=100), ((SELECT MAX(`ct_seq`) FROM `code_types`) + 1), 100 )  );
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external ) VALUES ('ICD10' , (SELECT MAX(`id`) FROM `temp_table_one`), (SELECT MAX(`seq`) FROM `temp_table_one`), 2, '', 0, 0, 0, 1, 0, 'ICD10', 1);
DROP TABLE `temp_table_one`;
#EndIf

#IfNotRow code_types ct_key SNOMED
DROP TABLE IF EXISTS `temp_table_one`;
CREATE TABLE `temp_table_one` (
  `id` int(11) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM ;
INSERT INTO `temp_table_one` (`id`, `seq`) VALUES ( IF( ((SELECT MAX(`ct_id`) FROM `code_types`)>=100), ((SELECT MAX(`ct_id`) FROM `code_types`) + 1), 100 ) , IF( ((SELECT MAX(`ct_seq`) FROM `code_types`)>=100), ((SELECT MAX(`ct_seq`) FROM `code_types`) + 1), 100 )  );
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external ) VALUES ('SNOMED' , (SELECT MAX(`id`) FROM `temp_table_one`), (SELECT MAX(`seq`) FROM `temp_table_one`), 2, '', 0, 0, 0, 1, 0, 'SNOMED', 2);
DROP TABLE `temp_table_one`;
#EndIf

#IfMissingColumn ar_activity code_type
ALTER TABLE `ar_activity` ADD COLUMN `code_type` varchar(12) NOT NULL DEFAULT '';
#EndIf

#IfRow2D billing code_type COPAY activity 1
DROP TABLE IF EXISTS `temp_table_one`;
CREATE TABLE `temp_table_one` (
  id             int unsigned  NOT NULL AUTO_INCREMENT,
  session_id     int unsigned  NOT NULL,
  payer_id       int(11)       NOT NULL DEFAULT 0,
  user_id        int(11)       NOT NULL,
  pay_total      decimal(12,2) NOT NULL DEFAULT 0,
  payment_type varchar( 50 ) NOT NULL DEFAULT 'patient',
  description text NOT NULL,
  adjustment_code varchar( 50 ) NOT NULL DEFAULT 'patient_payment',
  post_to_date date NOT NULL,
  patient_id int( 11 ) NOT NULL,
  payment_method varchar( 25 ) NOT NULL DEFAULT 'cash',
  pid            int(11)       NOT NULL,
  encounter      int(11)       NOT NULL,
  code_type      varchar(12)   NOT NULL DEFAULT '',
  code           varchar(9)    NOT NULL,
  modifier       varchar(5)    NOT NULL DEFAULT '',
  payer_type     int           NOT NULL DEFAULT 0,
  post_time      datetime      NOT NULL,
  post_user      int(11)       NOT NULL,
  pay_amount     decimal(12,2) NOT NULL DEFAULT 0,
  account_code varchar(15) NOT NULL DEFAULT 'PCP',
  PRIMARY KEY (id)
) ENGINE=MyISAM AUTO_INCREMENT=1;
INSERT INTO `temp_table_one` (`user_id`, `pay_total`, `patient_id`, `post_to_date`, `pid`, `encounter`, `post_time`, `post_user`, `pay_amount`, `description`) SELECT `user`, (`fee`*-1), `pid`, `date`, `pid`, `encounter`, `date`, `user`, (`fee`*-1), 'COPAY' FROM `billing` WHERE `code_type`='COPAY' AND `activity`!=0;
UPDATE `temp_table_one` SET `session_id`= ((SELECT MAX(session_id) FROM ar_session)+`id`);
UPDATE `billing`, `code_types`, `temp_table_one` SET temp_table_one.code_type=billing.code_type, temp_table_one.code=billing.code, temp_table_one.modifier=billing.modifier WHERE billing.code_type=code_types.ct_key AND code_types.ct_fee=1 AND temp_table_one.pid=billing.pid AND temp_table_one.encounter=billing.encounter AND billing.activity!=0;
INSERT INTO `ar_session` (`payer_id`, `user_id`, `pay_total`, `payment_type`, `description`, `patient_id`, `payment_method`, `adjustment_code`, `post_to_date`) SELECT `payer_id`, `user_id`, `pay_total`, `payment_type`, `description`, `patient_id`, `payment_method`, `adjustment_code`, `post_to_date` FROM `temp_table_one`;
INSERT INTO `ar_activity` (`pid`, `encounter`, `code_type`, `code`, `modifier`, `payer_type`, `post_time`, `post_user`, `session_id`, `pay_amount`, `account_code`) SELECT `pid`, `encounter`, `code_type`, `code`, `modifier`, `payer_type`, `post_time`, `post_user`, `session_id`, `pay_amount`, `account_code` FROM `temp_table_one`;
UPDATE `billing` SET `activity`=0 WHERE `code_type`='COPAY';
DROP TABLE IF EXISTS `temp_table_one`;
#EndIf

#IfNotTable facility_user_ids
CREATE TABLE  `facility_user_ids` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` bigint(20) DEFAULT NULL,
  `facility_id` bigint(20) DEFAULT NULL,
  `field_id`    varchar(31)  NOT NULL COMMENT 'references layout_options.field_id',
  `field_value` TEXT NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`,`facility_id`,`field_id`)
) ENGINE=MyISAM  AUTO_INCREMENT=1 ;
#EndIf

#IfNotRow layout_options form_id FACUSR
INSERT INTO `layout_options` (form_id, field_id, group_name, title, seq, data_type, uor, fld_length, max_length, list_id, titlecols, datacols, default_value, edit_options, description) VALUES ('FACUSR', 'provider_id', '1General', 'Provider ID', 1, 2, 1, 15, 63, '', 1, 1, '', '', 'Provider ID at Specified Facility');
#EndIf

#IfMissingColumn patient_data ref_providerID
ALTER TABLE `patient_data` ADD COLUMN `ref_providerID` int(11) default NULL;
UPDATE `patient_data` SET `ref_providerID`=`providerID`;
INSERT INTO `layout_options` (form_id, field_id, group_name, title, seq, data_type, uor, fld_length, max_length, list_id, titlecols, datacols, default_value, edit_options, description) VALUES ('DEM', 'ref_providerID', '3Choices', 'Referring Provider', 2, 11, 1, 0, 0, '', 1, 3, '', '', 'Referring Provider');
UPDATE `layout_options` SET `description`='Provider' WHERE `form_id`='DEM' AND `field_id`='providerID';
UPDATE `layout_options` SET `seq`=(1+`seq`) WHERE `form_id`='DEM' AND `group_name` LIKE '%Choices' AND `field_id` != 'providerID' AND `field_id` != 'ref_providerID';
#EndIf

#IfMissingColumn documents couch_docid
ALTER TABLE `documents` ADD COLUMN `couch_docid` VARCHAR(100) NULL;
#EndIf

#IfMissingColumn documents couch_revid
ALTER TABLE `documents` ADD COLUMN `couch_revid` VARCHAR(100) NULL;
#EndIf

#IfMissingColumn documents storagemethod
ALTER TABLE `documents` ADD COLUMN `storagemethod` TINYINT(4) DEFAULT '0' NOT NULL COMMENT '0->Harddisk,1->CouchDB';
#EndIf

#IfNotRow2D list_options list_id lists option_id ptlistcols
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('lists','ptlistcols','Patient List Columns','1','0','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','name'      ,'Full Name'     ,'10','3','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','phone_home','Home Phone'    ,'20','3','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','ss'        ,'SSN'           ,'30','3','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','DOB'       ,'Date of Birth' ,'40','3','','');
insert into list_options (list_id, option_id, title, seq, option_value, mapping, notes) values('ptlistcols','pubpid'    ,'External ID'   ,'50','3','','');
#EndIf

#IfNotRow2D code_types ct_key DSMIV ct_mod 0
UPDATE `code_types` SET `ct_mod`=0 WHERE `ct_key`='DSMIV' OR `ct_key`='ICD9' OR `ct_key`='ICD10' OR `ct_key`='SNOMED';
#EndIf

#IfMissingColumn layout_options fld_rows
ALTER TABLE `layout_options` ADD COLUMN `fld_rows` int(11) NOT NULL default '0';
UPDATE `layout_options` SET `fld_rows`=max_length WHERE `data_type`='3';
UPDATE `layout_options` SET `max_length`='0' WHERE `data_type`='3';
UPDATE `layout_options` SET `max_length`='0' WHERE `data_type`='34';
UPDATE `layout_options` SET `max_length`='20' WHERE `field_id`='financial_review' AND `form_id`='DEM';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='history_father' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='history_mother' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='history_siblings' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='history_spouse' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='history_offspring' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_cancer' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_tuberculosis' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_diabetes' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_high_blood_pressure' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_heart_problems' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_stroke' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_epilepsy' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_mental_illness' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='relatives_suicide' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='coffee' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='tobacco' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='alcohol' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='recreational_drugs' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='counseling' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='exercise_patterns' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='hazardous_activities' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='sleep_patterns' AND `form_id`='HIS';
UPDATE `layout_options` SET `max_length`='0' WHERE `field_id`='seatbelt_use' AND `form_id`='HIS';
#EndIf

#IfNotColumnType history_data usertext11 TEXT
ALTER TABLE `history_data` CHANGE `usertext11` `usertext11` TEXT NOT NULL;
#EndIf

#IfMissingColumn x12_partners x12_isa01
ALTER TABLE x12_partners ADD COLUMN x12_isa01 VARCHAR( 2 ) NOT NULL DEFAULT '00' COMMENT 'User logon Required Indicator';
#EndIf

#IfMissingColumn x12_partners x12_isa02
ALTER TABLE x12_partners ADD COLUMN x12_isa02 VARCHAR( 10 ) NOT NULL DEFAULT '          ' COMMENT 'User Logon';
#EndIf

#IfMissingColumn x12_partners x12_isa03
ALTER TABLE x12_partners ADD COLUMN x12_isa03 VARCHAR( 2 ) NOT NULL DEFAULT '00' COMMENT 'User password required Indicator';
#EndIf

#IfMissingColumn x12_partners x12_isa04
ALTER TABLE x12_partners ADD COLUMN x12_isa04 VARCHAR( 10 ) NOT NULL DEFAULT '          ' COMMENT 'User Password';
#EndIf

#IfMissingColumn codes financial_reporting
ALTER TABLE `codes` ADD COLUMN `financial_reporting` TINYINT(1) DEFAULT 0 COMMENT '0 = negative, 1 = considered important code in financial reporting';
#EndIf

#IfNotColumnType codes code_type smallint(6)
ALTER TABLE `codes` CHANGE `code_type` `code_type` SMALLINT(6) default NULL;
#EndIf

#IfNotIndex codes code_type
CREATE INDEX `code_type` ON `codes` (`code_type`);
#EndIf

#IfNotColumnType billing code_type varchar(15)
ALTER TABLE `billing` CHANGE `code_type` `code_type` VARCHAR(15) default NULL;
#EndIf

#IfNotColumnType codes modifier varchar(12)
ALTER TABLE `codes` CHANGE `modifier` `modifier` VARCHAR(12) NOT NULL default '';
#EndIf

#IfNotColumnType ar_activity modifier varchar(12)
ALTER TABLE `ar_activity` CHANGE `modifier` `modifier` VARCHAR(12) NOT NULL default '';
#EndIf

#IfNotRow code_types ct_key CPTII
DROP TABLE IF EXISTS `temp_table_one`;
CREATE TABLE `temp_table_one` (
  `id` int(11) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM ;
INSERT INTO `temp_table_one` (`id`, `seq`) VALUES ( IF( ((SELECT MAX(`ct_id`) FROM `code_types`)>=100), ((SELECT MAX(`ct_id`) FROM `code_types`) + 1), 100 ) , IF( ((SELECT MAX(`ct_seq`) FROM `code_types`)>=100), ((SELECT MAX(`ct_seq`) FROM `code_types`) + 1), 100 )  );
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external ) VALUES ('CPTII' , (SELECT MAX(`id`) FROM `temp_table_one`), (SELECT MAX(`seq`) FROM `temp_table_one`), 12, 'ICD9', 1, 0, 0, 0, 0, 'CPTII', 0);
DROP TABLE `temp_table_one`;
#EndIf

#IfNotRow code_types ct_key ICD9-SG
DROP TABLE IF EXISTS `temp_table_one`;
CREATE TABLE `temp_table_one` (
  `id` int(11) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM ;
INSERT INTO `temp_table_one` (`id`, `seq`) VALUES ( IF( ((SELECT MAX(`ct_id`) FROM `code_types`)>=100), ((SELECT MAX(`ct_id`) FROM `code_types`) + 1), 100 ) , IF( ((SELECT MAX(`ct_seq`) FROM `code_types`)>=100), ((SELECT MAX(`ct_seq`) FROM `code_types`) + 1), 100 )  );
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external ) VALUES ('ICD9-SG' , (SELECT MAX(`id`) FROM `temp_table_one`), (SELECT MAX(`seq`) FROM `temp_table_one`), 12, 'ICD9', 1, 0, 0, 0, 0, 'ICD9 Procedure/Service', 5);
DROP TABLE `temp_table_one`;
#EndIf

#IfNotRow code_types ct_key ICD10-PCS
DROP TABLE IF EXISTS `temp_table_one`;
CREATE TABLE `temp_table_one` (
  `id` int(11) NOT NULL DEFAULT '0',
  `seq` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM ;
INSERT INTO `temp_table_one` (`id`, `seq`) VALUES ( IF( ((SELECT MAX(`ct_id`) FROM `code_types`)>=100), ((SELECT MAX(`ct_id`) FROM `code_types`) + 1), 100 ) , IF( ((SELECT MAX(`ct_seq`) FROM `code_types`)>=100), ((SELECT MAX(`ct_seq`) FROM `code_types`) + 1), 100 )  );
INSERT INTO code_types (ct_key, ct_id, ct_seq, ct_mod, ct_just, ct_fee, ct_rel, ct_nofs, ct_diag, ct_active, ct_label, ct_external ) VALUES ('ICD10-PCS' , (SELECT MAX(`id`) FROM `temp_table_one`), (SELECT MAX(`seq`) FROM `temp_table_one`), 12, 'ICD10', 1, 0, 0, 0, 0, 'ICD10 Procedure/Service', 6);
DROP TABLE `temp_table_one`;
UPDATE `code_types` SET `ct_label`='ICD9 Diagnosis' WHERE `ct_key`='ICD9';
UPDATE `code_types` SET `ct_label`='CPT4 Procedure/Service' WHERE `ct_key`='CPT4';
UPDATE `code_types` SET `ct_label`='HCPCS Procedure/Service' WHERE `ct_key`='HCPCS';
UPDATE `code_types` SET `ct_label`='CVX Immunization' WHERE `ct_key`='CVX';
UPDATE `code_types` SET `ct_label`='DSMIV Diagnosis' WHERE `ct_key`='DSMIV';
UPDATE `code_types` SET `ct_label`='ICD10 Diagnosis' WHERE `ct_key`='ICD10';
UPDATE `code_types` SET `ct_label`='SNOMED Diagnosis' WHERE `ct_key`='SNOMED';
#EndIf

#IfMissingColumn code_types ct_claim
ALTER TABLE `code_types` ADD COLUMN `ct_claim` tinyint(1) NOT NULL default 0 COMMENT '1 if this is used in claims';
UPDATE `code_types` SET `ct_claim`='1' WHERE `ct_key`='ICD9' OR `ct_key`='CPT4' OR `ct_key`='HCPCS' OR `ct_key`='DSMIV' OR `ct_key`='ICD10' OR `ct_key`='SNOMED' OR `ct_key`='CPTII' OR `ct_key`='ICD9-SG' OR `ct_key`='ICD10-PCS';
UPDATE `code_types` SET `ct_fee`='0', `ct_mod`='0', `ct_label`='CPTII Performance Measures' WHERE `ct_key`='CPTII';
#EndIf

#IfMissingColumn form_encounter pos_code
	ALTER TABLE `form_encounter` ADD `pos_code` INT( 11 ) NOT NULL; 
#EndIf

#IfMissingColumn facility pos_code_multiple
	ALTER TABLE `facility` ADD `pos_code_multiple` TEXT NOT NULL;
#EndIf

#IfNotRow2D list_options list_id lists option_id POS
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `seq`, `is_default` ) VALUES ('lists' ,'POS','POS', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 1, 'Unassigned', 'N/A', 1, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 3, 'School', 'A facility whose primary purpose is education.', 3, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 4, 'Homeless Shelter', 'A facility or location whose primary purpose is to provide temporary housing to homeless individuals (e.g., emergency shelters, individual or family shelters).', 4, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 5, 'Indian Health Service Free-standing Facility', 'A facility or location, ownedAnd operated by the Indian Health Service, which provides diagnostic, therapeutic (surgicalAnd non-surgical),And rehabilitation services toAmerican IndiansAndAlaska Natives who do not require hospitalization.', 5, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 6, 'Indian Health Service Provider-based Facility', 'A facility or location, ownedAnd operated by the Indian Health Service, which provides diagnostic, therapeutic (surgicalAnd non-surgical),And rehabilitation services rendered by, or under the supervision of, physicians toAmerican IndiansAndAlaska NativesAdmittedAs inpatients or outpatients. ', 6, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 7, 'Tribal 6 Free-standing Facility', 'A facility or location ownedAnd operated byA federally recognizedAmerican Indian orAlaska Native tribe or tribal organization underA 6Agreement, which provides diagnostic, therapeutic (surgicalAnd non-surgical),And rehabilitation services to tribal members who do not require hospitalization.', 7, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 8, 'Tribal 6 Provider-based Facility', 'A facility or location ownedAnd operated byA federally recognizedAmerican Indian orAlaska Native tribe or tribal organization underA 6Agreement, which provides diagnostic, therapeutic (surgicalAnd non-surgical),And rehabilitation services to tribal membersAdmittedAs inpatients or outpatients.', 8, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 11, 'Office ', 'Location, other than a hospital, skilled nursing facility (SNF), military treatment facility, community health center, State orLocal public health clinic, or intermediate care facility (ICF), where the health professional routinely provides health examinations, diagnosis, and treatment of illness or injury on an ambulatory basis.', 11, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 12, 'Home', 'Location, other than a hospital or other facility, where the patient receives care in a private residence.', 12, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 13, 'Assisted Living Facility', 'Congregate residential facility with self-contained living units providing assessment of each resident’s needs and on-site support 24 hours a day, 7 days a week, with the capacity to deliver or arrange for services including some health care and other services.  (effective 10/1/03)', 13, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 14, 'Group Home *', 'A residence, with shared living areas, where clients receive supervision and other services such as social and/or behavioral services, custodial service, and minimal services (e.g., medication administration).', 14, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 15, 'Mobile Unit', 'A facility/unit that moves from place-to-place equipped to provide preventive, screening, diagnostic,And/or treatment services.', 15, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 20, 'Urgent Care Facility', 'Location, distinct from a hospital emergency room, an office, or a clinic, whose purpose is to diagnose and treat illness or injury for unscheduled, ambulatory patients seeking immediate medical attention.', 20, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 21, 'Inpatient Hospital', 'A facility, other than psychiatric, which primarily provides diagnostic, therapeutic (both surgicalAnd nonsurgical),And rehabilitation services by, or under, the supervision of physicians to patientsAdmitted forA variety of medical conditions.', 21, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 22, 'Outpatient Hospital', 'A portion of a hospital which provides diagnostic, therapeutic (both surgical and nonsurgical), and rehabilitation services to sick or injured persons who do not require hospitalization or institutionalization.', 22, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 23, 'Emergency Room - Hospital', 'A portion of a hospital where emergency diagnosis and treatment of illness or injury is provided.', 23, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 24, 'Ambulatory Surgical Center', 'A freestanding facility, other than a physician office, where surgical and diagnostic services are provided on an ambulatory basis.', 24, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 25, 'Birthing Center ', 'A facility, other thanA hospital maternity facilities orA physician office, which providesA setting for labor, delivery,And immediate post-partum careAs wellAs immediate care of new born infants.', 25, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 26, 'Military Treatment Facility', 'A medical facility operated by one or more of the Uniformed Services. Military Treatment Facility (MTF) also refers to certain former U.S. Public Health Service (USPHS) facilities now designated as Uniformed Service Treatment Facilities (USTF).', 26, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 31, 'Skilled Nursing Facility', 'A facility which primarily provides inpatient skilled nursing careAnd related services to patients who require medical, nursing, or rehabilitative services but does not provide the level of care or treatmentAvailable inA hospital.', 31, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 32, 'Nursing Facility', 'A facility which primarily provides to residents skilled nursing careAnd related services for the rehabilitation of injured, disabled, or sick persons, or, onA regular basis, health-related care servicesAbove the level of custodial care to other than mentally retarded individuals.', 32, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 33, 'Custodial Care Facility', 'A facility which provides room, boardAnd other personalAssistance services, generally onA long-term basis,And which does not includeA medical component.', 33, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 34, 'Hospice', 'A facility, other thanA patient home, in which palliativeAnd supportive care for terminally ill patientsAnd their familiesAre provided.', 34, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 41, 'Ambulance - Land', 'A land vehicle specifically designed, equipped and staffed for lifesaving and transporting the sick or injured.', 41, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 42, 'Ambulance - Air or Water', 'An air or water vehicle specifically designed, equipped and staffed for lifesaving and transporting the sick or injured.', 42, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 49, 'Independent Clinic', 'A location, not part of a hospital and not described by any other Place of Service code, that is organized and operated to provide preventive, diagnostic, therapeutic, rehabilitative, or palliative services to outpatients only.  (effective 10/1/03)', 49, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 50, 'Federally Qualified Health Center', 'A facility located inA medically underservedArea that provides Medicare beneficiaries preventive primary medical care under the general direction ofA physician.', 50, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 51, 'Inpatient Psychiatric Facility', 'A facility that provides inpatient psychiatric services for the diagnosisAnd treatment of mental illness onA 24-hour basis, by or under the supervision ofA physician.', 51, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 52, 'Psychiatric Facility-Partial Hospitalization', 'A facility for the diagnosisAnd treatment of mental illness that providesA planned therapeutic program for patients who do not require full time hospitalization, but who need broader programs thanAre possible from outpatient visits toA hospital-based or hospital-affiliated facility.', 52, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 53, 'Community Mental Health Center', 'A facility that provides the following services: outpatient services, including specialized outpatient services for children, the elderly, individuals whoAre chronically ill,And residents of the CMHC mental health servicesArea who have been discharged from inpatient treatmentAtA mental health facility 24 hourA day emergency care services day treatment, other partial hospitalization services, or psychosocial rehabilitation services screening for patients being considered forAdmission to State mental health facilities to determine theAppropriateness of suchAdmissionAnd consultationAnd education services.', 53, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 54, 'Intermediate Care Facility/Mentally Retarded', 'A facility which primarily provides health-related careAnd servicesAbove the level of custodial care to mentally retarded individuals but does not provide the level of care or treatmentAvailable inA hospital or SNF.', 54, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 55, 'Residential Substance Abuse Treatment Facility', 'A facility which provides treatment for substance (alcoholAnd drug)Abuse to live-in residents who do not requireAcute medical care. Services include individualAnd group therapyAnd counseling, family counseling, laboratory tests, drugsAnd supplies, psychological testing,And roomAnd board.', 55, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 56, 'Psychiatric Residential Treatment Center', 'A facility or distinct part ofA facility for psychiatric care which providesA total 24-hour therapeutically plannedAnd professionally staffed group livingAnd learning environment.', 56, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 57, 'Non-residential Substance Abuse Treatment Facility', 'A location which provides treatment for substance (alcoholAnd drug)Abuse onAnAmbulatory basis.  Services include individualAnd group therapyAnd counseling, family counseling, laboratory tests, drugsAnd supplies,And psychological testing.  (effective 10/1/03)', 57, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 60, 'Mass Immunization Center', 'A location where providersAdminister pneumococcal pneumoniaAnd influenza virus vaccinationsAnd submit these servicesAs electronic media claims, paper claims, or using the roster billing method. This generally takes place inA mass immunization setting, suchAs,A public health center, pharmacy, or mall but may includeA physician office setting.', 60, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 61, 'Comprehensive Inpatient Rehabilitation Facility', 'A facility that provides comprehensive rehabilitation services under the supervision ofA physician to inpatients with physical disabilities. Services include physical therapy, occupational therapy, speech pathology, social or psychological services,And orthoticsAnd prosthetics services.', 61, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 62, 'Comprehensive Outpatient Rehabilitation Facility', 'A facility that provides comprehensive rehabilitation services under the supervision ofA physician to outpatients with physical disabilities. Services include physical therapy, occupational therapy,And speech pathology services.', 62, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 65, 'End-Stage Renal Disease Treatment Facility', 'A facility other thanA hospital, which provides dialysis treatment, maintenance,And/or training to patients or caregivers onAnAmbulatory or home-care basis.', 65, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 71, 'Public Health Clinic', 'A facility maintained by either State or local health departments that providesAmbulatory primary medical care under the general direction ofA physician.  (effective 10/1/03)', 71, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 72, 'Rural Health Clinic', 'A certified facility which is located in a rural medically underserved area that provides ambulatory primary medical care under the general direction of a physician.', 72, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 81, 'Independent Laboratory', 'A laboratory certified to perform diagnosticAnd/or clinical tests independent ofAn institution orA physician office.', 81, 0);
INSERT INTO `list_options` ( `list_id`, `option_id`, `title`, `notes`, `seq`, `is_default` ) VALUES ('POS', 99, 'Other Place of Service', 'Other place of service not identified above. ', 99, 0);
#EndIf

