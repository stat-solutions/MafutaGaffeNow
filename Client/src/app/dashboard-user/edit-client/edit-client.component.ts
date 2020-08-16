import { Component, OnInit, ViewChildren, AfterViewInit, ViewChild, ElementRef } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { StageNames } from 'src/app/models/stage-names';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { DashboardUserService } from 'src/app/services/dashboard-user.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router, ActivatedRoute } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import { CustomValidator } from 'src/app/validators/custom-validator';
import * as jwt_decode from 'jwt-decode';
import { AllClients } from 'src/app/models/all-clients';
@Component({
  selector: 'app-edit-client',
  templateUrl: './edit-client.component.html',
  styleUrls: ['./edit-client.component.scss']
})
export class EditClientComponent implements OnInit, AfterViewInit  {


  @ViewChild('cusname', {static: false}) cusname: ElementRef;

  registered = false;
  submitted = false;
  errored = false;
  posted = false;
  userForm: FormGroup;
  serviceErrors: any = {};
  value: string;
  client: any;
  clientNumberPlate: string;

  theStageNames: StageNames[];

  clientDetails: AllClients[];

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
    // uez 609a
    this.stageNames();

    this.actRoute.paramMap.subscribe(
      params => {
        this.userForm.patchValue({
          customer_name: params.get('name'),
          main_contact_number: params.get('plate'),
          stage_name: params.get('stage'),
          number_plate: params.get('phone'),
          old_number_plate: params.get('phone')
        });


 });


  }

  ngAfterViewInit(): void {
    this.cusname.nativeElement.innerHTML = 'this.client';
  }
  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      user_station: new FormControl(''),
      old_number_plate: new FormControl(''),
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
      )
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

  stageNames() {
    this.adminUserService.getStageNames(jwt_decode(this.authService.getJwtToken()).user_station).subscribe(
      data => {
        // this.userForm.controls.stage_name.reset();
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

  showAllClients() {
    this.adminUserService.getAllClients(jwt_decode(this.authService.getJwtToken()).user_station).subscribe(
      data => {

       return data;

        // console.log( this.clientDetails);
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

  // getClientOne(clientId: number) {

  //  return  {... this.clientDetails.find(c => c.customers_id === clientId)};

  // }


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

      this.adminUserService.updateCustomer(this.userForm).subscribe(
        () => {
          this.posted = true;
          this.spinner.hide();

          // tslint:disable-next-line:max-line-length
          this.alertService.success({
            html:
              '<b>Customer  was Successfully updated!!</b>'
          });
          this.revert();
          setTimeout(() => {
            this.router.navigate(['dashboarduser/clients']);
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
