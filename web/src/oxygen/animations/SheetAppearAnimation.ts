import { AbstractAnimation } from './AbstractAnimation';

export class SheetAppearAnimation extends AbstractAnimation {
  start() {
    this.element.style.display = 'block';
  }
}
