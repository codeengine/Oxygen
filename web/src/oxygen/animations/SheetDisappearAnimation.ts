import { AbstractAnimation } from './AbstractAnimation';

export class SheetDisappearAnimation extends AbstractAnimation {
  start() {
    this.element.style.display = 'none';
  }
}
