import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ProfilearticlesComponent } from './profilearticles.component';

describe('ProfilearticlesComponent', () => {
  let component: ProfilearticlesComponent;
  let fixture: ComponentFixture<ProfilearticlesComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [ProfilearticlesComponent]
    });
    fixture = TestBed.createComponent(ProfilearticlesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
