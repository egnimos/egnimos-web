import { Injectable, inject } from "@angular/core";
import { BookModel } from "../models/book.model";
import { Subject } from "rxjs";
import { DocumentData, Firestore, collection, deleteDoc, doc, getDocs, limit, orderBy, query, setDoc, startAfter, updateDoc, where } from "@angular/fire/firestore";
import { PublishType } from "../enum";
import { UserActivityModel } from "../models/user.model";
import { ArticleModel } from "../models/article.model";


@Injectable({
    providedIn: "root"
})
export class BookService {
    private firestore = inject(Firestore);
    private draftBooks: BookModel[] = [];
    private publishBooks: BookModel[] = [];
    draftBooksSub: Subject<BookModel[]> = new Subject<BookModel[]>();
    publishBooksSub: Subject<BookModel[]> = new Subject<BookModel[]>();

    get draftBookList(): BookModel[] {
        return this.draftBooks;
    }

    get publishBookList(): BookModel[] {
        return this.publishBooks;
    }

    constructor() { }

    //save/update the book
    async saveBook(book: BookModel, userActivity: UserActivityModel): Promise<void> {
        try {
            const bookDoc = doc(this.firestore, "books/" + book.id);
            const resp = await setDoc(bookDoc, book, { merge: true });
            console.log(resp);
            if (book.releaseType == PublishType.draft) {
                this.draftBooks.push(book);
                this.draftBooksSub.next(this.draftBooks.slice());
            }

            if (book.releaseType == PublishType.publish) {
                this.publishBooks.push(book);
                this.publishBooksSub.next(this.publishBooks.slice());
            }
        } catch (error) {
            throw error;
        }
    }

    async updateBookThumbnail(bookId: String, imageURI: String): Promise<void> {
        try {
            const bookDoc = doc(this.firestore, "books/" + bookId)
            await updateDoc(bookDoc, {
                "thumbnail": imageURI,
            });
        } catch (error) {
            throw error;
        }
    }

    //get the list of book based on publish type (Publish)
    async getListOfBook(pageSize: number, lastVisible: DocumentData | null): Promise<{
        data: BookModel[], lastDocData: DocumentData | null
    }> {
        const result = [];
        let lastVisibleDoc = lastVisible;
        try {
            const sortByCreatedAt = orderBy('createdAt', 'desc');
            const collectionRef = lastVisibleDoc == null ? query(
                collection(this.firestore, "books/"),
                where("releaseType", "==", PublishType.publish),
                sortByCreatedAt,
                limit(pageSize),
            ) : query(
                collection(this.firestore, "books/"),
                where("releaseType", "==", PublishType.publish),
                sortByCreatedAt,

                startAfter(lastVisibleDoc?.data().createdAt),
                limit(pageSize)
            );
            const response = await getDocs(collectionRef)
            response.forEach((doc) => {
                const val = doc?.data()
                result.push(val);
            });
            if (response.docs.length != 0) {
                lastVisibleDoc = response.docs[response.docs.length - 1]
            }
            return { data: result, lastDocData: lastVisibleDoc };
        } catch (error) {
            console.log(error);
            throw error;
        }
    }

    //get the list of book based on creator/user id
    async getListOfBookBasedOnCreatorId(
        creatorId: String,
        publishType: String,
        pageSize: number,
        lastVisible: DocumentData | null): Promise<{
            data: BookModel[], lastDocData: DocumentData | null
        }> {
        const result = [];
        let lastVisibleDoc = lastVisible;
        try {
            const sortByCreatedAt = orderBy('createdAt', 'desc');
            const collectionRef = lastVisibleDoc == null ? query(
                collection(this.firestore, "books/"),
                where("releaseType", "==", publishType),
                where("authorInfo.id", "==", creatorId),
                sortByCreatedAt,
                limit(pageSize)
            ) : query(
                collection(this.firestore, "books/"),
                where("releaseType", "==", publishType),
                where("authorInfo.id", "==", creatorId),
                sortByCreatedAt,

                startAfter(lastVisibleDoc?.data().createdAt),
                limit(pageSize)
            );
            const response = await getDocs(collectionRef)
            response.forEach((doc) => {
                const val = doc?.data()
                result.push(val);
            });
            if (response.docs.length != 0) {
                lastVisibleDoc = response.docs[response.docs.length - 1]
            }
            return { data: result, lastDocData: lastVisibleDoc };
        } catch (error) {
            console.log(error);
            throw error;
        }
    }

    updateListAndSub(values, publishType) {
        // let values = []
        if (publishType == "draft") {
            // values = [...this.draftMetaArticleList, ...result];
            this.draftBooks = values;
            this.draftBooksSub.next(this.draftBooks.slice());
        }

        if (publishType == "publish") {
            // values = [...this.publishMetaArticleList, ...result];
            this.publishBooks = values;
            this.publishBooksSub.next(this.publishBooks.slice());
        }
    }


    //delete the book
    async deleteBook(bookId: String, publishType: PublishType): Promise<void> {
        try {
            const bookDoc = doc(this.firestore, "books/" + bookId);
            await deleteDoc(bookDoc);
            if (publishType == PublishType.publish) {
                this.publishBooks = this.publishBooks.filter(book => book.id != bookId);
                this.publishBooksSub.next(this.publishBooks.slice());
            }

            if (publishType == PublishType.draft) {
                this.draftBooks = this.draftBooks.filter(book => book.id != bookId);
                this.draftBooksSub.next(this.draftBooks.slice());
            }
        } catch (error) {
            throw error;
        }
    }
}