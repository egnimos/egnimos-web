import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DraftsComponent } from './drafts.component';

describe('DraftsComponent', () => {
  let component: DraftsComponent;
  let fixture: ComponentFixture<DraftsComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [DraftsComponent]
    });
    fixture = TestBed.createComponent(DraftsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
