import { BrowserModule } from '@angular/platform-browser';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import { AuthRoutingModule } from './auth-routing.module';
import { AuthComponent } from './auth.component';
import { LoginComponent } from './login/login.component';
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { BsDatepickerModule } from 'ngx-bootstrap/datepicker';
import { NgxSpinnerModule } from 'ngx-spinner';
import { NgxSpinnersModule } from 'ngx-spinners';
import { AlertModule } from 'ngx-alerts';
import { ReactiveFormsModule } from '@angular/forms';
import { RegisterUserComponent } from './register-user/register-user.component';
import { ChangePasswordComponent } from './change-password/change-password.component';
// import { BootstrapAlertModule } from 'ngx-bootstrap-alert';

@NgModule({
  declarations: [AuthComponent, LoginComponent, RegisterUserComponent, ChangePasswordComponent],
  imports: [
    CommonModule,
    AuthRoutingModule,
    AlertModule,
    BsDatepickerModule,
    ReactiveFormsModule,
    NgxSpinnerModule,
    NgxSpinnersModule,
    BrowserModule,
    BrowserAnimationsModule,
    AlertModule.forRoot({maxMessages: 5, timeout: 7000, position: 'left'}),
    // BootstrapAlertModule
  ]
})
export class AuthModule { }
