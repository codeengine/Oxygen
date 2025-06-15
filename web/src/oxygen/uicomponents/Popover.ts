export class Popover {
  constructor(public content: HTMLElement) {}
  show(target: HTMLElement) {
    target.appendChild(this.content);
  }
}
