import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { BookModel } from 'src/app/models/book.model';
import { AuthService } from 'src/app/services/auth.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-book-box',
  templateUrl: './book-box.component.html',
  styleUrls: ['./book-box.component.css']
})
export class BookBoxComponent implements OnInit {
  joinedIn = "";
  authenticatedUser = null;
  thumbnail: String = "";
  @Input() bookInf: BookModel;

  constructor(private as: AuthService, private us: UtilityService, private router: Router) { }

  ngOnInit(): void {
    this.authenticatedUser = this.as.userInfo;
    this.joinedIn =
      this.us.secondsToDateTime(this.bookInf.updatedAt?.seconds).toLocaleDateString();
    this.thumbnail = this.bookInf?.thumbnail ?? "assets/images/no-image.jpg";
  }


  isDeleting = false;
  async deleteBook() {
    try {
      this.isDeleting = true;

    } catch (error) {
      alert(error);
    } finally {
      this.isDeleting = false;
    }
  }

  editBook() {
    this.router.navigate(["book", "create-book"], {
      queryParams: {
        data: JSON.stringify(this.bookInf),
      }
    });
  }

  navToViewBook() {
    this.router.navigate(["book", "view-book"], {
      queryParams: {
        data: JSON.stringify(this.bookInf),
      }
    })
  }
}
