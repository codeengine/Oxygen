import { AbstractAnimation } from './AbstractAnimation';

export class ZoomOutClosingWindowAnimation extends AbstractAnimation {
  start() {
    this.element.style.transform = 'scale(0)';
  }
}
