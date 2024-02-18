import Header from '@editorjs/header';
import Paragraph from '@editorjs/paragraph';
import NestedList from '@editorjs/nested-list';
import CodeTool from '@editorjs/code';
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
import { CustomImageTool } from './blocks/custom_image_tool';
import { Color } from './blocks/text_color';


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

export let comImg: Ng2ImgMaxService

@Injectable()
export class Config {

    constructor(private ng2ImgMaxService: Ng2ImgMaxService) {
        comImg = this.ng2ImgMaxService
    }
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
            class: CustomImageTool as any,
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
        Color: {
            class: Color, // if load from CDN, please try: window.ColorPlugin
            config: {
                colorCollections: ['#EC7878', '#9C27B0', '#673AB7', '#3F51B5', '#0070FF', '#03A9F4', '#00BCD4', '#4CAF50', '#8BC34A', '#CDDC39', '#FFF'],
                defaultColor: '#FF1300',
                type: 'text',
                customPicker: true, // add a button to allow selecting any colour  
            },
        },
        Marker: {
            class: Color, // if load from CDN, please try: window.ColorPlugin
            config: {
                defaultColor: '#FFBF00',
                type: 'marker',
                icon: `<svg fill="#000000" height="200px" width="200px" version="1.1" id="Icons" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 32 32" xml:space="preserve"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <g> <path d="M17.6,6L6.9,16.7c-0.2,0.2-0.3,0.4-0.3,0.6L6,23.9c0,0.3,0.1,0.6,0.3,0.8C6.5,24.9,6.7,25,7,25c0,0,0.1,0,0.1,0l6.6-0.6 c0.2,0,0.5-0.1,0.6-0.3L25,13.4L17.6,6z"></path> <path d="M26.4,12l1.4-1.4c1.2-1.2,1.1-3.1-0.1-4.3l-3-3c-0.6-0.6-1.3-0.9-2.2-0.9c-0.8,0-1.6,0.3-2.2,0.9L19,4.6L26.4,12z"></path> </g> <g> <path d="M28,29H4c-0.6,0-1-0.4-1-1s0.4-1,1-1h24c0.6,0,1,0.4,1,1S28.6,29,28,29z"></path> </g> </g></svg>`
            }
        },
        align: {
            class: AlignmentTuneTool,
            config: {
                default: "left",
                blocks: {
                    header: 'left',
                    list: 'left',
                    image: 'left',
                },
            },
        },
    };
}
// const storageFB = () => {
//     const storage: Storage = inject(Storage)
//     return storage;
// }
export async function uploadArticleImages(file: File, id: String): Promise<String> {
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

