import { Timestamp } from "@angular/fire/firestore";
import { AuthorInfo } from "./article.model";

export interface BookModel {
    id: String;
    authorInfo: AuthorInfo;
    thumbnail: String;
    name: String;
    category: String;
    tags: String[];
    description: String;
    numberOfModules: number;
    createdAt: Timestamp;
    updatedAt: Timestamp;
}