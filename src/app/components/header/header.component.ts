import { Component } from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent {
  constructor(private router: Router, private activatedRoute: ActivatedRoute) {}

  navigateToAuth() {
    console.log("NAVIGATE AUTH")
    this.router.navigate(['/auth'])
  }
}
