import { Component, OnInit } from '@angular/core';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { Router } from '@angular/router';
import { LayoutManageService } from 'src/app/services/layout-manage.service';
import * as jwt_decode from 'jwt-decode';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
@Component({
  selector: 'app-layout-pump',
  templateUrl: './layout-pump.component.html',
  styleUrls: ['./layout-pump.component.scss']
})
export class LayoutPumpComponent implements OnInit {
  loggedInPumpUser: boolean;
  loggedInAdminUser: boolean;
  loggedIn: boolean;
  shiftDetails: any;

  imageUrl = './assets/blimassLead.jpg';
  boxUsage = 'Loans';
  usage = ['View Loans'];
  boxUsage2 = 'Revenue';
  usage2 = ['Check Revenues'];

  boxUsage3 = 'Clients';
  usage3 = ['Check Clients'];

  isCollapsed: boolean;

  toggleClass: string;

  boxUsage12 = 'Loans';
  usage12 = ['View Loans'];
  errored: boolean;
  serviceErrors: string;
  alertService: any;

  constructor(
    private authService: AuthServiceService,
    private router: Router,
    private layoutService: LayoutManageService,
    private pumpService: DashboardPumpService,
  ) {}

  ngOnInit() {
    this.getTheShiftDetails();

    this.toggleArial();

    // this.updateLayout();
  }


  getTheShiftDetails() {



    this.pumpService.shiftDetails(jwt_decode(this.authService.getJwtToken()).user_station).subscribe(

      (datab) => {

        this.shiftDetails = datab[0];
        this.setActionStatus();
        // this.alertService.success({ html: '<b> Shift details fetched</b>' + '<br/>' });
      },

      (error: string) => {
        this.errored = true;
        this.serviceErrors = error;
        this.alertService.danger({ html: '<b>' + this.serviceErrors + '</b>' + '<br/>' });
      });

  }
  setActionStatus() {

    console.log(this.shiftDetails.shift_status);
    if (this.shiftDetails.shift_status === 'OPENED') {
      this.loggedIn = true;
      this.loggedInPumpUser = true;
      this.loggedInAdminUser = true;

    } else if (this.shiftDetails.shift_status === 'CLOSED') {
      this.loggedIn = false;
      this.loggedInPumpUser = false;
      this.loggedInAdminUser = false;
    }
  }

  // updateLayout() {
  //   this.layoutService.changeEmittedlogoutin$.subscribe(status1 => {
  //     this.loggedIn = status1;
  //   });

  //   this.layoutService.changeEmittedpumpuser$.subscribe(status2 => {
  //     this.loggedInPumpUser = status2;
  //   });

  //   this.layoutService.changeEmittedpadminuser$.subscribe(status3 => {
  //     this.loggedInAdminUser = status3;
  //   });
  // }

  toggleArial() {
    this.isCollapsed = !this.isCollapsed;
    this.toggletheClass(this.isCollapsed);
  }

  toggletheClass(theTogler: boolean) {
    if (theTogler) {
      this.toggleClass = 'collapse navbar-collapse';

      // console.log(this.toggleClass);
    } else {
      this.toggleClass = 'navbar-collapse';
      // console.log(this.toggleClass);
    }
  }

  logMeout() {
    this.authService.doLogoutUser();
    this.layoutService.emitChangePumpUser(false);
    this.layoutService.emitChangeAdminUser(false);
    this.layoutService.emitLoginLogout(false);
  }
}
