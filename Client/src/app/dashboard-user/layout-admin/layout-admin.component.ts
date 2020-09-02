import { Component, OnInit } from '@angular/core';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { Router } from '@angular/router';
import { LayoutManageService } from 'src/app/services/layout-manage.service';
import * as jwt_decode from 'jwt-decode';
@Component({
  selector: 'app-layout-admin',
  templateUrl: './layout-admin.component.html',
  styleUrls: ['./layout-admin.component.scss']
})
export class LayoutAdminComponent implements OnInit {
  loggedInPumpUser: boolean;
  loggedInAdminUser: boolean;
  loggedIn: boolean;
  hasRights: boolean;
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

  constructor(
    private authService: AuthServiceService,
    private router: Router,
    private layoutService: LayoutManageService
  ) {}

  ngOnInit() {
    this.setRightsNow();
    // if (jwt_decode(this.authService.getJwtToken()).user_role === 1001) {
    //   this.layoutService.emitLoginLogout(true);
    //   this.layoutService.emitChangeAdminUser(true);
    //   this.loggedInAdminUser = this.authService.isLoggedIn();
    // }

    // if (jwt_decode(this.authService.getJwtToken()).user_role === 1000) {
    //   this.loggedInPumpUser = this.authService.isLoggedIn();
    //   this.layoutService.emitChangePumpUser(true);
    //   this.layoutService.emitLoginLogout(true);
    // }

    this.toggleArial();

    this.updateLayout();
  }


  setRightsNow() {
    this.hasRights = jwt_decode(this.authService.getJwtToken()).white_listed;
    console.log(this.hasRights);
      }


  updateLayout() {
    this.layoutService.changeEmittedlogoutin$.subscribe(status1 => {
      this.loggedIn = status1;
    });

    this.layoutService.changeEmittedpumpuser$.subscribe(status2 => {
      this.loggedInPumpUser = status2;
    });

    this.layoutService.changeEmittedpadminuser$.subscribe(status3 => {
      this.loggedInAdminUser = status3;
    });
  }

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
