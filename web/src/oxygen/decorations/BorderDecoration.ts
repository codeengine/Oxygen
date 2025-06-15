import { AbstractWindowDecoration } from './AbstractWindowDecoration';

export class BorderDecoration extends AbstractWindowDecoration {
  constructor(windowEl: HTMLElement, private color: string = '#000') {
    super(windowEl);
  }
  apply() {
    this.windowEl.style.border = `1px solid ${this.color}`;
  }
}
