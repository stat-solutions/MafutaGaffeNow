import { Component, OnInit } from '@angular/core';
import { SharedCenterService } from '../services/shared-center.service';
import { AuthServiceService } from '../services/auth-service.service';
import * as jwt_decode from 'jwt-decode';
@Component({
  selector: 'app-dashboard-user',
  templateUrl: './dashboard-user.component.html',
  styleUrls: ['./dashboard-user.component.scss']
})
export class DashboardUserComponent implements OnInit {
  balance: number;
  errored: boolean;
  serviceErrors: string;
  alertService: any;

  constructor(
    private ServiceShared: SharedCenterService,
    private authService: AuthServiceService
  ) {}

  ngOnInit() {
    this.populateAllBalance();
  }

  populateAllBalance() {
    this.ServiceShared.getAllBalanceRunning(
      jwt_decode(this.authService.getJwtToken()).user_station_name
    ).subscribe(
      (databc) => {
        this.balance = databc[0].balance;
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
}
