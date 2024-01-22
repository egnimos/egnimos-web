import { Injectable, inject } from "@angular/core";
import { Firestore, Timestamp, doc, getDoc, setDoc } from "@angular/fire/firestore";
import { Auth, getAuth, signInWithPopup, signOut, GithubAuthProvider, GoogleAuthProvider, AuthProvider, onAuthStateChanged, User } from "@angular/fire/auth";
import { ProviderType, UserModel } from "../models/user.model";
import { Router } from "@angular/router";
import { Subject } from "rxjs";
import { UtilityService } from "./utility.service";

@Injectable({
    providedIn: 'root'
})
export class AuthService {
    private loggedInUserInfo: UserModel = null;
    private storageUserKey = "user";
    private firestore: Firestore = inject(Firestore)
    private fireauth: Auth = getAuth();
    private githubProvider = new GithubAuthProvider();
    private googleProvider = new GoogleAuthProvider();
    isLoggedIn: Subject<boolean> = new Subject<boolean>();

    get userInfo(): UserModel {
        return JSON.parse(localStorage.getItem(this.storageUserKey)) as UserModel;
    }

    constructor(private router: Router, private us: UtilityService) {
        onAuthStateChanged(this.fireauth, (user: User | null) => {
            // if user is not null then change the state of the auth
            if (user) {
                // localStorage.setItem(this.storageUserKey, JSON.stringify(user));
                this.isLoggedIn.next(true);
                console.log("IS LOGGED IN");
            } else {
                localStorage.removeItem(this.storageUserKey)
                this.isLoggedIn.next(false);
                console.log("LOGGED OUT");
            }
        })
    }

    //login with google
    async authWithGoogle(isLoginProcess: boolean): Promise<void> {
        try {
            await this.authWithAuthProvider(this.googleProvider, isLoginProcess);
        } catch (error) {
            throw error;
        }
    }

    //login with github
    async authWithGithub(isLoginProcess: boolean): Promise<void> {
        try {
            await this.authWithAuthProvider(this.githubProvider, isLoginProcess);
        } catch (error) {
            throw error;
        }
    }

    async authWithAuthProvider(provider: AuthProvider, isLoginProcess: boolean): Promise<void> {
        try {
            const response = await signInWithPopup(this.fireauth, provider)
            console.log(response, "AUTH RESPONSE")
            //check if the user is registered or not
            await this.getUser(response.user?.uid);
            //check for the auth process 
            if (isLoginProcess) {
                //check if it is not registered
                if (!this.loggedInUserInfo) {
                    throw "user doesn't exists";
                }
            } else {
                //check if it is registered
                if (this.loggedInUserInfo) {
                    throw "user already exists";
                }
                await this.saveUser(response?.user);
                // this.router.navigate([""]);
            }
            this.router.navigate([""]);
        } catch (error) {
            console.log(error);
            throw error;
        }
    }

    async signout() {
        try {
            await signOut(this.fireauth);
            this.router.navigate(["auth"]);
        } catch (error) {
            throw error;
        }
    }

    //save the user
    async saveUser(user: User): Promise<void> {
        try {
            const uid = user.uid;
            const userInfo: UserModel = {
                id: uid,
                name: user?.displayName,
                nameSearch: this.us.createSearchList(user?.displayName ?? ""),
                email: user?.email,
                photoURL: user?.providerData[0]?.photoURL || "",
                emailSearch: this.us.createSearchList(user?.email ?? ""),
                providerType: this.getProviderType(user?.providerData[0]?.providerId||""),
                createdAt: Timestamp.now(),
                updatedAt: Timestamp.now(),
            }
            const userDoc = doc(this.firestore, "users/" + uid)
            const response = await setDoc(userDoc, userInfo, { merge: true });
            localStorage.setItem(this.storageUserKey, JSON.stringify(userInfo))
        } catch (error) {
            throw error;
        }
    }


    getProviderType(type: String) {
        switch (type) {
            case "google.com":
                return ProviderType.google;
            case "github.com":
                return ProviderType.github;
            default:
                return ProviderType.unknown;
        }
    }

    async getUser(uid: string): Promise<void> {
        try {
            const userDoc = doc(this.firestore, "users/" + uid)
            const response = await getDoc(userDoc)
            if (response.exists) {
                this.loggedInUserInfo = response.data() as UserModel;
                localStorage.setItem(this.storageUserKey, JSON.stringify(this.loggedInUserInfo))
            }
        } catch (error) {
            throw error;
        }
    }

    //update the user
    async updateUser(userInfo: UserModel): Promise<void> {
        try {
            const userDoc = doc(this.firestore, "users/" + userInfo.id)
            const response = await setDoc(userDoc, userInfo, { merge: true });
            localStorage.setItem(this.storageUserKey, JSON.stringify(userInfo))
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