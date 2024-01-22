import { Timestamp } from "@angular/fire/firestore";

// collection name :users
export interface UserModel {
    id: String;
    name: String;
    nameSearch: String[];
    email: String;
    emailSearch: String[];
    photoURL?: String;
    dob?: String;
    gender?: Gender;
    providerType: ProviderType;
    ageAccountType?: AccountType;
    age?: number;
    createdAt: Timestamp;
    updatedAt: Timestamp;
}

export enum ProviderType {
    github = "github.com",
    google = "google.com",
    unknown = "unknown",
}

export enum Gender {
    male = "male",
    female = "female",
    RatherNotToSay = "Rather Not To Say",
}

export enum AccountType {
    Adult = "Adult",
    Child = "Child",
}