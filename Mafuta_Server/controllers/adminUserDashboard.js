var express = require('express');
var request = require('request');
var router = express.Router();
var bodyParser = require('body-parser');
var serviceU = require('../services/db_services/adminUserDashboardService');
var authDbService = require('../services/db_services/authService');
router.use(bodyParser.urlencoded({ extended: false }));
router.use(bodyParser.json());
var SMS = require('../services/other_services/smsService');




router.post('/updateCustomer', function(req, res,next) {
  
  serviceU.updateClient(req.body).then( function(results) {
    res.setHeader('Content-Type', 'application/json');
    res.json(results);
  }).catch(next);
 
  });

  router.post('/waiveThatInterest', function(req, res,next) {
  
    serviceU.waiveTheInterestNowNow(req.body).then( function(results) {
      res.setHeader('Content-Type', 'application/json');
      res.json(results);
    }).catch(next);
   
    });

  



router.post('/registerCustomer', function(req, res,next) {
  
  serviceU.numberPlateAlreadyExists(req.body.number_plate).then( function(resultsNP) {
     
    if(resultsNP){

res.status(401).json('Customer with the same NUMBER PLATE already exists!!!');
   
}else{
 
      serviceU.saveCustomerDetails(req.body).then( function(results) {

        const sms={
          'contanct_number':results[0].customers_phone_number,
          'message':'MAFUTA GAFFE PIN:'+results[0].secret_pin+' Togyerabira!!!'
          
        }
    
        authDbService.checkSMSBalance(next).then(function(result1){
                        
          if(result1){
        
            SMS.sendSMS(sms,next);
          }
        
        }).catch(next);
    
        res.status(200).json(results);
        
      }
      
      ).catch(next);

    }
    
    
  }).catch(next);

  });



  router.post('/registerStage', function(req, res,next) {
   
    // console.log(req.body);

    

    serviceU.chairmanContactAlreadyExists(req.body.main_contact_number).then( function(resultsCCN) {
    
      if(resultsCCN){
res.status(401).json('A chairman with the same CONTACT NUMBER already exists!!!');

      } else{

        serviceU.saveStageDetails(req.body).then( function(results) {
    
    
          res.status(200).json(results);
          
        }).catch(next);

      }
    
 
      
    }).catch(next);

    
    });
  
    
    


    router.get('/customerPayStatemnt', function(req, res,next) {
      // console.log(req.query.id);
       serviceU.getcustomerPayStatemntNow(req.query.id).then( function(results) {
         res.setHeader('Content-Type', 'application/json');
         res.json(results);
       } ).catch(next);});

    router.get('/outstandInterestNow', function(req, res,next) {
      // console.log(req.query.id);
       serviceU.theOutStandingInt(req.query.id).then( function(results) {
         res.setHeader('Content-Type', 'application/json');
         res.json(results);
       } ).catch(next);});
    




  router.get('/allClients', function(req, res,next) {
    // console.log(req.query.id);
     serviceU.getAllTheClientsDetails(req.query.id).then( function(results) {
       res.setHeader('Content-Type', 'application/json');
       res.json(results);
     } ).catch(next);});

  router.get('/stageNames', function(req, res,next) {
   console.log(req.query.id);
    serviceU.getTheStageNames(req.query.id).then( function(results) {
      res.setHeader('Content-Type', 'application/json');
      res.json(results);
    } ).catch(next);});


    router.get('/getAllLoansDetails', function(req, res,next) {
   
      serviceU.getAllLoansDetailsNow().then( function(results) {
        res.setHeader('Content-Type', 'application/json');
        res.json(results);
      } ).catch(next);});

module.exports = router;