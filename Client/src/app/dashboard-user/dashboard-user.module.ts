import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BsDatepickerModule } from 'ngx-bootstrap/datepicker';
import { NgxSpinnerModule } from 'ngx-spinner';
import { NgxSpinnersModule } from 'ngx-spinners';
import { ReactiveFormsModule } from '@angular/forms';
import { AlertModule } from 'ngx-alerts';
import { DashboardUserRoutingModule } from './dashboard-user-routing.module';
import { LoansComponent } from './loans/loans.component';
import { RevenueComponent } from './revenue/revenue.component';
import { ClientsComponent } from './clients/clients.component';
import { EnrollComponent } from './enroll/enroll.component';
import { DashboardUserComponent } from './dashboard-user.component';
import { StageComponent } from './stage/stage.component';
import { LayoutAdminComponent } from './layout-admin/layout-admin.component';
import { PostComponent } from './post/post.component';
import { PostTrn2Component } from './post-trn2/post-trn2.component';
import { ViewCustomerScreteComponent } from './view-customer-screte/view-customer-screte.component';
import { EditClientComponent } from './edit-client/edit-client.component';


@NgModule({
  declarations: [
    LoansComponent,
    RevenueComponent,
    ClientsComponent,
     EnrollComponent,
      DashboardUserComponent,
       StageComponent,
        LayoutAdminComponent,
        PostComponent,
        PostTrn2Component,
        ViewCustomerScreteComponent,
        EditClientComponent],
  imports: [
    CommonModule,
    DashboardUserRoutingModule,
    BsDatepickerModule,
    NgxSpinnerModule,
    NgxSpinnersModule,
    ReactiveFormsModule,
    AlertModule
  ]
})
export class DashboardUserModule { }
