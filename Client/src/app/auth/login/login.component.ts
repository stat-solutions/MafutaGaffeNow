import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import * as jwt_decode from 'jwt-decode';
import { CustomValidator } from 'src/app/validators/custom-validator';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { AlertService } from 'ngx-alerts';
import { LayoutManageService } from 'src/app/services/layout-manage.service';
import { UserRole } from 'src/app/models/user-role';
import { Observable } from 'rxjs';
import { ServicePoints } from 'src/app/models/service-points';
// import { BootstrapAlertService, BootstrapAlert } from 'ngx-bootstrap-alert';
@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {
  registered: boolean;
  submitted: boolean;
  errored: boolean;
  posted: boolean;
  whiteListedContact: boolean;
  userForm: FormGroup;
  loginStatus: string;
  fieldType: boolean;
  value: string;
  stationBalanceExits: boolean;
  mySubscription: any;
  userRoleInfo1$: Observable<UserRole[]>;

 theServicePoints$: Observable<ServicePoints[]>;

  serviceErrors: any = {};


  constructor(
    private authService: AuthServiceService,

    private router: Router,
    private alertService: AlertService,
    private spinner: NgxSpinnerService,
    private layoutService: LayoutManageService
  ) {}

  ngOnInit() {
    this.userForm = this.createFormGroup();
    this.userRoleInfo1$ = this.authService.getUserRoles();
    this.theServicePoints$ = this.authService.getAllServicePoints();
  }




  createFormGroup() {
    return new FormGroup({

      contact_white_liested: new FormControl(''),

      main_contact_number: new FormControl(
        '',
        Validators.compose([
          Validators.required,
          CustomValidator.patternValidator(/\d/, { hasNumber: true }),
          Validators.maxLength(10),
          Validators.minLength(10)
        ])
      ),

      user_role11: new FormControl(
        '',
        Validators.compose([
          Validators.required
          // CustomValidator.
          //   patternValidator(
          //     /^(([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9]))$/, { hasNumber: true })
          //
        ])
      ),

      service_points: new FormControl(
        { value: '', disabled: true },
        Validators.compose([
          Validators.required

        ])
      ),
      service_points_id: new FormControl(
        { value: '', disabled: true },
        Validators.compose([
          Validators.required

        ])
      ),
      password: new FormControl(
        '',
        Validators.compose([
          // 1. Password Field is Required

          Validators.required
        ])
      )
    });
  }



  changeBranchValue(contactNumber: any) {

    this.authService.exitingInWhiteListed(contactNumber.target.value).subscribe(

      whiteList => {

        if (whiteList[0].whiteListed > 1) {
          // console.log(roledata[0].roles);
          this.whiteListedContact = true;
          this.fval. service_points.enable();
          this.userForm.patchValue({
           contact_white_liested: this.whiteListedContact
          });

        } else {

          // console.log(roledata[0].roles);

          this.whiteListedContact = false;

          this.fval. service_points.disable();
        }

      }, (error: string) => { }

     ); }


     setTheServicePointId(event: any) {

       if (event.target.value === 'Select The User Role') {

this.fval.service_points.setErrors({required: true});

       } else {


      this.fval. service_points_id.enable();
      this.theServicePoints$.subscribe(
        servicePoints =>
          this.fval.service_points_id.setValue(servicePoints.find(
            theServicePoint => theServicePoint.service_point_name === event.target.value
          ).service_point_id) );
        }
     }


  get fval() {
    return this.userForm.controls;
  }


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


