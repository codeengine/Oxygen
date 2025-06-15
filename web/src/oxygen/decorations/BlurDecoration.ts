import { AbstractDecoration } from './AbstractDecoration';

export class BlurDecoration extends AbstractDecoration {
  apply() {
    this.element.style.filter = 'blur(4px)';
  }
}
