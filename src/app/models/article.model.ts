import { CategoryModel } from "./category.model";
import { TagModel } from "./tag.model";

// collection name :meta_articles
export interface MetaArticleModel {
    id: string,
    articleDataId: string,
    authorInfo: AuthorInfo,
    category: CategoryModel,
    tags: TagModel[],
    publishType: PublishType,
    title: string,
    titleSearch: string[],
    description: string,
    descSearch: string[],
    createdAt: string,
    updatedAt: string,
}

// collection name :articles
export interface ArticleModel {
    id: string,
    editorType: EditorType,
    articleData
}

export interface AuthorInfo {
    id: string,
    name: string,
    imageUri: string,
}

export enum PublishType {
    publish = "publish",
    draft = "draft",
}

export enum EditorType {
    quill = "quill",
    editorjs = "editorjs",
}