import { Injectable, inject } from "@angular/core";
import { Storage, getDownloadURL, ref, uploadBytesResumable } from "@angular/fire/storage";
import { Ng2ImgMaxService } from "ng2-img-max";
import { Subject } from "rxjs";
import { UploadStatus } from "../enum";




@Injectable({
    providedIn: 'root',
})
export class UploadService {
    private storage: Storage = inject(Storage)
    private uploadProcess: Subject<{ progress: number, status: UploadStatus, uri: String }> = new Subject<{ progress: number, status: UploadStatus, uri: String }>();
    uploadObs = this.uploadProcess.asObservable();
    constructor() { }
    //upload the profile photo
    uploadProfilePhoto(file: File, userId: String): void {
        try {
            if (!file) return;
            //compress the image
            const storageRef = ref(this.storage, "users/" + userId);
            const response = uploadBytesResumable(storageRef, file);
            response.on("state_changed", (snapshot) => {
                const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                console.log('Upload is ' + progress + '% done');
                this.uploadProcess.next({
                    progress: progress,
                    status: UploadStatus.uploading,
                    uri: null,
                });
            }, (error) => {
                throw error;
            }, async () => {
                const url = await getDownloadURL(storageRef);
                this.uploadProcess.next({
                    progress: 100,
                    status: UploadStatus.complete,
                    uri: url,
                });
            });
        } catch (error) {
            throw error;
        }
    }

    //upload the file with progress
    uploadFile(file: File, url: string): void {
        try {
            if (!file) return;
            //compress the image
            const storageRef = ref(this.storage, url);
            const response = uploadBytesResumable(storageRef, file);
            response.on("state_changed", (snapshot) => {
                const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
                console.log('Upload is ' + progress + '% done');
                this.uploadProcess.next({
                    progress: progress,
                    status: UploadStatus.uploading,
                    uri: null,
                });
            }, (error) => {
                throw error;
            }, async () => {
                const url = await getDownloadURL(storageRef);
                this.uploadProcess.next({
                    progress: 100,
                    status: UploadStatus.complete,
                    uri: url,
                });
            });
        } catch (error) {
            throw error;
        }
    }

    //upload article photo
    async uploadArticleImages(file: File, id: String): Promise<String> {
        try {
            if (!file) return;
            const storageRef = ref(this.storage, "users/" + "articles" + "/" + id);
            const response = await uploadBytesResumable(storageRef, file);
            const url = await getDownloadURL(storageRef);
            return url;
        } catch (error) {
            throw error;
        }
    }

    //upload the attachements
    async uploadAttachments(file: File, articleId: String, id: String) {
        try {
            if (!file) return;
            const storageRef = ref(this.storage, "users/" + articleId + "/" + id);
            const response = await uploadBytesResumable(storageRef, file);
            const url = await getDownloadURL(storageRef);
            return url;
        } catch (error) {
            throw error
        }
    }
}

export { UploadStatus };
