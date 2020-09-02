
/*  USER ROLES DATA */

--  INSERT INTO the_company_datails VALUES(NULL,'EL-WILL FINANCIAL SERVICES',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

--  INSERT INTO petrol_station_company VALUES(NULL,'STABEX INTERNATIONAL',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

--  INSERT INTO petrol_station VALUES(NULL,'NDEEBA',303,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

-- INSERT INTO user_role VALUES(1000,'pump_user',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(1001,'admin_user',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(1002,'other_user',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()); 

--UPDATE users SET  fk_user_role_id_users=1002 WHERE  users_id=100000000;

-- INSERT INTO petrol_station_rates VALUES(NULL,5,5,20000,511,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()); 

-- INSERT INTO ps_l_accrual_p VALUES(NULL,20,511); 


--INSERT INTO sms_management VALUES(NULL,5);

/*SELECT THE INITIAL SETUP */
/* ALL PETROL STATION COMPANIES*/



INSERT INTO petrol_station_company VALUES(NULL,'ALBERTINE REGION',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'CENTRAL UGANDA',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'EASTERN UGANDA',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'GREATER BUSOGA REGION',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'GREATER MUKONO',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'HOIMA ROAD',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'MAKINDYE SSEBAGABO DIVISION',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'NAKAWA DIVISION',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'NORTHERN UGANDA',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'RUBAGA DIVISION',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP()),(NULL,'UGANDA',16000,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

DROP PROCEDURE IF EXISTS getTheCompanyPetrolStations;

DELIMITER ##

CREATE PROCEDURE   getTheCompanyPetrolStations() 

BEGIN

SELECT petrol_station_company_id,petrol_station_company_name FROM petrol_station_company;

END ##

DELIMITER ;

 

/* ALL PETROL STATIONS UNDER A COMPANY */


DROP PROCEDURE IF EXISTS getThePetrolStations;

DELIMITER ##

CREATE PROCEDURE   getThePetrolStations(IN the_company_details VARCHAR(45)) 

BEGIN

DECLARE theCoId INT;

SELECT tst.petrol_station_id,tst.petrol_station_name FROM petrol_station tst INNER JOIN petrol_station_company psc ON tst.fk_petrol_station_company_id_petrol_station=psc.petrol_station_company_id WHERE psc.petrol_station_company_name=the_company_details;

END ##

DELIMITER ;


/* ALL USER ROLES */
DROP PROCEDURE IF EXISTS getTheUserRoles;

DELIMITER ##

CREATE PROCEDURE   getTheUserRoles() 

BEGIN

SELECT user_role_id,user_role_name FROM user_role;

END ##

DELIMITER ;




/* TEST WHETHER USER EXISTS */
DROP PROCEDURE IF EXISTS userExists;
DELIMITER ##
CREATE PROCEDURE   userExists(IN phone_number VARCHAR(45),IN user_role VARCHAR(45)) 
BEGIN

SELECT  COUNT(u.users_id) AS user_exists FROM  users u INNER JOIN user_role ul ON u.fk_user_role_id_users=ul.user_role_id WHERE u.users_name=phone_number AND ul.user_role_name=user_role;
END ##
DELIMITER ;


/* CREATE INITIAL USER DETAILS/register user using phone number*/
DROP PROCEDURE IF EXISTS registerTheUsersDetails;
DELIMITER ##
CREATE PROCEDURE   registerTheUsersDetails(IN data JSON,IN phone_number VARCHAR(45),IN password VARCHAR(200)) 
BEGIN

DECLARE the_station_id,the_role_id,the_users_id INT;

SELECT user_role_id INTO the_role_id FROM  user_role  WHERE user_role_name=JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_role'));

SELECT petrol_station_id INTO the_station_id FROM petrol_station  WHERE petrol_station_name=JSON_UNQUOTE(JSON_EXTRACT(data, '$.petrol_station'));

INSERT INTO  users VALUES(NULL,phone_number,password,'Created',the_station_id,the_role_id,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());

SET the_users_id=LAST_INSERT_ID();

SELECT users_id,users_name,fk_user_role_id_users FROM users where users_id=the_users_id;

INSERT INTO common_bio_data VALUES(NULL,JSON_UNQUOTE(JSON_EXTRACT(data, '$.full_name')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.sex')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.date_of_birth')),the_users_id,CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());


END ##
DELIMITER ;



/*GET THE AVAILABLE SMSs*/

DROP PROCEDURE IF EXISTS getTheNumberOfSMSs;

DELIMITER ##
CREATE PROCEDURE   getTheNumberOfSMSs() 
BEGIN
SELECT number_of_sms  FROM sms_management;


END ##
DELIMITER ;


/*PURCHASE SMSs*/

DROP PROCEDURE IF EXISTS purchaseSMSs;

DELIMITER ##
CREATE PROCEDURE   purchaseSMSs(IN data JSON) 
BEGIN

DECLARE existingSmsBalance,newSmsBalance INT;
SELECT number_of_sms FROM sms_management INTO existingSmsBalance;

SET newSmsBalance=existingSmsBalance+JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_of_SMSs'));

UPDATE sms_management SET number_of_sms=newSmsBalance;

END ##
DELIMITER ;




/*REDUCE SMSs*/

DROP PROCEDURE IF EXISTS reduceSMSs;

DELIMITER ##
CREATE PROCEDURE   reduceSMSs() 
BEGIN

DECLARE existingSmsBalance,newSmsBalance INT;

SELECT number_of_sms FROM sms_management INTO existingSmsBalance;

SET newSmsBalance=existingSmsBalance-1;

UPDATE sms_management SET number_of_sms=newSmsBalance;

END ##
DELIMITER ;


/* GET user_id,password,phone number and role OF THE USER */
DROP PROCEDURE IF EXISTS getNormaUserLogInDetails;
DELIMITER ##
CREATE PROCEDURE   getNormaUserLogInDetails(IN phone_number VARCHAR(45),IN user_role VARCHAR(45)) 
BEGIN
SELECT u.users_id,u.users_name,cbd.name,psc.petrol_station_company_name,ps.petrol_station_name,u.users_password,u.users_active_status,u.fk_petrol_station_id_users,u.fk_user_role_id_users FROM  users u INNER JOIN user_role ul ON u.fk_user_role_id_users=ul.user_role_id INNER JOIN common_bio_data cbd ON u.users_id=cbd.fk_users_id_common_bio_data INNER JOIN petrol_station ps ON ps.petrol_station_id=u.fk_petrol_station_id_users INNER JOIN petrol_station_company psc ON psc.petrol_station_company_id=ps.fk_petrol_station_company_id_petrol_station WHERE u.users_name=phone_number AND ul.user_role_name=user_role;
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS getTheStageNames;
DELIMITER ##
CREATE PROCEDURE   getTheStageNames(IN station INT) 
BEGIN

DECLARE stageExists INT;

SELECT COUNT(sg.stage_id) INTO stageExists FROM stage sg INNER JOIN users u ON sg.fk_user_id_created_by_stage=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id WHERE ps.petrol_station_id=station;

IF stageExists>0 THEN

SELECT sg.stage_id,sg.stage_name FROM stage sg INNER JOIN users u ON sg.fk_user_id_created_by_stage=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id WHERE ps.petrol_station_id=station;


ELSEIF stageExists<=0 THEN
SELECT 0 AS stage_id,'No Stage Created Yet' AS stage_name;
END IF;

END ##
DELIMITER ;






DROP PROCEDURE IF EXISTS updateCustomerDetails;

DELIMITER ##

CREATE PROCEDURE   updateCustomerDetails(IN data JSON) 
BEGIN

DECLARE customerId,thestage_id INT;

SELECT  customers_id INTO customerId FROM customers WHERE customers_number_plate=JSON_UNQUOTE(JSON_EXTRACT(data, '$.old_number_plate'));

SELECT stage_id INTO thestage_id FROM stage WHERE stage_name=JSON_UNQUOTE(JSON_EXTRACT(data, '$.stage_name'));

UPDATE customers SET customers_name=JSON_UNQUOTE(JSON_EXTRACT(data, '$.customer_name')),customers_phone_number=JSON_UNQUOTE(JSON_EXTRACT(data, '$.main_contact_number')),customers_number_plate=JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_plate')),fk_stage_id_customer=thestage_id WHERE customers_id= customerId;



SELECT 'SUCCESS';

END ##
DELIMITER ;











DROP PROCEDURE IF EXISTS saveCustomerDetails;

DELIMITER ##

CREATE PROCEDURE   saveCustomerDetails(IN data JSON) 
BEGIN

DECLARE pin,thestage_id INT;

DECLARE completion_status VARCHAR(10);

SELECT FLOOR(RAND()*(1000-9999+1)+9999) INTO pin;

SELECT JSON_UNQUOTE(JSON_EXTRACT(data, '$.stage_name'));

SELECT stage_id INTO thestage_id FROM stage WHERE stage_name=JSON_UNQUOTE(JSON_EXTRACT(data, '$.stage_name'));

SELECT thestage_id;

INSERT INTO customers VALUES(NULL,JSON_UNQUOTE(JSON_EXTRACT(data, '$.customer_name')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.main_contact_number')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_plate')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),pin,thestage_id,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);

SELECT customers_phone_number,secret_pin FROM customers WHERE customers_id=LAST_INSERT_ID();

END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS saveStageDetails;

DELIMITER ##

CREATE PROCEDURE   saveStageDetails(IN data JSON) 
BEGIN
DECLARE completion_status VARCHAR(10);
INSERT INTO stage VALUES(NULL,JSON_UNQUOTE(JSON_EXTRACT(data, '$.stage_name')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.chairman_name')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.main_contact_number')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);
END ##
DELIMITER ;



/* WHETHER NUMBER PLATE EXISTS */

DROP PROCEDURE IF EXISTS numberPlateAlreadyExists;
DELIMITER ##
CREATE PROCEDURE   numberPlateAlreadyExists(IN theNumberPlate VARCHAR(45)) 
BEGIN

SELECT COUNT(customers_id) AS number_plate_exists FROM customers WHERE customers_number_plate=theNumberPlate;

END ##
DELIMITER ;

/* WHETHER NUMBER PLATE EXISTS */

DROP PROCEDURE IF EXISTS chairmanContactAlreadyExists;
DELIMITER ##
CREATE PROCEDURE   chairmanContactAlreadyExists(IN theNumberContact VARCHAR(45)) 
BEGIN

SELECT COUNT(stage_id) AS number_contact_exists FROM stage WHERE chairmans_number=theNumberContact;

END ##
DELIMITER ;




/* WHETHER NUMBER PLATE EXISTS */

DROP PROCEDURE IF EXISTS getAllNumberPlates;
DELIMITER ##
CREATE PROCEDURE   getAllNumberPlates(IN station VARCHAR(45)) 
BEGIN

DECLARE number_plate_exists INT;


 SELECT COUNT(c.customers_number_plate) INTO number_plate_exists FROM customers c INNER JOIN users u ON u.users_id=c.fk_user_id_created_by_customers INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id WHERE petrol_station_name=station;
  
  IF number_plate_exists>0 THEN

 SELECT c.customers_number_plate FROM customers c INNER JOIN users u ON u.users_id=c.fk_user_id_created_by_customers INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id WHERE petrol_station_name=station;

 ELSEIF number_plate_exists<=0 THEN

 SELECT 'MISSING' AS customers_number_plate;

 END IF;

END ##
DELIMITER ;



/* WHETHER NUMBER PLATE EXISTS */

DROP PROCEDURE IF EXISTS borrowerHasLoanWithCompany;
DELIMITER ##
CREATE PROCEDURE   borrowerHasLoanWithCompany(IN theNumberPlatef VARCHAR(45)) 
BEGIN

SELECT COUNT(l.loans_id) AS has_a_loan FROM loans l INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id WHERE c.customers_number_plate=theNumberPlatef AND l.loan_status=1;

END ##
DELIMITER ;
/* GETTING LOANABLE DETAILS */

DROP PROCEDURE IF EXISTS getLoanableDetails;
DELIMITER ##
CREATE PROCEDURE   getLoanableDetails(IN numberPlate VARCHAR(45)) 
BEGIN

 SELECT c.customers_name,psr.petrol_station_loan_limit,ps.petrol_station_name,c.secret_pin from customers c INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps. petrol_station_id INNER JOIN petrol_station_rates psr ON ps. petrol_station_id=psr.fk_petrol_station_id_petrol_station_rates WHERE c.customers_number_plate=numberPlate;
END ##
DELIMITER ;



/* CREATE A LOAN */

DROP PROCEDURE IF EXISTS createLoanNow;

DELIMITER ##

CREATE PROCEDURE   createLoanNow(IN data JSON) 
BEGIN

DECLARE newLoanCycle, loanCycle,customerId,loan_id,interestRate,computedInterestperDay,interest_id,sId,loanId,customerCreatedById INT;

DECLARE closeBal,newCloseBal DOUBLE;

SELECT COUNT(l.loans_id) INTO loanCycle FROM loans l INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id WHERE c.customers_number_plate=JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_plate'));
-- SELECT loanCycle;

SELECT c.fk_user_id_created_by_customers INTO customerCreatedById FROM customers c  WHERE c.customers_number_plate=JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_plate'));

-- SELECT customerCreatedById;
SET newLoanCycle=loanCycle+1;

SELECT customers_id INTO customerId FROM customers  WHERE customers_number_plate=JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_plate'));
-- SELECT customerId;

INSERT INTO loans VALUES(NULL,newLoanCycle,1,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_borrow')),0,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_borrow')),CURRENT_TIMESTAMP,customerCreatedById,customerId);

SET loan_id=LAST_INSERT_ID();

INSERT INTO lc_manager VALUES(NULL,1,CURRENT_TIMESTAMP,(CURRENT_TIMESTAMP  + INTERVAL 24 HOUR),0,loan_id);


INSERT INTO loan_payments VALUES(NULL,1,0,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_borrow')),CURRENT_TIMESTAMP,loan_id);

CALL  creditGeneralLedger('BORROW',JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_borrow')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),customerCreatedById,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL reduceShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_borrow')));

SELECT psr.petrol_station_interest INTO interestRate FROM petrol_station_rates psr INNER JOIN petrol_station ps ON psr.fk_petrol_station_id_petrol_station_rates=ps.petrol_station_id WHERE ps.petrol_station_id= JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station'));

SET computedInterestperDay=((interestRate*JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_borrow')))/100);

INSERT INTO interest VALUES(NULL,1,computedInterestperDay,0,computedInterestperDay,loan_id);
SET interest_id=LAST_INSERT_ID();
INSERT INTO interest_payments VALUES(NULL,computedInterestperDay,0,computedInterestperDay,CURRENT_TIMESTAMP,interest_id);

SELECT loans_id INTO loanId FROM loans ORDER BY loans_id DESC LIMIT 1;

SELECT (JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_borrow'))+computedInterestperDay) AS amount_due,loanId AS txn_id;
END ##
DELIMITER ;



/* GETTING LOAN PAYMENT DETAILS */

DROP PROCEDURE IF EXISTS getLoanPaymentDetails;
DELIMITER ##
CREATE PROCEDURE   getLoanPaymentDetails(IN numberPlate VARCHAR(45)) 
BEGIN
DECLARE secret INT;
DECLARE loanRemaining, interestRemaining,totalLoan DOUBLE;
DECLARE customer VARCHAR(45);

SELECT l.loan_amount_remaining INTO loanRemaining FROM loans l INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id WHERE c.customers_number_plate=numberPlate AND l.loan_status=1;




IF ISNULL(loanRemaining) THEN 
SET loanRemaining=0;
END IF;

SELECT i.interest_remaining INTO interestRemaining FROM interest i  INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id WHERE c.customers_number_plate=numberPlate AND l.loan_status=1;

IF ISNULL(interestRemaining) THEN
SET interestRemaining=0;
END IF;

SELECT customers_name,secret_pin INTO customer,secret FROM customers WHERE customers_number_plate=numberPlate;

-- SELECT interestRemaining;

SET totalLoan=loanRemaining+interestRemaining;
 
SELECT totalLoan AS loan_amount_due,customer AS customers_name,secret AS secret_pin;

END ##
DELIMITER ;


CALL  getLoanPaymentDetails('UEP 925D');




/* REPAY THE LOAN NOW*/

DROP PROCEDURE IF EXISTS repayLoanOld;
DELIMITER ##
CREATE PROCEDURE   repayLoanOld(IN data JSON) 
BEGIN

DECLARE numberOfDays,newNumberOfDays,loanId,interestId,newLoanId,newInterestId,createdByIdLoanPay,createdByIdInterestPay,interesPayId,lastLoanId,customerId INT;

DECLARE loanRemaining, interestRemaining,newLoanRemaining,newInterestRemaining,loanDue,loanPaid,interestPaid,newInterst,newLoan DOUBLE;


SELECT lp.loan_amount_remaining,lp.no_days_paid,l.loans_id,c.fk_user_id_created_by_customers,c.customers_id INTO loanRemaining,numberOfDays,loanId,createdByIdLoanPay,customerId FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id WHERE c.customers_number_plate=JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_plate')) ORDER BY lp.loan_payments_id  DESC LIMIT 1;

SELECT ip.interest_amount_remaining,i.interest_id,c.fk_user_id_created_by_customers  INTO interestRemaining,interestId,createdByIdInterestPay FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id WHERE c.customers_number_plate=JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_plate'))ORDER BY ip.interest_payments_id DESC LIMIT 1;

SET loanDue=loanRemaining+interestRemaining;

IF interestRemaining<=0 THEN

IF JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))<loanRemaining THEN

SET newLoanRemaining=loanRemaining-JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));
SET newNumberOfDays=numberOfDays+1;

INSERT INTO loan_payments VALUES(NULL,1,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),newLoanRemaining,CURRENT_TIMESTAMP(), newNumberOfDays,loanId);

SET lastLoanId=LAST_INSERT_ID()-1;

UPDATE loan_payments SET  loan_payments_status=2 WHERE loan_payments_id=lastLoanId;

CALL  debitGeneralLedger('LOANREPAY',JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdLoanPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')));

ELSE

SET newNumberOfDays=numberOfDays+1;

INSERT INTO loan_payments VALUES(NULL,2,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),0,CURRENT_TIMESTAMP(), newNumberOfDays,loanId);

SET lastLoanId=LAST_INSERT_ID()-1;

UPDATE loan_payments SET  loan_payments_status=2 WHERE loan_payments_id=lastLoanId;

CALL  debitGeneralLedger('LOANREPAY',JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')));

 UPDATE loans SET loan_status=2 WHERE loans_id=loanId;

END IF;



 ELSEIF  JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))<interestRemaining THEN 

SET newInterestRemaining =interestRemaining-JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));
SET newNumberOfDays=numberOfDays+1;

INSERT INTO interest_payments VALUES(NULL,0,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),newInterestRemaining,CURRENT_TIMESTAMP(), newNumberOfDays,interestId);

SET interesPayId=LAST_INSERT_ID();

CALL commissionEarned(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),interestId);

CALL  debitGeneralLedger('INTERESTPAY',JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')));

 ELSEIF 

 loanDue=JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')) THEN


SET newLoanRemaining=JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))-interestRemaining;

SET newNumberOfDays=numberOfDays+1;

INSERT INTO interest_payments VALUES(NULL,0,interestRemaining,0,CURRENT_TIMESTAMP(), newNumberOfDays,interestId);

SET interesPayId=LAST_INSERT_ID();

CALL commissionEarned(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),interestRemaining,interestId);

CALL  debitGeneralLedger('INTERESTPAY',interestRemaining,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),interestRemaining);


INSERT INTO loan_payments VALUES(NULL,1,newLoanRemaining,0,CURRENT_TIMESTAMP(), newNumberOfDays,loanId);

SET lastLoanId=LAST_INSERT_ID()-1;

UPDATE loan_payments SET  loan_payments_status=2 WHERE loan_payments_id=lastLoanId;

CALL  debitGeneralLedger('LOANREPAY',newLoanRemaining,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),newLoanRemaining);

UPDATE interest SET interest_accrual_status=2 WHERE  fk_loans_id_interest=loanId;

UPDATE loans SET loan_status=2 WHERE loans_id=loanId;

UPDATE lc_manager SET lc_manager_status=2 WHERE fk_loans_id_lc_manager=loanId;


ELSE


SET newLoanRemaining=loanDue-JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));
SET loanPaid=JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))-interestRemaining;

SET newNumberOfDays=numberOfDays+1;

INSERT INTO interest_payments VALUES(NULL,0,interestRemaining,0,CURRENT_TIMESTAMP(), newNumberOfDays,interestId);

SET interesPayId=LAST_INSERT_ID();

CALL commissionEarned(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),interestRemaining,interestId);

CALL  debitGeneralLedger('INTERESTPAY',interestRemaining,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),interestRemaining);


INSERT INTO loan_payments VALUES(NULL,1,loanPaid,newLoanRemaining,CURRENT_TIMESTAMP(), newNumberOfDays,loanId);

SET lastLoanId=LAST_INSERT_ID()-1;

UPDATE loan_payments SET  loan_payments_status=2 WHERE loan_payments_id=lastLoanId;

CALL  debitGeneralLedger('LOANREPAY',loanPaid,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdLoanPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),loanPaid);

 END IF;

SELECT loan_amount_remaining,loan_payments_id INTO newLoan,newLoanId FROM loan_payments WHERE fk_loans_id_loan_payment=loanId ORDER BY loan_payments_id DESC LIMIT 1;

SELECT interest_amount_remaining,interest_payments_id INTO newInterst,newInterestId FROM interest_payments WHERE fk_interest_id_interest_payment=interestId ORDER BY interest_payments_id DESC LIMIT 1;


SELECT (newLoan+newInterst) AS amount_due,ROUND(((newLoanId+newInterestId)/2)) AS txn_id;
 
END ##
DELIMITER ;



/* GET SHIFT DETAILS */

DROP PROCEDURE IF EXISTS shiftDetailsPumpUser;

DELIMITER ##

CREATE PROCEDURE   shiftDetailsPumpUser(IN station INT) 
BEGIN

SELECT s.shift_id,s.shift_opening_bal,s.shift_closing_bal,s.shift_status,DATE_FORMAT(DATE(s.shift_start_date),"%d/%m/%Y") AS shift_date,TIME(s.shift_start_date) AS open_time,TIME(s.shift_end_date) AS close_time,UserName(s.fk_user_id_created_by_shift) AS opened_by,UserName(s.fk_user_id_closed_by_shift) AS closed_by FROM shift s  WHERE s.fk_petrol_station_id_shift=station ORDER BY s.shift_id DESC LIMIT 1;
close_time
END ##
DELIMITER ;



/* USER NAME FUNCTION USING USER ID */
DROP FUNCTION IF EXISTS UserName;
DELIMITER ##
CREATE FUNCTION UserName(user_id INT) 
RETURNS VARCHAR(60)
DETERMINISTIC
BEGIN
DECLARE userName VARCHAR(60);
SELECT name INTO userName FROM common_bio_data WHERE fk_users_id_common_bio_data=user_id;
RETURN userName;
END ##
DELIMITER ;


/* POST DEPOSIT TRANSACTIONS */
DROP PROCEDURE IF EXISTS postWithdrawTxn;

DELIMITER ##

CREATE PROCEDURE   postWithdrawTxn(IN txnType VARCHAR(45),IN amount DOUBLE,IN station INT,IN userId INT) 
BEGIN

DECLARE shiftExist,shiftId INT;

DECLARE closingBal ,newClosingBal DOUBLE;

SELECT COUNT(s.shift_id) INTO shiftExist FROM shift s WHERE  s.fk_petrol_station_id_shift=station;


IF shiftExist>0 THEN 

SELECT shift_id,shift_closing_bal INTO shiftId, closingBal FROM shift s WHERE  s.fk_petrol_station_id_shift=station ORDER BY s.shift_id DESC LIMIT 1;

SET newClosingBal=closingBal-amount;

UPDATE shift SET shift_closing_bal=newClosingBal WHERE shift_id=shiftId;

END IF;
      
IF  shiftExist<=0 THEN 

INSERT INTO shift VALUES(NULL,0.0,amount,'OPENED',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP(),station,userId,userId);

END IF;

CALL creditGeneralLedger('WITHDRAWAL',amount,userId,userId,station,100);

END ##
DELIMITER ;




/* POST DEPOSIT TRANSACTIONS */
DROP PROCEDURE IF EXISTS postDepositTxn ;

DELIMITER ##

CREATE PROCEDURE   postDepositTxn(IN txnType VARCHAR(45),IN amount DOUBLE,IN station INT,IN userId INT) 
BEGIN


DECLARE shiftExist,shiftId INT;

DECLARE closingBal,newClosingBal DOUBLE;

SELECT COUNT(s.shift_id) INTO shiftExist FROM shift s  WHERE  s. fk_petrol_station_id_shift=station;


IF shiftExist>0 THEN 

SELECT shift_id,shift_closing_bal INTO shiftId, closingBal FROM shift s  WHERE  s.fk_petrol_station_id_shift=station ORDER BY s.shift_id DESC LIMIT 1;

SET newClosingBal=closingBal+amount;

UPDATE shift SET shift_closing_bal=newClosingBal WHERE shift_id=shiftId;

END IF;
      
IF  shiftExist<=0 THEN 

INSERT INTO shift VALUES(NULL,0.0,amount,'OPENED',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP(),station,userId,userId);

END IF;

CALL debitGeneralLedger('DEPOSIT',amount,userId,userId,station,100);

END ##
DELIMITER ;





/* DEBIT GENERAL LEDGER */

DROP PROCEDURE IF EXISTS debitGeneralLedger;
DELIMITER ##
CREATE PROCEDURE   debitGeneralLedger(IN txnType VARCHAR(45),IN amount DOUBLE,IN userId_by INT,IN userId_to INT,IN user_station INT,IN customer_id INT) 
BEGIN


DECLARE CustmerNumberPlate,CustomerName VARCHAR(60);

 
 IF txnType='BORROW' OR txnType='INTERESTPAY' OR txnType='LOANREPAY' THEN 

 SELECT customers_number_plate,customers_name INTO CustmerNumberPlate,CustomerName FROM customers WHERE customers_id=customer_id;

ELSE 

SET CustmerNumberPlate='NOT APPLICABLE';

SET CustomerName='NOT APPLICABLE';

END IF;




INSERT INTO trn_general_ledger VALUES(NULL,CURRENT_TIMESTAMP,txnType,amount,0,user_station,userId_by,userId_to,CurrentShift(user_station));
SET @InsertedId=LAST_INSERT_ID();
INSERT INTO trn_customer_details VALUES(NULL,CustmerNumberPlate,CustomerName,@InsertedId);

CALL increaseBalance(amount,user_station);

END ##
DELIMITER ;


/* CREDIT GENERAL LEDGER */

DROP PROCEDURE IF EXISTS creditGeneralLedger;
DELIMITER ##
CREATE PROCEDURE   creditGeneralLedger(IN txnType VARCHAR(45),IN amount DOUBLE,IN userId_by INT,IN userId_to INT,IN user_station INT,IN customer_id INT) 
BEGIN

DECLARE CustmerNumberPlate,CustomerName VARCHAR(60);

 
 IF txnType='BORROW' OR txnType='INTERESTPAY' OR txnType='LOANREPAY' THEN 

 SELECT customers_number_plate,customers_name INTO CustmerNumberPlate,CustomerName FROM customers WHERE customers_id=customer_id;

ELSE 

SET CustmerNumberPlate='NOT APPLICABLE';

SET CustomerName='NOT APPLICABLE';

END IF;


INSERT INTO trn_general_ledger VALUES(NULL,CURRENT_TIMESTAMP,txnType,0,amount,user_station,userId_by,userId_to,CurrentShift(user_station));
SET @IsertedId=LAST_INSERT_ID();

INSERT INTO trn_customer_details VALUES(NULL,CustmerNumberPlate,CustomerName,@IsertedId);


CALL reduceBalance(amount,user_station);
END ##
DELIMITER ;

/*INCREASE BALANCE */

DROP PROCEDURE IF EXISTS increaseBalance;
DELIMITER ##
CREATE PROCEDURE   increaseBalance(IN amount DOUBLE,IN user_station INT) 
BEGIN

DECLARE oldBalance,newBalance DOUBLE;

DECLARE balanceId,balExists INT;
 
SELECT COUNT(balance_per_day_id) INTO balExists FROM balance_per_day WHERE  fk_petrol_station_id_balance_per_day=user_station ORDER BY balance_per_day_id DESC LIMIT 1;

IF balExists>0 THEN

 SELECT balance_per_day_id,the_balance INTO balanceId,oldBalance FROM balance_per_day WHERE  fk_petrol_station_id_balance_per_day=user_station ORDER BY balance_per_day_id DESC LIMIT 1;

SET newBalance=oldBalance+amount;

UPDATE balance_per_day SET the_balance=newBalance WHERE balance_per_day_id=balanceId;

ELSEIF balExists<=0 THEN




INSERT INTO balance_per_day VALUES(NULL,amount,user_station,CURRENT_TIMESTAMP);

END IF;

END ##
DELIMITER ;



/*REDUCE BALANCE */

DROP PROCEDURE IF EXISTS reduceBalance;
DELIMITER ##
CREATE PROCEDURE   reduceBalance(IN amount DOUBLE,IN user_station INT) 
BEGIN

DECLARE oldBalance,newBalance DOUBLE;

DECLARE balanceId,balExists INT;
 
SELECT COUNT(balance_per_day_id) INTO balExists FROM balance_per_day WHERE fk_petrol_station_id_balance_per_day=user_station ORDER BY balance_per_day_id DESC LIMIT 1;

IF balExists>0 THEN

 SELECT balance_per_day_id,the_balance INTO balanceId,oldBalance FROM balance_per_day WHERE fk_petrol_station_id_balance_per_day=user_station ORDER BY balance_per_day_id DESC LIMIT 1;

SET newBalance=oldBalance-amount;

UPDATE balance_per_day SET the_balance=newBalance WHERE balance_per_day_id=balanceId;

ELSEIF balExists<=0 THEN

INSERT INTO balance_per_day VALUE(NULL,amount,user_station,CURRENT_TIMESTAMP);

END IF;

END ##
DELIMITER ;





DROP PROCEDURE IF EXISTS isStationBalanceEnoughOrExists;
DELIMITER ##
CREATE PROCEDURE   isStationBalanceEnoughOrExists(IN station VARCHAR(45)) 
BEGIN

DECLARE balExistsCount INT;
DECLARE bal DOUBLE;

SELECT COUNT(s.shift_id) INTO balExistsCount FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_name=station ORDER BY s.shift_id DESC LIMIT 1;

SELECT s.shift_closing_bal INTO bal FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_name=station ORDER BY s.shift_id DESC LIMIT 1;


IF balExistsCount>0 THEN

 IF bal>0 THEN
  
  SELECT 1 AS Balexists;

 ELSEIF bal<=0 THEN 
   
  SELECT 0 AS Balexists;

 END IF;

 ELSEIF balExistsCount<=0 THEN
  SELECT 0 AS Balexists;
 END IF;

END ##
DELIMITER ;




DROP PROCEDURE IF EXISTS closeOpenShift;
DELIMITER ##
CREATE PROCEDURE   closeOpenShift(IN data JSON) 
BEGIN

DECLARE theShift INT;

DECLARE completion_status VARCHAR(10);

SELECT s.shift_id INTO theShift FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_id= JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_station')) ORDER BY s.shift_id DESC LIMIT 1;


UPDATE shift SET shift_status='CLOSED',shift_end_date=CURRENT_TIMESTAMP,fk_user_id_closed_by_shift=JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_id')) WHERE shift_id=theShift;

SELECT shift_status INTO  completion_status FROM shift WHERE shift_id=theShift;

IF completion_status='CLOSED' THEN
SELECT 1 AS completed;
ELSEIF  completion_status='CLOSED' THEN
SELECT 0 AS completed;
END IF;

END ##
DELIMITER ;





DROP PROCEDURE IF EXISTS openClosedShift;
DELIMITER ##
CREATE PROCEDURE   openClosedShift(IN data JSON) 
BEGIN

DECLARE theShift INT;

DECLARE closeBal DOUBLE;

DECLARE completion_status VARCHAR(10);

SELECT shift_closing_bal INTO closeBal FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_id= JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_station')) ORDER BY s.shift_id DESC LIMIT 1;



INSERT INTO shift VALUES(NULL,closeBal,closeBal,'OPENED',CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP(),JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_id')),JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_id')));

SET theShift=LAST_INSERT_ID();

SELECT shift_status INTO  completion_status FROM shift WHERE shift_id=theShift;

IF completion_status='OPENED' THEN
SELECT 1 AS completed;
ELSEIF  completion_status='OPENED' THEN
SELECT 0 AS completed;
END IF;

END ##
DELIMITER ;

DROP PROCEDURE IF EXISTS postTheTxnNow;
DELIMITER ##
CREATE PROCEDURE   postTheTxnNow(IN data JSON) 
BEGIN

DECLARE edadBoxId INT;

IF  JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_type')) = 'DEPOSIT' THEN

CALL postDepositTxn(JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.txn_type')),
    JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.txn_amount')),
      JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_station')),
   JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_id'))
    ) ;




ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.txn_type')) = 'WITHDRAWAL' THEN

CALL postWithdrawTxn(JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.txn_type')),
    JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.txn_amount')),
      JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_station')),
   JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_id'))
    ) ;


END IF;


END ##

DELIMITER ;


DROP PROCEDURE IF EXISTS closeOpenShift;
DELIMITER ##
CREATE PROCEDURE   closeOpenShift(IN data JSON) 
BEGIN

DECLARE theShift INT;

DECLARE completion_status VARCHAR(10);

SELECT s.shift_id INTO theShift FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_id= JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_station')) ORDER BY s.shift_id DESC LIMIT 1;


UPDATE shift SET shift_status='CLOSED',shift_end_date=CURRENT_TIMESTAMP,fk_user_id_closed_by_shift=JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_id')) WHERE shift_id=theShift;

SELECT shift_status INTO  completion_status FROM shift WHERE shift_id=theShift;

IF completion_status='CLOSED' THEN
SELECT 1 AS completed;
ELSEIF  completion_status='CLOSED' THEN
SELECT 0 AS completed;
END IF;

END ##
DELIMITER ;



/* INCREASING SHIFT CLOSING BALANCE */

DROP PROCEDURE IF EXISTS increaseShiftClosingBalance;
DELIMITER ##
CREATE PROCEDURE   increaseShiftClosingBalance(IN stationId INT,IN amountInvolved DOUBLE) 
BEGIN
DECLARE sId INT;
DECLARE newCloseBal, closeBal DOUBLE;

SELECT  shift_id, shift_closing_bal INTO sId, closeBal FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_id=stationId ORDER BY s.shift_id DESC LIMIT 1;

 SET newCloseBal=closeBal+amountInvolved;

UPDATE shift SET shift_closing_bal=newCloseBal WHERE shift_id=sId;

END ##
DELIMITER ;



/* REDUCING SHIFT CLOSING BALANCE */

DROP PROCEDURE IF EXISTS reduceShiftClosingBalance;
DELIMITER ##
CREATE PROCEDURE   reduceShiftClosingBalance(IN stationId INT,IN amountInvolved DOUBLE) 
BEGIN
DECLARE sId INT;
DECLARE newCloseBal, closeBal DOUBLE;

SELECT  shift_id, shift_closing_bal INTO sId, closeBal FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_id=stationId ORDER BY s.shift_id DESC LIMIT 1;

 SET newCloseBal=closeBal-amountInvolved;

UPDATE shift SET shift_closing_bal=newCloseBal WHERE shift_id=sId;

END ##
DELIMITER ;







/* GET SHIFT DETAILS */

DROP PROCEDURE IF EXISTS getRunningBalance;

DELIMITER ##

CREATE PROCEDURE   getRunningBalance(IN station VARCHAR(45)) 
BEGIN

SELECT s.shift_closing_bal AS balance FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id INNER JOIN common_bio_data cbd ON u.users_id=cbd.fk_users_id_common_bio_data  WHERE ps.petrol_station_name=station ORDER BY s.shift_id DESC LIMIT 1;

END ##
DELIMITER ;



/* GET SHIFT DETAILS */

DROP PROCEDURE IF EXISTS getAllLoansDetailsNow;

DELIMITER ##

CREATE PROCEDURE   getAllLoansDetailsNow() 
BEGIN

 select c.customers_id, c.customers_name,c.customers_phone_number,c.customers_number_plate,s.stage_name,l.loan_amount_taken,CONCAT(DATE_FORMAT(DATE(l.loan_date_taken),"%d/%m/%Y"),"  ",TIME(l.loan_date_taken)) AS loan_date_taken FROM customers c INNER JOIN loans l ON l. fk_customers_id_loans=c.customers_id INNER JOIN stage s ON c.fk_stage_id_customer=s.stage_id ;

END ##
DELIMITER ;



/* CREATE EVENTS*/


CREATE EVENT manage_interest ON SCHEDULE EVERY 120 MINUTE STARTS CURRENT_TIMESTAMP  DO CALL manage_interest(CURRENT_TIMESTAMP());

CREATE EVENT change_daily_balances ON SCHEDULE EVERY 24 HOUR STARTS TIMESTAMP(CURRENT_DATE)  DO CALL changeBalance(CURRENT_TIMESTAMP());




/* GET SHIFT DETAILS */

DROP PROCEDURE IF EXISTS changeBalance;

DELIMITER ##

CREATE PROCEDURE   changeBalance(IN timeLStampIN TIMESTAMP) 

BEGIN



DECLARE newBalance DOUBLE;

DECLARE balanceId,balExists,stationId,l_done INT;

DECLARE forStations CURSOR FOR SELECT petrol_station_id  FROM petrol_station;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
 

 OPEN forStations;

accounts_loop: LOOP 

 FETCH  forStations INTO stationId;
 
 
 IF l_done=1 THEN

LEAVE accounts_loop;

 END IF;
 
 
SELECT COUNT(balance_per_day_id) INTO balExists FROM balance_per_day WHERE fk_petrol_station_id_balance_per_day=stationId  ORDER BY balance_per_day_id DESC LIMIT 1;

IF balExists>0 THEN

 SELECT the_balance INTO newBalance FROM balance_per_day WHERE fk_petrol_station_id_balance_per_day=stationId ORDER BY balance_per_day_id DESC LIMIT 1;

INSERT INTO balance_per_day VALUES(NULL,newBalance,stationId,CURRENT_TIMESTAMP);

ELSEIF balExists<=0 THEN

INSERT INTO balance_per_day VALUES(NULL,0,stationId,CURRENT_TIMESTAMP);

END IF;

SET l_done=0;

 END LOOP accounts_loop;

 CLOSE forStations;
 
END ##
DELIMITER ;




/* GET SHIFT DETAILS */
DROP PROCEDURE IF EXISTS manage_interestOld;

DELIMITER ##

CREATE PROCEDURE   manage_interestOld(IN timeStatmp TIMESTAMP) 
BEGIN



  DECLARE lcId,noPAccruals, maxNoPAccruals,interestRateAccrual,interestId,n,newnoPAccruals INT;

    DECLARE newexpirelyTime ,expirelyTime TIMESTAMP;

   DECLARE loanAmountR,interestCPMPU,existInterestAmountRemain,NewExistInterestAmountRemain,existingInterest,NewExistingInterest DOUBLE;


  DECLARE l_done INTEGER DEFAULT 0;
  
 DECLARE selectTrnIds CURSOR FOR SELECT lc.lc_manager_id  FROM lc_manager lc INNER JOIN loans l ON lc.fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_status=1 AND l.loan_status=1;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;

 OPEN selectTrnIds;


LedgerIds_loop: LOOP 

 FETCH selectTrnIds into lcId;

 IF l_done=1 THEN

LEAVE LedgerIds_loop;

 END IF;
SELECT timeStatmp;
 
SELECT lc.lc_manager_expirely_time, psl.ps_l_accrual_p_number,lc.lc_manager_no_accruals,psr.petrol_station_interest,i.interest_amount,i.interest_id INTO expirelyTime,maxNoPAccruals,noPAccruals,interestRateAccrual,existingInterest,interestId FROM lc_manager lc INNER JOIN loans l ON lc.fk_loans_id_lc_manager=l.loans_id INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id INNER JOIN petrol_station_rates psr ON psr.fk_petrol_station_id_petrol_station_rates=ps.petrol_station_id INNER JOIN ps_l_accrual_p psl ON psl.fk_petrol_station_id_ps_l_accrual_p=ps.petrol_station_id  INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id  WHERE lc.lc_manager_id=lcId;


SELECT lp.loan_amount_remaining INTO loanAmountR FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN lc_manager lc ON lc. fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_id=lcId ORDER BY lp.loan_payments_id DESC LIMIT 1;

SELECT ip.interest_amount_remaining,ip.no_days_paid INTO existInterestAmountRemain,n FROM interest_payments ip INNER JOIN interest i ON ip. fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id INNER JOIN lc_manager lc ON lc.fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_id=lcId ORDER BY ip.interest_payments_id DESC LIMIT 1;


IF expirelyTime<=timeStatmp THEN

SET interestCPMPU=ROUND(((loanAmountR*interestRateAccrual)/100));
SELECT interestCPMPU;
SET NewExistInterestAmountRemain=existInterestAmountRemain+interestCPMPU;

SET NewExistingInterest=existingInterest+interestCPMPU;
SELECT NewExistingInterest;

SET newnoPAccruals=noPAccruals+1;
SELECT newnoPAccruals;
SET newexpirelyTime=expirelyTime + INTERVAL 24 HOUR;
SELECT newexpirelyTime;
UPDATE interest SET interest_amount=NewExistingInterest WHERE interest_id=interestId;


INSERT INTO interest_payments VALUES(NULL,interestCPMPU,0,NewExistInterestAmountRemain,CURRENT_TIMESTAMP,n,interestId);


UPDATE lc_manager SET lc_manager_expirely_time=newexpirelyTime,lc_manager_no_accruals=newnoPAccruals WHERE lc_manager_id=lcId;

IF newnoPAccruals>=maxNoPAccruals THEN

UPDATE lc_manager SET lc_manager_status=2 WHERE lc_manager_id=lcId;

END IF;


END IF;


SET l_done=0;

 END LOOP LedgerIds_loop;



CLOSE selectTrnIds;

END ##
DELIMITER ;




DROP PROCEDURE IF EXISTS getTheRunningLoansService;

DELIMITER ##

CREATE PROCEDURE getTheRunningLoansService(IN station INT) READS SQL DATA BEGIN

 DECLARE loanIds,ID,AGINGDAYS,l_done INT;
 DECLARE dateTakenL TIMESTAMP;

DECLARE NAME,PHONE,NUMBERPLATE,STAGE VARCHAR(60);
DECLARE LOANTAKEN,LOANINTERESTEXPECTED,LOANINTERESTPAID,LOANINTERESTREMAINING,loanPaid,interestPaid,loanRemain,interestRemain DOUBLE;

-- SELECT station;

DECLARE forSelectingLoanIdS CURSOR FOR SELECT l.loans_id  FROM loans l INNER JOIN users u ON l.fk_user_id_loans=u.users_id INNER JOIN petrol_station ps ON u. fk_petrol_station_id_users=ps.petrol_station_id WHERE l.loan_status=1 AND ps.petrol_station_id=station;
 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
 
DROP TABLE IF EXISTS temp_loans;

CREATE TEMPORARY  TABLE temp_loans(id INT,name VARCHAR(60),date_taken VARCHAR(60),time_taken VARCHAR(60),loan_taken DOUBLE,loan_interest_expected DOUBLE,loan_interest_paid DOUBLE,loan_interest_remaining DOUBLE,aging_days INT,phone VARCHAR(60),number_plate VARCHAR(60),stage VARCHAR(60));

 SET ID=0;

 OPEN forSelectingLoanIdS;



accounts_loop: LOOP 

 FETCH forSelectingLoanIdS into loanIds;
 
 
 IF l_done=1 THEN

LEAVE accounts_loop;

 END IF;
 SET ID=ID+1;
 
/* SELECT ID; */
    SELECT c.customers_name,l.loan_amount_taken, (l.loan_amount_taken+i.interest_amount),c.customers_phone_number,c.customers_number_plate,s.stage_name,l.loan_date_taken INTO NAME,LOANTAKEN,LOANINTERESTEXPECTED,PHONE,NUMBERPLATE,STAGE,dateTakenL  FROM customers c INNER JOIN loans l ON l.fk_customers_id_loans=c.customers_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN stage s ON c.fk_stage_id_customer=s.stage_id  WHERE l.loans_id=loanIds;

    SELECT SUM(ip.interest_amount_paid) INTO interestPaid  FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id WHERE l.loans_id=loanIds;

    SELECT SUM(lp.loan_amount_paid) INTO loanPaid FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id WHERE l.loans_id=loanIds;

    SET LOANINTERESTPAID=interestPaid+loanPaid;

    SELECT lp.loan_amount_remaining INTO loanRemain FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id WHERE l.loans_id=loanIds ORDER BY lp.loan_payments_id DESC LIMIT 1; 

    SELECT ip.interest_amount_remaining INTO interestRemain FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i. fk_loans_id_interest=l.loans_id WHERE l.loans_id=loanIds ORDER BY ip.interest_payments_id DESC LIMIT 1;

     SET LOANINTERESTREMAINING=loanRemain+interestRemain;

SET AGINGDAYS=DATEDIFF(CURRENT_TIMESTAMP,dateTakenL);

 
 /* SELECT ID; */

 INSERT INTO temp_loans VALUES(ID,NAME,DATE_FORMAT(DATE(dateTakenL),"%d/%m/%Y"),TIME(dateTakenL),LOANTAKEN,LOANINTERESTEXPECTED,LOANINTERESTPAID,LOANINTERESTREMAINING,AGINGDAYS,PHONE,NUMBERPLATE,STAGE);


SET l_done=0;

 END LOOP accounts_loop;

 CLOSE forSelectingLoanIdS;
 

SELECT SUM(loan_taken), SUM(loan_interest_expected),SUM(loan_interest_paid),
SUM(loan_interest_remaining) INTO @LT,@LIE,@LIP,@LIR FROM temp_loans;

/* SELECT @LT,@LIE,@LIP,@LIR ; */
 INSERT INTO temp_loans VALUES(NULL,"TOTAL",NULL,NULL,@LT,@LIE,@LIP,@LIR,NULL,NULL,NULL,NULL);


SELECT * FROM temp_loans ORDER BY stage ASC ;

/* DROP TABLE temp_loans; */


END ##

DELIMITER ;



DROP PROCEDURE IF EXISTS getRunningBalanceAll;

DELIMITER ##

CREATE PROCEDURE   getRunningBalanceAll() 
BEGIN

DECLARE psIds,psExists INT;

DECLARE totalCBal,actualTotla DOUBLE DEFAULT 0.0;

  DECLARE l_done INTEGER DEFAULT 0;

 DECLARE selectTrnIds CURSOR FOR SELECT petrol_station_id  FROM petrol_station;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;

 OPEN selectTrnIds;


LedgerIds_loop: LOOP 

 FETCH selectTrnIds into psIds;

 IF l_done=1 THEN

LEAVE LedgerIds_loop;

 END IF;
 
SELECT COUNT(s.shift_closing_bal) INTO psExists FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_id=psIds;


IF psExists>0 THEN 

SELECT s.shift_closing_bal INTO totalCBal FROM shift s INNER JOIN users u ON s.fk_user_id_created_by_shift=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE ps.petrol_station_id=psIds ORDER BY s.shift_id DESC LIMIT 1;

SET actualTotla=actualTotla+totalCBal;


END IF;




SET l_done=0;

 END LOOP LedgerIds_loop;
CLOSE selectTrnIds;

SELECT actualTotla AS balance; 

END ##
DELIMITER ;

/**

 SELECT * FROM  commission     ;        
 SELECT * FROM   common_bio_data;         
 SELECT * FROM  customers ;              
  SELECT * FROM  interest;                
 SELECT * FROM  interest_payments  ;     
 SELECT * FROM  lc_manager  ;            
  SELECT * FROM  loan_payments ;          
  SELECT * FROM  loans  ;                 
SELECT * FROM   petrol_station  ;        
 SELECT * FROM  petrol_station_company ; 
  SELECT * FROM  petrol_station_rates ;   
  SELECT * FROM  ps_l_accrual_p ;         
  SELECT * FROM  shift ;                  
  SELECT * FROM  sms_management     ;     
 SELECT * FROM  stage ;                  
  SELECT * FROM  the_company_datails ;    
  SELECT * FROM  trn_general_ledger;      
 SELECT * FROM   user_role  ;             
 SELECT * FROM   users; 
  SELECT * FROM   balance_per_day; 


*/

--  #
-- Name
-- Amount Taken
-- Loan+Interest Expected
-- Loan+Interest Paid
-- Loan+Interest Remaining
-- Days Unpaid
-- Phone 
-- Number Plate
-- Stage 


	
DROP PROCEDURE IF EXISTS getTheRevenueFromLoans;

DELIMITER ##

CREATE PROCEDURE getTheRevenueFromLoans(IN data JSON) READS SQL DATA BEGIN

DROP TABLE IF EXISTS revenueCommision;

CREATE TEMPORARY TABLE revenueCommision(
  id INT NOT NULL AUTO_INCREMENT ,
  name VARCHAR(200),
  number_plate VARCHAR(20),
  amount_taken   VARCHAR(100),
  interest_paid DOUBLE,
  commision_amount DOUBLE,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;


DROP TABLE IF EXISTS revenueCommision1;

CREATE TEMPORARY TABLE revenueCommision1(
  id INT NOT NULL AUTO_INCREMENT ,
  name VARCHAR(200),
  number_plate VARCHAR(20),
  amount_taken   VARCHAR(100),
  interest_paid DOUBLE,
  commision_amount DOUBLE,
  PRIMARY KEY(id)
) ENGINE=innoDB
AUTO_INCREMENT=1
DEFAULT CHARACTER SET=utf8;



INSERT INTO revenueCommision(
  id  ,
  name ,
  number_plate,
  amount_taken   ,
  interest_paid ,
  commision_amount 

)

SELECT NULL, c.customers_name,c.customers_number_plate,l.loan_amount_taken,i. interest_paid,cm.commission_amount from interest i INNER JOIN commission cm ON cm.fk_interest_id_commision=i.interest_id  INNER JOIN 
loans l ON i.fk_loans_id_interest=l.loans_id INNER JOIN customers c ON l. fk_customers_id_loans=c.customers_id INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id  WHERE i.interest_paid>0 AND ps.petrol_station_id =JSON_UNQUOTE(
    JSON_EXTRACT(data, '$.user_station'));


    INSERT INTO revenueCommision1(
  id  ,
  name ,
  number_plate,
  amount_taken   ,
  interest_paid ,
  commision_amount 

) SELECT 0,'TOTAL',NULL,SUM(amount_taken),SUM(interest_paid),SUM(commision_amount) FROM revenueCommision;

 INSERT INTO revenueCommision1(
  id  ,
  name ,
  number_plate,
  amount_taken   ,
  interest_paid ,
  commision_amount 

) SELECT id+1,name,number_plate,amount_taken,interest_paid,commision_amount FROM revenueCommision;


    INSERT INTO revenueCommision1(
  id  ,
  name ,
  number_plate,
  amount_taken   ,
  interest_paid ,
  commision_amount 

) SELECT COUNT(id)+2,'TOTAL',NULL,SUM(amount_taken),SUM(interest_paid),SUM(commision_amount) FROM revenueCommision;

SELECT * FROM revenueCommision1;


END ##

DELIMITER ;





	
DROP PROCEDURE IF EXISTS getTheLoans;

DELIMITER ##

CREATE PROCEDURE getTheLoans(IN data JSON) READS SQL DATA BEGIN

  
  IF JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='RUNNING LOANS' THEN
   
   CALL getTheRunningLoansService(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')));

  ELSEIF  JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='OVERDUE LOANS' THEN
     
       CALL getTheOverDueLoansService();

  ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='COMPLETED LOANS' THEN 
   
    CALL getTheCompletedLoansService();

  END IF;

END ##

DELIMITER ;

    
DROP PROCEDURE IF EXISTS allClients;

DELIMITER ##

CREATE PROCEDURE allClients(IN station INT) READS SQL DATA BEGIN

 DECLARE l_done,CId,Id INT;



DECLARE forSelectingAllClients CURSOR FOR SELECT c.customers_id  FROM customers c  INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON u. fk_petrol_station_id_users=ps.petrol_station_id WHERE  ps.petrol_station_id=station;
 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
 
DROP TABLE IF EXISTS temp_clients;

CREATE TEMPORARY  TABLE temp_clients(customers_id INT,customers_name VARCHAR(60),customers_phone_number VARCHAR(60),customers_number_plate VARCHAR(60),stage_name VARCHAR(60),chair_name VARCHAR(60),chair_number VARCHAR(60),l_limit DOUBLE);

SET Id=0;

OPEN forSelectingAllClients;



accounts_loop: LOOP 

 FETCH forSelectingAllClients into CId;
 
 
 IF l_done=1 THEN

LEAVE accounts_loop;

 END IF;

SET Id=Id+1;

SELECT c.customers_name,c.customers_phone_number,c.customers_number_plate,sg.stage_name,sg.chairmans_name,sg.chairmans_number,psr.petrol_station_loan_limit INTO @Cname,@Cnumber,@CnPlate,@CStage,@CSChair,@CSChairNum,@CLimit FROM customers c INNER JOIN stage sg ON c. fk_stage_id_customer=sg.stage_id  INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON 
u.fk_petrol_station_id_users INNER JOIN petrol_station_rates psr ON psr.fk_petrol_station_id_petrol_station_rates=ps.petrol_station_id WHERE c.customers_id=CId AND ps.petrol_station_id=station;

INSERT INTO temp_clients VALUES (Id,@Cname,@Cnumber,@CnPlate,@CStage,@CSChair,@CSChairNum,@CLimit);

 
SET l_done=0;

 END LOOP accounts_loop;

 CLOSE forSelectingAllClients;
 
SELECT * FROM temp_clients;
END ##

DELIMITER ;








/*
	
DROP PROCEDURE IF EXISTS getTheRunningLoansService;

DELIMITER ##

CREATE PROCEDURE getTheRunningLoansService(IN station INT) READS SQL DATA BEGIN

 DECLARE loanIds,ID,AGINGDAYS,l_done INT;
 DECLARE dateTakenL TIMESTAMP;

DECLARE NAME,PHONE,NUMBERPLATE,STAGE,DATETAKEN,TIMETAKEN VARCHAR(60);
DECLARE LOANTAKEN,LOANINTERESTEXPECTED,LOANINTERESTPAID,LOANINTERESTREMAINING,loanPaid,interestPaid,loanRemain,interestRemain DOUBLE;

-- SELECT station;

DECLARE forSelectingLoanIdS CURSOR FOR SELECT l.loans_id  FROM loans l INNER JOIN users u ON l.fk_user_id_loans=u.users_id INNER JOIN petrol_station ps ON u. fk_petrol_station_id_users=ps.petrol_station_id WHERE l.loan_status=1 AND ps.petrol_station_id=station;
 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
 
DROP TABLE IF EXISTS temp_loans;

CREATE TEMPORARY  TABLE temp_loans(id INT,name VARCHAR(60),loan_taken DOUBLE,loan_interest_expected DOUBLE,loan_interest_paid DOUBLE,loan_interest_remaining DOUBLE,aging_days INT,phone VARCHAR(60),number_plate VARCHAR(60),stage VARCHAR(60));

 SET ID=0;

 OPEN forSelectingLoanIdS;



accounts_loop: LOOP 

 FETCH forSelectingLoanIdS into loanIds;
 
 
 IF l_done=1 THEN

LEAVE accounts_loop;

 END IF;
 SET ID=ID+1;
 
 SELECT ID; 
    SELECT c.customers_name,l.loan_amount_taken, (l.loan_amount_taken+i.interest_amount),c.customers_phone_number,c.customers_number_plate,s.stage_name,l.loan_date_taken INTO NAME,LOANTAKEN,LOANINTERESTEXPECTED,PHONE,NUMBERPLATE,STAGE,dateTakenL  FROM customers c INNER JOIN loans l ON l.fk_customers_id_loans=c.customers_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN stage s ON c.fk_stage_id_customer=s.stage_id  WHERE l.loans_id=loanIds;

    SELECT SUM(ip.interest_amount_paid) INTO interestPaid  FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id WHERE l.loans_id=loanIds;

    SELECT SUM(lp.loan_amount_paid) INTO loanPaid FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id WHERE l.loans_id=loanIds;

    SET LOANINTERESTPAID=interestPaid+loanPaid;

    SELECT lp.loan_amount_remaining INTO loanRemain FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id WHERE l.loans_id=loanIds ORDER BY lp.loan_payments_id DESC LIMIT 1; 

    SELECT ip.interest_amount_remaining INTO interestRemain FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i. fk_loans_id_interest=l.loans_id WHERE l.loans_id=loanIds ORDER BY ip.interest_payments_id DESC LIMIT 1;

     SET LOANINTERESTREMAINING=loanRemain+interestRemain;

SET AGINGDAYS=DATEDIFF(CURRENT_TIMESTAMP,dateTakenL);

 
  SELECT ID; 

 INSERT INTO temp_loans VALUES(ID,NAME,LOANTAKEN,LOANINTERESTEXPECTED,LOANINTERESTPAID,LOANINTERESTREMAINING,AGINGDAYS,PHONE,NUMBERPLATE,STAGE);


SET l_done=0;

 END LOOP accounts_loop;

 CLOSE forSelectingLoanIdS;
 

SELECT SUM(loan_taken), SUM(loan_interest_expected),SUM(loan_interest_paid),
SUM(loan_interest_remaining) INTO @LT,@LIE,@LIP,@LIR FROM temp_loans;

/* SELECT @LT,@LIE,@LIP,@LIR ; 
 INSERT INTO temp_loans VALUES(NULL,"TOTAL",@LT,@LIE,@LIP,@LIR,NULL,NULL,NULL,NULL);


SELECT * FROM temp_loans ORDER BY stage*1 ;

 DROP TABLE temp_loans; 


END ##

DELIMITER ;

*/


DROP PROCEDURE IF EXISTS getTheRunningLoansService;

DELIMITER ##

CREATE PROCEDURE getTheRunningLoansService(IN station INT) READS SQL DATA BEGIN
CALL clearIds();

DROP TABLE IF EXISTS temp_loans;
CREATE TEMPORARY  TABLE temp_loans(id INT NOT NULL AUTO_INCREMENT,name VARCHAR(60),date_taken VARCHAR(30),time_taken TIME,loan_taken DOUBLE,loan_interest_expected DOUBLE,loan_interest_paid DOUBLE,loan_interest_remaining DOUBLE,aging_days INT,phone VARCHAR(60),number_plate VARCHAR(60),stage VARCHAR(60), PRIMARY KEY (id))ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;

INSERT INTO temp_loans(id,name,date_taken,time_taken,loan_taken,loan_interest_expected,loan_interest_paid,loan_interest_remaining,aging_days,phone,number_plate,stage)
SELECT NULL ,c.customers_name AS name ,DATE_FORMAT(DATE(l.loan_date_taken),"%d/%m/%Y") AS date_taken,TIME(l.loan_date_taken) AS time_taken,l.loan_amount_taken AS loan_taken, (l.loan_amount_taken+i.interest_amount) AS loan_interest_expected,(l.loan_amount_paid+i.interest_paid) AS loan_interest_paid,(l.loan_amount_remaining+i.interest_remaining) AS loan_interest_remaining,DATEDIFF(CURRENT_TIMESTAMP,l.loan_date_taken) AS aging_days, c.customers_phone_number AS phone,c.customers_number_plate AS number_plate ,s.stage_name AS stage  FROM customers c INNER JOIN loans l ON l.fk_customers_id_loans=c.customers_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN stage s ON c.fk_stage_id_customer=s.stage_id INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON u. fk_petrol_station_id_users=ps.petrol_station_id   WHERE (l.loan_status=1 AND ps.petrol_station_id=station ) ORDER BY s.stage_id ASC;

SELECT SUM(loan_taken), SUM(loan_interest_expected),SUM(loan_interest_paid),
SUM(loan_interest_remaining) INTO @LT,@LIE,@LIP,@LIR FROM temp_loans;

 INSERT INTO temp_loans VALUES(0,"TOTAL",NULL,NULL,@LT,@LIE,@LIP,@LIR,NULL,NULL,NULL,NULL);


SELECT * FROM temp_loans;
END ##

DELIMITER ;

CALL getTheRunningLoansService(506);

DROP PROCEDURE IF EXISTS clearIds;

DELIMITER ££

CREATE PROCEDURE clearIds() BEGIN

DELETE FROM theGen;

ALTER TABLE theGen AUTO_INCREMENT=1;

END ££

DELIMITER ;



/* CURRENT SHIFT FUNCTION */
DROP FUNCTION IF EXISTS IDGen;
DELIMITER ##
CREATE FUNCTION IDGen() 
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE shiftId INT;

INSERT INTO theGen VALUES(NULL);

RETURN LAST_INSERT_ID();

END ##
DELIMITER ;


	
DROP PROCEDURE IF EXISTS getTheOverDueLoansService;

DELIMITER ##

CREATE PROCEDURE getTheOverDueLoansService() READS SQL DATA BEGIN

 DECLARE loanIds,ID,AGINGDAYS,l_done INT;
 DECLARE dateTakenL TIMESTAMP;

DECLARE NAME,PHONE,NUMBERPLATE,STAGE VARCHAR(60);
DECLARE LOANTAKEN,LOANINTERESTEXPECTED,LOANINTERESTPAID,LOANINTERESTREMAINING,loanPaid,interestPaid,loanRemain,interestRemain DOUBLE;


DECLARE forSelectingLoanIdS CURSOR FOR SELECT loans_id  FROM loans WHERE loan_status=1 AND DATEDIFF(CURRENT_TIMESTAMP,loan_date_taken)>=1;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
 
DROP TABLE IF EXISTS temp_loans;

CREATE TEMPORARY  TABLE temp_loans(id INT,name VARCHAR(60),loan_taken DOUBLE,loan_interest_expected DOUBLE,loan_interest_paid DOUBLE,loan_interest_remaining DOUBLE,aging_days INT,phone VARCHAR(60),number_plate VARCHAR(60),stage VARCHAR(60));

 SET ID=0;

 OPEN forSelectingLoanIdS;



accounts_loop: LOOP 



 FETCH forSelectingLoanIdS into loanIds;
 
 
 IF l_done=1 THEN

LEAVE accounts_loop;

 END IF;
 SET ID=ID+1;
 
/* SELECT ID; */
    SELECT c.customers_name,l.loan_amount_taken, (l.loan_amount_taken+i.interest_amount),c.customers_phone_number,c.customers_number_plate,s.stage_name,l.loan_date_taken INTO NAME,LOANTAKEN,LOANINTERESTEXPECTED,PHONE,NUMBERPLATE,STAGE,dateTakenL  FROM customers c INNER JOIN loans l ON l.fk_customers_id_loans=c.customers_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN stage s ON c.fk_stage_id_customer=s.stage_id WHERE l.loans_id=loanIds ;

    SELECT SUM(ip.interest_amount_paid) INTO interestPaid  FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id WHERE l.loans_id=loanIds;

    SELECT SUM(lp.loan_amount_paid) INTO loanPaid FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id WHERE l.loans_id=loanIds;

    SET LOANINTERESTPAID=interestPaid+loanPaid;

    SELECT lp.loan_amount_remaining INTO loanRemain FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id WHERE l.loans_id=loanIds ORDER BY lp.loan_payments_id DESC LIMIT 1; 

    SELECT ip.interest_amount_remaining INTO interestRemain FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i. fk_loans_id_interest=l.loans_id WHERE l.loans_id=loanIds ORDER BY ip.interest_payments_id DESC LIMIT 1;

     SET LOANINTERESTREMAINING=loanRemain+interestRemain;

SET AGINGDAYS=DATEDIFF(CURRENT_TIMESTAMP,dateTakenL);

 
 /* SELECT ID; */

 INSERT INTO temp_loans VALUES(ID,NAME,LOANTAKEN,LOANINTERESTEXPECTED,LOANINTERESTPAID,LOANINTERESTREMAINING,AGINGDAYS,PHONE,NUMBERPLATE,STAGE);


SET l_done=0;

 END LOOP accounts_loop;

 CLOSE forSelectingLoanIdS;
 


SELECT SUM(loan_taken), SUM(loan_interest_expected),SUM(loan_interest_paid),
SUM(loan_interest_remaining) INTO @LT,@LIE,@LIP,@LIR FROM temp_loans;

 INSERT INTO temp_loans VALUES(NULL,"TOTAL",@LT,@LIE,@LIP,@LIR,NULL,NULL,NULL,NULL);

SELECT * FROM temp_loans ORDER BY stage ASC;

/* DROP TABLE temp_loans; */


END ##

DELIMITER ;


	
DROP PROCEDURE IF EXISTS getTheOverDueLoansService;

DELIMITER ##

CREATE PROCEDURE getTheOverDueLoansService() READS SQL DATA BEGIN

 DECLARE loanIds,ID,AGINGDAYS,l_done INT;
 DECLARE dateTakenL TIMESTAMP;

DECLARE NAME,PHONE,NUMBERPLATE,STAGE VARCHAR(60);
DECLARE LOANTAKEN,LOANINTERESTEXPECTED,LOANINTERESTPAID,LOANINTERESTREMAINING,loanPaid,interestPaid,loanRemain,interestRemain DOUBLE;


DECLARE forSelectingLoanIdS CURSOR FOR SELECT loans_id  FROM loans WHERE loan_status=1 AND DATEDIFF(CURRENT_TIMESTAMP,loan_date_taken)>=1;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
 
DROP TABLE IF EXISTS temp_loans;

CREATE TEMPORARY  TABLE temp_loans(id INT,name VARCHAR(60),loan_taken DOUBLE,loan_interest_expected DOUBLE,loan_interest_paid DOUBLE,loan_interest_remaining DOUBLE,aging_days INT,phone VARCHAR(60),number_plate VARCHAR(60),stage VARCHAR(60));

 SET ID=0;

 OPEN forSelectingLoanIdS;



accounts_loop: LOOP 



 FETCH forSelectingLoanIdS into loanIds;
 
 
 IF l_done=1 THEN

LEAVE accounts_loop;

 END IF;
 SET ID=ID+1;
 
/* SELECT ID; */
    SELECT c.customers_name,l.loan_amount_taken, (l.loan_amount_taken+i.interest_amount),c.customers_phone_number,c.customers_number_plate,s.stage_name,l.loan_date_taken INTO NAME,LOANTAKEN,LOANINTERESTEXPECTED,PHONE,NUMBERPLATE,STAGE,dateTakenL  FROM customers c INNER JOIN loans l ON l.fk_customers_id_loans=c.customers_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN stage s ON c.fk_stage_id_customer=s.stage_id WHERE l.loans_id=loanIds ;

    SELECT SUM(ip.interest_amount_paid) INTO interestPaid  FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id WHERE l.loans_id=loanIds;

    SELECT SUM(lp.loan_amount_paid) INTO loanPaid FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id WHERE l.loans_id=loanIds;

    SET LOANINTERESTPAID=interestPaid+loanPaid;

    SELECT lp.loan_amount_remaining INTO loanRemain FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id WHERE l.loans_id=loanIds ORDER BY lp.loan_payments_id DESC LIMIT 1; 

    SELECT ip.interest_amount_remaining INTO interestRemain FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i. fk_loans_id_interest=l.loans_id WHERE l.loans_id=loanIds ORDER BY ip.interest_payments_id DESC LIMIT 1;

     SET LOANINTERESTREMAINING=loanRemain+interestRemain;

SET AGINGDAYS=DATEDIFF(CURRENT_TIMESTAMP,dateTakenL);

 
 /* SELECT ID; */

 INSERT INTO temp_loans VALUES(ID,NAME,LOANTAKEN,LOANINTERESTEXPECTED,LOANINTERESTPAID,LOANINTERESTREMAINING,AGINGDAYS,PHONE,NUMBERPLATE,STAGE);


SET l_done=0;

 END LOOP accounts_loop;

 CLOSE forSelectingLoanIdS;
 


SELECT SUM(loan_taken), SUM(loan_interest_expected),SUM(loan_interest_paid),
SUM(loan_interest_remaining) INTO @LT,@LIE,@LIP,@LIR FROM temp_loans;

SELECT @LT,@LIE,@LIP,@LIR ;
 INSERT INTO temp_loans VALUES(0,"TOTAL",@LT,@LIE,@LIP,@LIR,0,"-","-","-");

SELECT * FROM temp_loans;

/* DROP TABLE temp_loans; */


END ##

DELIMITER ;





/* 
DROP PROCEDURE IF EXISTS ledgerStatement;

DELIMITER ##

CREATE PROCEDURE ledgerStatement(IN data JSON) READS SQL DATA BEGIN

DECLARE theShiftId INT;
DECLARE theShiftBal DOUBLE;

IF JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='ALL TRANSACTIONS' THEN

CALL generalLedgerStateAll(data);

ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='LOAN TRANSACTIONS' THEN

CALL generalLedgerStateAll(data);

ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='LOAN PAYMENTS' THEN

CALL generalLedgerStateAll(data);

ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='LOAN DISBUREMENTS' THEN

CALL generalLedgerStateAll(data);
ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='DEPOSITS AND WITHDRAWS' THEN

CALL generalLedgerStateAll(data);

ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.selection_options'))='SHIFTALL' THEN

SELECT shift_id,shift_opening_bal INTO theShiftId,theShiftBal FROM shift WHERE fk_petrol_station_id_shift=JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')) ORDER BY shift_id DESC LIMIT 1;

CALL generalLedgerShiftAll(theShiftId,theShiftBal,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')));

END IF;

END ##

DELIMITER ; */







	
DROP PROCEDURE IF EXISTS generalLedgerStateAll;

DELIMITER ##

CREATE PROCEDURE generalLedgerStateAll(IN data JSON) READS SQL DATA BEGIN

 DECLARE l_done INT;
 
DECLARE forSelectingLoanIdS CURSOR FOR SELECT loans_id  FROM loans WHERE loan_status=1 AND DATEDIFF(CURRENT_TIMESTAMP,loan_date_taken)>=1;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;
 


 OPEN forSelectingLoanIdS;



accounts_loop: LOOP 



 FETCH forSelectingLoanIdS into loanIds;
 
 
 IF l_done=1 THEN

LEAVE accounts_loop;

 END IF;
 


SET l_done=0;

 END LOOP accounts_loop;

 CLOSE forSelectingLoanIdS;
 


END ##

DELIMITER ;


/* CURRENT SHIFT FUNCTION */
DROP FUNCTION IF EXISTS CurrentShift;
DELIMITER ##
CREATE FUNCTION CurrentShift(user_station INT) 
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE shiftId INT;

SELECT s.shift_id INTO shiftId FROM shift s WHERE  s.fk_petrol_station_id_shift=user_station ORDER BY s.shift_id DESC LIMIT 1;

RETURN shiftId;
END ##
DELIMITER ;









DROP PROCEDURE IF EXISTS scretePIN;

DELIMITER ##

CREATE PROCEDURE scretePIN(IN numberPlate VARCHAR(45)) READS SQL DATA BEGIN

SELECT secret_pin FROM customers WHERE customers_number_plate=numberPlate;
 
END ##

DELIMITER ;



DROP PROCEDURE IF EXISTS generalLedgerShiftAllN;

DELIMITER ##

CREATE PROCEDURE generalLedgerShiftAllN(IN shiftId INT,IN openingBal DOUBLE,IN stationId INT) READS SQL DATA BEGIN
DECLARE DATE,TIME,TYPE,NUMBER_PLATE VARCHAR(60);
DECLARE DEBIT,CREDIT,RUNNING_BALANCE DOUBLE;
DECLARE l_done,glIds INT;
DECLARE forSelectingGeneralLedgerTxns CURSOR FOR SELECT trn_general_ledger_id  FROM trn_general_ledger WHERE fk_petrol_station_id_trn_general_ledger=stationId AND fk_shift_id_trn_general_ledger=shiftId;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;


DROP TABLE IF EXISTS temp_ledger;

CREATE  TABLE temp_ledger(id INT,trn_date VARCHAR(60),trn_time VARCHAR(60),trn_type VARCHAR(60),number_plate VARCHAR(45),debit_amount DOUBLE,credit_amount DOUBLE,running_balance DOUBLE);
--  number_plate
OPEN forSelectingGeneralLedgerTxns;
SET @RUNNING_BALANCE=openingBal;

SET @TOTAL_DEBIT=0;

SET @TOTAL_CREDIT=0;

SET @ID=0;
INSERT INTO temp_ledger VALUES(NULL,'OPENING BALANCE',NULL,NULL,NULL,NULL,NULL,openingBal);

accounts_loop: LOOP 
FETCH forSelectingGeneralLedgerTxns into glIds;
  
IF l_done=1 THEN
LEAVE accounts_loop;
END IF;
 
 SELECT DATE_FORMAT(DATE(trn_date),"%d/%m/%Y"),TIME(trn_date),trn_type,trn_debit,trn_credit INTO DATE,TIME,TYPE,DEBIT,CREDIT FROM trn_general_ledger WHERE trn_general_ledger_id=glIds;

 SELECT c.trn_number_plate INTO NUMBER_PLATE FROM trn_customer_details c INNER JOIN trn_general_ledger g ON c.fk_trn_general_ledger_id_trn_customer_details=g.trn_general_ledger_id WHERE g.trn_general_ledger_id=glIds;

 IF ISNULL(NUMBER_PLATE) THEN 
 SET NUMBER_PLATE="NOT APPLICABLE";
 END IF;

SET @RUNNING_BALANCE=@RUNNING_BALANCE+DEBIT-CREDIT;

SET @TOTAL_DEBIT=@TOTAL_DEBIT+DEBIT;

SET @TOTAL_CREDIT=@TOTAL_CREDIT+CREDIT;


SET @ID=@ID+1;

IF DEBIT=0 THEN

SET DEBIT=NULL;

END IF;

IF CREDIT=0 THEN

SET CREDIT=NULL;

END IF;


INSERT INTO temp_ledger VALUES(@ID,DATE,TIME,TYPE,NUMBER_PLATE,DEBIT,CREDIT,@RUNNING_BALANCE);

SET l_done=0;
END LOOP accounts_loop;
CLOSE forSelectingGeneralLedgerTxns;

SET @NET_BALANCE=@TOTAL_DEBIT-@TOTAL_CREDIT;

INSERT INTO temp_ledger VALUES(NULL,'TOTAL/NET BALANCE',NULL,NULL,NULL,@TOTAL_DEBIT,@TOTAL_CREDIT,@NET_BALANCE);


SELECT * FROM temp_ledger;
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS generalLedgerShiftAllNDate;

DELIMITER ##

CREATE PROCEDURE generalLedgerShiftAllNDate(IN shiftId INT,IN openingBal DOUBLE,IN stationId INT) READS SQL DATA BEGIN
DECLARE DATE,TIME,TYPE,NUMBER_PLATE VARCHAR(60);
DECLARE DEBIT,CREDIT,RUNNING_BALANCE DOUBLE;
DECLARE l_done,glIds INT;
DECLARE forSelectingGeneralLedgerTxns CURSOR FOR SELECT trn_general_ledger_id  FROM trn_general_ledger WHERE fk_petrol_station_id_trn_general_ledger=stationId ;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;


DROP TABLE IF EXISTS temp_ledger;

CREATE  TABLE temp_ledger(id INT,trn_date VARCHAR(60),trn_time VARCHAR(60),trn_type VARCHAR(60),number_plate VARCHAR(45),debit_amount DOUBLE,credit_amount DOUBLE,running_balance DOUBLE);
--  number_plate
OPEN forSelectingGeneralLedgerTxns;
SET @RUNNING_BALANCE=openingBal;

SET @TOTAL_DEBIT=0;

SET @TOTAL_CREDIT=0;

SET @ID=0;

INSERT INTO temp_ledger VALUES(NULL,'OPENING BALANCE',NULL,NULL,NULL,NULL,NULL,openingBal);

accounts_loop: LOOP 
FETCH forSelectingGeneralLedgerTxns into glIds;
  
IF l_done=1 THEN
LEAVE accounts_loop;
END IF;
 
 SELECT DATE_FORMAT(DATE(trn_date),"%d/%m/%Y"),TIME(trn_date),trn_type,trn_debit,trn_credit INTO DATE,TIME,TYPE,DEBIT,CREDIT FROM trn_general_ledger WHERE trn_general_ledger_id=glIds;

 SELECT c.trn_number_plate INTO NUMBER_PLATE FROM trn_customer_details c INNER JOIN trn_general_ledger g ON c.fk_trn_general_ledger_id_trn_customer_details=g.trn_general_ledger_id WHERE g.trn_general_ledger_id=glIds;

 IF ISNULL(NUMBER_PLATE) THEN 
 SET NUMBER_PLATE="NOT APPLICABLE";
 END IF;

SET @RUNNING_BALANCE=@RUNNING_BALANCE+DEBIT-CREDIT;

SET @TOTAL_DEBIT=@TOTAL_DEBIT+DEBIT;

SET @TOTAL_CREDIT=@TOTAL_CREDIT+CREDIT;


SET @ID=@ID+1;

IF DEBIT=0 THEN

SET DEBIT=NULL;

END IF;

IF CREDIT=0 THEN

SET CREDIT=NULL;

END IF;


INSERT INTO temp_ledger VALUES(@ID,DATE,TIME,TYPE,NUMBER_PLATE,DEBIT,CREDIT,@RUNNING_BALANCE);
SELECT DEBIT,CREDIT,@RUNNING_BALANCE;
SET l_done=0;
END LOOP accounts_loop;
CLOSE forSelectingGeneralLedgerTxns;

SET @NET_BALANCE=@TOTAL_DEBIT-@TOTAL_CREDIT;

INSERT INTO temp_ledger VALUES(NULL,'TOTAL/NET BALANCE',NULL,NULL,NULL,@TOTAL_DEBIT,@TOTAL_CREDIT,@NET_BALANCE);


SELECT * FROM temp_ledger;
END ##
DELIMITER ;





/* REPAY THE LOAN NOW*/
-- CALL repayLoanNow('{"user_id":100000012,"user_station":507,"number_plate":"UDM 726F","amount_to_pay":2311,"pin":"8251"}')


DROP PROCEDURE IF EXISTS repayLoanNow;
DELIMITER ##
CREATE PROCEDURE   repayLoanNow(IN data JSON) 
BEGIN

DECLARE loanId,interestId,newLoanId,newInterestId,createdByIdLoanPay,createdByIdInterestPay,interesPayId,lastLoanId,customerId INT;

DECLARE loanAmount,loanRemaining, interestRemaining,newLoanRemaining,newInterestRemaining,loanDue,newLoanPaid,loanPaid,interestPaid,newInterst,newLoan,newInterestPaid,loanIntDiff,loanPaidDiff,BorisJo DOUBLE;


SELECT l.loan_amount_taken,l.loan_amount_remaining,l.loan_amount_paid,l.loans_id,c.fk_user_id_created_by_customers,c.customers_id INTO loanAmount,loanRemaining,loanPaid,loanId,createdByIdLoanPay,customerId FROM  loans l  INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id WHERE c.customers_number_plate=JSON_UNQUOTE(JSON_EXTRACT(data, '$.number_plate')) AND l.loan_status=1 ORDER BY l.loans_id DESC LIMIT 1;

SELECT i.interest_remaining,i.interest_paid, i.interest_id INTO interestRemaining,interestPaid,interestId FROM interest i INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id WHERE i.fk_loans_id_interest=loanId;

SET loanDue=loanRemaining+interestRemaining;

IF interestRemaining<=0 THEN

IF JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))<loanRemaining THEN

SET newLoanRemaining=loanRemaining-JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));
SET newLoanPaid=loanPaid+JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));

UPDATE loans SET loan_amount_remaining=newLoanRemaining,loan_amount_paid=newLoanPaid WHERE loans_id=loanId;

INSERT INTO loan_payments VALUES(NULL,1,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),newLoanRemaining,CURRENT_TIMESTAMP(), loanId);

SET lastLoanId=LAST_INSERT_ID()-1;

UPDATE loan_payments SET  loan_payments_status=2 WHERE loan_payments_id=lastLoanId;

CALL  debitGeneralLedger('LOANREPAY',JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdLoanPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')));

ELSE


INSERT INTO loan_payments VALUES(NULL,2,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),0,CURRENT_TIMESTAMP(),loanId);

SET lastLoanId=LAST_INSERT_ID()-1;

UPDATE loan_payments SET  loan_payments_status=2 WHERE loan_payments_id=lastLoanId;

UPDATE loans SET loan_status=2, loan_amount_remaining=0,loan_amount_paid=loanAmount WHERE loans_id=loanId;


CALL  debitGeneralLedger('LOANREPAY',JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')));


END IF;

ELSEIF interestRemaining>0 THEN

IF JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))<=interestRemaining THEN

IF JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))<interestRemaining THEN

SET newInterestRemaining =interestRemaining-JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));

SET newInterestPaid=interestPaid+JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));

UPDATE interest SET interest_paid=newInterestPaid,interest_remaining=newInterestRemaining WHERE interest_id=interestId; 

INSERT INTO interest_payments VALUES(NULL,0,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),newInterestRemaining,CURRENT_TIMESTAMP(),interestId);

SET interesPayId=LAST_INSERT_ID();

CALL commissionEarned(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),interestId);

CALL  debitGeneralLedger('INTERESTPAY',JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')));

ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))=interestRemaining THEN

-- SET newInterestRemaining =interestRemaining-JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));

SET newInterestPaid=interestPaid+JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));

UPDATE interest SET interest_paid=newInterestPaid,interest_remaining=0 WHERE interest_id=interestId; 

INSERT INTO interest_payments VALUES(NULL,0,JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),0,CURRENT_TIMESTAMP(),interestId);

SET interesPayId=LAST_INSERT_ID();

CALL commissionEarned(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),interestId);

CALL  debitGeneralLedger('INTERESTPAY',JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')));
END IF;

ELSEIF JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))>interestRemaining THEN

IF loanDue=JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay')) THEN

SET loanIntDiff=(JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))-interestRemaining);

SET newLoanPaid=loanPaid+loanIntDiff;

SET newInterestPaid=interestPaid+interestRemaining;

UPDATE interest SET interest_paid=newInterestPaid,interest_remaining=0,interest_accrual_status=2 WHERE interest_id=interestId; 

INSERT INTO interest_payments VALUES(NULL,0,interestRemaining,0,CURRENT_TIMESTAMP(),interestId);

SET interesPayId=LAST_INSERT_ID();

CALL commissionEarned(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),interestRemaining,interestId);

CALL  debitGeneralLedger('INTERESTPAY',interestRemaining,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),interestRemaining);


INSERT INTO loan_payments VALUES(NULL,2,loanIntDiff,0,CURRENT_TIMESTAMP(),loanId);

SET lastLoanId=LAST_INSERT_ID()-1;

UPDATE loan_payments SET  loan_payments_status=2 WHERE loan_payments_id=lastLoanId;

UPDATE loans SET loan_status=2,loan_amount_paid=loanAmount,loan_amount_remaining=0 WHERE loans_id=loanId;

CALL  debitGeneralLedger('LOANREPAY',loanIntDiff,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),loanIntDiff);

UPDATE lc_manager SET lc_manager_status=2 WHERE fk_loans_id_lc_manager=loanId;


ELSE


SET newLoanRemaining=loanDue-JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'));

SET loanPaidDiff=JSON_UNQUOTE(JSON_EXTRACT(data, '$.amount_to_pay'))-interestRemaining;

SET newLoanPaid=loanPaid+loanPaidDiff;

INSERT INTO interest_payments VALUES(NULL,0,interestRemaining,0,CURRENT_TIMESTAMP(),interestId);

SET interesPayId=LAST_INSERT_ID();

UPDATE interest SET interest_paid=interestRemaining,interest_remaining=0,interest_accrual_status=2 WHERE interest_id=interestId; 

CALL commissionEarned(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),interestRemaining,interestId);

CALL  debitGeneralLedger('INTERESTPAY',interestRemaining,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdInterestPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),interestRemaining);



INSERT INTO loan_payments VALUES(NULL,1,loanPaidDiff,newLoanRemaining,CURRENT_TIMESTAMP(),loanId);

SET lastLoanId=LAST_INSERT_ID()-1;

UPDATE loan_payments SET  loan_payments_status=2 WHERE loan_payments_id=lastLoanId;

UPDATE loans SET  loan_amount_remaining=newLoanRemaining,loan_amount_paid=newLoanPaid WHERE loans_id=loanId;

CALL  debitGeneralLedger('LOANREPAY',loanPaidDiff,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_id')),createdByIdLoanPay,JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),customerId) ;

CALL increaseShiftClosingBalance(JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')),loanPaidDiff);

 END IF;

END IF;

END IF;

SELECT loan_payments_id INTO newLoanId FROM loan_payments WHERE fk_loans_id_loan_payment=loanId ORDER BY loan_payments_id DESC LIMIT 1;

SELECT loan_amount_remaining INTO newLoan FROM loans WHERE loans_id=loanId;

SELECT interest_payments_id INTO newInterestId FROM interest_payments WHERE fk_interest_id_interest_payment=interestId ORDER BY interest_payments_id DESC LIMIT 1;

SELECT interest_remaining INTO newInterst FROM interest WHERE interest_id=interestId;

SELECT (newLoan+newInterst) AS amount_due,ROUND(((newLoanId+newInterestId)/2))+1 AS txn_id;
 
END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS loanTableRestructuring;

DELIMITER ##

CREATE PROCEDURE loanTableRestructuring()BEGIN

DECLARE totalAmountPaid,totalAmountRemaining DOUBLE;

DECLARE  loan_ids_completed , theLoanId INT;

DECLARE loanIdsInTables CURSOR FOR SELECT loans_id FROM loans;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET loan_ids_completed=1;

 OPEN loanIdsInTables;
  
  loanIds:LOOP
  
  FETCH loanIdsInTables INTO theLoanId;

   IF loan_ids_completed=1 THEN
   
   LEAVE  loanIds;
   
   END IF;
   
    SELECT SUM(loan_amount_paid) INTO totalAmountPaid FROM loan_payments WHERE fk_loans_id_loan_payment=theLoanId;
    
      SELECT loan_amount_remaining INTO totalAmountRemaining FROM loan_payments WHERE fk_loans_id_loan_payment=theLoanId ORDER BY loan_payments_id DESC LIMIT 1;
      
      UPDATE loans SET loan_amount_paid=totalAmountPaid,loan_amount_remaining=totalAmountRemaining WHERE loans_id=theLoanId;
   
  
  
  SET loan_ids_completed=0;
  
  END LOOP loanIds;

 CLOSE loanIdsInTables;

END ##
DELIMITER ;
CALL loanTableRestructuring();




DROP PROCEDURE IF EXISTS interestTableRestructuring;

DELIMITER ££

CREATE PROCEDURE interestTableRestructuring() BEGIN

DECLARE interestAmountPaid,interestAmountRemaining DOUBLE;

DECLARE interest_ids_completed,theInterestId INT;

DECLARE interestIdsCursor CURSOR FOR SELECT interest_id FROM interest;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET interest_ids_completed=1;

OPEN interestIdsCursor;

interestIdsLoop:LOOP

FETCH interestIdsCursor INTO theInterestId;

IF interest_ids_completed=1 THEN

LEAVE interestIdsLoop;

END IF;

SELECT SUM(interest_amount_paid) INTO interestAmountPaid FROM interest_payments WHERE fk_interest_id_interest_payment=theInterestId;

SELECT interest_amount_remaining INTO interestAmountRemaining FROM interest_payments WHERE fk_interest_id_interest_payment=theInterestId ORDER BY interest_payments_id DESC LIMIT 1;

UPDATE interest SET interest_paid=interestAmountPaid,interest_remaining=interestAmountRemaining WHERE interest_id=theInterestId;


SET interest_ids_completed=0;

END LOOP interestIdsLoop;

CLOSE interestIdsCursor;

END ££
DELIMITER ;

CALL interestTableRestructuring();


/* GET SHIFT DETAILS */

DROP PROCEDURE IF EXISTS commissionEarned;

DELIMITER ##

CREATE PROCEDURE   commissionEarned(IN station VARCHAR(45),IN interestPaid DOUBLE,IN interestPayamentId INT) 
BEGIN

DECLARE commissionRate,commissionId INT;

DECLARE theCommision,theTotalCommision DOUBLE;

SELECT `petrol_station_commission` INTO commissionRate FROM `petrol_station_rates` WHERE `fk_petrol_station_id_petrol_station_rates`=station;

SELECT `commission_id`,`commission_amount` INTO commissionId, theTotalCommision FROM `commission` WHERE `fk_interest_id_commision`=interestPayamentId;

SET theCommision=ROUND((interestPaid*commissionRate)/100);

 SET theTotalCommision=theTotalCommision+theCommision;

UPDATE `commission` SET `commission_amount`=theTotalCommision WHERE `commission_id`=commissionId;

INSERT INTO `commission_details` VALUES(NULL,theCommision,CURRENT_TIMESTAMP,commissionId);

END ##
DELIMITER ;



DROP PROCEDURE IF EXISTS normaliseCommision;

DELIMITER ££

CREATE PROCEDURE normaliseCommision() BEGIN

DECLARE edended_ids,interestIds INT;

DECLARE totalCommission DOUBLE;

DECLARE theInterestIds CURSOR FOR SELECT interest_id FROM interest;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET edended_ids=1;

OPEN theInterestIds;

DROP TABLE IF EXISTS commissionMigrations;

CREATE TEMPORARY TABLE commissionMigrations(`commission_id` INT(11) NOT NULL AUTO_INCREMENT,`commission_amount` DOUBLE NULL, `fk_interest_id_commision` INT,PRIMARY KEY (`commission_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 1300
DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS commissionMigrationsDetails;

CREATE TEMPORARY TABLE commissionMigrationsDetails(`commission_details_id` INT(11) NOT NULL AUTO_INCREMENT,`commission_amount` DOUBLE NULL,`fk_interest_id_commision` INT,  PRIMARY KEY (`commission_details_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 6500
DEFAULT CHARACTER SET = utf8;

INSERT INTO commissionMigrationsDetails(`commission_details_id`,`commission_amount`,`fk_interest_id_commision`) SELECT `commission_id`,`commission_amount`,`fk_interest_payments_id_commision` FROM commission;


theIdLoops:LOOP

FETCH theInterestIds INTO interestIds;

IF edended_ids=1 THEN

LEAVE theIdLoops;

END IF;

SELECT SUM(cm.commission_amount) INTO totalCommission FROM commission cm INNER JOIN 
interest_payments ip ON ip.interest_payments_id=cm.fk_interest_payments_id_commision INNER JOIN interest i ON i.interest_id=ip.fk_interest_id_interest_payment WHERE i. interest_id=interestIds;

IF ISNULL(totalCommission) THEN
SET totalCommission=0;
END IF;

IF totalCommission>0 THEN
-- SELECT totalCommission,interestIds;
INSERT INTO commissionMigrations VALUES(NULL,totalCommission,interestIds);

END IF;


END LOOP theIdLoops;

CLOSE theInterestIds;

DROP TABLE IF EXISTS commission_details;
DROP TABLE IF EXISTS commission;


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

INSERT INTO commission (`commission_id`,`commission_amount`,`fk_interest_id_commision`) SELECT `commission_id`,`commission_amount`,`fk_interest_id_commision` FROM commissionMigrations;

INSERT INTO commission_details (commission_details_id,commission_amount_added,commission_date_computed,fk_commission_id_commission_details) SELECT NULL,ip.interest_amount_paid*.05,CURRENT_TIMESTAMP,c.commission_id FROM interest_payments ip INNER JOIN interest i ON ip.fk_interest_id_interest_payment=i.interest_id INNER JOIN commission c ON c.fk_interest_id_commision=i.interest_id WHERE ip.interest_amount_paid>0;


-- INSERT INTO `commission_details` (`commission_details_id`,`commission_amount_added`, `commission_date_computed`, `fk_commission_id_commission_details`) SELECT NULL,cdt.commission_amount,CURRENT_TIMESTAMP,c.fk_interest_id_commision FROM  commissionMigrationsDetails cdt INNER JOIN interest_payments lp ON lp.interest_payments_id=cdt.fk_interest_id_commision INNER JOIN interest i ON i.interest_id=lp.fk_interest_id_interest_payment INNER JOIN commissionMigrations c
-- ON c.fk_interest_id_commision=i.interest_id;

DROP TABLE commissionMigrations;

END ££

DELIMITER ;

CALL normaliseCommision();


/* GET SHIFT DETAILS */
DROP PROCEDURE IF EXISTS manage_interest;

DELIMITER ##

CREATE PROCEDURE   manage_interest(IN timeStatmp TIMESTAMP) 
BEGIN



  DECLARE lcId,noPAccruals, maxNoPAccruals,interestRateAccrual,interestId,n,newnoPAccruals INT;

    DECLARE newexpirelyTime ,expirelyTime TIMESTAMP;

   DECLARE loanAmountR,interestCPMPU,existInterestAmountRemain,NewExistInterestAmountRemain,existingInterest,NewExistingInterest DOUBLE;


  DECLARE l_done INTEGER DEFAULT 0;
  
 DECLARE selectTrnIds CURSOR FOR SELECT lc.lc_manager_id  FROM lc_manager lc INNER JOIN loans l ON lc.fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_status=1 AND l.loan_status=1;
 
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;

 OPEN selectTrnIds;


LedgerIds_loop: LOOP 

 FETCH selectTrnIds into lcId;

 IF l_done=1 THEN

LEAVE LedgerIds_loop;

 END IF;
 
SELECT timeStatmp;
 
SELECT lc.lc_manager_expirely_time, psl.ps_l_accrual_p_number,lc.lc_manager_no_accruals,psr.petrol_station_interest,i.interest_amount,i.interest_remaining,i.interest_id,l.loan_amount_remaining INTO expirelyTime,maxNoPAccruals,noPAccruals,interestRateAccrual,existingInterest,existInterestAmountRemain,interestId,loanAmountR FROM lc_manager lc INNER JOIN loans l ON lc.fk_loans_id_lc_manager=l.loans_id INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id INNER JOIN users u ON c.fk_user_id_created_by_customers=u.users_id INNER JOIN petrol_station ps ON u.fk_petrol_station_id_users=ps.petrol_station_id INNER JOIN petrol_station_rates psr ON psr.fk_petrol_station_id_petrol_station_rates=ps.petrol_station_id INNER JOIN ps_l_accrual_p psl ON psl.fk_petrol_station_id_ps_l_accrual_p=ps.petrol_station_id  INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id  WHERE lc.lc_manager_id=lcId;


-- SELECT lp.loan_amount_remaining INTO loanAmountR FROM loan_payments lp INNER JOIN loans l ON lp.fk_loans_id_loan_payment=l.loans_id INNER JOIN interest i ON i.fk_loans_id_interest=l.loans_id INNER JOIN lc_manager lc ON lc. fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_id=lcId ORDER BY lp.loan_payments_id DESC LIMIT 1;

-- SELECT ip.interest_amount_remaining,ip.no_days_paid INTO existInterestAmountRemain,n FROM interest_payments ip INNER JOIN interest i ON ip. fk_interest_id_interest_payment=i.interest_id INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id INNER JOIN lc_manager lc ON lc.fk_loans_id_lc_manager=l.loans_id WHERE lc.lc_manager_id=lcId ORDER BY ip.interest_payments_id DESC LIMIT 1;


IF expirelyTime<=timeStatmp THEN

SET interestCPMPU=ROUND(((loanAmountR*interestRateAccrual)/100));
SELECT interestCPMPU;

SET NewExistInterestAmountRemain=existInterestAmountRemain+interestCPMPU;

SET NewExistingInterest=existingInterest+interestCPMPU;

SELECT NewExistingInterest;

SET newnoPAccruals=noPAccruals+1;
SELECT newnoPAccruals;
SET newexpirelyTime=expirelyTime + INTERVAL 24 HOUR;
SELECT newexpirelyTime;

UPDATE interest SET interest_amount=NewExistingInterest,interest_remaining=NewExistInterestAmountRemain WHERE interest_id=interestId;


INSERT INTO interest_payments VALUES(NULL,interestCPMPU,0,NewExistInterestAmountRemain,CURRENT_TIMESTAMP,interestId);


UPDATE lc_manager SET lc_manager_expirely_time=newexpirelyTime,lc_manager_no_accruals=newnoPAccruals WHERE lc_manager_id=lcId;

IF newnoPAccruals>=maxNoPAccruals THEN

UPDATE lc_manager SET lc_manager_status=2 WHERE lc_manager_id=lcId;

END IF;


END IF;


SET l_done=0;

 END LOOP LedgerIds_loop;



CLOSE selectTrnIds;

END ##
DELIMITER ;















DROP PROCEDURE IF EXISTS theOutstandInterestNowX;

DELIMITER ##

CREATE PROCEDURE theOutstandInterestNowX(IN numberPlate VARCHAR(45)) READS SQL DATA BEGIN

  SELECT i.interest_remaining AS the_interest from interest i INNER JOIN loans l ON i.fk_loans_id_interest=l.loans_id INNER JOIN customers c ON l.fk_customers_id_loans=c.customers_id WHERE l.loan_status=1 AND  c.customers_number_plate=numberPlate;

END ##

DELIMITER ;


DROP PROCEDURE IF EXISTS waiveInterstIncome;

DELIMITER ##

CREATE PROCEDURE waiveInterstIncome(IN data JSON) READS SQL DATA BEGIN


END ##

DELIMITER ;

  

  


  
DROP PROCEDURE IF EXISTS getTheNowServiceStations;
DELIMITER ##
CREATE PROCEDURE   getTheNowServiceStations() 
BEGIN

SELECT tst.petrol_station_id AS service_point_id,tst.petrol_station_name AS service_point_name FROM petrol_station tst ;

END ##
DELIMITER ;


/* COUNT ALL USER ROLES */
DROP PROCEDURE IF EXISTS theWhiteListExitsHow;

DELIMITER ##

CREATE PROCEDURE   theWhiteListExitsHow(IN thePhoneNumber VARCHAR(45)) 

BEGIN

SELECT COUNT(users_id) AS whiteListed FROM white_users  WHERE users_contact=thePhoneNumber;

END ##

DELIMITER ;




/* COUNT ALL USER ROLES */
DROP PROCEDURE IF EXISTS individualLoanStatment;

DELIMITER ##

CREATE PROCEDURE   individualLoanStatment(IN numberPlate VARCHAR(45)) 
BEGIN

select DATE_FORMAT(DATE(gl.trn_date),"%d/%m/%Y") AS dateN,TIME(gl.trn_date) AS timeN,gl.trn_type,gl.trn_debit,gl.trn_credit from trn_general_ledger gl INNER JOIN trn_customer_details tcd ON tcd.fk_trn_general_ledger_id_trn_customer_details=gl.trn_general_ledger_id WHERE tcd.trn_number_plate=numberPlate;

END ##

DELIMITER ;
-- 'UES 172P'

/* CALL ledgerStatement('{"user_id":100000023,"user_station":509,"current_date":"01/09/2020"}') */


DROP PROCEDURE IF EXISTS generalLedgerShiftAll;

DELIMITER ##

CREATE PROCEDURE generalLedgerShiftAll(IN data JSON) READS SQL DATA BEGIN
DECLARE DATE,TIME,TYPE,NUMBER_PLATE VARCHAR(60);
DECLARE DEBIT,CREDIT,RUNNING_BALANCE,openingBal DOUBLE;
DECLARE l_done,glIds INT;

DECLARE forSelectingGeneralLedgerTxns CURSOR FOR SELECT trn_general_ledger_id  FROM trn_general_ledger WHERE fk_petrol_station_id_trn_general_ledger=JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station')) AND DATE(trn_date)=JSON_UNQUOTE(JSON_EXTRACT(data, '$.current_date')) AND TIME(trn_date)>='00:00:00' AND TIME(trn_date)<='23:59:59';

DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_done=1;


DROP TABLE IF EXISTS temp_ledger;

CREATE TEMPORARY  TABLE temp_ledger(id INT,trn_date VARCHAR(60),trn_time VARCHAR(60),trn_type VARCHAR(60),number_plate VARCHAR(45),debit_amount DOUBLE,credit_amount DOUBLE,running_balance DOUBLE);

SELECT the_balance INTO openingBal FROM balance_per_day WHERE  DATE(trn_date)=DATE_SUB(JSON_UNQUOTE(JSON_EXTRACT(data, '$.current_date')),INTERVAL 1 DAY) AND  fk_petrol_station_id_balance_per_day=JSON_UNQUOTE(JSON_EXTRACT(data, '$.user_station'));

OPEN forSelectingGeneralLedgerTxns;
SET @RUNNING_BALANCE=openingBal;

SET @TOTAL_DEBIT=0;

SET @TOTAL_CREDIT=0;

SET @ID=0;
INSERT INTO temp_ledger VALUES(NULL,'OPENING BALANCE',NULL,NULL,NULL,NULL,NULL,openingBal);

accounts_loop: LOOP 
FETCH forSelectingGeneralLedgerTxns into glIds;
  
IF l_done=1 THEN
LEAVE accounts_loop;
END IF;
 
 SELECT DATE_FORMAT(DATE(trn_date),"%d/%m/%Y"),TIME(trn_date),trn_type,trn_debit,trn_credit INTO DATE,TIME,TYPE,DEBIT,CREDIT FROM trn_general_ledger WHERE trn_general_ledger_id=glIds;

 SELECT c.trn_number_plate INTO NUMBER_PLATE FROM trn_customer_details c INNER JOIN trn_general_ledger g ON c.fk_trn_general_ledger_id_trn_customer_details=g.trn_general_ledger_id WHERE g.trn_general_ledger_id=glIds;

 IF ISNULL(NUMBER_PLATE) THEN 
 SET NUMBER_PLATE="WITHDRAWAL/DEPOSIT";
 END IF;

SET @RUNNING_BALANCE=@RUNNING_BALANCE+DEBIT-CREDIT;

SET @TOTAL_DEBIT=@TOTAL_DEBIT+DEBIT;

SET @TOTAL_CREDIT=@TOTAL_CREDIT+CREDIT;


SET @ID=@ID+1;

IF DEBIT=0 THEN

SET DEBIT=NULL;

END IF;

IF CREDIT=0 THEN

SET CREDIT=NULL;

END IF;


INSERT INTO temp_ledger VALUES(@ID,DATE,TIME,TYPE,NUMBER_PLATE,DEBIT,CREDIT,@RUNNING_BALANCE);

SET l_done=0;
END LOOP accounts_loop;
CLOSE forSelectingGeneralLedgerTxns;

SET @NET_BALANCE=@TOTAL_DEBIT-@TOTAL_CREDIT;

INSERT INTO temp_ledger VALUES(NULL,'TOTAL/NET BALANCE',NULL,NULL,NULL,@TOTAL_DEBIT,@TOTAL_CREDIT,@NET_BALANCE);


SELECT * FROM temp_ledger;
END ##
DELIMITER ;
