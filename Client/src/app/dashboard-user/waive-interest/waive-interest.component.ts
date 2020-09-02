import { Observable } from 'rxjs';
import { Component, OnInit, ViewChild, ElementRef } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { DashboardUserService } from 'src/app/services/dashboard-user.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router, ActivatedRoute } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import { CustomValidator } from 'src/app/validators/custom-validator';
import { InterestOut } from 'src/app/models/interest-out';
import * as jwt_decode from 'jwt-decode';
import { CustomerPayStatement } from 'src/app/models/customer-pay-statement';
@Component({
  selector: 'app-waive-interest',
  templateUrl: './waive-interest.component.html',
  styleUrls: ['./waive-interest.component.scss']
})
export class WaiveInterestComponent implements OnInit {



    @ViewChild('cusname', {static: false}) cusname: ElementRef;
    hasRights: boolean;
    registered = false;
    submitted = false;
    errored = false;
    posted = false;
    userForm: FormGroup;
    serviceErrors: any = {};
    value: string;
    client: any;
   outstandInterest$: Observable <InterestOut[]>;
   indiLoanStatement$: Observable <CustomerPayStatement[]>;
   thePlate: string;
   numberValue: number;
   values: any;
    constructor(
      private authService: AuthServiceService,
      private adminUserService: DashboardUserService,
      private spinner: NgxSpinnerService,
      private router: Router,
      private alertService: AlertService,
      private actRoute: ActivatedRoute
    ) {}

    ngOnInit() {
      // this.showAllClients();
      this.userForm = this.createFormGroup();


      this.actRoute.paramMap.subscribe(
        params => {

          this.userForm.patchValue({

            number_plate: params.get('plate')

          });
          this.  thePlate = params.get('plate');

   });

      this. outstandInterest$ = this.adminUserService.getTheOutStandItnesNow(this.  thePlate);

      this.indiLoanStatement$ = this.adminUserService.getTheMiniLoanStatement(this.  thePlate);

    }

// getTheOutInt(){


// }


onKey(event: any) {
  // without type info
  this.values = event.target.value.replace(/[\D\s\._\-]+/g, '');

  this.numberValue = this.values ? parseInt(this.values, 10) : 0;

  // tslint:disable-next-line:no-unused-expression
  this.values =
    this.numberValue === 0 ? '' : this.numberValue.toLocaleString('en-US');

  this.userForm.controls.interest_to_wave.setValue(this.values);
}
    createFormGroup() {
      return new FormGroup({

        number_plate: new FormControl(''),

        interest_to_wave: new FormControl(
          '',
          Validators.compose([
            Validators.required,
            CustomValidator.patternValidator(/\d/, { hasNumber: true }),
            Validators.maxLength(6),
            Validators.minLength(1)
          ])
        ),

      });
    }

    revert() {
      this.userForm.reset();
    }

    // resetStageNames() {
    //   this.userForm.controls.stage_name.reset();
    // }

    get fval() {
      return this.userForm.controls;
    }



    onSubmit() {

      this.submitted = true;
      // this.spinner.show();

      this.userForm.patchValue({
        interest_to_wave: parseInt( this.userForm.controls.amount_to_borrow.value.replace(/[\D\s\._\-]+/g, ''), 10 )
    });

      if (this.userForm.invalid === true) {
        return;
      } else {
        this.userForm.patchValue({
          user_station: jwt_decode(this.authService.getJwtToken()).user_station,
          user_id: jwt_decode(this.authService.getJwtToken()).user_id,

        });

        this.adminUserService.waiveInterestNow(this.userForm).subscribe(
          () => {
            this.posted = true;
            this.spinner.hide();

            // tslint:disable-next-line:max-line-length
            this.alertService.success({
              html:
                '<b>Interest  was Successfully waived!!</b>'
            });
            this.revert();
            setTimeout(() => {
              this.router.navigate(['dashboarduser/loans']);
            }, 1000);
          },

          (error: string) => {
            this.errored = true;
            this.serviceErrors = error;
            this.alertService.danger({
              html: '<b>' + this.serviceErrors + '</b>' + '<br/>'
            });
            this.spinner.hide();
            setTimeout(() => {
              this.router.navigate(['dashboarduser/loans']);
            }, 1000);
          }
        );
      }
    }



}
