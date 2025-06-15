import { AbstractAnimation } from './AbstractAnimation';

export class PulseAnimation extends AbstractAnimation {
  start() {
    this.element.animate([{ opacity: 0.5 }, { opacity: 1 }], { duration: 500 });
  }
}
