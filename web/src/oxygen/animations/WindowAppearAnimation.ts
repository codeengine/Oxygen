import { AbstractAnimation } from './AbstractAnimation';

export class WindowAppearAnimation extends AbstractAnimation {
  start() {
    this.element.style.opacity = '1';
  }
}
