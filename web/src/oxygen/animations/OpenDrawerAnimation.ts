import { AbstractAnimation } from './AbstractAnimation';

export class OpenDrawerAnimation extends AbstractAnimation {
  start() {
    this.element.style.display = 'block';
  }
}
