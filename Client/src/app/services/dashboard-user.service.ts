import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import {
  HttpHeaders,
  HttpClient,
  HttpErrorResponse,
  HttpParams
} from '@angular/common/http';
import { Router } from '@angular/router';
import { FormGroup } from '@angular/forms';
import { Observable, throwError } from 'rxjs';
import { tap, catchError } from 'rxjs/operators';
import { StageNames } from '../models/stage-names';
import { AllLoansDisplay } from '../models/all-loans-display';
import { AllClients } from '../models/all-clients';
import { InterestOut } from '../models/interest-out';
import { CustomerPayStatement } from '../models/customer-pay-statement';

@Injectable({
  providedIn: 'root'
})
export class DashboardUserService {
  private API_URL = environment.apiUrl;

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    })
  };

  constructor(private http: HttpClient, private router: Router) {}

  registerCustomer(postData: FormGroup): Observable<boolean> {
    return this.http
      .post<boolean>(
        `${this.API_URL}/api/adminUserDashboard/registerCustomer`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  updateCustomer(postData: FormGroup): Observable<boolean> {
    return this.http
      .post<boolean>(
        `${this.API_URL}/api/adminUserDashboard/updateCustomer`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }





  registerStage(postData: FormGroup): Observable<boolean> {
    return this.http
      .post<boolean>(
        `${this.API_URL}/api/adminUserDashboard/registerStage`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }



  waiveInterestNow(postData: FormGroup): Observable<boolean> {
    return this.http
      .post<boolean>(
        `${this.API_URL}/api/adminUserDashboard/waiveThatInterest`,
        postData.value,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }



  getTheMiniLoanStatement(id: string): Observable<CustomerPayStatement[]> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<CustomerPayStatement[]>(
        `${this.API_URL}/api/adminUserDashboard/customerPayStatemnt`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }




  getAllClients(id: string): Observable<AllClients[]> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<AllClients[]>(
        `${this.API_URL}/api/adminUserDashboard/allClients`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }




  getTheOutStandItnesNow(id: string): Observable<InterestOut[]> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<InterestOut[]>(
        `${this.API_URL}/api/adminUserDashboard/outstandInterestNow`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }


  getAllLoans(): Observable<AllLoansDisplay[]> {
    return this.http
      .get<AllLoansDisplay[]>(
        `${this.API_URL}/api/adminUserDashboard/getAllLoansDetails`,
        this.httpOptions
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  getStageNames(id: string): Observable<StageNames[]> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<StageNames[]>(
        `${this.API_URL}/api/adminUserDashboard/stageNames`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  // getStageNames(): Observable<StageNames[]> {
  //   return this.http
  //     .get<StageNames[]>(
  //       `${this.API_URL}/api/adminUserDashboard/stageNames`,
  //       this.httpOptions
  //     )

  //     .pipe(
  //       tap(response => console.log(`${response}`)),

  //       catchError(this.handleError)
  //     );
  // }

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
