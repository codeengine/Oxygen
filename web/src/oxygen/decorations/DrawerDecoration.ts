import { AbstractDecoration } from './AbstractDecoration';

export class DrawerDecoration extends AbstractDecoration {
  apply() {
    this.element.style.boxShadow = '0 0 6px rgba(0,0,0,0.3)';
  }
}
