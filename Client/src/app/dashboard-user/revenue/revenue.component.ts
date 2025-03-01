import { Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
import { AlertService } from 'ngx-alerts';
import { CustomValidator } from 'src/app/validators/custom-validator';
import * as jwt_decode from 'jwt-decode';
import { RevenueDetails } from 'src/app/models/revenue-details';
@Component({
  selector: 'app-revenue',
  templateUrl: './revenue.component.html',
  styleUrls: ['./revenue.component.scss']
})
export class RevenueComponent implements OnInit {
  currentDate = new Date();
  // maxDate = new Date();
  modalRef: BsModalRef;
  userForm: FormGroup;
  posted = false;
  actionButton: string;
  shiftDetails: any;
  errored: boolean;
  serviceErrors: string;
  status: boolean;
  checkedOk: boolean;
  station: string;
  theCompany: string;
  closingBal: string;
  revenueDetails: RevenueDetails[];
  secretPin: number;
  loanLimit: number;
  amountDue: number;
  txnId: number;
  constructor(
    private authService: AuthServiceService,
    private pumpService: DashboardPumpService,
    private alertService: AlertService  ) {
    // this.maxDate.setDate(this.maxDate.getDate());
  }

  ngOnInit() {
    this.station = jwt_decode(this.authService.getJwtToken()).user_station_name;
    this.theCompany = jwt_decode(
      this.authService.getJwtToken()
    ).user_station_company;
    this.userForm = this.createFormGroup();
    this.checkedOk = false;
    this. getTheRevenueDetails();
  }

  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl(''),
      start_date: new FormControl(
        '',
        Validators.compose([Validators.required])
      ),
      end_date: new FormControl(''),

      // selection_options: new FormControl(
      //   { value: '', disabled: false },
      //   Validators.compose([
      //     Validators.required,
      //     CustomValidator.patternValidator(/\d/, { hasNumber: true }),
      //     Validators.maxLength(5),
      //     Validators.minLength(3)
      //   ])
      // )
      // dateYMD: new FormControl(new Date()),
      // dateFull: new FormControl(new Date()),
      // dateMDY: new FormControl(new Date()),
      // dateRange: new FormControl([
      //   new Date(),
      //   new Date(this.currentDate.setDate(this.currentDate.getDate() + 7))
      // ])
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
  getTheRevenueDetails() {
    // console.log(this.userForm.controls.selection_options.value);

    // if (this.userForm.controls.selection_options.value === '') {
    //   this.userForm.patchValue({
    //     selection_options: 'ALL TRANSACTIONS'
    //   });
    // }
    if (this.userForm.controls.start_date.value === '') {
      this.userForm.patchValue({
        start_date: [new Date(), new Date()]
      });
    }

    this.userForm.patchValue({
      user_station: jwt_decode(this.authService.getJwtToken()).user_station,
      user_id: jwt_decode(this.authService.getJwtToken()).user_id,
      start_date: this.dateConverter(
        this.userForm.controls.start_date.value[0]
      ),
      end_date: this.dateConverter(this.userForm.controls.start_date.value[1])
    });
    this.pumpService.theRevenueDetailsAll(this.userForm).subscribe(
      data => {
        this.revenueDetails = data;
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
  pad(n) {
    return n < 10 ? '0' + n : n;
  }
  dateConverter(datestring: Date): string {
    const day = datestring.getDate();
    const month = datestring.getMonth() + 1;
    const year = datestring.getFullYear();
    return year + '-' + this.pad(month) + '-' + this.pad(day);
  }
}
