import { Component, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';
import { PublishType } from 'src/app/enum';
import { MetaArticleModel } from 'src/app/models/article.model';
import { ArticleService } from 'src/app/services/article.service';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-drafts',
  templateUrl: './drafts.component.html',
  styleUrls: ['./drafts.component.css']
})
export class DraftsComponent implements OnInit {
  articles: MetaArticleModel[] = [

  ];
  pageSize: number = 10;
  lastDoc: DocumentData = null;
  isLoading: boolean = false;
  errorMsg = null;



  ngOnInit(): void {
    this.loadData();
    this.ars.draftMetaArticlesSub.subscribe((values) => {
      this.articles = values;
    });
  }


  constructor(private ars: ArticleService, private as: AuthService) { }

  async loadData() {
    try {
      this.isLoading = true;
      const response = await this.ars.getListOfMetaArticleBasedOnCreatorId(this.as.userInfo.id,
        "draft",
        this.pageSize,
        this.lastDoc
      );
      this.lastDoc = response.lastDocData;
      const values = [...this.articles, ...response.data];
      this.ars.updateListAndSub(values, "draft")
      // this.articles = values;
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }

}
