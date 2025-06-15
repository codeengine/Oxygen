import { AbstractAnimation } from './AbstractAnimation';

export class WindowAlertingAnimation extends AbstractAnimation {
  start() {
    this.element.animate([{ transform: 'scale(1)' }, { transform: 'scale(1.1)' }], { duration: 200 });
  }
}
