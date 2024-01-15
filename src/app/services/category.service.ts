import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { Observable } from "rxjs";

@Injectable({
    providedIn: "root",
})
export class CategoryService {

    constructor(private http: HttpClient) {}
    //save category to the file

    //get the category from the main file
    getCategories(): Observable<any> {
        try {
            return this.http.get<any>('assets/categories.json');
        } catch (error) {
            throw error;
        }
    }
}