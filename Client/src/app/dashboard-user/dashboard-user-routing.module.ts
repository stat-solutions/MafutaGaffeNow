import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { DashboardUserComponent } from './dashboard-user.component';
import { ClientsComponent } from './clients/clients.component';
import { LoansComponent } from './loans/loans.component';
import { EnrollComponent } from './enroll/enroll.component';
import { RevenueComponent } from './revenue/revenue.component';
import { StageComponent } from './stage/stage.component';
import { PostComponent } from './post/post.component';
import { PostTrn2Component } from './post-trn2/post-trn2.component';
import { ViewCustomerScreteComponent } from './view-customer-screte/view-customer-screte.component';
import { EditClientComponent } from './edit-client/edit-client.component';
import { WaiveInterestComponent } from './waive-interest/waive-interest.component';
import { LedgerStatmentComponent } from '../dashboard-pump/ledger-statment/ledger-statment.component';


const routes: Routes = [
  { path: 'dashboarduser', redirectTo: '/dashboarduser/loans', pathMatch: 'full' },
  {
  path: 'dashboarduser', component: DashboardUserComponent, children: [
    { path: 'clients', component: ClientsComponent },
    { path: 'loans', component: LoansComponent },
    { path: 'cashledger', component: LedgerStatmentComponent },
    { path: 'enroll', component: EnrollComponent },
    { path: 'revenue', component: RevenueComponent },
    { path: 'stage', component: StageComponent },
    { path: 'post', component: PostComponent },
    { path: 'post_trn2', component: PostTrn2Component },
    { path: 'viewsecrete', component: ViewCustomerScreteComponent },
    { path: 'editcustomer/:name/:stage/:phone/:plate', component: EditClientComponent },
    { path: 'waiveinterest/:plate', component: WaiveInterestComponent }
  ]
}
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DashboardUserRoutingModule { }
