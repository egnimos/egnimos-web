import { Component } from '@angular/core';
import { ProviderType } from 'src/app/enum';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-auth',
  templateUrl: './auth.component.html',
  styleUrls: ['./auth.component.css']
})
export class AuthComponent {
  heading: string = "Log in"
  error: string = null;
  selectedProvider: ProviderType = null
  // authType: AuthType = AuthType.Login
  isLogin: boolean = true
  isAuthInProcess = false;

  constructor(private as: AuthService) {

  }

  switchToAuthType() {
    this.isLogin = !this.isLogin
    if (this.isLogin) {
      this.heading = "Log in"
      return
    } else {
      this.heading = "Register"
    }
  }

  async loginByGoogle() {
    try {
      this.isAuthInProcess = true;
      this.selectedProvider = ProviderType.google;
      await this.as.authWithGoogle(this.isLogin);
    } catch (error) {
      this.error = error;
    } finally {
      this.isAuthInProcess = false;
      this.selectedProvider = null;
    }
  }

  async loginByGithub() {
    try {
      this.isAuthInProcess = true;
      this.selectedProvider = ProviderType.github;
      await this.as.authWithGithub(this.isLogin);
    } catch (error) {
      this.error = error;
    } finally {
      this.isAuthInProcess = false;
      this.selectedProvider = null;
    }
  }
}

// enum AuthType {
//   Login,
//   Register
// }