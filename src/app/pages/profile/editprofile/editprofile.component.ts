import { AfterViewInit, Component, NgZone, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { Ng2ImgMaxService } from 'ng2-img-max';
import { Subscription, takeUntil } from 'rxjs';
import { AccountType, Gender, UploadStatus } from 'src/app/enum';
import { UserModel } from 'src/app/models/user.model';
import { AuthService } from 'src/app/services/auth.service';
import { UploadService } from 'src/app/services/upload.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-editprofile',
  templateUrl: './editprofile.component.html',
  styleUrls: ['./editprofile.component.css']
})
export class EditprofileComponent implements OnInit, AfterViewInit, OnDestroy {
  @ViewChild('ed', { static: false }) edForm: NgForm;
  userData: UserModel;
  errorMsg = null;
  isLoading = false;
  selectedGender: Gender = null;
  dob = null;
  accountType = null;
  age = null;
  genders = Object.keys(Gender);
  photoURL: String = "";

  constructor(private router: Router,
    private route: ActivatedRoute,
    private as: AuthService,
    private us: UtilityService,
    private ups: UploadService,
    private ng2ImgMaxService: Ng2ImgMaxService, private ngZone: NgZone) { }

  ngAfterViewInit(): void {
    console.log("ng after view init");
    setTimeout(() => {
      this.initForm();
    }, 200);
  }

  ngOnInit(): void {
    this.userData = this.as.userInfo;
  }

  ngOnDestroy(): void {
    this.upSub?.unsubscribe();
  }

  private async initForm() {
    this.edForm.form.patchValue({
      name: this.userData?.name || '',
    });
    this.dob = this.userData?.dob || '';
    this.setAccountTypeandAge(this.dob)
    this.selectedGender = this.userData?.gender;
    this.photoURL = this.userData?.photoURL;
  }

  setQuizCategory(gender: Gender) {
    this.selectedGender = gender;
  }

  setAccountTypeandAge(value) {
    if (!value) {
      this.age = null;
      this.accountType = null
    };
    const date = new Date(value).getFullYear();
    const nowDate = new Date().getFullYear();
    this.age = nowDate - date;
    this.accountType = this.age > 17 ? AccountType.Adult : AccountType.Child;
  }

  profilePhotoFile: File = null;
  progress: number = 0;
  uploadStatus: UploadStatus = UploadStatus.complete;
  isUploading = false;
  upSub: Subscription;
  setFile(event) {
    const file = event.target.files[0]
    this.profilePhotoFile = file;
    console.log(file);
  }
  compressSub: Subscription = new Subscription();
  async uploadPhoto() {
    try {
      this.errorMsg = null;
      // const file: File = input?.target?.files[0];
      if (!this.profilePhotoFile) return;
      console.log("FILE:: ", this.profilePhotoFile);
      // const percentageReduction = 0.95;
      // const targetFileSize = this.profilePhotoFile.size * (1 - percentageReduction);
      // const maxSizeInMB = targetFileSize * 0.000001;
      let compressedFile = null
      this.ng2ImgMaxService.compress([this.profilePhotoFile], 0.1).subscribe((file) => {
        compressedFile = file;
        //upload the file
        if (!compressedFile) {
          throw "Failed to compress the image";
        }
        this.ups.uploadFile(compressedFile, "users/" + this.userData.id);
      });
      this.upSub = this.ups.uploadObs.subscribe((info) => {
        this.ngZone.run(async () => {
          this.progress = info.progress;
          this.uploadStatus = info.status;
          if (this.uploadStatus == UploadStatus.complete) {
            this.photoURL = info.uri;
            await this.as.updateProfileImage(this.userData.id, this.photoURL);
          }
          this.isUploading = this.uploadStatus == UploadStatus.uploading;
        });
        console.log("STATUS: ", this.uploadStatus, "PROGRESS: ", this.progress);
      });
      // .forEach((compressedImage) => {
      //   console.log("FILE:: ", compressedImage);
      //   compressedFile = compressedImage;
      //   // Do whatever you want to do with the compressed file, like send to server.
      // }).catch((error) => {
      //   throw error;
      // });
    } catch (error) {
      this.errorMsg = error;
    }
  }

  async submit() {
    try {
      this.isLoading = true;
      this.errorMsg = null;
      this.userData.name = this.edForm.value.name;
      this.userData.nameSearch = this.us.createSearchList(this.userData?.name ?? "");
      this.userData.email = this.userData?.email;
      this.userData.emailSearch = this.us.createSearchList(this.userData?.email ?? "");
      this.userData.dob = this.dob ?? 0;
      this.userData.ageAccountType = this.accountType;
      this.userData.age = this.age;
      this.userData.gender = this.selectedGender;
      this.userData.photoURL = this.photoURL;
      console.log(this.userData);
      await this.as.updateUser(this.userData)
      this.router.navigate(["profile"]);
    } catch (error) {
      this.errorMsg = error;
    } finally {
      this.isLoading = false;
    }
  }
}
