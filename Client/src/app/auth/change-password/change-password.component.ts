import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { CustomValidator } from 'src/app/validators/custom-validator';
import * as jwt_decode from 'jwt-decode';
import { Observable } from 'rxjs';
import { UserRole } from 'src/app/models/user-role';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import { NgxSpinnerService } from 'ngx-spinner';
import { LayoutManageService } from 'src/app/services/layout-manage.service';
@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  styleUrls: ['./change-password.component.scss']
})
export class ChangePasswordComponent implements OnInit {

  registered = false;
  submitted = false;
  errored = false;
  posted = false;
  userForm: FormGroup;
  loginStatus: string;
  fieldType: boolean;
  value: string;
  stationBalanceExits: boolean;
  mySubscription: any;
  userRoleInfo1$: Observable<UserRole[]>;
  serviceErrors: any = {};
  // initialSetUpData: SetupData[];

  constructor(
    private authService: AuthServiceService,

    private router: Router,
    private alertService: AlertService,
    private spinner: NgxSpinnerService,
    private layoutService: LayoutManageService
  ) {}
  ngOnInit() {

    this.userForm = this.createFormGroup();
  }


  createFormGroup() {
    return new FormGroup({

      main_contact_number: new FormControl('', Validators.compose([Validators.required,
      CustomValidator.patternValidator(/\d/, { hasNumber: true }),
      Validators.maxLength(10), Validators.minLength(10)
      ])),

      user_role11: new FormControl('', Validators.compose([Validators.required,
        // CustomValidator.
        //   patternValidator(
        //     /^(([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9]))$/, { hasNumber: true })
        //
      ])
      ),

      password: new FormControl('', Validators.compose(
        [

          // 1. Password Field is Required

          Validators.required

        ]))
    });
  }

  // revert() {
  //   this.userForm.reset();
  // }

  get fval() { return this.userForm.controls; }





      toggleFieldType() {
        this.fieldType = !this.fieldType;
      }



          login() {
      this.submitted = true;

      this.spinner.show();

      if (this.userForm.invalid === true) {
        return;
      } else {
        this.authService
          .loginNormalUser(this.userForm)

          .subscribe(
            (success: boolean) => {
              if (success) {
                this.posted = true;

                if (
                  jwt_decode(this.authService.getJwtToken()).user_status ===
                  'Created'
                ) {
                  this.alertService.danger({
                    html:
                      '<strong>This account Requires Approval first, please contact system admin!!</strong>'
                  });
                  this.spinner.hide();
                  return;
                } else if (
                  jwt_decode(this.authService.getJwtToken()).user_status ===
                  'Approved'
                ) {
                  if (
                    jwt_decode(this.authService.getJwtToken()).user_role === 1000
                  ) {
                    this.alertService.success({
                      html: '<strong>Signed In Successfully!!</strong>'
                    });
                    // if (!this.stationBalanceExits) {

                    // } else {
                    this.alertService.success({
                      html:
                        '<strong>Signed In Successfully into pump user module!!</strong>'
                    });
                    this.spinner.hide();
                    setTimeout(() => {
                      this.spinner.hide();

                      this.layoutService.emitChangePumpUser(true);
                      this.layoutService.emitLoginLogout(true);
                      this.router.navigate(['dashboardpump/shiftmanagement']);
                      // location.reload();
                    }, 1000);

                    // }
                  } else if (
                    jwt_decode(this.authService.getJwtToken()).user_role === 1001
                  ) {
                    this.spinner.hide();
                    setTimeout(() => {
                      this.layoutService.emitChangeAdminUser(true);
                      this.layoutService.emitLoginLogout(true);
                      this.router.navigate(['dashboarduser/loans']);
                    }, 1000);
                  } else if (
                    jwt_decode(this.authService.getJwtToken()).user_role === 1002
                  ) {
                    this.spinner.hide();
                    setTimeout(() => {
                      this.router.navigate([
                        'superuserdashboard/thesuperuserdashboard'
                      ]);
                    }, 1000);
                  } else {
                    this.alertService.danger({
                      html: '<strong>User not registered for this role!!</strong>'
                    });
                    this.spinner.hide();
                  }
                } else if (
                  jwt_decode(this.authService.getJwtToken()).user_status ===
                  'Deactivated'
                ) {
                  this.alertService.danger({
                    html:
                      '<strong>This account has been deactivated!!, please contact system admin!!</strong>'
                  });
                  this.spinner.hide();
                  return;
                }
              } else {
                this.spinner.hide();
                this.errored = true;
              }
            },

            (error: string) => {
              this.spinner.hide();
              this.errored = true;
              this.loginStatus = error;
              // this.alertService.danger(this.loginStatus);
              this.alertService.danger({
                html: '<b>' + this.loginStatus + '</b>' + '<br/>'
              });
              // this.alertService.warning({html: '<b>Signed In Successfully</b>'});
              if (
                this.loginStatus === 'Authorisation Failed!! User Not Registered'
              ) {
                setTimeout(() => {
                  this.router.navigate(['userDashboard/registeruser']);
                }, 1000);
              }
              this.spinner.hide();

            }
          );
      }
    }








}
