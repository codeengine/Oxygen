import { AbstractDecoration } from './AbstractDecoration';

export class ForegroundDecoration extends AbstractDecoration {
  apply() {
    this.element.style.zIndex = '1000';
  }
}
