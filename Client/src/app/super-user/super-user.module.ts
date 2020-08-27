import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SuperUserRoutingModule } from './super-user-routing.module';
import { SuperUserComponent } from './super-user.component';
import { SuperUserApproveUserComponent } from './super-user-approve-user/super-user-approve-user.component';
import { SuperUserPostBranchCashComponent } from './super-user-post-branch-cash/super-user-post-branch-cash.component';
import { SuperUserDashboardComponent } from './super-user-dashboard/super-user-dashboard.component';
import { SuperUserLayoutComponent } from './super-user-layout/super-user-layout.component';
import { SuperUserResetPinComponent } from './super-user-reset-pin/super-user-reset-pin.component';
import { SuperUserWaiveInterestComponent } from './super-user-waive-interest/super-user-waive-interest.component';


@NgModule({
  declarations: [SuperUserComponent, SuperUserApproveUserComponent, SuperUserDashboardComponent,
     SuperUserLayoutComponent, SuperUserPostBranchCashComponent, SuperUserPostBranchCashComponent,
     SuperUserResetPinComponent, SuperUserWaiveInterestComponent],
  imports: [
    CommonModule,
    SuperUserRoutingModule
  ]
})
export class SuperUserModule { }
