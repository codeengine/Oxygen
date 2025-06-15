import { AbstractAnimation } from './AbstractAnimation';

export class WindowDisappearAnimation extends AbstractAnimation {
  start() {
    this.element.style.opacity = '0';
  }
}
