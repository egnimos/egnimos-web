import { Timestamp } from "@angular/fire/firestore";
import { AccountType, Gender, ProviderType } from "../enum";
import { CategoryModel } from "./category.model";

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


export interface UserActivityModel {
    id: String;
    totalNumberArticlesPublished: number;
    totalNumberArticlesDraft: number;
    categoryBasedArticleCounts?: CategoryBasedCounts[];
    totalNumberBooksPublished?: number;
    totalNumberBooksDraft?: number;
    categoryBasedBookCounts?: CategoryBasedCounts[];
}


export interface CategoryBasedCounts {
    category: CategoryModel,
    count: number,
}