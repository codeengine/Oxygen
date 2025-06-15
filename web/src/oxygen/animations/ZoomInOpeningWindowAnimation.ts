import { AbstractAnimation } from './AbstractAnimation';

export class ZoomInOpeningWindowAnimation extends AbstractAnimation {
  start() {
    this.element.style.transform = 'scale(1)';
  }
}
