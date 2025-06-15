import { AbstractAnimation } from './AbstractAnimation';

export class DisappearPopoverAnimation extends AbstractAnimation {
  start() {
    this.element.style.opacity = '0';
  }
}
