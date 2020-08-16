import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { Router } from '@angular/router';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { AlertService } from 'ngx-alerts';
import { LayoutManageService } from 'src/app/services/layout-manage.service';
import * as jwt_decode from 'jwt-decode';
import { AllLoansDisplay } from 'src/app/models/all-loans-display';
import { DashboardUserService } from 'src/app/services/dashboard-user.service';
import { LoanStatement } from 'src/app/models/loan-statement';
@Component({
  selector: 'app-loans',
  templateUrl: './loans.component.html',
  styleUrls: ['./loans.component.scss']
})
export class LoansComponent implements OnInit {
  userForm: FormGroup;
  actionButton: string;
  loanDetails: AllLoansDisplay[];
  errored: boolean;
  serviceErrors: string;
  status: boolean;
  balance = 1000000;
  station: string;
  theCompany: string;
  closingBal: string;
  loansDetails: LoanStatement[];
  constructor(
    private authService: AuthServiceService,
    private adminUserService: DashboardUserService,
    private spinner: NgxSpinnerService,
    private router: Router,
    private alertService: AlertService,
    private pumpService: DashboardPumpService,
  ) {}

  ngOnInit() {
    this.station = jwt_decode(this.authService.getJwtToken()).user_station_name;
    this.theCompany = jwt_decode(
      this.authService.getJwtToken()
    ).user_station_company;
    this.userForm = this.createFormGroup();
    this.getTheLoansNow();

  }

  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl(''),
      search: new FormControl(''),
      selection_options: new FormControl(
        { value: '', disabled: false },
        Validators.compose([Validators.required])
      )
    });
  }
  

  revert() {
    this.userForm.reset();
  }

  refresh() {
    location.reload();
  }
  revertPetrol() {
    this.userForm.controls.petrol_station.reset();
  }

  get fval() {
    return this.userForm.controls;
  }

  // Time	Number plate	Amount	Description
  getTheLoansNow() {
    if (this.userForm.controls.selection_options.value === '') {
      this.userForm.patchValue({
        selection_options: 'RUNNING LOANS'
      });

    }
    // console.log(jwt_decode(this.authService.getJwtToken()).user_id);
    this.userForm.patchValue({
      user_id: jwt_decode(this.authService.getJwtToken()).user_id,
      user_station: jwt_decode(this.authService.getJwtToken()).user_station
    });


    this.pumpService
      .theRunningLoans(this.userForm)
      .subscribe(
        data => {
          this.loansDetails = data;
        },

        (error: string) => {
          this.errored = true;
          this.serviceErrors = error;
          this.alertService.danger({
            html: '<b>' + this.serviceErrors + '</b>' + '<br/>'
          });
        }
      );
  }
}
