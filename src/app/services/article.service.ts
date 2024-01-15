import { Injectable, inject } from "@angular/core";
import { DocumentData, Firestore, collection, deleteDoc, doc, getDoc, getDocs, limit, orderBy, query, setDoc, startAfter, where } from "@angular/fire/firestore";
import { ArticleModel, MetaArticleModel, PublishType } from "../models/article.model";
import { Subject } from "rxjs";

@Injectable({
    providedIn: 'root'
})
export class ArticleService {
    private firestore: Firestore = inject(Firestore);
    private draftMetaArticleList: MetaArticleModel[] = [];
    private publishMetaArticleList: MetaArticleModel[] = [];
    draftMetaArticlesSub: Subject<MetaArticleModel[]> = new Subject<MetaArticleModel[]>();
    publishMetaArticlesSub: Subject<MetaArticleModel[]> = new Subject<MetaArticleModel[]>();


    get draftMetaArticles(): MetaArticleModel[] {
        return this.draftMetaArticleList;
    }

    get publishMetaArticles(): MetaArticleModel[] {
        return this.publishMetaArticleList;
    }

    //save article (Draft, Publish)
    async saveArticle(metaArticle: MetaArticleModel, article: ArticleModel): Promise<void> {
        try {
            const metaDocRef = doc(this.firestore, "meta_articles/" + metaArticle.id);
            const articleDocRef = doc(this.firestore, "meta_articles/" + metaArticle.id + "article_data/" + article.id);
            const response = await setDoc(metaDocRef, metaArticle, { merge: true });
            console.log(response);
            const resp = await setDoc(articleDocRef, article, { merge: true });
            console.log(resp);
            if (metaArticle.publishType == PublishType.draft) {
                this.draftMetaArticleList.push(metaArticle);
                this.draftMetaArticlesSub.next(this.draftMetaArticleList.slice());
            }

            if (metaArticle.publishType == PublishType.publish) {
                this.publishMetaArticleList.push(metaArticle);
                this.publishMetaArticlesSub.next(this.publishMetaArticleList.slice());
            }
        } catch (error) {
            throw error;
        }
    }

    //delete article
    async deleteArticle(metaArticleId: string, publishType: PublishType): Promise<void> {
        try {
            const metaDocRef = doc(this.firestore, "meta_articles/" + metaArticleId);
            await deleteDoc(metaDocRef);
            if (publishType == PublishType.draft) {
                this.draftMetaArticleList = this.draftMetaArticleList.filter(metaArt => metaArt.id != metaArticleId);
                this.draftMetaArticlesSub.next(this.draftMetaArticleList.slice());
            }

            if (publishType == PublishType.publish) {
                this.publishMetaArticleList = this.publishMetaArticleList.filter(metaArt => metaArt.id != metaArticleId);
                this.publishMetaArticlesSub.next(this.publishMetaArticleList.slice());
            }
        } catch (error) {
            throw error;
        }
    }

    //update article
    async updateArticle(metaArticle: MetaArticleModel, article: ArticleModel): Promise<void> {
        try {
            await this.saveArticle(metaArticle, article);
        } catch (error) {
            throw error;
        }
    }

    //get article
    async getArticle(metaArticleId: string, articleId: string): Promise<ArticleModel> {
        try {
            const articleDocRef = doc(this.firestore, "meta_articles/" + metaArticleId + "article_data/" + articleId);
            const response = await getDoc(articleDocRef);
            return response?.data() as ArticleModel;
        } catch (error) {
            throw error;
        }
    }

    //get the list of articles based on publish type (Publish)
    async getListOfMetaArticles(pageSize: number, lastVisible: DocumentData | null): Promise<{
        data: MetaArticleModel[], lastDocData: DocumentData | null
    }> {
        const result = [];
        let lastVisibleDoc = lastVisible;
        try {
            const sortByCreatedAt = orderBy('createdAt', 'desc');
            const collectionRef = lastVisibleDoc == null ? query(
                collection(this.firestore, "meta_articles/"),
                where("publishType", "==", PublishType.publish),
                sortByCreatedAt,
                limit(pageSize),
            ) : query(
                collection(this.firestore, "meta_articles/"),
                where("publishType", "==", PublishType.publish),
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
        } catch (error) {
            throw error;
        } finally {
            return { data: result, lastDocData: lastVisibleDoc };
        }
    }

    //get the list of articles based on creator/user id
    async getListOfMetaArticleBasedOnCreatorId(
        creatorId: string,
        publishType: PublishType,
        pageSize: number,
        lastVisible: DocumentData | null): Promise<{
            data: MetaArticleModel[], lastDocData: DocumentData | null
        }> {
        const result = [];
        let lastVisibleDoc = lastVisible;
        try {
            const sortByCreatedAt = orderBy('createdAt', 'desc');
            const collectionRef = lastVisibleDoc == null ? query(
                collection(this.firestore, "meta_articles/"),
                where("publishType", "==", publishType),
                where("authorInfo.id", "==", creatorId),
                sortByCreatedAt,
                limit(pageSize)
            ) : query(
                collection(this.firestore, "meta_articles/"),
                where("publishType", "==", publishType),
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

        } catch (error) {
            throw error;
        } finally {
            return { data: result, lastDocData: lastVisibleDoc };
        }
    }

}