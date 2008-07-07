-- -*-sql-*-

-- DROP TABLE `marks`;

CREATE TABLE IF NOT EXISTS `marks` (
       `mark_id` INTEGER NOT NULL AUTO_INCREMENT,
       `mark_channel` VARCHAR(32) NOT NULL,
       `mark_nick` VARCHAR(32) NOT NULL,
       `mark_prefix` VARCHAR(64) NOT NULL,
       `mark_url` VARCHAR(256) NOT NULL,
       `mark_message` VARCHAR(256) NOT NULL,
       `mark_time` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
       PRIMARY KEY (`mark_id`),
       UNIQUE KEY (`mark_url`),
       INDEX (`mark_url`)
) DEFAULT CHARSET=utf8;

-- SHOW CREATE TABLE `marks`;
