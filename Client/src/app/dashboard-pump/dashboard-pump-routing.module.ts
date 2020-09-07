import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DashboardPumpComponent } from './dashboard-pump.component';
import { LendComponent } from './lend/lend.component';
import { PaymentComponent } from './payment/payment.component';
import { ShiftManagementComponent } from './shift-management/shift-management.component';
import { ShiftsComponent } from './shifts/shifts.component';
import { StatementComponent } from './statement/statement.component';
import { PostTrnComponent } from './post-trn/post-trn.component';
import { LedgerStatmentComponent } from './ledger-statment/ledger-statment.component';
import { SavingsComponent } from './savings/savings.component';


const routes: Routes = [
  { path: 'dashboardpump', redirectTo: '/dashboardpump/shiftmanagement', pathMatch: 'full' },
  {
    path: 'dashboardpump', component: DashboardPumpComponent, children: [
      { path: 'lend', component: LendComponent },
      { path: 'payment', component: PaymentComponent },
      { path: 'shiftmanagement', component: ShiftManagementComponent },
      { path: 'shifts', component: ShiftsComponent },
      { path: 'statement', component: StatementComponent },
      { path: 'ledgerstatement', component: LedgerStatmentComponent },
      { path: 'depositwithdraw', component: PostTrnComponent },
      { path: 'savings', component: SavingsComponent },

    ]
  }


];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DashboardPumpRoutingModule { }
