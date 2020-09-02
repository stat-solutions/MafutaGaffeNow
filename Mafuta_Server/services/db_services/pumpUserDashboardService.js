var dbconnection = require('../../connectors/dbConnector');



exports.postTheTxnNow = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL postTheTxnNow("+ "'" + JSON.stringify(data) + "'" +")";
  console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}



exports.createLoanNow = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL createLoanNow("+ "'" + JSON.stringify(data) + "'" +")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}



exports.repayLoanNow = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL repayLoanNow("+ "'" + JSON.stringify(data) + "'" +")";
  console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}


exports.getRunningBalance = function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL getRunningBalance("+"'"+station+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}



exports.getRunningBalanceAll = function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL getRunningBalanceAll()";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}



exports.theRevenueDetails = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL getTheRevenueFromLoans("+"'"+JSON.stringify(data)+"'"+")";
  console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}



exports.getTheRunningLoansService = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL getTheLoans("+"'"+JSON.stringify(data)+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}




exports.getAllShiftDetails = function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL shiftDetailsPumpUser("+"'"+station+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}




exports.getLoanPaymentDetails = function (numberPlate) {

  return new Promise(function (resolve,next) {

    var sql = "CALL getLoanPaymentDetails("+"'"+numberPlate+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}

exports.getLoanableDetails = function (numberPlate) {

  return new Promise(function (resolve,next) {

    var sql = "CALL getLoanableDetails("+"'"+numberPlate+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}

exports.getTheUserSecret
= function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL scretePIN("+"'"+station+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      // console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}


exports.getAllNumberPlates = function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL getAllNumberPlates("+"'"+station+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {
      console.log(results[0]);

      resolve(results[0]);
    }
  });
});

}





exports.theLedgerDetails = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL generalLedgerShiftAll(" + "'" + JSON.stringify(data)+"'"+ ")";

    console.log(sql);
    
    dbconnection.query(sql, null, function (error, results, fields) {
      if (error) {
        return next(error);
      } else {

          //  console.log(results[0]);

        resolve(results[0]);
      }
    });

  }

  );

 
}


exports.registerGroupService = function (data, next) {

  return new Promise(function (resolve) {

    var sql = "CALL registerGroupService(" + "'" + JSON.stringify(data)+"'"+ ")";

    // console.log(sql);
    dbconnection.query(sql, null, function (error, results, fields) {
      if (error) {
        return next(error);
      } else {

      }
    });
    resolve("Registered Successfully");
  }

  );

 
}




exports.closeOpenShift = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL closeOpenShift("+"'"+JSON.stringify(data)+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {

      // console.log(results[0][0].completed>0);

     resolve(Boolean(results[0][0].completed>0));
    }
  });
});

}




exports.openClosedShift = function (data) {

  return new Promise(function (resolve,next) {

    var sql = "CALL openClosedShift("+"'"+JSON.stringify(data)+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {

      // console.log(results[0][0].completed>0);

     resolve(Boolean(results[0][0].completed>0));
    }
  });
});

}





exports.getBalanceEnoughExists = function (station) {

  return new Promise(function (resolve,next) {

    var sql = "CALL isStationBalanceEnoughOrExists("+"'"+station+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {

      // console.log(results[0][0].Balexists>0);

     resolve(Boolean(results[0][0].Balexists>0));
    }
  });
});

}


exports.doesTheNumberPlateExist = function (numberPlate) {

  return new Promise(function (resolve,next) {

    var sql = "CALL numberPlateAlreadyExists("+"'"+numberPlate+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {

      // console.log(results[0][0].Balexists>0);

     resolve(Boolean(results[0][0].number_plate_exists>0));
    }
  });
});
}






exports.doesTheBorrowerHaveAloan = function (numberPlate) {

  return new Promise(function (resolve,next) {

    var sql = "CALL borrowerHasLoanWithCompany("+"'"+numberPlate+"'"+")";
  // console.log(sql);
  dbconnection.query(sql, null, function (error, results, fields) {
    if (error) {
      return next(error);
    } else {

      // console.log(results[0][0].has_a_loan>0);

     resolve(Boolean(results[0][0].has_a_loan>0));
    }
  });
});

}