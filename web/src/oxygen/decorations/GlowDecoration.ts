import { AbstractDecoration } from './AbstractDecoration';

export class GlowDecoration extends AbstractDecoration {
  apply() {
    this.element.style.boxShadow = '0 0 10px #ffd700';
  }
}
