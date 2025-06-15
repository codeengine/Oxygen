import { AbstractDecoration } from './AbstractDecoration';

export class BackgroundDecoration extends AbstractDecoration {
  constructor(element: HTMLElement, private color: string) {
    super(element);
  }
  apply() {
    this.element.style.background = this.color;
  }
}
