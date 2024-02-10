import { Component, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';
import { PublishType } from 'src/app/enum';
import { MetaArticleModel } from 'src/app/models/article.model';
import { ArticleService } from 'src/app/services/article.service';
import { AuthService } from 'src/app/services/auth.service';
import { CacheService } from 'src/app/services/cache.service';

@Component({
  selector: 'app-articles',
  templateUrl: './articles.component.html',
  styleUrls: ['./articles.component.css']
})
export class ArticlesComponent implements OnInit {
  cacheID = "home/published/article";
  articles: MetaArticleModel[] = [

  ];
  pageSize: number = 10;
  lastDoc: DocumentData = null;
  isLoading: boolean = false;
  errorMsg = null;

  constructor(private ars: ArticleService, private as: AuthService, private cacheSer: CacheService) { }

  ngOnInit(): void {
    this.loadData(true);
  }

  async loadData(enableNetwork=false) {
    try {
      this.isLoading = true;
      this.errorMsg = null;
      if ((this.cacheSer.get(this.cacheID)?.isCached ?? false) && enableNetwork) {
        await this.ars.switchToOffline();
      }
      const response = await this.ars.getListOfMetaArticles(
        this.pageSize,
        this.lastDoc
      );
      await this.ars.switchToOnline();
      this.lastDoc = response.lastDocData;
      const values = [...this.articles, ...response.data];
      this.articles = values;
      this.cacheSer.set({
        id: this.cacheID,
        isCached: true,
        change: false,
      })
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }

}
