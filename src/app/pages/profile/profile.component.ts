import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css']
})
export class ProfileComponent {

  constructor(private route: Router, private currentRoute: ActivatedRoute) { }

  navToWriteBlog() {
    this.route.navigate(['write-article']);
  }
}
