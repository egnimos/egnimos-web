import { Component, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';
import {BookService} from 'src/app/services/book.services';
import {AuthService} from 'src/app/services/auth.service';
import {BookModel} from 'src/app/models/book.model';

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent implements OnInit {
  isLoading = false;
  books: BookModel[] = [];
  errorMsg = null;
  lastDocData: DocumentData = null;
  pageLimit = 10;

  constructor(private bs: BookService, private as: AuthService) { }

  ngOnInit(): void {
    this.loadData();
  }

  async loadData() {
    try {
      this.errorMsg = null;
      this.isLoading = true;
      const response = await this.bs.getListOfBookBasedOnCreatorId(this.as.userInfo.id,
        "publish",
        this.pageLimit,
        this.lastDocData
      );
      this.lastDocData = response.lastDocData;
      const values = [...this.books, ...response.data];
      this.bs.updateListAndSub(values, "publish")
    } catch (error) {
      console.log(error);
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }
}
