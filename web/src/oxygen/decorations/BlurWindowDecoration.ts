import { AbstractWindowDecoration } from './AbstractWindowDecoration';

export class BlurWindowDecoration extends AbstractWindowDecoration {
  apply() {
    this.windowEl.style.filter = 'blur(4px)';
  }
}
