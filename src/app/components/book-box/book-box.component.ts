import { Component, Input} from '@angular/core';
import {BookModel} from 'src/app/models/book.model';

@Component({
  selector: 'app-book-box',
  templateUrl: './book-box.component.html',
  styleUrls: ['./book-box.component.css']
})
export class BookBoxComponent {
  @Input() bookInf: BookModel;
}
