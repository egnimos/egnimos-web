import { Component, EventEmitter, Input, Output } from '@angular/core';

@Component({
  selector: 'app-image-pop',
  templateUrl: './image-pop.component.html',
  styleUrls: ['./image-pop.component.css']
})
export class ImagePopComponent {
  @Input() imageUrl;
  @Input() show = true;
  @Output() close = new EventEmitter<boolean>();
  classPop = "animate__animated animate__zoomIn";

  closeImagePop() {
    this.classPop = "animate__animated animate__zoomOut"
    setTimeout(() => {
      this.show = false;
      this.close.emit(false);
    }, 1000)
  }
}
