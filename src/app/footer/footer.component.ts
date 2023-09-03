import { Component } from '@angular/core';

@Component({
  selector: 'app-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.css']
})
export class FooterComponent {
  date: Date = new Date()

  getYear() : String {
    return this.date.getFullYear().toString()
  }
}
