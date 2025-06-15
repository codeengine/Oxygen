import { AbstractAnimation } from './AbstractAnimation';

export class WindowFlipAnimation extends AbstractAnimation {
  start() {
    this.element.style.transform = 'rotateY(180deg)';
  }
}
