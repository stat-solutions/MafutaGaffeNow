import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import {
  HttpHeaders,
  HttpErrorResponse,
  HttpClient,
  HttpParams
} from '@angular/common/http';
import { Router } from '@angular/router';
import { FormGroup } from '@angular/forms';
import { map, tap, catchError, mapTo } from 'rxjs/operators';
import { throwError, Observable } from 'rxjs';
import { ShiftDetails } from '../models/shift-details';
import { NumberPlates } from '../models/number-plates';
import { LoanabilityDetails } from '../models/loanability-details';
import { LendingDetails } from '../models/lending-details';
import { LoanPayability } from '../models/loan-payability';
import { LoanRepayDetails } from '../models/loan-repay-details';
import { LoanStatement } from '../models/loan-statement';
import { GeneralLedgerDetails } from '../models/general-ledger-details';
import { RevenueDetails } from '../models/revenue-details';
import { UserSecret } from '../models/user-secret';

@Injectable({
  providedIn: 'root'
})
export class DashboardPumpService {
  private API_URL = environment.apiUrl;

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    })
  };

  constructor(private http: HttpClient, private router: Router) {}




  customerSecret(id: string): Observable<UserSecret[]> {
    const options1 = { params: new HttpParams().set('id', id) };
    return this.http
      .get<UserSecret[]>(
        `${this.API_URL}/api/pumpUserDashboard/userSecrete`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  theNumberPlates(id: string): Observable<NumberPlates[]> {
    const options1 = { params: new HttpParams().set('id', id) };
    return this.http
      .get<NumberPlates[]>(
        `${this.API_URL}/api/pumpUserDashboard/theNumberPlates`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  checkWhetherTheCLoanPayable(id: string): Observable<LoanPayability[]> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<LoanPayability[]>(
        `${this.API_URL}/api/pumpUserDashboard/theClientLoanPayability`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  checkWhetherTheCLoanable(id: string): Observable<LoanabilityDetails[]> {
    const options1 = { params: new HttpParams().set('id', id) };
    return this.http
      .get<LoanabilityDetails[]>(
        `${this.API_URL}/api/pumpUserDashboard/theClientLoanable`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  shiftDetails(id: string): Observable<ShiftDetails[]> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<ShiftDetails[]>(
        `${this.API_URL}/api/pumpUserDashboard/shiftDetails`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  isBalanceIsEnoughOrExists(id: string): Observable<boolean> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<boolean>(
        `${this.API_URL}/api/pumpUserDashboard/checkBalExistEnough`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  createLoan(postData: FormGroup): Observable<LendingDetails[]> {
    return this.http
      .post<LendingDetails[]>(
        `${this.API_URL}/api/pumpUserDashboard/createLoan`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  theRunningLoans(postData: FormGroup): Observable<LoanStatement[]> {

    return this.http
    .post<LoanStatement[]>(
      `${this.API_URL}/api/pumpUserDashboard/getTheRunningLoans`,
      postData.value,
      this.httpOptions
    )

    .pipe(
      // tap(response => console.log(`${response}`)),

      catchError(this.handleError)
    );
  }


  theRevenueDetailsAll(postData: FormGroup): Observable<RevenueDetails[]> {

    return this.http
    .post<RevenueDetails[]>(
      `${this.API_URL}/api/pumpUserDashboard/getTheRevenueDetails`,
      postData.value,
      this.httpOptions
    )

    .pipe(
      // tap(response => console.log(`${response}`)),

      catchError(this.handleError)
    );
  }


  theLedgerDetails(postData: FormGroup): Observable<GeneralLedgerDetails[]> {

    return this.http
    .post<GeneralLedgerDetails[]>(
      `${this.API_URL}/api/pumpUserDashboard/getTheLedgerDetails`,
      postData.value,
      this.httpOptions
    )

    .pipe(
      // tap(response => console.log(`${response}`)),

      catchError(this.handleError)
    );
  }



  repayLoan(postData: FormGroup): Observable<LoanRepayDetails[]> {
    return this.http
      .post<LoanRepayDetails[]>(
        `${this.API_URL}/api/pumpUserDashboard/loanRepayNow`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  openClosedShift(postData: FormGroup): Observable<boolean> {
    return this.http
      .post<boolean>(
        `${this.API_URL}/api/pumpUserDashboard/openClosedShift`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  closeOpenShift(postData: FormGroup): Observable<boolean> {
    return this.http
      .post<boolean>(
        `${this.API_URL}/api/pumpUserDashboard/closeOpenShift`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  postTheTxn(postData: FormGroup) {
    return this.http
      .post<string>(
        `${this.API_URL}/api/pumpUserDashboard/postTheTxn`,
        postData.value,
        this.httpOptions
      )

      .pipe(mapTo(true), catchError(this.handleError));
  }

  areSavingsRegistered(id: string): Observable<boolean> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<boolean>(
        `${this.API_URL}/api/allEdadBoxRelatedTxns/areSavingsAdded`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  registerSmartSavings(postData: FormGroup) {
    return this.http
      .post<string>(
        `${this.API_URL}/api/allEdadBoxRelatedTxns/registerSmartSavings`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        map((res: string) => res),
        // tap(res => console.log(`AFTER MAP: ${res}`)),
        catchError(this.handleSmartSavingRegError)
      );
  }

  private handleTokensPurchaseError(errorResponse: HttpErrorResponse) {
    if (errorResponse.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', errorResponse.error.message);
    } else {
      // The backend returned an unsuccessful response code.
      // The response body may contain clues as to what went wrong,
      console.error(
        `Backend returned code ${errorResponse.status}, ` +
          `body was: ${errorResponse.error}`
      );
    }
    // return an observable with a user-facing error message
    return throwError(`Tokens Purchase failed!!
       ${
         errorResponse.status === 500 ||
         errorResponse.status === 0 ||
         errorResponse.status === 200 ||
         errorResponse.status === 404
           ? 'The Back End was not able to Handle this Request'
           : errorResponse.error
       }
   !!`);
  }

  private handleSmartSavingRegError(errorResponse: HttpErrorResponse) {
    if (errorResponse.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', errorResponse.error.message);
    } else {
      // The backend returned an unsuccessful response code.
      // The response body may contain clues as to what went wrong,
      console.error(
        `Backend returned code ${errorResponse.status}, ` +
          `body was: ${errorResponse.error}`
      );
    }
    // return an observable with a user-facing error message
    return throwError(`Smart Savings Registration failed!!
       ${
         errorResponse.status === 500 ||
         errorResponse.status === 0 ||
         errorResponse.status === 200 ||
         errorResponse.status === 404
           ? 'The Back End was not able to Handle this Request'
           : errorResponse.error
       }
   !!`);
  }

  private handleError(errorResponse: HttpErrorResponse) {
    if (errorResponse.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', errorResponse.error.message);
    } else {
      // The backend returned an unsuccessful response code.
      // The response body may contain clues as to what went wrong,
      console.error(
        `Backend returned code ${errorResponse.status}, ` +
          `body was: ${errorResponse.error}`
      );
    }
    // return an observable with a user-facing error message
    return throwError(`Get Error!!
       ${
         errorResponse.status === 500 ||
         errorResponse.status === 0 ||
         errorResponse.status === 200
           ? 'The Back End was not able to Handle this Request'
           : errorResponse.error
       }
   !!`);
  }
}
