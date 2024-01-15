import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {
  isLogin: boolean = false;
  error: string = null;
  constructor(private router: Router, private as: AuthService, private activatedRoute: ActivatedRoute) { }

  ngOnInit(): void {
    this.as.isLoggedIn.subscribe((isLogin) => {
      this.isLogin = isLogin || false;
    });
  }

  navigateToAuth() {
    console.log("NAVIGATE AUTH")
    this.router.navigate(['/auth'])
  }

  async signout() {
    try {
      await this.as.signout();
    } catch (error) {
      this.error = error;
    }
  }
}
