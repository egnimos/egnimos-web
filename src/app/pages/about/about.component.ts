import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpEventType } from "@angular/common/http";

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrls: ['./about.component.css']
})
export class AboutComponent implements OnInit {
  markdown = ""

  constructor (private http: HttpClient) {}

  ngOnInit() {
    // this.loadMarkDownFile()
  }

  // loadMarkDownFile() {
  //   const mdFileURL = "assets/md/about_us.md";
  //   this.http.get(mdFileURL, {responseType: "text"}).subscribe((data) => {
  //     this.markdown = data
  //   });
  // } 
}
