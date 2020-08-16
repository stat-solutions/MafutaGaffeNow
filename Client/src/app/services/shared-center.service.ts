import { Injectable } from '@angular/core';
import {
  HttpHeaders,
  HttpClient,
  HttpErrorResponse,
  HttpParams
} from '@angular/common/http';
import { throwError, Observable } from 'rxjs';
import { ShiftDetails } from '../models/shift-details';
import { tap, catchError } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { Router } from '@angular/router';
import { BalanceRunning } from '../models/balance-running';

@Injectable({
  providedIn: 'root'
})
export class SharedCenterService {
  private API_URL = environment.apiUrl;

  httpOptions = {
    headers: new HttpHeaders({
      'Content-Type': 'application/json'
    })
  };

  constructor(private http: HttpClient, private router: Router) {}

  getBalanceRunning(id: string): Observable<BalanceRunning[]> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<BalanceRunning[]>(
        `${this.API_URL}/api/pumpUserDashboard/runningBalance`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
  }

  getAllBalanceRunning(id: string): Observable<BalanceRunning[]> {
    const options1 = { params: new HttpParams().set('id', id) };

    return this.http
      .get<BalanceRunning[]>(
        `${this.API_URL}/api/pumpUserDashboard/runningBalanceAll`,
        options1
      )

      .pipe(
        // tap(response => console.log(`${response}`)),

        catchError(this.handleError)
      );
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
