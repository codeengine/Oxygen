import { AbstractAnimation } from './AbstractAnimation';

export class UnminimizeWindowAnimation extends AbstractAnimation {
  start() {
    this.element.style.display = 'block';
  }
}
