import { Timestamp } from "@angular/fire/firestore";
import { AccountType, Gender, ProviderType } from "../enum";

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

