import Header from '@editorjs/header';
import Paragraph from '@editorjs/paragraph';
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
import AlignmentTuneTool from 'editorjs-text-alignment-blocktune';

import { Injectable } from '@angular/core';
import { v4 as uuidv4 } from 'uuid';
import { getDownloadURL, getStorage, ref, uploadBytesResumable } from "@angular/fire/storage";
import { Ng2ImgMaxService } from 'ng2-img-max';
import { firstValueFrom } from 'rxjs';

export const defaultData = {
    time: 1552744582955,
    blocks: [
        {
            type: "header",
            data: {
                level: 1,
                placeholder: "Title...",
                text: "Title...",
            }
        },
        {
            type: "paragraph",
            data: {
                level: 1,
                placeholder: "Add small description...",
                text: "Add small description...",
            }
        }
    ],
};

let comImg: Ng2ImgMaxService

@Injectable()
export class Config {

    constructor(private ng2ImgMaxService: Ng2ImgMaxService) {
        comImg = this.ng2ImgMaxService
    }
    // editorConfig: EditorJS = editorConfig;
    editorTool = {
        header: {
            class: Header,
            inlineToolbar: true,
            tunes: ['align'],
        },
        paragraph: {
            class: Paragraph,
            inlineToolbar: true,
            tunes: ['align'],
        },
        list: {
            class: NestedList,
            inlineToolbar: true,
            tunes: ['align'],
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
            inlineToolbar: true,
            tunes: ['align'],
        },
        embed: {
            class: Embed,
            inlineToolbar: true,
            tunes: ['align'],
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
            inlineToolbar: true,
            tunes: ['align'],
            config: {
                uploader: {
                    /**
                     * Upload file to the server and return an uploaded image data
                     * @param {File} file - file selected from the device or pasted by drag-n-drop
                     * @return {Promise.<{success, file: {url}}>}
                     */
                    async uploadByFile(file) {
                        // your own uploading logic here
                        console.log("hello, world", file);
                        // const us = new UploadService();
                        // const ng2ImgMaxService = inject(Ng2ImgMaxService)
                        const id = uuidv4();
                        let compressedFile = null
                        const compSub = comImg.compress([file], 0.5)
                        compressedFile = await firstValueFrom(compSub);
                        const url = await uploadArticleImages(file, id);
                        return {
                            success: 1,
                            file: {
                                url: url,
                                // any other image data you want to store, such as width, height, color, extension, etc
                            }
                        };

                    },
                },
            }
        },
        align: {
            class: AlignmentTuneTool,
            inlineToolbar: true,
        },
        attaches: {
            class: AttachesTool,
            config: {
                endpoint: 'http://localhost:8008/uploadFile'
            }
        }
    };
}
// const storageFB = () => {
//     const storage: Storage = inject(Storage)
//     return storage;
// }
async function uploadArticleImages(file: File, id: String): Promise<String> {
    try {
        if (!file) return;
        const storageRef = ref(getStorage(), "users/" + "articles" + "/" + id);
        const response = await uploadBytesResumable(storageRef, file);
        const url = await getDownloadURL(storageRef);
        return url;
    } catch (error) {
        throw error;
    }
}