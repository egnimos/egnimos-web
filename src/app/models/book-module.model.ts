import { Timestamp } from "@angular/fire/firestore";
import { AuthorInfo } from "./article.model";

export interface BookModule {
    id: String;
    authorInfo: AuthorInfo;
    parentId: String;
    name: String;
    numberOfSessions: number;
    numberOfSubModule: number;
    createdAt: Timestamp;
    updatedAt: Timestamp;
}

export interface ModuleSession {
    id: String;
    moduleId: String;
    bookId: String;
    name: String;
}