import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import * as jwt_decode from 'jwt-decode';
import { NumberPlates } from 'src/app/models/number-plates';
@Component({
  selector: 'app-savings',
  templateUrl: './savings.component.html',
  styleUrls: ['./savings.component.scss']
})
export class SavingsComponent implements OnInit {

    userForm: FormGroup;
    errored: boolean;
    serviceErrors: string;
    station: string;
    theCompany: string;
    values: any;
    numberValue: number;
    numberPlates: NumberPlates[];
    // ShiftDetails[]
    constructor(
      private authService: AuthServiceService,
      private pumpService: DashboardPumpService,
      private spinner: NgxSpinnerService,
      private router: Router,
      private alertService: AlertService
    ) {}

    ngOnInit() {
      this.station = jwt_decode(this.authService.getJwtToken()).user_station_name;
      this.theCompany = jwt_decode(
        this.authService.getJwtToken()
      ).user_station_company;

      this.userForm = this.createFormGroup();
      this.getTheNumberPlates();
    }

    createFormGroup() {
      return new FormGroup({
        user_id: new FormControl(''),
        user_station: new FormControl(''),
        txn_type: new FormControl('', Validators.compose([Validators.required])),
        number_plate: new FormControl(
          '',
          Validators.compose([
            Validators.required,
            Validators.minLength(8),
            Validators.maxLength(8)
          ])
        ),
        txn_amount: new FormControl(
          '',
          Validators.compose([
            Validators.required
            // CustomValidator.patternValidator(/^\d+$/, { hasNumber: true }
            // )
          ])
        )
      });
    }

    revert() {
      this.userForm.reset();
    }
    get fval() {
      return this.userForm.controls;
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

    onKey(event: any) {
      // without type info
      this.values = event.target.value.replace(/[\D\s\._\-]+/g, '');

      this.numberValue = this.values ? parseInt(this.values, 10) : 0;

      // tslint:disable-next-line:no-unused-expression
      this.values =
        this.numberValue === 0 ? '' : this.numberValue.toLocaleString('en-US');

      this.userForm.controls.txn_amount.setValue(this.values);
    }
    postTxn() {
      this.userForm.patchValue({
        txn_amount: parseInt(
          this.userForm.controls.txn_amount.value.replace(/[\D\s\._\-]+/g, ''),
          10
        )
      });

      this.spinner.show();

      if (this.userForm.invalid === true) {
        return;
      } else {
        this.userForm.patchValue({
          user_station: jwt_decode(this.authService.getJwtToken()).user_station,
          user_id: jwt_decode(this.authService.getJwtToken()).user_id
        });

        this.pumpService.postTheTxn(this.userForm).subscribe(
          (success: boolean) => {
            if (success) {
              this.spinner.hide();
              this.alertService.warning({
                html: '<b>' + 'Txn was successfully posted!!' + '</b>' + '<br/>'
              });


              setTimeout(() => {
                this.router.navigate(['dashboarduser/cashledger']);
                location.reload();
              }, 3000);
            } else {
              this.spinner.hide();
              this.errored = true;
            }
          },

          (error: string) => {
            this.spinner.hide();
            this.errored = true;
            this.alertService.danger({ html: '<b>' + error + '</b>' + '<br/>' });

            this.spinner.hide();
          }
        );
      }
    }


}
