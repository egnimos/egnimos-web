import { Timestamp } from "@angular/fire/firestore";
import { AuthorInfo } from "./article.model";
import { PublishType } from "../enum";
import { CategoryModel } from "./category.model";

export interface BookModel {
    id: String;
    authorInfo: AuthorInfo;
    releaseType: PublishType;
    thumbnail: String;
    name: String;
    nameSearch: String[];
    category: CategoryModel;
    tags: String[];
    description: String;
    descSearch: String[];
    numberOfModules: number;
    createdAt: Timestamp;
    updatedAt: Timestamp;
}