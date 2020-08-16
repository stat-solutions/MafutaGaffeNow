import { Component, OnInit } from '@angular/core';
import * as jwt_decode from 'jwt-decode';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { AuthServiceService } from 'src/app/services/auth-service.service';
import { DashboardPumpService } from 'src/app/services/dashboard-pump.service';
import { AlertService } from 'ngx-alerts';
import { LoanStatement } from 'src/app/models/loan-statement';
import { Observable, of } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { FilterPipe } from 'ngx-filter-pipe';
@Component({
  selector: 'app-statement',
  templateUrl: './statement.component.html',
  styleUrls: ['./statement.component.scss']
})
export class StatementComponent implements OnInit {
  public searchText: string;
  userFilter: any = { stage: '' };
  station: any;
  term : any;
  theCompany: any;
  userForm: FormGroup;
  loansDetails$: Observable<LoanStatement[]>;
  // filteredloansDetails$: Observable<LoanStatement[]>;
  filter: FormControl;
  filter$: Observable<string>;
  errored: boolean;
  serviceErrors: string;
  overduePast15: boolean;
  stage: string;

  constructor(
    private authService: AuthServiceService,
    private pumpService: DashboardPumpService,
    private alertService: AlertService  ) {

      this.filter = new FormControl('');
  }

  ngOnInit() {
    this.station = jwt_decode(this.authService.getJwtToken()).user_station_name;
    this.theCompany = jwt_decode(
      this.authService.getJwtToken()
    ).user_station_company;
    this.userForm = this.createFormGroup();
    this.getTheLoansNow();

    // this. loanFiltering();
  }

// loanFiltering() {

//   this.filter = new FormControl('');
//   this.filter$ = this.filter.valueChanges.pipe(startWith(''));

//   this.filteredloansDetails$ = combineLatest([this.loansDetails$, this.filter$])
//   .pipe(
// tap(x=>console.log(x)),
//     map(([loandetails, filterString]) => loandetails.filter(

//       loandetail => loandetail.stage.toLowerCase().indexOf(filterString.toLowerCase()) !== -1))
//   );
// }


  createFormGroup() {
    return new FormGroup({
      user_id: new FormControl(''),
      stage: new FormControl(''),
      user_station: new FormControl(''),
      selection_options: new FormControl(
        { value: '', disabled: false },
        Validators.compose([Validators.required])
      )
    });
  }

  revert() {
    this.userForm.reset();
  }

  refresh() {
    location.reload();
  }
  revertPetrol() {
    this.userForm.controls.petrol_station.reset();
  }

  get fval() {
    return this.userForm.controls;
  }

  // Time	Number plate	Amount	Description
  // getTheLoansNow() {
  //   if (this.userForm.controls.selection_options.value === '') {
  //     this.userForm.patchValue({
  //       selection_options: 'RUNNING LOANS'
  //     });

  //   }
  //   // console.log(jwt_decode(this.authService.getJwtToken()).user_id);
  //   this.userForm.patchValue({
  //     user_id: jwt_decode(this.authService.getJwtToken()).user_id,
  //     user_station: jwt_decode(this.authService.getJwtToken()).user_station
  //   });



  //   this.pumpService
  //     .theRunningLoans(this.userForm)
  //     .subscribe(
  //       data => {
  //         this.loansDetails = data;
  //       },

  //       (error: string) => {
  //         this.errored = true;
  //         this.serviceErrors = error;
  //         this.alertService.danger({
  //           html: '<b>' + this.serviceErrors + '</b>' + '<br/>'
  //         });
  //       }
  //     );
  // }



  getTheLoansNow() {
    if (this.userForm.controls.selection_options.value === '') {
      this.userForm.patchValue({
        selection_options: 'RUNNING LOANS'
      });

    }
    // console.log(jwt_decode(this.authService.getJwtToken()).user_id);
    this.userForm.patchValue({
      user_id: jwt_decode(this.authService.getJwtToken()).user_id,
      user_station: jwt_decode(this.authService.getJwtToken()).user_station
    });



    this.loansDetails$ =  this.pumpService
      .theRunningLoans(this.userForm).pipe(

        catchError(error => {
        this.errored = true;
        this.serviceErrors = error;
        this.alertService.danger({
          html: '<b>' + this.serviceErrors + '</b>' + '<br/>'
        });
        return of(null);
        }));



  }

}
