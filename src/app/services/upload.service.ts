import { inject } from "@angular/core";
import { Storage, getDownloadURL, ref, uploadBytesResumable } from "@angular/fire/storage";
import { Ng2ImgMaxService } from "ng2-img-max";

export class UploadService {
    private storage: Storage = inject(Storage)

    constructor() {}
    //upload the profile photo
    async uploadProfilePhoto(file: File, userId: String): Promise<String> {
        try {
            if (!file) return;
            //compress the image
            const storageRef = ref(this.storage, "users/" + userId);
            const response = await uploadBytesResumable(storageRef, file);
            const url = await getDownloadURL(storageRef);
            return url;
        } catch (error) {
            throw error;
        }
    }

    //upload article photo
    async uploadArticleImages(file: File, articleId: String, id: String): Promise<String> {
        try {
            if (!file) return;
            const storageRef = ref(this.storage, "users/" + articleId+"/"+id);
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
            const storageRef = ref(this.storage, "users/" + articleId+"/"+id);
            const response = await uploadBytesResumable(storageRef, file);
            const url = await getDownloadURL(storageRef);
            return url;
        } catch (error) {
            throw error
        }
    }
}