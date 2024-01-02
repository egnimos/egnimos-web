import { Injectable, inject } from "@angular/core";
import { Firestore } from "@angular/fire/firestore";

@Injectable({
    providedIn: 'root'
})
export class AuthService {
    private firestore: Firestore = inject(Firestore)

    //login with google
    async loginWithGoogle(): Promise<void> {
        try {

        } catch (error) {
            throw error;
        }
    }

    //login with github
    async loginWithGithub(): Promise<void> {
        try {

        } catch (error) {
            throw error;
        }
    }

    //save the user
    async saveUser(): Promise<void> {
        try {

        } catch (error) {
            throw error;
        }
    }
    //update the user
    async updateUser(): Promise<void> {
        try {

        } catch (error) {
            throw error;
        }
    }

    //delete the user
    async deleteUser(): Promise<void> {
        try {
            
        } catch (error) {
            throw error;
        }
    }
}