import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { SuperUserComponent } from './super-user.component';
import { SuperUserApproveUserComponent } from './super-user-approve-user/super-user-approve-user.component';


const routes: Routes = [
  { path: 'dashboardsuperuser', redirectTo: '/dashboardsuperuser/superuserdashboard', pathMatch: 'full' },
  {
    path: 'dashboardsuperuser', component: SuperUserComponent, children: [
      { path: 'approveusers', component: SuperUserApproveUserComponent },
    ]
  }


];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class SuperUserRoutingModule { }
