import { Component, OnDestroy, OnInit } from '@angular/core';
import { Subject } from 'rxjs';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit, OnDestroy {
  ngOnDestroy(): void {
    // isTimeOutSession.unsubscribe();
  }
  timeOutSession = false;
  ngOnInit(): void {
    // timeOutGlobalVariable();
    // isTimeOutSession.subscribe((value) => {
    //   this.timeOutSession = value;
    // });
  }


}


// const isTimeOutSession = new Subject<boolean>();
// function timeOutGlobalVariable() {
//   setTimeout(() => {
//     isTimeOutSession.next(true);
//   }, 2000)
// }
