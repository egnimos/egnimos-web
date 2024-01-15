import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CategoryModel } from 'src/app/models/category.model';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-category-box',
  templateUrl: './category-box.component.html',
  styleUrls: ['./category-box.component.css']
})
export class CategoryBoxComponent implements OnInit {
  @Input() category: CategoryModel;
  color;
  initiationLetter: string = '';

  constructor(private us: UtilityService, private router: Router) { }

  ngOnInit(): void {
    this.color = this.us.getRandomDarkerColor();
    this.initiationLetter = this.category.name.substring(0, 2)
  }

  viewAllQuizOfSpecificCategory() {
    this.router.navigate(["view_all_category_based_articles"], {
      // replaceUrl: true,
      queryParams: {
        categoryInfo: JSON.stringify(this.category)
      }
    })
  }
}
