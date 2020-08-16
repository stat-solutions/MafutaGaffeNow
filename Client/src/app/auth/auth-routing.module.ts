import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { AuthComponent } from './auth.component';
import { LoginComponent } from './login/login.component';
import { RegisterUserComponent } from './register-user/register-user.component';
import { ChangePasswordComponent } from './change-password/change-password.component';


const routes: Routes = [


  {
    path: 'authpage', component: AuthComponent, children: [
      { path: 'loginpage', component: LoginComponent },
      { path: 'registeruser', component: RegisterUserComponent },
      { path: 'changepassword', component: ChangePasswordComponent }



    ]
  }




];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AuthRoutingModule { }
