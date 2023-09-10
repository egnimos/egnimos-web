import { Component } from '@angular/core';

@Component({
  selector: 'app-auth',
  templateUrl: './auth.component.html',
  styleUrls: ['./auth.component.css']
})
export class AuthComponent {
  heading: string = "Log in"
  // authType: AuthType = AuthType.Login
  isLogin: boolean = true

  switchToAuthType() {
    this.isLogin = !this.isLogin
    if (this.isLogin) {
      this.heading = "Log in"
      return
    } else {
      this.heading = "Register"
    }
  }
}

// enum AuthType {
//   Login,
//   Register
// }