import { AfterViewInit, Component, ElementRef, OnInit, ViewChild } from '@angular/core';
import EditorJS from '@editorjs/editorjs';
import Header from '@editorjs/header';
import NestedList from '@editorjs/nested-list';
import ImageTool from '@editorjs/image';
import CodeTool from '@editorjs/code';
// import CodeTool from '@rxpm/editor-js-code';
// import editorjsCodeflask from '@calumk/editorjs-codeflask';
import AttachesTool from '@editorjs/attaches';
import Table from '@editorjs/table';
import Embed from '@editorjs/embed';
import Delimiter from '@editorjs/delimiter';
import Quote from '@editorjs/quote';
import LinkTool from '@editorjs/link';
// import notifier from 'codex-notifier';
// import {ConfirmNotifierOptions, NotifierOptions, PromptNotifierOptions} from 'codex-notifier';
import { exampleSetup } from 'prosemirror-example-setup';
import { Schema, DOMParser } from 'prosemirror-model';
import { schema } from 'prosemirror-schema-basic';
import { addListNodes } from 'prosemirror-schema-list';
import { EditorState } from 'prosemirror-state';
import { EditorView } from 'prosemirror-view';
import { Config, defaultData } from './editor.config';
import { ArticleService } from 'src/app/services/article.service';
import { ActivatedRoute, Router } from '@angular/router';
import { PublishType } from 'src/app/models/article.model';
import { UtilityService } from 'src/app/services/utility.service';

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
  previewOn = false;
  editorData = defaultData;

  constructor(private as: ArticleService,
    private router: Router,
    private route: ActivatedRoute,
    private us: UtilityService,
    private config: Config) { }

  ngOnInit(): void {
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
      data: this.editorData
    });
    this.checkIsEditorReady();
  }

  ngAfterViewInit(): void {

  }

  async checkIsEditorReady() {
    try {
      await this.editor.isReady;
      this.isEditorReady = true;
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
      const pubType = this.us.enumToString(PublishType, publishType);
      const docData = await this.editor.save()
      console.log('Article data: ', docData);
    } catch (error) {
      this.errorMsg = error;
    }
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
