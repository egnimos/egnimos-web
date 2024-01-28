import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MetaArticleModel } from 'src/app/models/article.model';
import { AuthService } from 'src/app/services/auth.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-article-box',
  templateUrl: './article-box.component.html',
  styleUrls: ['./article-box.component.css']
})
export class ArticleBoxComponent implements OnInit {
  joinedIn = "";
  authenticatedUser = null;
  @Input() articleInf: MetaArticleModel;

  constructor(private us: UtilityService, private as: AuthService, private router: Router) { }

  ngOnInit(): void {
    this.authenticatedUser = this.as.userInfo;
    this.joinedIn =
      this.us.secondsToDateTime(this.articleInf.updatedAt?.seconds).toLocaleDateString();
  }

  deleteArticle() {

  }

  editArticle() {
    this.router.navigate(["write-article"], {
      queryParams: {
        data: JSON.stringify(this.articleInf),
      }
    });
  }

  navToViewArticle() {
    this.router.navigate(["view-article"], {
      queryParams: {
        data: JSON.stringify(this.articleInf),
      }
    });
  }
}
