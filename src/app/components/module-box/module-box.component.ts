import { Component, Input } from '@angular/core';
import { Router } from '@angular/router';
import { BookModule } from 'src/app/models/book-module.model';
import { AuthService } from 'src/app/services/auth.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-module-box',
  templateUrl: './module-box.component.html',
  styleUrls: ['./module-box.component.css']
})
export class ModuleBoxComponent {
  updatedAt = "";
  @Input() moduleInfo: BookModule;
  authenticatedUser = null;

  constructor(private as: AuthService, private us: UtilityService, private router: Router) { }

  ngOnInit(): void {
    this.authenticatedUser = this.as.userInfo;
    this.updatedAt =
      this.us.secondsToDateTime(this.moduleInfo.updatedAt?.seconds).toLocaleDateString();
  }

  isDeleting = false;
  async deleteModule() {
    try {
      this.isDeleting = true;

    } catch (error) {
      alert(error);
    } finally {
      this.isDeleting = false;
    }
  }

  editModule() {
    this.router.navigate(["book", "create-module"], {
      queryParams: {
        data: JSON.stringify(this.moduleInfo),
      }
    });
  }

  navToViewModule() {
    this.router.navigate(["view-module"], {
      queryParams: {
        data: JSON.stringify(this.moduleInfo),
      }
    });
  }
}
