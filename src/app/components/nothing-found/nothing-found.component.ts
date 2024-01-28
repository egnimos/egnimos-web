import { Component } from '@angular/core';
import { AnimationOptions } from 'ngx-lottie';

@Component({
  selector: 'app-nothing-found',
  templateUrl: './nothing-found.component.html',
  styleUrls: ['./nothing-found.component.css']
})
export class NothingFoundComponent {
  lottieOptions: AnimationOptions = {
    path: 'assets/animations/nothing-to-show.json',
  };
}
