import { Component, OnInit } from '@angular/core';
import { Timestamp } from '@angular/fire/firestore';
import { ActivatedRoute, Router } from '@angular/router';
import { BookModule } from 'src/app/models/book-module.model';
import { CategoryModel } from 'src/app/models/category.model';
import { CategoryService } from 'src/app/services/category.service';

@Component({
  selector: 'app-create-book',
  templateUrl: './create-book.component.html',
  styleUrls: ['./create-book.component.css']
})
export class CreateBookComponent implements OnInit {
  searchCategoryKeyword = "";
  searchedCategories = [];
  categories = [];
  selectedCategory: CategoryModel = null;
  isUploading = false;
  thumbnail: File = null;

  modules: BookModule[] = [
    {
      id: "1",
      parentId: "2",
      authorInfo: null,
      name: "Module-1",
      numberOfSessions: 2,
      numberOfSubModule: 1,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    }
  ];

  constructor(private cs: CategoryService, private router: Router, private route: ActivatedRoute) { }

  ngOnInit(): void {
    this.cs.getCategories().subscribe(data => {
      this.categories = data.categories as CategoryModel[];
    })
  }

  searchQuizCategory(): void {
    //search for quiz category
    this.searchedCategories = this.categories.filter(item => {
      return item.name.toLowerCase().includes(this.searchCategoryKeyword.toLowerCase());
    });
  }

  setQuizCategory(category: CategoryModel) {
    this.selectedCategory = category;
  }

  setFile(event) {
    const file = event.target.files[0]
    this.thumbnail = file;
    console.log(file);
  }

  async uploadThumbnail() {

  }

  async submit() {

  }

  navToCreateModule() {
    this.router.navigate(["create-module"]);
  }
}
