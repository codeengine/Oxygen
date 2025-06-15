import { IDecorator } from './IDecorator';

export class Decorator implements IDecorator {
  decorate(el: HTMLElement) {
    el.style.outline = '1px dashed #999';
  }
}
