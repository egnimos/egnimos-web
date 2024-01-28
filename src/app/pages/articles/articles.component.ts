import { Component, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';
import { PublishType } from 'src/app/enum';
import { MetaArticleModel } from 'src/app/models/article.model';
import { ArticleService } from 'src/app/services/article.service';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-articles',
  templateUrl: './articles.component.html',
  styleUrls: ['./articles.component.css']
})
export class ArticlesComponent implements OnInit {
  articles: MetaArticleModel[] = [

  ];
  pageSize: number = 10;
  lastDoc: DocumentData = null;
  isLoading: boolean = false;
  errorMsg = null;

  constructor(private ars: ArticleService, private as: AuthService) { }

  ngOnInit(): void {
    this.loadData();
  }

  async loadData() {
    try {
      this.isLoading = true;
      const response = await this.ars.getListOfMetaArticles(
        this.pageSize,
        this.lastDoc
      );
      this.lastDoc = response.lastDocData;
      const values = [...this.articles, ...response.data];
      this.articles = values;
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }

}
