import { Injectable, inject } from "@angular/core";
import { Firestore, doc, getDoc, setDoc } from "@angular/fire/firestore";
import { UserActivityModel } from "../models/user.model";

@Injectable({
    providedIn: "root",
})
export class ActivityService {
    private firestore = inject(Firestore);
    //save user activities
    async saveUserActivities(activity: UserActivityModel): Promise<void> {
        try {
            const activityDocRef = doc(this.firestore, "user-activities/" + activity.id);
            const response = await setDoc(activityDocRef, activity, { merge: true });
        } catch (error) {
            throw error;
        }
    }

    async getUserActivities(userId: String): Promise<UserActivityModel> {
        try {
            const activityDocRef = doc(this.firestore, "user-activities/" + userId);
            const response = await getDoc(activityDocRef);
            return response?.data() as UserActivityModel;
        } catch (error) {
            throw error;
        }
    }

    //save user histories

    //save user article activites
}