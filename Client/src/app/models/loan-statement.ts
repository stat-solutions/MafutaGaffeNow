export interface LoanStatement {

    id: number;
name: string;
date_taken: string;
time_taken: string;
loan_taken: number;
loan_interest_expected: number;
loan_interest_paid: number;
loan_interest_remaining: number;
aging_days: number;
phone: string;
number_plate: string;
stage: string;
}
