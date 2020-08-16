import { Injectable } from '@angular/core';
import { Subject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LayoutManageService {

  private emitChangeSourcePumpUser = new Subject<boolean>();

  private logoutIn = new Subject<boolean>();

  private emitChangeSourceAdminUser = new Subject<boolean>();

  changeEmittedpumpuser$ = this.emitChangeSourcePumpUser.asObservable();

  changeEmittedpadminuser$ = this.emitChangeSourceAdminUser.asObservable();

  changeEmittedlogoutin$ = this.logoutIn.asObservable();

  emitChangePumpUser(change: boolean) {

    this.emitChangeSourcePumpUser.next(change);

  }

  emitChangeAdminUser(change: boolean) {
    this.emitChangeSourceAdminUser.next(change);
  }
  emitLoginLogout(change: boolean) {
    this.logoutIn.next(change);
  }

}
