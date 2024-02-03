import { Component, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent implements OnInit {
  isLoading = false;
  books = [];
  errorMsg = null;
  lastDocData: DocumentData = null;
  pageLimit = 10;

  ngOnInit(): void {
    this.loadData();
  }

  async loadData() {
    try {
      this.isLoading = true;
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }
}
