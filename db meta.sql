users_roles:role_name
->admin_normal
->admin_super
->user_nomal
:role_type
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';





CREATE TABLE `accountsidgenerators` (
  `TemplateIdAssets` int(11) DEFAULT '100000',
  `TemplateIdExpenses` int(11) DEFAULT '200000',
  `TemplateIdIncomes` int(11) DEFAULT '300000',
  `TemplateIdEquity` int(11) DEFAULT '400000',
  `TemplateIdLiabilities` int(11) DEFAULT '500000',
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
CREATE TABLE `accountstemplate` (
  `TemplateId` int(11) NOT NULL AUTO_INCREMENT,--Uni
  `TemplateDate` date NOT NULL DEFAULT '1970-01-01',
  `AccountName` varchar(200) DEFAULT '0',
  `AccountNumber` varchar(200) DEFAULT '0',
  `AccountCategory1` varchar(200) DEFAULT '0',
  `AccountCategory2` varchar(200) DEFAULT '0',
  `AccountCategory3` varchar(200) DEFAULT '0',
  `AccountCategory4` varchar(200) DEFAULT '0',
  `AccountStatus` varchar(100) DEFAULT 'Active',
  `UserId` int(11) NOT NULL,
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO',
  PRIMARY KEY (`TemplateId`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `balancesdb`;
CREATE TABLE `balancesdb` (
  `TxnId` int(11) NOT NULL AUTO_INCREMENT,
  `postDate` date NOT NULL DEFAULT '1970-01-01',
  `TxnDate` date NOT NULL DEFAULT '1970-01-01',
  `accountNumber` varchar(100) DEFAULT '0',
   `accountName` varchar(200) DEFAULT '0',
  `Balance` varchar(100) DEFAULT '0',
  `UserId` int(11) NOT NULL,
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO',
  PRIMARY KEY (`TxnId`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;



DROP TABLE IF EXISTS `generalledger`;
CREATE TABLE `generalledger` (
  `TxnId` int(11) NOT NULL,
  `TxnDate` date NOT NULL DEFAULT '1970-01-01',
  `SysDate` date NOT NULL DEFAULT '1970-01-01',
  `PostDate` date NOT NULL DEFAULT '1970-01-01',
  `BatchNumber` varchar(100) DEFAULT '0',
  `TxnType` varchar(100) DEFAULT '0',
  `Narration` varchar(300) DEFAULT '0',
  `AccountName` varchar(200) DEFAULT '0',
  `AccountNumber` varchar(100) DEFAULT '0',
  `DEDITAmount` varchar(100) DEFAULT '0',
  `CREDITAmount` varchar(100) DEFAULT '0',
  `UserId` int(11) NOT NULL,
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `generalledger` ADD PRIMARY KEY (`TxnId`);

ALTER TABLE `generalledger` MODIFY `TxnId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;


CREATE TABLE `datesforsystem` (
  `DateID` int(11) NOT NULL AUTO_INCREMENT,
  `SystemDate` date NOT NULL DEFAULT '1970-01-01',
  `PostingmDate` date NOT NULL DEFAULT '1970-01-01',
  `ValueDate` date NOT NULL DEFAULT '1970-01-01',
  `OtherDate` date NOT NULL DEFAULT '1970-01-01',
  PRIMARY KEY (`DateID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

INSERT INTO systemids VALUES(2,10,100,1000,10000,20000,70000,80000,90000,100000,110000,120000,130000,140000,'NCO','NCO','NCO');




DROP TABLE IF EXISTS `TxnsProcess`;

CREATE TABLE `TxnsProcess` (
  `TxnsProcessId` int(11) NOT NULL AUTO_INCREMENT,
  `TxnName` varchar(100) DEFAULT '0',
  `DrAccountNumber` varchar(100) DEFAULT '0',
  `DrAccountName` varchar(100) DEFAULT '0',
  `CrAccountNumber` varchar(100) DEFAULT '0',
  `CrAccountName`  varchar(100) DEFAULT '0',
  `CreationDate` date NOT NULL DEFAULT '1970-01-01',
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO',
  PRIMARY KEY (`TxnsProcessId`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=latin1;


CREATE TABLE `TxnsCategories` (
  `TxnsCatId` int(11) NOT NULL AUTO_INCREMENT,
  `TxnCatName` varchar(100) DEFAULT '0',
  `TxnCatDescription` varchar(300) DEFAULT '0',
  `CreationDate` date NOT NULL DEFAULT '1970-01-01',
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO',
  PRIMARY KEY (`TxnsCatId`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SpecialAccountSetUp`;
CREATE TABLE `SpecialAccountSetUp` (
  `setUpId` int(11) NOT NULL AUTO_INCREMENT,
  `setUpName` varchar(100) DEFAULT '0',
  `setUpAccountName` varchar(300) DEFAULT '0',
  `setUpAccountNumber` varchar(300) DEFAULT '0',
  `CreationDate` date NOT NULL DEFAULT '1970-01-01',
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO',
  PRIMARY KEY (`setUpId`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `GeneralJournalEntry`;
CREATE TABLE `GeneralJournalEntry` (
  `JournalId` int(11) NOT NULL AUTO_INCREMENT,
  `PostingIdBatch` varchar(100) DEFAULT '0',
  `journalAccountName` varchar(300) DEFAULT '0',
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO',
  PRIMARY KEY (`JournalId`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS `GeneralJournalEntry`;
CREATE TABLE `GeneralJournalEntry` (
  `JournalId` int(11) NOT NULL AUTO_INCREMENT,
  `PostingIdBatch` varchar(100) DEFAULT '0',
  `journalAccountName` varchar(300) DEFAULT '0',
  `OtherThree` varchar(45) DEFAULT 'NCO',
  `OtherFour` varchar(45) DEFAULT 'NCO',
  `OtherFive` varchar(45) DEFAULT 'NCO',
    `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`JournalId`)
) ENGINE=InnoDB AUTO_INCREMENT=1000 DEFAULT CHARSET=latin1;


  `fk_user_id_created_by` INT,
  `fk_user_id_first_approved_by` INT,
  `fk_user_id_second_approved_by` INT,



  INSERT INTO the_company_datails VALUES(NULL,'EL-WILL FINANCIAL SERVICES',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());
  INSERT INTO petrol_station_company VALUES(NULL,'HASS',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());
 INSERT INTO petrol_station VALUES(NULL,'MULAGO',300,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

 INSERT INTO user_role VALUES(1000,'pump_user',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(1001,'admin_user',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(1002,'other_user',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()); 

UPDATE users SET  fk_user_role_id_users=1002 WHERE  users_id=100000000;

 INSERT INTO petrol_station_rates VALUES(NULL,5,5,20000,500,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()); 

 INSERT INTO ps_l_accrual_p VALUES(NULL,30,500); 


INSERT INTO sms_management VALUES(NULL,5);

