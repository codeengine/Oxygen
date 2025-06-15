import { AbstractAnimation } from './AbstractAnimation';

export class SlideSheetOutAnimation extends AbstractAnimation {
  start() {
    this.element.style.transform = 'translateY(100%)';
  }
}
