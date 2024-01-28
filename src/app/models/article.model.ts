import { Timestamp } from "@angular/fire/firestore";
import { EditorType, PublishType } from "../enum";
import { CategoryModel } from "./category.model";
import { TagModel } from "./tag.model";

// collection name :meta_articles
export interface MetaArticleModel {
    id: String,
    articleDataId: String,
    authorInfo: AuthorInfo,
    category: CategoryModel,
    tags: TagModel[],
    publishType: PublishType,
    title: String,
    titleSearch: String[],
    description: String,
    descSearch: String[],
    thumbnail: String;
    createdAt: Timestamp,
    updatedAt: Timestamp,
}

// collection name :articles
export interface ArticleModel {
    id: string,
    editorType: EditorType,
    articleData
}

export interface AuthorInfo {
    id: String,
    name: String,
    imageUri: String,
}

