import { AbstractAnimation } from './AbstractAnimation';

export class WindowMaximizingAnimation extends AbstractAnimation {
  start() {
    this.element.style.width = '100%';
    this.element.style.height = '100%';
  }
}
