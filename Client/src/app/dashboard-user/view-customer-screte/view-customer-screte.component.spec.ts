import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewCustomerScreteComponent } from './view-customer-screte.component';

describe('ViewCustomerScreteComponent', () => {
  let component: ViewCustomerScreteComponent;
  let fixture: ComponentFixture<ViewCustomerScreteComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ViewCustomerScreteComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ViewCustomerScreteComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
