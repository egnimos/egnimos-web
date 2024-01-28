import { Component, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';
import { FetchingStatus, PublishType } from 'src/app/enum';
import { MetaArticleModel } from 'src/app/models/article.model';
import { ArticleService } from 'src/app/services/article.service';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-profilearticles',
  templateUrl: './profilearticles.component.html',
  styleUrls: ['./profilearticles.component.css']
})
export class ProfilearticlesComponent implements OnInit {
  articles: MetaArticleModel[] = [

  ];
  pageSize: number = 10;
  lastDoc: DocumentData = null;
  isLoading: boolean = false;
  errorMsg = null;



  ngOnInit(): void {
    this.loadData();
  }


  constructor(private ars: ArticleService, private as: AuthService) { }

  async loadData() {
    try {
      this.isLoading = true;
      const response = await this.ars.getListOfMetaArticleBasedOnCreatorId(this.as.userInfo.id,
        PublishType.publish,
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
