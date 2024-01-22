import { AfterViewInit, Component, OnInit, ViewChild } from '@angular/core';
import { NgForm } from '@angular/forms';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { Ng2ImgMaxService } from 'ng2-img-max';
import { Subscription } from 'rxjs';
import { AccountType, Gender, UserModel } from 'src/app/models/user.model';
import { AuthService } from 'src/app/services/auth.service';
import { UtilityService } from 'src/app/services/utility.service';

@Component({
  selector: 'app-editprofile',
  templateUrl: './editprofile.component.html',
  styleUrls: ['./editprofile.component.css']
})
export class EditprofileComponent implements OnInit, AfterViewInit {
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
    private ng2ImgMaxService: Ng2ImgMaxService) { }

  ngAfterViewInit(): void {
    console.log("ng after view init");
    setTimeout(() => {
      this.initForm();
    }, 200);
  }

  ngOnInit(): void {
    this.userData = this.as.userInfo;
  }

  private async initForm() {
    this.edForm.form.patchValue({
      name: this.userData?.name || '',
    });
    this.dob = this.userData?.dob || '';
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
  compressSub: Subscription = new Subscription();
  async uploadPhoto() {
    try {
      this.errorMsg = null;
      // const file: File = input?.target?.files[0];
      if (!this.profilePhotoFile) return;
      console.log("FILE:: ", this.profilePhotoFile);
      const percentageReduction = 0.95;
      const targetFileSize = this.profilePhotoFile.size * (1 - percentageReduction);
      const maxSizeInMB = targetFileSize * 0.000001;
      this.ng2ImgMaxService.compress([this.profilePhotoFile], maxSizeInMB)
        .forEach((compressedImage) => {
          console.log("FILE:: ", compressedImage);
          // Do whatever you want to do with the compressed file, like send to server.
        });
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
      this.userData.email = this.edForm.value.email;
      this.userData.emailSearch = this.us.createSearchList(this.userData?.email ?? "");
      this.userData.dob = this.dob ?? 0;
      this.userData.ageAccountType = this.accountType;
      this.userData.age = this.age;
      this.userData.gender = this.selectedGender;
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
