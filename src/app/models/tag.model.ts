import { Timestamp } from "@angular/fire/firestore";

// collection name :tags
export interface TagModel {
    id: string,
    creatorId: string,
    tagName: string,
    searchTagChar: string[],
    createdAt: Timestamp,
}