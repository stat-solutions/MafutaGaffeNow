import { Component, OnInit } from '@angular/core';
import { SharedCenterService } from '../services/shared-center.service';
import { AuthServiceService } from '../services/auth-service.service';
import * as jwt_decode from 'jwt-decode';

@Component({
  selector: 'app-super-user',
  templateUrl: './super-user.component.html',
  styleUrls: ['./super-user.component.scss']
})
export class SuperUserComponent implements OnInit {


    balance: number;
    errored: boolean;
    serviceErrors: string;
    alertService: any;
    constructor(
      private ServiceShared: SharedCenterService,
      private authService: AuthServiceService
    ) {}

    ngOnInit() {
      this.populateBalance();
    }

    populateBalance() {
      this.ServiceShared.getBalanceRunning(
        jwt_decode(this.authService.getJwtToken()).user_station_name
      ).subscribe(
        datab => {
          this.balance = datab[0].balance;
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
