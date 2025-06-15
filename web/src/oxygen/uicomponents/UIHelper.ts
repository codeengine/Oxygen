export class UIHelper {
  static createDiv(className: string): HTMLDivElement {
    const d = document.createElement('div');
    d.className = className;
    return d;
  }
}
