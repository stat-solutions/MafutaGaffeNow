import { Component, OnInit } from '@angular/core';
import { BsModalRef } from 'ngx-bootstrap';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
import { AlertService } from 'ngx-alerts';
import { CustomValidator } from 'src/app/validators/custom-validator';
import * as jwt_decode from 'jwt-decode';
import { GeneralLedgerDetails } from 'src/app/models/general-ledger-details';
import { NgxSpinnerService } from 'ngx-spinner';

@Component({
  selector: 'app-ledger-statment',
  templateUrl: './ledger-statment.component.html',
  styleUrls: ['./ledger-statment.component.scss']
})
export class LedgerStatmentComponent implements OnInit {
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
  ledgerDetails: GeneralLedgerDetails[];
  secretPin: number;
  loanLimit: number;
  amountDue: number;
  txnId: number;
  constructor(
    private authService: AuthServiceService,
    private pumpService: DashboardPumpService,
    private alertService: AlertService,
    private spinner: NgxSpinnerService,  ) {
    // this.maxDate.setDate(this.maxDate.getDate());
  }

  ngOnInit() {
    this.station = jwt_decode(this.authService.getJwtToken()).user_station_name;
    this.theCompany = jwt_decode(
      this.authService.getJwtToken()
    ).user_station_company;

    this.userForm = this.createFormGroup();
    this.fval.current_date.setValue(new Date());
    this.getTheLedgerDetailsShift();
    // this.fval.current_date.setValue(new Date());
    this.checkedOk = false;
  }



  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl(''),
      current_date: new FormControl(
        '',
        Validators.compose([Validators.required])
      ),

      // selection_options: new FormControl(
      //   { value: '', disabled: false },
      //   Validators.compose([
      //     Validators.required,
      //     CustomValidator.patternValidator(/\d/, { hasNumber: true }),
      //     Validators.maxLength(5),
      //     Validators.minLength(3)
      //   ])
      // )

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

  getTheLedgerDetailsShift() {
    this.spinner.show();
    this.userForm.patchValue({
      user_station: jwt_decode(this.authService.getJwtToken()).user_station,
      user_id: jwt_decode(this.authService.getJwtToken()).user_id,
      current_date: this.dateConverter(this.fval.current_date.value)
    });
    this.pumpService.theLedgerDetails(this.userForm).subscribe(
      data => {
        this.ledgerDetails = data;
        this.spinner.hide();
      },

      (error: string) => {
        this.errored = true;
        this.serviceErrors = error;
        this.spinner.hide();
        this.alertService.danger({
          html: '<b>' + this.serviceErrors + '</b>' + '<br/>'
        });
      }
    );
    this.fval.current_date.setValue(new Date());
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
 dateConverter1(datestring: Date): string {
    const day = datestring.getDate();
    const month = datestring.getMonth() + 1;
    const year = datestring.getFullYear();
    return   this.pad(day) + '/' + this.pad(month) + '/' + year ;
  }
}
