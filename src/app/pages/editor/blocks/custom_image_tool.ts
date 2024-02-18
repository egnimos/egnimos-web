import { deleteObject, getStorage, ref } from '@angular/fire/storage';
import ImageTool from '@editorjs/image';

export class CustomImageTool extends ImageTool {
    removed() {
        try {
            const d = this;
            const url = d["_data"]["file"]["url"] || null;
            console.log("DATA: ", d, "URL: ", url);
            if (!url) return;
            this.deleteArticleImages(url);
        } catch (error) {
            console.log("REMOVED ERROR: ", error);
            throw error;
        }
    }

    async deleteArticleImages(url: string): Promise<void> {
        try {
            const storageRef = ref(getStorage(), url);
            await deleteObject(storageRef);
        } catch (error) {
            throw error;
        }
    }
}