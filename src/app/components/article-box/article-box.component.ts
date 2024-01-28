import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MetaArticleModel } from 'src/app/models/article.model';
import { ArticleService } from 'src/app/services/article.service';
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
  thumbnail: String = "";
  @Input() articleInf: MetaArticleModel;

  constructor(private us: UtilityService, private as: AuthService, private router: Router, private ars: ArticleService) { }

  ngOnInit(): void {
    this.authenticatedUser = this.as.userInfo;
    this.joinedIn =
      this.us.secondsToDateTime(this.articleInf.updatedAt?.seconds).toLocaleDateString();
    this.thumbnail = this.articleInf?.thumbnail ?? "assets/images/no-image.jpg";
  }

  isDeleting = false;
  async deleteArticle() {
    try {
      this.isDeleting = true;
      await this.ars.deleteArticle(this.articleInf.id, this.articleInf.publishType, this.articleInf.articleDataId);
    } catch (error) {
      alert(error);
    } finally {
      this.isDeleting = false;
    }
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
