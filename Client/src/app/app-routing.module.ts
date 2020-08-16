import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';


const routes: Routes = [
  { path: 'authpage', redirectTo: '/authpage/loginpage', pathMatch: 'full' },
  { path: '', redirectTo: '/authpage/loginpage', pathMatch: 'full' }

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
