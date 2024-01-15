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

const editorConfig = new EditorJS({
    /**
     * Create a holder for the Editor and pass its ID
     */
    holder: 'editorjs',
    placeholder: "Write something interesting",
    autofocus: true,
    /**
     * Available Tools list.
     */
    tools: {
        header: Header,
        list: {
            class: NestedList,
            inlineToolbar: true,
            // shortcut: 'CMD+SHIFT+8',
            config: {
                defaultStyle: 'ordered',
                // nested: true,
            },
        },
        code: {
            class: CodeTool,
        },
        linkTool: {
            class: LinkTool,
        },
        embed: {
            class: Embed,
            inlineToolbar: true,
            config: {
                services: {
                    youtube: true,
                }
            }
        },
        quote: Quote,
        table: Table,
        delimiter: Delimiter,
        image: {
            class: ImageTool,
            config: {
                uploader: {
                    /**
                     * Upload file to the server and return an uploaded image data
                     * @param {File} file - file selected from the device or pasted by drag-n-drop
                     * @return {Promise.<{success, file: {url}}>}
                     */
                    uploadByFile(file) {
                        // your own uploading logic here
                        console.log("hello, world")
                    },
                },
            }
        },
        attaches: {
            class: AttachesTool,
            config: {
                endpoint: 'http://localhost:8008/uploadFile'
            }
        }
    },
});

export class Config {
    editorConfig: EditorJS = editorConfig;
}