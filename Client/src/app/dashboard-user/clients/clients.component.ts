import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { DashboardUserService } from 'src/app/services/dashboard-user.service';
import { NgxSpinnerService } from 'ngx-spinner';
import { Router } from '@angular/router';
import { AlertService } from 'ngx-alerts';
import * as jwt_decode from 'jwt-decode';
import { AllClients } from 'src/app/models/all-clients';

@Component({
  selector: 'app-clients',
  templateUrl: './clients.component.html',
  styleUrls: ['./clients.component.scss']
})
export class ClientsComponent implements OnInit {
  userForm: FormGroup;
  actionButton: string;
  clientDetails: AllClients[];
  errored: boolean;
  serviceErrors: string;
  status: boolean;
  balance = 1000000;
  station: string;
  theCompany: string;
  closingBal: string;
  constructor(
    private authService: AuthServiceService,
    private adminUserService: DashboardUserService,
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
    this.showAllClients();
// this.checkloans();
  }

  createFormGroup() {
    return new FormGroup({
      selection_options: new FormControl(''),
      user_station: new FormControl('')
    });
  }

  get fval() {
    return this.userForm.controls;
  }

//   edit(data: any){
// console.log(data);
//   }
  showAllClients() {
    this.adminUserService.getAllClients(jwt_decode(this.authService.getJwtToken()).user_station).subscribe(
      data => {
        this.clientDetails = data;
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

  // checkloans(){
  //   console.log(this.clientDetails[0]);

  //     }
}
