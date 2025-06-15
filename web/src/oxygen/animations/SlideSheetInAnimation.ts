import { AbstractAnimation } from './AbstractAnimation';

export class SlideSheetInAnimation extends AbstractAnimation {
  start() {
    this.element.style.transform = 'translateY(0)';
  }
}
