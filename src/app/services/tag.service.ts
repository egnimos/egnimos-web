import { Injectable, inject } from "@angular/core";
import { DocumentData, Firestore, collection, deleteDoc, doc, getDocs, limit, orderBy, query, setDoc, startAfter, where } from "@angular/fire/firestore";
import { TagModel } from "../models/tag.model";
import { Subject } from "rxjs";

@Injectable({
    providedIn: 'root'
})
export class TagService {
    private firestore: Firestore = inject(Firestore);
    private tagList: TagModel[] = [];
    tagsSub: Subject<TagModel[]> = new Subject<TagModel[]>();

    get tags(): TagModel[] {
        return this.tagList;
    }

    //save tags
    async saveTags(tagInfo: TagModel): Promise<void> {
        try {
            const tagInf = tagInfo;
            const docRef = doc(this.firestore, "tags/" + tagInf.id)
            const response = await setDoc(docRef, tagInf, { merge: true });
            console.log(response)
            this.tagList.push(tagInfo);
            this.tagsSub.next(this.tagList.slice());
        } catch (error) {
            throw error;
        }
    }

    //delete tags
    async deleteTags(id: string): Promise<void> {
        try {
            const docRef = doc(this.firestore, "tags/" + id)
            const response = await deleteDoc(docRef)
            console.log(response)
            this.tagList = this.tagList.filter(tag => tag.id != id);
            this.tagsSub.next(this.tagList.slice());
        } catch (error) {
            throw error;
        }
    }

    //get tags
    async getTags(creatorId: string, pageSize: number, lastVisible: DocumentData | null): Promise<{
        data: TagModel[], lastDocData: DocumentData | null
    }> {
        let lastVisibleDoc = lastVisible;
        const result: TagModel[] = [];
        try {
            const sortByCreatedAt = orderBy('createdAt', 'desc');
            const collectionRef = lastVisibleDoc == null ? query(
                collection(this.firestore, "tags/"),
                where("creatorId", "==", creatorId),
                sortByCreatedAt,
                limit(pageSize)
            ) : query(
                collection(this.firestore, "tags/"),
                where("creatorId", "==", creatorId),
                sortByCreatedAt,

                startAfter(lastVisibleDoc?.data().createdAt),
                limit(pageSize)
            );
            const response = await getDocs(collectionRef)
            console.log(response);
            response.forEach((doc) => {
                const val = doc.data() as TagModel;
                result.push(val)
            });
            if (response.docs.length != 0) {
                lastVisibleDoc = response.docs[response.docs.length - 1];
            }
            this.tagList = result;
            // this.tagsSub.next(this.tagList.slice());
        } catch (error) {
            throw error;
        } finally {
            return { data: this.tagList, lastDocData: lastVisibleDoc, };
        }
    }

    //search tags
    async searchTags(keyword: string, pageSize: number, lastVisible: DocumentData | null): Promise<{
        data: TagModel[], lastDocData: DocumentData | null
    }> {
        const searchTags: TagModel[] = [];
        let lastVisibleDoc = lastVisible;
        try {
            const collectionRef = lastVisibleDoc == null ? query(
                collection(this.firestore, "tags/"),
                where("searchTagChar", "array-contains", keyword),
                limit(pageSize),
            )
                : query(
                    collection(this.firestore, "tags/"),
                    where("searchTagChar", "array-contains", keyword),
                    startAfter(lastVisibleDoc?.data().createdAt),
                    limit(pageSize),
                )

            const response = await getDocs(collectionRef)
            console.log(response);
            response.forEach((doc) => {
                const val = doc.data() as TagModel;
                searchTags.push(val)
            });
            if (response.docs.length != 0) {
                lastVisibleDoc = response.docs[response.docs.length - 1];
            }
        } catch (error) {
            throw error;
        } finally {
            return { data: searchTags, lastDocData: lastVisibleDoc, };
        }
    }
}