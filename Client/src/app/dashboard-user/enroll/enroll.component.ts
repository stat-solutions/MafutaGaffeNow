import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import { CustomValidator } from 'src/app/validators/custom-validator';
import { DashboardUserService } from 'src/app/services/dashboard-user.service';
import { StageNames } from 'src/app/models/stage-names';
import * as jwt_decode from 'jwt-decode';

@Component({
  selector: 'app-enroll',
  templateUrl: './enroll.component.html',
  styleUrls: ['./enroll.component.scss']
})
export class EnrollComponent implements OnInit {
  registered = false;
  submitted = false;
  errored = false;
  posted = false;
  userForm: FormGroup;
  serviceErrors: any = {};
  value: string;
  numberValue: number;
  values: any;
  theStageNames: StageNames[];

  constructor(
    private authService: AuthServiceService,
    private adminUserService: DashboardUserService,
    private spinner: NgxSpinnerService,
    private router: Router,
    private alertService: AlertService
  ) {}

  ngOnInit() {
    this.userForm = this.createFormGroup();
    this.stageNames();
  }

  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl(''),
      customer_name: new FormControl(
        '',
        Validators.compose([Validators.required])
      ),
      main_contact_number: new FormControl(
        '',
        Validators.compose([
          Validators.required,
          CustomValidator.patternValidator(
            /^(([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9]))$/,
            { hasNumber: true }
          )
        ])
      ),
      stage_name: new FormControl(
        '',
        Validators.compose([Validators.required])
      ),
      comment: new FormControl(
        '',
        Validators.compose([Validators.required])
      ),

      loan_limit: new FormControl('',
        Validators.compose([
          Validators.required,
          CustomValidator.patternValidator(/\d/, { hasNumber: true }),
          Validators.maxLength(6),
          Validators.minLength(3)
        ])
      ),

      number_plate: new FormControl(
        '',
        Validators.compose([
          Validators.required,
          Validators.minLength(8),
          Validators.maxLength(8),
          CustomValidator.patternValidator(
            /^(([U])([A-Z])([A-Z])(\s)([0-9])([0-9])([0-9])([A-Z]))$/,
            { beUgandanNumberPlate: true }
          )
        ])
      ),

      national_id: new FormControl(
        '',
        Validators.compose([
          Validators.required,
          Validators.minLength(14),
          Validators.maxLength(14),
          // CustomValidator.patternValidator(
          //   /^(([U])([A-Z])([A-Z])(\s)([0-9])([0-9])([0-9])([A-Z]))$/,
          //   { beUgandanNumberPlate: true }
          // )
        ])
      )
    });
  }

  revert() {
    this.userForm.reset();
  }
  onKey(event: any) {
    // without type info
    this.values = event.target.value.replace(/[\D\s\._\-]+/g, '');

    this.numberValue = this.values ? parseInt(this.values, 10) : 0;

    // tslint:disable-next-line:no-unused-expression
    this.values =
      this.numberValue === 0 ? '' : this.numberValue.toLocaleString('en-US');

    this.userForm.controls.loan_limit.setValue(this.values);
  }


  resetStageNames() {
    this.userForm.controls.stage_name.reset();
  }

  get fval() {
    return this.userForm.controls;
  }

  stageNames() {
    this.adminUserService.getStageNames(jwt_decode(this.authService.getJwtToken()).user_station).subscribe(
      data => {
        this.userForm.controls.stage_name.reset();
        this.theStageNames = data;
        // this.alertService.success({ html: '<b> User Roles Updated</b>' + '<br/>' });
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

  onSubmit() {
    this.submitted = true;
    this.spinner.show();
    this.userForm.patchValue({
      loan_limit: parseInt( this.userForm.controls.loan_limit.value.replace(/[\D\s\._\-]+/g, ''), 10 )
    });
    if (this.userForm.invalid === true) {
      return;
    } else {
      this.userForm.patchValue({
        user_station: jwt_decode(this.authService.getJwtToken()).user_station,
        user_id: jwt_decode(this.authService.getJwtToken()).user_id
      });

      this.adminUserService.registerCustomer(this.userForm).subscribe(
        () => {
          this.posted = true;
          this.spinner.hide();

          // tslint:disable-next-line:max-line-length
          this.alertService.success({
            html:
              '<b>Customer Registration was Successful!!</b>' +
              '</br>' +
              'Please proceed to lend him'
          });
          this.revert();
          setTimeout(() => {
            this.router.navigate(['dashboarduser/loans']);
          }, 2000);
        },

        (error: string) => {
          this.errored = true;
          this.serviceErrors = error;
          this.alertService.danger({
            html: '<b>' + this.serviceErrors + '</b>' + '<br/>'
          });
          this.spinner.hide();
        }
      );
    }
  }
}
