-- Loan Payment Receipt
-- Loan Disbursement
-- Savings Receipt
-- Shares Contribution
-- Savings Withdraw


-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema rubai

-- Arrange company setup,continent,continental region,petrol_station,busin ess petrol_station,petrol_station region.

-- user,user roles,next of kin, address,

-- constants
-- --------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `rubai` DEFAULT CHARACTER SET utf8 ;
USE `rubai` ;


/*==============PART ONE:COMPANY SETUP=============*/

-- Table `the_company_datails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `the_company_datails` (
  `the_company_details_id` INT(11) NOT NULL AUTO_INCREMENT,
  `the_company_name` VARCHAR(100) NULL DEFAULT 'Edad Coin SMS-Ltd',
  `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`the_company_details_id`)
  )
ENGINE = InnoDB
AUTO_INCREMENT = 16000
DEFAULT CHARACTER SET = utf8;



-- ---------------------------------------------------
-- Table `the_company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `the_company` (
  `the_company_id` INT(11) NOT NULL AUTO_INCREMENT,
  `the_company_name` VARCHAR(100) NULL DEFAULT NULL,
  `fk_the_company_details_id_the_company` INT(11) NULL DEFAULT NULL,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`the_company_id`),
  CONSTRAINT `fk_the_company_details_id_the_company`
    FOREIGN KEY (`fk_the_company_details_id_the_company`)
    REFERENCES `the_company_datails` (`the_company_details_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 300
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_the_company_details_id_the_companyes_idx` ON `the_company` (`fk_the_company_details_id_the_company` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `petrol_station`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petrol_station` (
  `petrol_station_id` INT(11) NOT NULL AUTO_INCREMENT,
  `petrol_station_name` VARCHAR(100) NULL DEFAULT 'Disbursement',
  `fk_the_company_id_petrol_station` INT(11) NULL ,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`petrol_station_id`),
  CONSTRAINT `fk_the_company_id_petrol_station` 
  FOREIGN KEY (`fk_the_company_id_petrol_station`) 
  REFERENCES `the_company`(`the_company_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 500
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_the_company_id_petrol_station_idx` ON `petrol_station`(`fk_the_company_id_petrol_station` ASC) VISIBLE;





-- -----------------------------------------------------
-- Table `petrol_station_rates`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `petrol_station_rates` (
  `petrol_station_rates_id` INT(11) NOT NULL AUTO_INCREMENT,
  `petrol_station_interest` DOUBLE,
  `petrol_station_commission` DOUBLE,
   `petrol_station_loan_limit` DOUBLE,
  `fk_petrol_station_id_petrol_station_rates` INT(11) NULL ,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`petrol_station_rates_id`),

  CONSTRAINT `fk_petrol_station_id_petrol_station_rates` 
  FOREIGN KEY (`fk_petrol_station_id_petrol_station_rates`) 
  REFERENCES `petrol_station`(`petrol_station_id`)
   ON DELETE CASCADE 
   ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 5000
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_petrol_station_id_petrol_station_rates_idx` ON `petrol_station_rates`(`fk_petrol_station_id_petrol_station_rates` ASC) VISIBLE;


/*==============PART TWO:USER DETAILS SETUPS=============*/

-- ---------------------------------------------------
-- Table `user_role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `user_role` (
  `user_role_id` INT NOT NULL AUTO_INCREMENT,
  `user_role_name` VARCHAR(45) NULL,
  `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`user_role_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1000;


-- ---------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS  `users`;

CREATE TABLE IF NOT EXISTS `users` (
  `users_id` INT(11) NOT NULL AUTO_INCREMENT,
  `users_name` VARCHAR(45) NULL DEFAULT 'GoogoBazi',
  `users_password` VARCHAR(500) NULL DEFAULT 'XXXXXX',
  `users_active_status` VARCHAR(20) NULL DEFAULT 'XXXXXX', -- Created,Approved,Deactivated
    `fk_petrol_station_id_users` INT(11) NULL,
  `fk_user_role_id_users` INT(11) NULL,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`users_id`),

  CONSTRAINT `fk_user_role_id_users`
    FOREIGN KEY (`fk_user_role_id_users`)
    REFERENCES `user_role` (`user_role_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,

     CONSTRAINT `fk_petrol_station_id_users`
    FOREIGN KEY (`fk_petrol_station_id_users`)
    REFERENCES `petrol_station` (`petrol_station_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 100000000
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_user_role_id_users_idx` ON `users` (`fk_user_role_id_users` ASC) VISIBLE;
-- CREATE INDEX `fk_petrol_station_id_users_idx` ON `users` (`fk_petrol_station_id_users` ASC) VISIBLE;




-- ---------------------------------------------------
-- Table `common_bio_data`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `common_bio_data` (
  `common_bio_data_id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL DEFAULT 'Augustine',
  `sex` VARCHAR(45) NULL DEFAULT 'Male',
  `date_of_birth` VARCHAR(45) NULL DEFAULT '1983-10-04',
  `fk_users_id_common_bio_data` INT(11) NULL DEFAULT NULL,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`common_bio_data_id`),
  CONSTRAINT `fk_users_id_common_bio_data`
    FOREIGN KEY (`fk_users_id_common_bio_data`)
    REFERENCES `users` (`users_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
  
ENGINE = InnoDB
AUTO_INCREMENT = 90
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_next_of_kin_id_common_bio_data` ON `common_bio_data` (`fk_users_id_common_bio_data` ASC) VISIBLE;


-- ---------------------------------------------------
-- Table `stage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS  `stage`;

CREATE TABLE IF NOT EXISTS `stage` (
  `stage_id` INT(11) NOT NULL AUTO_INCREMENT,
  `stage_name` VARCHAR(200) NULL DEFAULT 'GoogoBazi',
  `chairmans_name` VARCHAR(45) NULL ,
  `chairmans_number` VARCHAR(45) NULL ,
 `fk_user_id_created_by_stage` INT,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`stage_id`),

  CONSTRAINT `fk_user_id_created_by_stage`
    FOREIGN KEY (`fk_user_id_created_by_stage`)
    REFERENCES `users` (`users_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    )
ENGINE = InnoDB
AUTO_INCREMENT = 100000000
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_user_id_created_by_stage_indx` ON `stage` (`fk_user_id_created_by_stage` ASC) VISIBLE;

-- ---------------------------------------------------
-- Table `customers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS  `customers`;

CREATE TABLE IF NOT EXISTS `customers` (
  `customers_id` INT(11) NOT NULL AUTO_INCREMENT,
  `customers_name` VARCHAR(200) NULL DEFAULT 'GoogoBazi',
  `customers_phone_number` VARCHAR(45) NULL ,
  `customers_number_plate` VARCHAR(45) NULL ,
 `fk_user_id_created_by_customers` INT,
   `secret_pin`INT ,
  `fk_stage_id_customer` INT,
   `created_at` TIMESTAMP,
  `update_at` TIMESTAMP,
  PRIMARY KEY (`customers_id`),

  CONSTRAINT `fk_user_id_created_by_customers`
    FOREIGN KEY (`fk_user_id_created_by_customers`)
    REFERENCES `users` (`users_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    )
ENGINE = InnoDB
AUTO_INCREMENT = 100000000
DEFAULT CHARACTER SET = utf8;



-- CREATE INDEX `fk_user_id_created_by_customers_indx` ON `customers` (`fk_user_id_created_by_customers` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `loans`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loans` (
  `loans_id` INT(11) NOT NULL AUTO_INCREMENT,

  `loan_cycle` INT NULL,

    `loan_status` INT NULL, --  1=Running,2=Completed,3=Stopped 

  `loan_amount_taken` DOUBLE NULL,
   `loan_amount_paid` DOUBLE NULL,
    `loan_amount_remaining` DOUBLE NULL,
  `loan_date_taken` TIMESTAMP,
   `fk_user_id_loans` INT,
  `fk_customers_id_loans` INT,

  PRIMARY KEY (`loans_id`),

  CONSTRAINT `fk_user_id_loans`
    FOREIGN KEY (`fk_user_id_loans`)
    REFERENCES `users` (`users_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
    
      CONSTRAINT `fk_customers_id_loans`
    FOREIGN KEY (`fk_customers_id_loans`)
    REFERENCES `customers` (`customers_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 1700
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_customers_id_loans_indx` ON `loans` (`fk_customers_id_loans` ASC) VISIBLE;



-- -----------------------------------------------------
-- Table `loan_payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `loan_payments` (
  `loan_payments_id` INT(11) NOT NULL AUTO_INCREMENT,
  `loan_payments_status` INT NULL, -- 1=OnGoing,2=Completed
  `loan_amount_paid` DOUBLE NULL,
  `loan_amount_remaining`  DOUBLE NULL,
  `loan_date_paid` TIMESTAMP,
   `fk_loans_id_loan_payment` INT,
  PRIMARY KEY (`loan_payments_id`),

  CONSTRAINT `fk_loans_id_loan_payment`
    FOREIGN KEY (`fk_loans_id_loan_payment`)
    REFERENCES `loans` (`loans_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    )
ENGINE = InnoDB
AUTO_INCREMENT = 5700
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_loans_id_loan_payment_indx` ON `loan_payments` (`fk_loans_id_loan_payment` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `lc_manager` loan_cycle_management_table
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `lc_manager` (

  `lc_manager_id` INT(11) NOT NULL AUTO_INCREMENT,

  `lc_manager_status` INT NULL, -- 1=OnGoing,2=Stopped

  `lc_manager_start_time` TIMESTAMP,
 
  `lc_manager_expirely_time` TIMESTAMP,

   `lc_manager_no_accruals` INT,

   `fk_loans_id_lc_manager` INT,

  PRIMARY KEY (`lc_manager_id`),

  CONSTRAINT `fk_loans_id_lc_manager`
    FOREIGN KEY (`fk_loans_id_lc_manager`)
    REFERENCES `loans` (`loans_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 1974
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_loans_id_lc_manager_indx` ON `lc_manager` (`fk_loans_id_lc_manager` ASC) VISIBLE;


--  petrol_station
-- -----------------------------------------------------
-- Table `ps_l_accrual_p` petrol_station_loan_accrual_period
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ps_l_accrual_p` (

  `ps_l_accrual_p_id` INT(11) NOT NULL AUTO_INCREMENT,

  `ps_l_accrual_p_number` INT NULL,

   `fk_petrol_station_id_ps_l_accrual_p` INT,

  PRIMARY KEY (`ps_l_accrual_p_id`),

  CONSTRAINT `fk_petrol_station_id_ps_l_accrual_p`
    FOREIGN KEY (`fk_petrol_station_id_ps_l_accrual_p`)
    REFERENCES `petrol_station` (`petrol_station_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 6009
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_petrol_station_id_ps_l_accrual_p_indx` ON `ps_l_accrual_p` (`fk_petrol_station_id_ps_l_accrual_p` ASC) VISIBLE;




-- -----------------------------------------------------
-- Table `interest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `interest` (
  `interest_id` INT(11) NOT NULL AUTO_INCREMENT,

  `interest_accrual_status` INT NULL, -- 1=OnGoing,2=Stopped
  `interest_amount` DOUBLE NULL,
   `interest_paid` DOUBLE NULL,
   `interest_remaining` DOUBLE NULL, 
   `fk_loans_id_interest` INT,
  PRIMARY KEY (`interest_id`),

  CONSTRAINT `fk_loans_id_interest`
    FOREIGN KEY (`fk_loans_id_interest`)
    REFERENCES `loans` (`loans_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 1900
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_loans_id_interest_indx` ON `interest` (`fk_loans_id_interest` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `Generated_id`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `theGen` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
    
    )
ENGINE = InnoDB
AUTO_INCREMENT =1
DEFAULT CHARACTER SET = utf8;

-- -----------------------------------------------------
-- Table `interest_payments`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `interest_payments` (
  `interest_payments_id` INT(11) NOT NULL AUTO_INCREMENT,
   `interest_amount_added` DOUBLE NULL,
  `interest_amount_paid` DOUBLE NULL,
  `interest_amount_remaining`  DOUBLE NULL,
  `interest_date_paid` TIMESTAMP,
   `fk_interest_id_interest_payment` INT,
  PRIMARY KEY (`interest_payments_id`),

  CONSTRAINT `fk_interest_id_interest_payment`
    FOREIGN KEY (`fk_interest_id_interest_payment`)
    REFERENCES `interest` (`interest_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 3700
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_interest_id_interest_payment_indx` ON `interest_payments` (`fk_interest_id_interest_payment` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `commission`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `commission`;

CREATE TABLE IF NOT EXISTS `commission` (
  `commission_id` INT(11) NOT NULL AUTO_INCREMENT,


  `commission_amount` DOUBLE NULL,

   `fk_interest_id_commision` INT,
  PRIMARY KEY (`commission_id`),

  CONSTRAINT `fk_interest_id_commision`
    FOREIGN KEY (`fk_interest_id_commision`)
    REFERENCES `interest` (`interest_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 1300
DEFAULT CHARACTER SET = utf8;


CREATE INDEX `fk_interest_id_commision_indx` ON `commission` (`fk_interest_id_commision` ASC) VISIBLE;




-- -- -----------------------------------------------------
-- -- Table `commission`
-- -- -----------------------------------------------------
-- DROP TABLE IF EXISTS `commission_M`;

-- CREATE TABLE IF NOT EXISTS `commission_M` (
--   `commission_id` INT(11) NOT NULL AUTO_INCREMENT,


--   `commission_amount` DOUBLE NULL,

--    `fk_interest_id_commision` INT,
--   PRIMARY KEY (`commission_id`),

--   CONSTRAINT `fk_interest_id_commision`
--     FOREIGN KEY (`fk_interest_id_commision`)
--     REFERENCES `interest` (`interest_id`)
--     ON DELETE CASCADE
--     ON UPDATE NO ACTION
    
--     )
-- ENGINE = InnoDB
-- AUTO_INCREMENT = 1300
-- DEFAULT CHARACTER SET = utf8;


-- CREATE INDEX `fk_interest_id_commision_indx` ON `commission` (`fk_interest_id_commision` ASC) VISIBLE;



-- -----------------------------------------------------
-- Table `commission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `commission_details` (
  `commission_details_id` INT(11) NOT NULL AUTO_INCREMENT,
  `commission_amount_added` DOUBLE NULL,
  `commission_date_computed` TIMESTAMP,
   `fk_commission_id_commission_details` INT,
  PRIMARY KEY (`commission_details_id`),

  CONSTRAINT `fk_commission_id_commission_details`
    FOREIGN KEY (`fk_commission_id_commission_details`)
    REFERENCES `commission` (`commission_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )

ENGINE = InnoDB
AUTO_INCREMENT = 6500
DEFAULT CHARACTER SET = utf8;


CREATE INDEX `fk_commission_id_commission_details_indx` ON `commission_details` (`fk_commission_id_commission_details` ASC) VISIBLE;


-- ---------------------------------------------------
-- Table `trn_general_ledger`
-- ---------------------------------------------------
DROP TABLE IF EXISTS `trn_general_ledger`;

CREATE TABLE IF NOT EXISTS `trn_general_ledger` (
  `trn_general_ledger_id` INT(11) NOT NULL AUTO_INCREMENT,
  `trn_date` TIMESTAMP NULL DEFAULT NULL,
  `trn_type` VARCHAR(50) NULL DEFAULT NULL,
  `trn_debit` DOUBLE NULL DEFAULT NULL,
  `trn_credit` DOUBLE NULL DEFAULT NULL,
   `fk_petrol_station_id_trn_general_ledger` INT(11) NULL DEFAULT NULL,
  `fk_user_id_posted_by_trn_general_ledger_id` INT(11) NULL DEFAULT NULL,
  `fk_user_id_belongs_to_trn_general_ledger_id` INT(11) NULL DEFAULT NULL,
   `fk_shift_id_trn_general_ledger` INT(11) NULL DEFAULT NULL,

  PRIMARY KEY (`trn_general_ledger_id`),

  CONSTRAINT `fk_petrol_station_id_trn_general_ledger`
  FOREIGN KEY (`fk_petrol_station_id_trn_general_ledger`)
  REFERENCES `petrol_station`(`petrol_station_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION,

  CONSTRAINT `fk_user_id_posted_by_trn_general_ledger_id`
  FOREIGN KEY (`fk_user_id_posted_by_trn_general_ledger_id`)
  REFERENCES `users`(`users_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION,

   CONSTRAINT `fk_user_id_belongs_to_trn_general_ledger_id`
  FOREIGN KEY (`fk_user_id_belongs_to_trn_general_ledger_id`)
  REFERENCES `users`(`users_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION,
  
    CONSTRAINT `fk_shift_id_trn_general_ledger`
  FOREIGN KEY (`fk_shift_id_trn_general_ledger`)
  REFERENCES `shift`(`shift_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION )

ENGINE = InnoDB
AUTO_INCREMENT = 4000
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_user_id_posted_by_trn_general_ledger_id_indx` ON `trn_general_ledger`(`fk_user_id_posted_by_trn_general_ledger_id` ASC);

CREATE INDEX `fk_user_id_belongs_to_trn_general_ledger_id_indx` ON `trn_general_ledger`(`fk_user_id_belongs_to_trn_general_ledger_id` ASC);


CREATE INDEX `fk_shift_id_trn_general_ledger_indx` ON `trn_general_ledger`(`fk_shift_id_trn_general_ledger` ASC);

CREATE INDEX `fk_petrol_station_id_trn_general_ledger_indx` ON `trn_general_ledger`(`fk_petrol_station_id_trn_general_ledger` ASC);




-- ---------------------------------------------------
-- Table `trn_customer_details`
-- ---------------------------------------------------
DROP TABLE IF EXISTS `trn_customer_details`;

CREATE TABLE IF NOT EXISTS `trn_customer_details` (
  `trn_customer_details_id` INT(11) NOT NULL AUTO_INCREMENT,
  `trn_number_plate` VARCHAR(50) NULL DEFAULT NULL,
  `trn_customer_name` VARCHAR(50) NULL DEFAULT NULL,
   `fk_trn_general_ledger_id_trn_customer_details` INT(11) NULL DEFAULT NULL,
  PRIMARY KEY (`trn_customer_details_id`),

  CONSTRAINT `fk_trn_general_ledger_id_trn_customer_details`
  FOREIGN KEY (`fk_trn_general_ledger_id_trn_customer_details`)
  REFERENCES `trn_general_ledger`(`trn_general_ledger_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION )

ENGINE = InnoDB
AUTO_INCREMENT = 5200
DEFAULT CHARACTER SET = utf8;

CREATE INDEX `fk_trn_general_ledger_id_trn_customer_details_indx` ON `trn_customer_details`(`fk_trn_general_ledger_id_trn_customer_details` ASC);


-- -----------------------------------------------------
-- Table `balance_per_day`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `balance_per_day`;
CREATE TABLE IF NOT EXISTS `balance_per_day` (
  `balance_per_day_id` INT(11) NOT NULL AUTO_INCREMENT,
  `the_balance` DOUBLE NULL,
  `fk_petrol_station_id_balance_per_day` INT NULL,
  `trn_date` TIMESTAMP,
  PRIMARY KEY (`balance_per_day_id`),
  
  
  CONSTRAINT `fk_petrol_station_id_balance_per_day`
  FOREIGN KEY (`fk_petrol_station_id_balance_per_day`)
  REFERENCES `petrol_station`(`petrol_station_id`)
  ON DELETE CASCADE
  ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 4750
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `the_balance_indx` ON `balance_per_day` (`the_balance` ASC) VISIBLE;

-- CREATE INDEX `fk_petrol_station_id_balance_per_day_indx` ON `balance_per_day` (`fk_petrol_station_id_balance_per_day` ASC) VISIBLE;





-- -----------------------------------------------------
-- Table `shift`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `shift`;
CREATE TABLE IF NOT EXISTS `shift` (
  `shift_id` INT(11) NOT NULL AUTO_INCREMENT,
  `shift_opening_bal` DOUBLE NULL,
  `shift_closing_bal` DOUBLE NULL,
  `shift_status`  VARCHAR(100) NULL, -- started,open,closed

  `shift_start_date` TIMESTAMP,
  `shift_end_date` TIMESTAMP,
    `fk_petrol_station_id_shift` INT,
   `fk_user_id_created_by_shift` INT,
    `fk_user_id_closed_by_shift` INT,
  PRIMARY KEY (`shift_id`),

    CONSTRAINT `fk_petrol_station_id_shift`
    FOREIGN KEY (`fk_petrol_station_id_shift`)
    REFERENCES `petrol_station` (`petrol_station_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,

  CONSTRAINT `fk_user_id_created_by_shift`
    FOREIGN KEY (`fk_user_id_created_by_shift`)
    REFERENCES `users` (`users_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,

     CONSTRAINT `fk_user_id_closed_by_shift`
    FOREIGN KEY (`fk_user_id_closed_by_shift`)
    REFERENCES `users` (`users_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
AUTO_INCREMENT = 400
DEFAULT CHARACTER SET = utf8;

-- CREATE INDEX `fk_user_id_created_by_shift_indx` ON `shift` (`fk_user_id_created_by_shift` ASC) VISIBLE;
-- CREATE INDEX `fk_petrol_station_id_shift_indx` ON `shift` (`fk_petrol_station_id_shift` ASC) VISIBLE;


-- -----------------------------------------------------
-- Table `sms_management` a table holding the counter for the SMSs that the company has bought
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sms_management` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `number_of_sms` INT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;




CREATE EVENT test_event_03 ON SCHEDULE EVERY 1 MINUTE STARTS CURRENT_TIMESTAMP ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR DO INSERT INTO messages(message,created_at) VALUES('Test MySQL recurring Event',NOW());