import { Component, OnInit } from '@angular/core';
import { BookModule } from 'src/app/models/book-module.model';

@Component({
  selector: 'app-view-book',
  templateUrl: './view-book.component.html',
  styleUrls: ['./view-book.component.css']
})
export class ViewBookComponent implements OnInit {
  modules: BookModule[] = [];
  modulesBasedSessions = {};

  
  ngOnInit(): void {
  }
}
