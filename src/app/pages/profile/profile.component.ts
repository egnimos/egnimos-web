import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { UserModel } from 'src/app/models/user.model';
import { AuthService } from 'src/app/services/auth.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent implements OnInit {
  
  userInfo: UserModel = null;
  joinedIn = null
  constructor(private route: Router, private currentRoute: ActivatedRoute, private as: AuthService, private us: UtilityService) { }
  ngOnInit(): void {
    this.userInfo = this.as.userInfo;
    this.joinedIn = this.us.secondsToDateTime(this.userInfo.createdAt?.seconds).toLocaleDateString();
    console.log(this.userInfo, "USERINFO");
  }

  // secondsToDateTime(seconds: number): Date {
  //   // Multiply seconds by 1000 to get milliseconds
  //   const milliseconds = seconds * 1000;

  //   // Create a new Date object with the milliseconds
  //   const date = new Date(milliseconds);

  //   return date;
  // }

  navToWriteBlog() {
    this.route.navigate(['write-article']);
  }

  navToCreateBook() {
    this.route.navigate(["book", "create-book"]);
  }
}
