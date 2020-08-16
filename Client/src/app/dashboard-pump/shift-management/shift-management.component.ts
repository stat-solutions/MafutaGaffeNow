import { Component, OnInit } from '@angular/core';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
import * as jwt_decode from 'jwt-decode';
import { FormGroup, FormControl } from '@angular/forms';
import { LayoutManageService } from 'src/app/services/layout-manage.service';
@Component({
  selector: 'app-shift-management',
  templateUrl: './shift-management.component.html',
  styleUrls: ['./shift-management.component.scss']
})
export class ShiftManagementComponent implements OnInit {

  userForm: FormGroup;
  actionButton: string;
  shiftDetails: any;
  errored: boolean;
  serviceErrors: string;
  status: boolean;
  balanceEnough: boolean;
  station: string;
  theCompany: string;
  closingBal: string;

  constructor(
    private authService: AuthServiceService,
    private pumpService: DashboardPumpService,
    private spinner: NgxSpinnerService,
    private alertService: AlertService,
    private layoutService: LayoutManageService  ) { }

  ngOnInit() {
    this.station = jwt_decode(this.authService.getJwtToken()).user_station_name;
    this.theCompany = jwt_decode(this.authService.getJwtToken()).user_station_company;
    this.getTheShiftDetails();
    this.checkWhetherBalanceIsEnoughOrExists();
    this.userForm = this.createFormGroup();

  }



  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl('')
    });
  }

  get fval() { return this.userForm.controls; }

  getTheShiftDetails() {



    this.pumpService.shiftDetails(jwt_decode(this.authService.getJwtToken()).user_station).subscribe(

      (datab) => {

        this.shiftDetails = datab[0];
        this.setActionStatus();
        // this.alertService.success({ html: '<b> Shift details fetched</b>' + '<br/>' });
      },

      (error: string) => {
        this.errored = true;
        this.serviceErrors = error;
        this.alertService.danger({ html: '<b>' + this.serviceErrors + '</b>' + '<br/>' });
      });

  }


  checkWhetherBalanceIsEnoughOrExists() {

    this.pumpService.isBalanceIsEnoughOrExists(jwt_decode(this.authService.getJwtToken()).user_station_name).subscribe(

      (datak) => {
        this.alertService.success({ html: '<b>en' + this.balanceEnough + '</b>' + '<br/>' });
        this.balanceEnough = datak;
       
        this.setActionStatus();
        // this.alertService.success({ html: '<b> Shift details fetched</b>' + '<br/>' });
      },

      (error: string) => {
        this.errored = true;
        this.serviceErrors = error;
        this.alertService.danger({ html: '<b>' + this.serviceErrors + '</b>' + '<br/>' });
      });




  }

  setActionStatus() {

    // console.log(this.shiftDetails.shift_status);
    if (this.shiftDetails.shift_status === 'OPENED') {
      this.layoutService.emitChangePumpUser(true);
      this.actionButton = 'Close Running Shift';
      this.closingBal = 'RUNNING BAL:';
      this.status = true;

    } else if (this.shiftDetails.shift_status === 'CLOSED') {
      this.layoutService.emitChangePumpUser(false);
      this.actionButton = 'Open New Shift';
      this.closingBal = 'CLOSING BALANCE:';
      this.status = false;
    }
  }


  updateShiftRecords() {


    this.spinner.show();

    this.userForm.patchValue({
      user_station: jwt_decode(this.authService.getJwtToken()).user_station,
      user_id: jwt_decode(this.authService.getJwtToken()).user_id
    });


    if (this.shiftDetails.shift_status === 'OPENED') {

      this.pumpService.closeOpenShift(this.userForm).subscribe(
        (data1) => {
          if (data1) {

            this.spinner.hide();

            this.alertService.success({ html: '<b> The shift was successfully closed!!</b>' + '<br/>' });

            setTimeout(() => { location.reload(); }, 2000);


          } else {

            this.alertService.warning({ html: '<b> Closing of the shift Failed!!</b>' + '<br/>' });

          }

        },

        (error: string) => {
          this.errored = true;
          this.serviceErrors = error;
          this.alertService.danger({ html: '<b>' + this.serviceErrors + '</b>' + '<br/>' });
        });




    } else if (this.shiftDetails.shift_status === 'CLOSED') {


      this.pumpService.openClosedShift(this.userForm).subscribe(
        (data2) => {

          if (data2) {

            this.spinner.hide();

            this.alertService.success({ html: '<b> The shift was successfully opened!!</b>' + '<br/>' });

            setTimeout(() => { location.reload(); }, 2000);

          } else {

            this.alertService.warning({ html: '<b> Opening of shift Failed!!</b>' + '<br/>' });

          }
        },

        (error: string) => {
          this.errored = true;
          this.serviceErrors = error;
          this.alertService.danger({ html: '<b>' + this.serviceErrors + '</b>' + '<br/>' });
        });





    }

  }

}



