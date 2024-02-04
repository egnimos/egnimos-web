import { AfterViewInit, Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { Timestamp } from '@angular/fire/firestore';
import { NgForm } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { Ng2ImgMaxService } from 'ng2-img-max';
import { Subscription, firstValueFrom } from 'rxjs';
import { PublishType, UploadStatus } from 'src/app/enum';
import { AuthorInfo } from 'src/app/models/article.model';
import { BookModule } from 'src/app/models/book-module.model';
import { BookModel } from 'src/app/models/book.model';
import { CategoryModel } from 'src/app/models/category.model';
import { AuthService } from 'src/app/services/auth.service';
import { BookService } from 'src/app/services/book.services';
import { CategoryService } from 'src/app/services/category.service';
import { UploadService } from 'src/app/services/upload.service';
import { UtilityService } from 'src/app/services/utility.service';
import { v4 as uuidv4 } from 'uuid';

@Component({
  selector: 'app-create-book',
  templateUrl: './create-book.component.html',
  styleUrls: ['./create-book.component.css']
})
export class CreateBookComponent implements OnInit, AfterViewInit, OnDestroy {
  @ViewChild('ed', { static: false }) edForm: NgForm;
  searchCategoryKeyword = "";
  searchedCategories = [];
  categories = [];
  selectedCategory: CategoryModel = null;
  tags = [];
  isUploading = false;
  isLoading = false;
  thumbnail: File = null;
  photoURL: String = "";
  releaseType: PublishType = PublishType.draft;
  publish = PublishType.publish;
  draft = PublishType.draft;
  bookInf: BookModel = null;
  bookId = uuidv4();
  errorMsg = null;
  userData = null;

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

  constructor(
    private as: AuthService,
    private cs: CategoryService,
    private ups: UploadService,
    private us: UtilityService,
    private bs: BookService,
    private ng2ImgMaxService: Ng2ImgMaxService,
    private router: Router,
    private route: ActivatedRoute
  ) { }


  ngAfterViewInit(): void {
    console.log("ng after view init");
    setTimeout(() => {
      this.initForm();
    }, 200);
  }

  ngOnDestroy(): void {
    this.upSub?.unsubscribe();
  }

  ngOnInit(): void {
    this.userData = this.as.userInfo;
    this.route.queryParams.subscribe((value) => {
      if (this.bookInf) return;
      if (!value?.data) return;
      this.bookInf = JSON.parse(value?.data) as BookModel;
    });
    this.cs.getCategories().subscribe(data => {
      this.categories = data.categories as CategoryModel[];
    })
  }

  private async initForm() {
    if (!this.bookInf) return;
    this.edForm.form.patchValue({
      name: this.bookInf.name || '',
      desc: this.bookInf.description || '',
    });
    this.bookId = this.bookInf?.id;
    this.photoURL = this.bookInf?.thumbnail;
    this.releaseType = this.bookInf?.releaseType;
    this.selectedCategory = this.bookInf?.category;
    this.tags = this.bookInf?.tags;
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

  setReleaseType(value) {
    this.releaseType = value;
    console.log("VALUE: ", value);
  }

  removeTag(tagI: String) {
    this.tags = this.tags.filter(tag => tag != tagI)
  }

  addTag() {
    const tag = this.edForm.value.tag
    const isPresent = this.tags.filter(t => t == tag).length != 0;
    // if tag is present then don't add the tag
    if (isPresent) return;
    this.tags.push(tag);
  }

  setFile(event) {
    const file = event.target.files[0]
    this.thumbnail = file;
    console.log(file);
  }

  progress: number = 0;
  uploadStatus: UploadStatus = UploadStatus.complete;
  upSub: Subscription;
  async uploadThumbnail() {
    try {
      this.errorMsg = null;
      //check if the thumbnail exists
      if (!this.thumbnail) return;
      console.log("FILE:: ", this.thumbnail);

      //COMPRESS THE IMAGE
      const compressedFile = await firstValueFrom(this.ng2ImgMaxService.compress([this.thumbnail], 0.1))
      this.ups.uploadFile(compressedFile, "users/books-thumbnail/" + this.bookId);

      this.upSub = this.ups.uploadObs.subscribe(async (info) => {
        // this.ngZone.run(async () => {
        this.progress = info.progress;
        this.uploadStatus = info.status;
        if (this.uploadStatus == UploadStatus.complete) {
          this.photoURL = info.uri;
          if (this.bookInf) {
            await this.bs.updateBookThumbnail(this.bookId, this.photoURL);
          }
        }
        this.isUploading = this.uploadStatus == UploadStatus.uploading;
        console.log("STATUS: ", this.uploadStatus, "PROGRESS: ", this.progress);
      });
    } catch (e) {
      console.log(e);
      const err = e?.error || e;
      this.errorMsg = e?.reason || e;
    }
  }

  async submit() {
    try {
      this.isLoading = true;
      console.log("RELEASE TYPE: ", this.releaseType);

      const authorInfo: AuthorInfo = {
        id: this.userData.id,
        name: this.userData.name,
        imageUri: this.userData.photoURL
      };
      const bookData: BookModel = {
        id: this.bookId,
        authorInfo: this.bookInf?.authorInfo ?? authorInfo,
        releaseType: this.releaseType,
        category: this.selectedCategory,
        tags: this.tags,
        thumbnail: this.photoURL,
        name: this.edForm.value.name,
        nameSearch: this.us.createSearchList(this.edForm.value.name),
        description: this.edForm.value.desc,
        descSearch: this.edForm.value.desc.split(" "),
        numberOfModules: this.bookInf?.numberOfModules,
        createdAt: this.bookInf?.createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now(),
      };
    } catch (error) {
      throw error;
    } finally {
      this.isLoading = false;
    }
  }

  navToCreateModule() {
    this.router.navigate(["create-module"]);
  }
}
