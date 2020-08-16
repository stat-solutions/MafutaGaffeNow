var express = require('express');
var request = require('request');
var router = express.Router();
var serviceU = require('../services/other_services/emailService');
var bodyParser = require('body-parser');
router.use(bodyParser.urlencoded({ extended: false }));
router.use(bodyParser.json());



router.post('/sendEmail',function(req, res,next) {

  console.log(req.body);
serviceU.sendEmailService(req.body,next).then( function(results) {
  console.log(req.body);
  console.log(results);

  res.status(200).json(results);
  
}

).catch(next);

});



module.exports = router;
