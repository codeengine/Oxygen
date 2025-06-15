import { AbstractAnimation } from './AbstractAnimation';

export class WindowMinimizingAnimation extends AbstractAnimation {
  start() {
    this.element.style.width = '200px';
    this.element.style.height = '30px';
  }
}
