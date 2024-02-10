import { Component, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';
import { BookService } from 'src/app/services/book.services';
import { AuthService } from 'src/app/services/auth.service';
import { BookModel } from 'src/app/models/book.model';

@Component({
  selector: 'app-books',
  templateUrl: './books.component.html',
  styleUrls: ['./books.component.css']
})
export class BooksComponent implements OnInit {
  isPublishedLoading = false;
  isDraftLoading = false;
  booksPublished: BookModel[] = [];
  booksDraft: BookModel[] = [];
  errorMsg = null;
  lastDocData: DocumentData = null;
  pageLimit = 10;

  constructor(private bs: BookService, private as: AuthService) { }

  ngOnInit(): void {
    this.bs.publishBooksSub.subscribe((values) => {
      this.booksPublished = values;
    });
    this.bs.draftBooksSub.subscribe((values) => {
      this.booksDraft = values;
    });
    this.loadPublishedData();
    this.loadDraftData();
  }

  async loadPublishedData() {
    try {
      this.errorMsg = null;
      this.isPublishedLoading = true;
      const response = await this.bs.getListOfBookBasedOnCreatorId(this.as.userInfo.id,
        "publish",
        this.pageLimit,
        this.lastDocData
      );
      this.lastDocData = response.lastDocData;
      this.booksPublished = [...this.booksPublished, ...response.data];

      // this.bs.updateListAndSub(values, "publish")
    } catch (error) {
      console.log(error);
      this.errorMsg = error;
    } finally {
      this.isPublishedLoading = false;
    }
  }

  async loadDraftData() {
    try {
      this.errorMsg = null;
      this.isDraftLoading = true;
      const response = await this.bs.getListOfBookBasedOnCreatorId(this.as.userInfo.id,
        "draft",
        this.pageLimit,
        this.lastDocData
      );
      this.lastDocData = response.lastDocData;
      this.booksDraft = [...this.booksDraft, ...response.data];

      // this.bs.updateListAndSub(values, "draft")
    } catch (error) {
      console.log(error);
      this.errorMsg = error;
    } finally {
      this.isDraftLoading = false;
    }
  }
}
