import { AfterViewInit, Component, ElementRef, OnInit, ViewChild, inject } from '@angular/core';
import EditorJS, { OutputBlockData, OutputData } from '@editorjs/editorjs';
import { Config, defaultData } from './editor.config';
import { ArticleService } from 'src/app/services/article.service';
import { ActivatedRoute, Router } from '@angular/router';
import { UtilityService } from 'src/app/services/utility.service';
import { EditorType, PublishType } from 'src/app/enum';
import { v4 as uuidv4 } from 'uuid';
import { ArticleModel, AuthorInfo, MetaArticleModel } from 'src/app/models/article.model';
import { AuthService } from 'src/app/services/auth.service';
import { CategoryModel } from 'src/app/models/category.model';
import { Timestamp } from '@angular/fire/firestore';
import { CategoryService } from 'src/app/services/category.service';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.css'],
  providers: [Config]
})
export class EditorComponent implements OnInit, AfterViewInit {
  // @ViewChild("editor") editor: ElementRef;
  @ViewChild("content") content: ElementRef;
  editor: EditorJS = null
  errorMsg = null
  isEditorReady = false;
  isSaving = false;
  isLoading = false;

  previewOn = false;
  editorData = defaultData;
  searchCategoryKeyword = "";
  searchedCategories = [];
  categories = [];
  selectedCategory: CategoryModel = null;
  metaArticle: MetaArticleModel = null;
  articleInfo: ArticleModel = null;
  private config: Config = inject(Config);

  constructor(private ars: ArticleService,
    private router: Router,
    private route: ActivatedRoute,
    private us: UtilityService,
    private as: AuthService, private cs: CategoryService) { }

  ngOnInit(): void {
    this.route.queryParams.subscribe((value) => {
      if (this.articleInfo) return;
      if (!value) return;
      this.metaArticle = JSON.parse(value?.data) as MetaArticleModel;
    });
    this.cs.getCategories().subscribe(data => {
      this.categories = data.categories as CategoryModel[];
    })
  }

  ngAfterViewInit(): void {
    setTimeout(() => {
      this.initForm();
    }, 200);
  }

  private async initForm() {
    try {
      this.isLoading = true;
      if (this.metaArticle) {
        //load the article
        this.articleInfo = await this.ars.getArticle(this.metaArticle.id, this.metaArticle.articleDataId);
        this.editorData = this.articleInfo.articleData;
        this.selectedCategory = this.metaArticle.category;
      };
      this.editor = new EditorJS({
        /**
         * Create a holder for the Editor and pass its ID
         */
        holder: 'editorjs',
        placeholder: "Write something interesting",
        autofocus: true,
        /**
         * Available Tools list.
         */
        tools: this.config.editorTool,
        data: this.editorData,
      });
      await this.checkIsEditorReady();
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }

  searchQuizCategory(): void {
    //search for quiz category
    this.searchedCategories = this.categories.filter(item => {
      return item.name.toLowerCase().includes(this.searchCategoryKeyword.toLowerCase());
    });
  }

  setQuizCategory(category: CategoryModel) {
    this.selectedCategory = category;
  }

  async checkIsEditorReady() {
    try {
      await this.editor.isReady;
      this.isEditorReady = true;
      // const undo = new Undo({ editor: this.editor, });
      // undo.initialize(this.editorData);
    } catch (error) {
      this.errorMsg = error;
      this.isEditorReady = false;
    }
  }

  async showPreview() {
    this.previewOn = !this.previewOn;
    await this.editor.readOnly.toggle(this.previewOn);
  }


  //save the article
  async saveArticle(publishType: string) {
    try {
      this.errorMsg = null;
      this.isSaving = true;
      const pubType = this.us.enumToString(PublishType, publishType);
      const docData = await this.editor.save()
      console.log('Article data: ', docData);
      const resp = this.getData(docData);
      const title: String = resp["header"] ?? "";
      const desc: String = resp["paragraph"] ?? "";
      const thumbnail: String = resp["image"] ?? null;
      //create article data info
      const articleInf: ArticleModel = {
        id: this.articleInfo?.id ?? uuidv4(),
        editorType: this.articleInfo?.editorType ?? EditorType.editorjs,
        articleData: docData,
      }
      const authorInfo: AuthorInfo = {
        id: this.as.userInfo.id,
        name: this.as.userInfo.name,
        imageUri: this.as.userInfo.photoURL
      }
      const categoryInfo: CategoryModel = this.selectedCategory;
      //create meta article info
      const metaArticleInfo: MetaArticleModel = {
        id: this.metaArticle?.id ?? uuidv4(),
        articleDataId: articleInf.id,
        authorInfo: authorInfo,
        category: categoryInfo,
        tags: [],
        publishType: this.getPubType(pubType),
        thumbnail: thumbnail,
        title: title,
        titleSearch: this.us.createSearchList(title ?? ""),
        description: desc,
        // length >= 30 ?
        //   desc.substring(0, 30)
        //   : desc.substring(0, desc.length),
        descSearch: desc.split(" ", 20),
        createdAt: this.metaArticle?.createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now(),
      };

      if (!categoryInfo) {
        throw "Provide Category For Article";
      }
      console.log(metaArticleInfo);
      await this.ars.saveArticle(metaArticleInfo, articleInf);
      if (pubType == "draft") {
        this.router.navigate(["profile","drafts"])
      } else {
        this.router.navigate(["profile"])
      }
      //save the article
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isSaving = false;
    }
  }

  getPubType(value: String) {
    if (value === "draft") {
      return PublishType.draft;
    } else {
      return PublishType.publish;
    }
  }

  getData(doc: OutputData): {} {
    let data = {};
    const blocks = doc.blocks;
    for (let key in blocks) {
      //header
      const type = blocks[key]["type"] as String;
      if (!data["header"] && type == "header") {
        data["header"] = blocks[key]["data"]["text"]
      }
      //paragraph
      if (!data["paragraph"] && type == "paragraph") {
        data["paragraph"] = blocks[key]["data"]["text"]
      }
      //image
      if (!data["image"] && type == "image") {
        data["image"] = blocks[key]["data"]["file"]["url"]
      }

      if (data["header"] && data["paragraph"] && data["image"]) {
        break;
      }
    }
    return data;
  }

  //update the article
  async updateArticle() {
    try {

    } catch (error) {
      this.errorMsg = error;
    }
  }

  //delete the article
  async deleteArticle() {
    try {

    } catch (error) {
      this.errorMsg = error;
    }
  }
}
