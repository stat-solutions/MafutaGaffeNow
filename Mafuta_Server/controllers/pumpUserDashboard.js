var express = require('express');
var router = express.Router();
const passport = require('passport');
var serviceU=require('../services/db_services/pumpUserDashboardService');
var collections=require('../connectors/momoCollectionsConnector');
const  jwt  =  require('jsonwebtoken');
var request = require('request');
var sms = require('../services/other_services/smsService');
const SECRET_KEY = "secretkey23456";
var authDbService = require('../services/db_services/authService');
var SMS= require('../services/other_services/smsService');
passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(user, done) {
  done(null, user);
});


function verifyTokens(req,res,next){

  if(!req.headers.authorization){
    return res.status(401).send('Unauthorised Request');
  }
  
  let token=req.headers.authorization.split(' ')[1];
  
  if(token=='null'){
    return res.status(401).send('Unauthorised Request');
  }
  
  let payload=jwt.verify(token,SECRET_KEY);
  
  if(!payload){
    return res.status(401).send('Unauthorised Request');
  }
  
  req.main_contact_number=payload.user_contact;
  
  next();
  
  }
  
  

  router.get('/userSecrete', function(req, res,next) {
    serviceU.getTheUserSecret(req.query.id).then( function(results) {
          res.setHeader('Content-Type', 'application/json');
          res.json(results);
        }
        
        ).catch(next);
         });

   
  router.get('/theNumberPlates', function(req, res,next) {
    serviceU.getAllNumberPlates(req.query.id).then( function(results) {
          res.setHeader('Content-Type', 'application/json');
          res.json(results);
        }
        
        ).catch(next);
         });

         
         
  router.get('/theClientLoanable', function(req, res,next) {

    console.log(req.query.id);

        serviceU.doesTheNumberPlateExist(req.query.id).then( function(numberPlateExists) {

        if(!numberPlateExists){
         res.status(401).json('Number plate is not registered!!');

        }else{

          serviceU.doesTheBorrowerHaveAloan(req.query.id).then( function(hasLoanOnAccount) {

            if(hasLoanOnAccount){
    
              res.status(401).json('This number plate still has a running loan. Please first complete the loan!!');
            }else{

              serviceU.getLoanableDetails(req.query.id).then( function(results) {

                res.setHeader('Content-Type', 'application/json');
      console.log(results);
                res.json(results);
              }
              
              ).catch(next);
    
    
            }
    
     } ).catch(next);
    

        }

 } ).catch(next);


         });



             
  router.get('/theClientLoanPayability', function(req, res,next) {


      serviceU.doesTheBorrowerHaveAloan(req.query.id).then( function(hasLoanOnAccount) {

        if(!hasLoanOnAccount){

          res.status(401).json('This number plate has no running loan. Please you can create a loan first!!');
        }else{

          serviceU.getLoanPaymentDetails(req.query.id).then( function(results) {

            res.setHeader('Content-Type', 'application/json');
  
            res.json(results);
          }
          
          ).catch(next);


        }

 } ).catch(next);  });

 
         
      router.get('/shiftDetails', function(req, res,next) {
        serviceU.getAllShiftDetails(req.query.id).then( function(results) {
              res.setHeader('Content-Type', 'application/json');
              res.json(results);
            }
            
            ).catch(next);
             });
             

             
             router.get('/runningBalanceAll', function(req, res,next) {
              serviceU.getRunningBalanceAll(req.query.id).then( function(results) {
                    res.setHeader('Content-Type', 'application/json');
                    res.json(results);
                  }
                  
                  ).catch(next);
                   });





             router.get('/runningBalance', function(req, res,next) {
              serviceU.getRunningBalance(req.query.id).then( function(results) {
                    res.setHeader('Content-Type', 'application/json');
                    res.json(results);
                  }
                  
                  ).catch(next);
                   });



             router.post('/closeOpenShift', function(req, res,next) {
              serviceU.closeOpenShift(req.body).then( function(results) {
                    res.setHeader('Content-Type', 'application/json');
                    res.json(results);
                  }).catch(next);
                   });

                   
             router.post('/openClosedShift', function(req, res,next) {
              serviceU.openClosedShift(req.body).then( function(results) {
                    res.setHeader('Content-Type', 'application/json');
                    res.json(results);
                  } ).catch(next);
                   });


                   
             router.get('/checkBalExistEnough', function(req, res,next) {
              serviceU.getBalanceEnoughExists(req.query.id).then( function(results) {
                    res.setHeader('Content-Type', 'application/json');
                    // console.log(results);
                    res.json(results);
                  }
                  
                  ).catch(next);
                   });
             

                   router.post('/getTheRunningLoans', function(req, res,next) {
                   
                    serviceU.getTheRunningLoansService(req.body).then( function(results) {
                          res.setHeader('Content-Type', 'application/json');
                          // console.log(results);
                          res.json(results);
                        }
                        
                        ).catch(next);
                         });

                         

         
                         router.post('/getTheRevenueDetails', function(req, res,next) {
                          serviceU.theRevenueDetails(req.body).then( function(results) {
                            res.status(200).json(results);
                          }
                          ).catch(next);
                          });
            


                         
             router.post('/getTheLedgerDetails', function(req, res,next) {
              serviceU.theLedgerDetails(req.body).then( function(results) {
                res.status(200).json(results);
              }
              ).catch(next);
              });

              router.post('/postTheTxn', function(req, res,next) {
                serviceU.postTheTxnNow(req.body).then( function(results) {
                  res.status(200).json(results);
                }
                ).catch(next);
                });
              router.post('/loanRepayNow', function(req, res,next) {
                serviceU.repayLoanNow(req.body).then( function(results) {
                  res.status(200).json(results);
                }
                ).catch(next);
                });


router.post('/createLoan', function(req, res,next) {
  serviceU.createLoanNow(req.body).then( function(results) {
    res.status(200).json(results);
  }
  ).catch(next);
  });
        
  
  module.exports = router;