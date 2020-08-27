import { Component, OnInit, ViewContainerRef } from '@angular/core';
import * as jwt_decode from 'jwt-decode';
import { BsModalRef, BsModalService } from 'ngx-bootstrap';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { NumberPlates } from 'src/app/models/number-plates';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { Router } from '@angular/router';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { AlertService } from 'ngx-alerts';
import { LayoutManageService } from 'src/app/services/layout-manage.service';
import { ModalDialogService } from 'ngx-modal-dialog';
import { CustomValidator } from 'src/app/validators/custom-validator';
import { LendDialogComponent } from '../lend-dialog/lend-dialog.component';
import { PaymentDialogComponent } from '../payment-dialog/payment-dialog.component';

@Component({
  selector: 'app-payment',
  templateUrl: './payment.component.html',
  styleUrls: ['./payment.component.scss']
})
export class PaymentComponent implements OnInit {
  modalRef: BsModalRef;
  userForm: FormGroup;
  actionButton: string;
  shiftDetails: any;
  errored: boolean;
  serviceErrors: string;
  status: boolean;
  checkedOk: boolean;
  fieldType: boolean;
  station: string;
  theCompany: string;
  closingBal: string;
  numberPlates: NumberPlates[];
  loanDetails: any;
  secretPin: number;
  amountDue: number;
  txnId: number;
  posted: boolean;
  values: string;
  numberValue: number;
  constructor(
    private authService: AuthServiceService,
    private router: Router,
    private pumpService: DashboardPumpService,
    private spinner: NgxSpinnerService,
    private alertService: AlertService,
    private layoutService: LayoutManageService,
    private modalService: ModalDialogService,
    private viewRef: ViewContainerRef,
    private modalServiceb: BsModalService
  ) {}

  ngOnInit() {
    this.station = jwt_decode(this.authService.getJwtToken()).user_station_name;
    this.theCompany = jwt_decode(
      this.authService.getJwtToken()
    ).user_station_company;
    this.getTheNumberPlates();
    this.userForm = this.createFormGroup();
    this.checkedOk = false;
  }

  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl(''),
      number_plate: new FormControl(
        '',
        Validators.compose([
          Validators.required,
          Validators.minLength(8),
          Validators.maxLength(8)
        ])
      ),

      amount_to_pay: new FormControl(
        { value: '', disabled: true },
        Validators.compose([
          Validators.required,
          CustomValidator.patternValidator(/\d/, { hasNumber: true }),
          Validators.maxLength(6)
        ])
      ),
      pin: new FormControl(
        { value: '', disabled: true },
        Validators.compose([
          Validators.required,
          CustomValidator.patternValidator(/\d/, { hasNumber: true }),
          Validators.maxLength(4),
          Validators.minLength(4)
        ])
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

  onKey(event: any) {
    // without type info
    this.values = event.target.value.replace(/[\D\s\._\-]+/g, '');

    this.numberValue = this.values ? parseInt(this.values, 10) : 0;

    // tslint:disable-next-line:no-unused-expression
    this.values =
      this.numberValue === 0 ? '' : this.numberValue.toLocaleString('en-US');
    this.userForm.controls.amount_to_pay.setValue(this.values);
  }

  openModal() {
    this.modalRef = this.modalServiceb.show(PaymentDialogComponent, {
      initialState: {
        title: 'Loan Repayment',
        data: {
          number_plate: this.userForm.controls.number_plate.value,
          amount_to_pay: this.userForm.controls.amount_to_pay.value,
          amount_due: this.amountDue,
          txn_id: this.txnId
        }
      }
    });
  }
  getTheNumberPlates() {
    this.pumpService.theNumberPlates(this.station).subscribe(
      data => {
        this.numberPlates = data;
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

  checkLoanRepayability() {
    this.pumpService
      .checkWhetherTheCLoanPayable(this.userForm.controls.number_plate.value)
      .subscribe(
        data => {
          this.loanDetails = data[0];
          this.checkedOk = true;
          this.secretPin = this.loanDetails.secret_pin;
          this.amountDue = this.loanDetails.loan_amount_due;
          this.userForm.controls.number_plate.disable();
          this.userForm.controls.amount_to_pay.enable();
          this.userForm.controls.pin.enable();
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

    //toggle visibility of password field
    toggleFieldType() {
      this.fieldType = !this.fieldType;
    }


  pay() {
    this.userForm.patchValue({
      amount_to_pay: parseInt(
        this.userForm.controls.amount_to_pay.value.replace(/[\D\s\._\-]+/g, ''),
        10
      )
    });
    // tslint:disable-next-line:triple-equals
    if (!(this.secretPin == this.userForm.controls.pin.value)) {
      this.alertService.danger({
        html: '<b>Invalid PIN</b>'
      });
      return;
    } else {
      if (this.userForm.controls.amount_to_pay.value > this.amountDue) {
        this.alertService.warning({
          html: '<b>Amount being paid exceeded amount due!!</b>' + '<br/>'
        });
        return;
      } else {
        this.userForm.controls.number_plate.enable();

        this.userForm.patchValue({
          user_station: jwt_decode(this.authService.getJwtToken()).user_station,
          user_id: jwt_decode(this.authService.getJwtToken()).user_id
        });
        // console.log(this.userForm.value);
        this.spinner.show();
        this.pumpService.repayLoan(this.userForm).subscribe(
          result => {
            this.amountDue = result[0].amount_due;
            this.txnId = result[0].txn_id;
            this.spinner.hide();
            this.posted = true;
            this.openModal();
            this.router.navigate(['dashboardpump/shiftmanagement']);
            setTimeout(() => {
            location.reload();
            }, 3000);
          },

          (error: string) => {
            this.spinner.hide();
            this.errored = true;
            this.serviceErrors = error;
            this.alertService.danger({
              html: '<b>' + this.serviceErrors + '</b>' + '<br/>'
            });
          }
        );
      }
    }
  }
}
