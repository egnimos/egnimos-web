import { AfterViewInit, Component, OnDestroy, OnInit } from '@angular/core';
import { DocumentData } from '@angular/fire/firestore';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { MetaArticleModel } from 'src/app/models/article.model';
import { CategoryModel } from 'src/app/models/category.model';
import { ArticleService } from 'src/app/services/article.service';
import { CategoryService } from 'src/app/services/category.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-viewall',
  templateUrl: './viewall.component.html',
  styleUrls: ['./viewall.component.css']
})
export class ViewallComponent implements OnInit, OnDestroy, AfterViewInit {
  categories = [];
  category: CategoryModel = null;
  articles: MetaArticleModel[] = [];
  type: ViewAllType = ViewAllType.unknown;
  pageSize: number = 10;
  lastVisible: DocumentData = null
  isLoading: boolean = false;
  paramSub: Subscription;
  querySub: Subscription;
  catSub: Subscription;

  constructor(private cs: CategoryService, private as: ArticleService, private route: ActivatedRoute, private router: Router) { }

  ngAfterViewInit(): void {

  }
  ngOnDestroy(): void {
    this.paramSub?.unsubscribe();
    this.querySub?.unsubscribe();
    this.catSub?.unsubscribe();
  }

  ngOnInit(): void {
    this.paramSub = this.route.params.subscribe((params: Params) => {
      this.type = params['type'];
      console.log("TYPE: ", this.type)
    });
    if (this.type == ViewAllType.category) {
      this.catSub = this.cs.getCategories().subscribe(data => {
        this.categories = (data.categories as [CategoryModel]);
      })
    }
    if (this.type == ViewAllType.categorybasedQuiz) {
      console.log("QUERY PARAMAS:: ", this.type)
      this.querySub = this.route.queryParams.subscribe((qParam) => {
        console.log("QUERY PARAMAS:: ", qParam)
        this.category = JSON.parse(qParam["categoryInfo"])
      });
      this.fetchCategoryBasedArticles()
    }
  }

  async fetchCategoryBasedArticles() {
    try {
      this.isLoading = true;
      const response = await this.as.getListOfMetaArticleBasedOnCategoryName(this.category, this.pageSize, this.lastVisible);
      this.lastVisible = response.lastDocData;
      const values = [...this.articles, ...response.data];
      this.articles = values;
    } catch (error) {
      alert(error);
    } finally {
      this.isLoading = false;
    }
  }
}


export enum ViewAllType {
  category = 'category',
  sessonalquiz = 'sessonalquiz',
  normalquiz = 'normalquiz',
  categorybasedQuiz = 'categorybasedQuiz',
  unknown = 'unknown'
}