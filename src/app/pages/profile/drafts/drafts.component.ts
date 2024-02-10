import { Component, OnInit } from '@angular/core';
import { DocumentData, disableNetwork } from '@angular/fire/firestore';
import { PublishType } from 'src/app/enum';
import { MetaArticleModel } from 'src/app/models/article.model';
import { ArticleService } from 'src/app/services/article.service';
import { AuthService } from 'src/app/services/auth.service';
import { CacheService } from 'src/app/services/cache.service';

@Component({
  selector: 'app-drafts',
  templateUrl: './drafts.component.html',
  styleUrls: ['./drafts.component.css']
})
export class DraftsComponent implements OnInit {
  cacheID = "profile/draft/article";
  articles: MetaArticleModel[] = [

  ];
  pageSize: number = 10;
  lastDoc: DocumentData = null;
  isLoading: boolean = false;
  errorMsg = null;



  ngOnInit(): void {
    this.loadData(true);
    this.ars.draftMetaArticlesSub.subscribe((values) => {
      this.articles = values;
    });
  }


  constructor(private ars: ArticleService,
    private as: AuthService,
    private cacheSer: CacheService) { }

  //enableNetwork parameter is used to check whether you want to enable 
  //or disable the offline/online feature of firestore
  async loadData(enableNetwork = false) {
    try {
      this.isLoading = true;

      if ((this.cacheSer.get(this.cacheID)?.isCached ?? false) && enableNetwork) {
        await this.ars.switchToOffline();
      }
      const response = await this.ars.getListOfMetaArticleBasedOnCreatorId(this.as.userInfo.id,
        "draft",
        this.pageSize,
        this.lastDoc
      );
      await this.ars.switchToOnline();
      this.lastDoc = response.lastDocData;
      this.articles = [...this.articles, ...response.data];
      this.cacheSer.set({
        id: this.cacheID,
        isCached: true,
        change: false,
      })
      // this.ars.updateListAndSub(values, "draft")
      // this.articles = values;
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }

}
