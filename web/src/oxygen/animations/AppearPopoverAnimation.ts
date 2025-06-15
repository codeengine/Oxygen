import { AbstractAnimation } from './AbstractAnimation';

export class AppearPopoverAnimation extends AbstractAnimation {
  start() {
    this.element.style.opacity = '1';
  }
}
