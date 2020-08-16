import { Component, OnInit } from '@angular/core';
import * as jwt_decode from 'jwt-decode';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import { CustomValidator } from 'src/app/validators/custom-validator';

@Component({
  selector: 'app-post',
  templateUrl: './post.component.html',
  styleUrls: ['./post.component.scss']
})
export class PostComponent implements OnInit {
  userForm: FormGroup;
  errored: boolean;
  serviceErrors: string;
  station: string;
  theCompany: string;

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
  }

  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl(''),
      txn_type: new FormControl('', Validators.compose([Validators.required])),
      txn_amount: new FormControl(
        '',
        Validators.compose([
          Validators.required,
          CustomValidator.patternValidator(/^\d+$/, { hasNumber: true })
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

  postTxn() {
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
            this.router.navigate(['dashboarduser/loans']);
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
