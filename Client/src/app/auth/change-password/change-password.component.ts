import { Component, OnInit } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { CustomValidator } from 'src/app/validators/custom-validator';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  styleUrls: ['./change-password.component.scss']
})
export class ChangePasswordComponent implements OnInit {

  userForm: FormGroup;

  constructor() { }

  ngOnInit() {

    this.userForm = this.createFormGroup();
  }


  createFormGroup() {
    return new FormGroup({

      main_contact_number: new FormControl('', Validators.compose([Validators.required,
      CustomValidator.patternValidator(/\d/, { hasNumber: true }),
      Validators.maxLength(10), Validators.minLength(10)
      ])),

      user_role11: new FormControl('', Validators.compose([Validators.required,
        // CustomValidator.
        //   patternValidator(
        //     /^(([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9])([0-9]))$/, { hasNumber: true })
        //
      ])
      ),

      password: new FormControl('', Validators.compose(
        [

          // 1. Password Field is Required

          Validators.required

        ]))
    });
  }

  // revert() {
  //   this.userForm.reset();
  // }

  get fval() { return this.userForm.controls; }



}
