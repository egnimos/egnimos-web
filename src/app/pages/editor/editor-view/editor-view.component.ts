import { Component, OnInit, inject } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import EditorJS from '@editorjs/editorjs';
import { ArticleModel, MetaArticleModel } from 'src/app/models/article.model';
import { ArticleService } from 'src/app/services/article.service';
import { UtilityService } from 'src/app/services/utility.service';
import { Config } from '../editor.config';

@Component({
  selector: 'app-editor-view',
  templateUrl: './editor-view.component.html',
  styleUrls: ['./editor-view.component.css'],
  providers: [Config]
})
export class EditorViewComponent implements OnInit {
  article: ArticleModel = null;
  metaArticle: MetaArticleModel = null;
  updateTime = ""
  isLoading = false;
  errorMsg = null;
  editor: EditorJS = null;
  private config: Config = inject(Config);

  constructor(private route: ActivatedRoute, private router: Router,
    private us: UtilityService, private ars: ArticleService) { }

  ngOnInit(): void {
    this.route.queryParams.subscribe((value) => {
      if (this.article) return;

      this.metaArticle = JSON.parse(value.data) as MetaArticleModel;
      this.updateTime = this.us.secondsToDateTime(this.metaArticle.updatedAt?.seconds).toLocaleDateString();
      this.loadData();
    });
  }

  //load data
  async loadData() {
    try {
      this.isLoading = true;
      this.article = await this.ars.getArticle(this.metaArticle.id, this.metaArticle.articleDataId);
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
        data: this.article.articleData,
        onReady: () => {

        },
      });
      await this.checkIsEditorReady();
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }

  async checkIsEditorReady() {
    try {
      await this.editor.isReady;
      await this.editor.readOnly.toggle(true);
    } catch (error) {
      throw error;
    }
  }
}
