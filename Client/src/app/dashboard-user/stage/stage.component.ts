import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import { CustomValidator } from 'src/app/validators/custom-validator';
import * as jwt_decode from 'jwt-decode';
import { DashboardUserService } from 'src/app/services/dashboard-user.service';

@Component({
  selector: 'app-stage',
  templateUrl: './stage.component.html',
  styleUrls: ['./stage.component.scss']
})
export class StageComponent implements OnInit {
  registered = false;
  submitted = false;
  errored = false;
  posted = false;
  userForm: FormGroup;
  serviceErrors: any = {};
  value: string;
  mySubscription: any;

  constructor(
    private authService: AuthServiceService,
    private adminUserService: DashboardUserService,
    private spinner: NgxSpinnerService,
    private router: Router,
    private alertService: AlertService
  ) {}

  ngOnInit() {

    this.userForm = this.createFormGroup();

  }

  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl(''),
      stage_name: new FormControl(
        '',
        Validators.compose([Validators.required])
      ),
      chairman_name: new FormControl(
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
      )
    });
  }

  revert() {
    this.userForm.reset();
  }

  revertPetrol() {
    this.userForm.controls.petrol_station.reset();
  }

  get fval() {
    return this.userForm.controls;
  }




  onSubmit() {
    this.submitted = true;
    this.spinner.show();

    if (this.userForm.invalid === true) {
      return;
    } else {
      this.userForm.patchValue({
        user_station: jwt_decode(this.authService.getJwtToken()).user_station,
        user_id: jwt_decode(this.authService.getJwtToken()).user_id
      });

      this.adminUserService.registerStage(this.userForm).subscribe(

        () => {

          this.posted = true;
          this.spinner.hide();

          // tslint:disable-next-line:max-line-length
          this.alertService.success({ html: '<b>Stage Registration was Successful!!</b>' + '</br>' + 'Please proceed to create customers on it' });
          this.revert();

          setTimeout(() => {

          this.router.navigate(['dashboarduser/loans']);

          }, 2000);

        },



        (error: string) => {

          this.errored = true;
          this.serviceErrors = error;
          this.alertService.danger({ html: '<b>' + this.serviceErrors + '</b>' + '<br/>' });
          this.spinner.hide();
        }

      );


    }
  }
}
