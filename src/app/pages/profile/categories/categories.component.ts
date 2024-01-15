import { Component, OnInit } from '@angular/core';
import { CategoryModel } from 'src/app/models/category.model';
import { CategoryService } from 'src/app/services/category.service';

@Component({
  selector: 'app-categories',
  templateUrl: './categories.component.html',
  styleUrls: ['./categories.component.css']
})
export class CategoriesComponent implements OnInit {
  isLoading: boolean = true;
  categories: CategoryModel[] = [];
  
  constructor(private cs: CategoryService) {}
  
  ngOnInit(): void {
    this.cs.getCategories().subscribe(data => {
      this.categories = data.categories as CategoryModel[];
      this.isLoading = false;
    })
  }

}
