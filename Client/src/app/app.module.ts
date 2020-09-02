import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule } from '@angular/common/http';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { AuthModule } from './auth/auth.module';
import { MatIconModule } from '@angular/material/icon';
import { DashboardPumpModule } from './dashboard-pump/dashboard-pump.module';
import { DashboardUserModule } from './dashboard-user/dashboard-user.module';
import { DatepickerModule, BsDatepickerModule } from 'ngx-bootstrap/datepicker';
import { ModalDialogModule } from 'ngx-modal-dialog';
import { ModalModule } from 'ngx-bootstrap/modal';
import { LendDialogComponent } from './dashboard-pump/lend-dialog/lend-dialog.component';
import { SearchTableDirective } from './directives/search-table.directive';
import { AngularMaterialModule } from './angular-material.module';




@NgModule({
  declarations: [
    AppComponent,
    SearchTableDirective,



  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    AuthModule,
    MatIconModule,
    HttpClientModule,
    DashboardPumpModule,
    DashboardUserModule,
    DatepickerModule.forRoot(),
    BsDatepickerModule.forRoot(),
    ModalDialogModule.forRoot(),
    ModalModule.forRoot(),
    AngularMaterialModule,

  ],
  entryComponents: [
    LendDialogComponent
 ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
