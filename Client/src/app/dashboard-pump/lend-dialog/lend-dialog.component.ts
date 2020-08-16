import { Component, OnInit } from '@angular/core';
import { BsModalRef, ModalModule , BsModalService } from 'ngx-bootstrap';




@Component({
  selector: 'app-lend-dialog',
  templateUrl: './lend-dialog.component.html',
  styleUrls: ['./lend-dialog.component.scss']
})
export class LendDialogComponent implements OnInit {
  title;
  data;
  constructor(  public modalRef: BsModalRef ) { }

  ngOnInit() {
  }

}
