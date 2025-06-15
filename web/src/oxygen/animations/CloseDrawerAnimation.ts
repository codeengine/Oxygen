import { AbstractAnimation } from './AbstractAnimation';

export class CloseDrawerAnimation extends AbstractAnimation {
  start() {
    this.element.style.display = 'none';
  }
}
