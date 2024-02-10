import { Component, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';
import { Router } from '@angular/router';
import { MetaArticleModel } from 'src/app/models/article.model';
import { ArticleService } from 'src/app/services/article.service';
import { AuthService } from 'src/app/services/auth.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-create-module',
  templateUrl: './create-module.component.html',
  styleUrls: ['./create-module.component.css']
})
export class CreateModuleComponent implements OnInit {
  sessionGroup = "sessionGroup";

  articles: MetaArticleModel[] = [];
  copyArticles: MetaArticleModel[] = [];
  selectedArticles: MetaArticleModel[] = [];
  searchKeyword = "";
  pageSize: number = 10;
  lastDoc: DocumentData = null;
  isLoading: boolean = false;
  errorMsg = null;
  // joinedIn = "";

  constructor(private ars: ArticleService, private as: AuthService, private router: Router, private us: UtilityService) { }

  ngOnInit(): void {

    this.loadData();
  }

  async loadData() {
    try {
      this.isLoading = true;
      const response = await this.ars.getListOfMetaArticleBasedOnCreatorId(this.as.userInfo.id,
        "publish",
        this.pageSize,
        this.lastDoc
      );
      this.lastDoc = response.lastDocData;
      this.articles = [...this.articles, ...response.data];
      this.copyArticles = this.articles;
      // this.ars.updateListAndSub(values, "publish")
      // this.articles = values;
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }

  //published
  async searchArticle() {

  }

  getDate(articleInf): String {
    return this.us.secondsToDateTime(articleInf.updatedAt?.seconds).toLocaleDateString();
  }

  navToViewArticle(articleInf) {
    this.router.navigate(["view-article"], {
      queryParams: {
        data: JSON.stringify(articleInf),
      }
    });
  }

  async submit() {
    try {
      console.log(this.selectedArticles[0] ?? "");
    } catch (error) {
      console.log(error);
      this.errorMsg = error;
    }
  }

  onSelectedArticle(value) {
    console.log(value);
  }

}
