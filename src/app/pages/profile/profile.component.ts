import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { UserModel } from 'src/app/models/user.model';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  userInfo: UserModel = null;
  constructor(private route: Router, private currentRoute: ActivatedRoute, private as: AuthService) { }
  ngOnInit(): void {
    this.userInfo = this.as.userInfo;
    console.log(this.userInfo, "USERINFO");
  }

  navToWriteBlog() {
    this.route.navigate(['write-article']);
  }


}
