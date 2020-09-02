import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { DashboardPumpRoutingModule } from './dashboard-pump-routing.module';
import { ShiftManagementComponent } from './shift-management/shift-management.component';
import { LendComponent } from './lend/lend.component';
import { PaymentComponent } from './payment/payment.component';
import { StatementComponent } from './statement/statement.component';
import { ShiftsComponent } from './shifts/shifts.component';
import { DashboardPumpComponent } from './dashboard-pump.component';
import { PostTrnComponent } from './post-trn/post-trn.component';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { NgxSpinnerModule } from 'ngx-spinner';
import { AlertModule } from 'ngx-alerts';
import { ModalDialogModule } from 'ngx-modal-dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { LendDialogComponent } from './lend-dialog/lend-dialog.component';
import { PaymentDialogComponent } from './payment-dialog/payment-dialog.component';
import { LayoutPumpComponent } from './layout-pump/layout-pump.component';
import { LedgerStatmentComponent } from './ledger-statment/ledger-statment.component';
import { DatepickerModule, BsDatepickerModule } from 'ngx-bootstrap/datepicker';
import { Ng2SearchPipeModule } from 'ng2-search-filter';
import { FilterPipeModule } from 'ngx-filter-pipe';
@NgModule({
  declarations: [
    ShiftManagementComponent,
    LendComponent,
    PaymentComponent,
    StatementComponent,
    ShiftsComponent,
    DashboardPumpComponent,
    PostTrnComponent,
    LendDialogComponent,
    PaymentDialogComponent,
    LayoutPumpComponent,
    LedgerStatmentComponent,


  ],
  imports: [
    CommonModule,
    DashboardPumpRoutingModule,
    ReactiveFormsModule,
    NgxSpinnerModule,
    AlertModule,
    DatepickerModule.forRoot(),
    BsDatepickerModule.forRoot(),
    ModalDialogModule.forRoot(),
    ModalModule.forRoot(),
    FormsModule,
    Ng2SearchPipeModule,
    FilterPipeModule
  ],
  entryComponents: [
    LendDialogComponent,
    PaymentDialogComponent
 ]
})
export class DashboardPumpModule { }
