import { AbstractDecoration } from './AbstractDecoration';

export class SheetDecoration extends AbstractDecoration {
  apply() {
    this.element.style.border = '1px solid #ccc';
  }
}
