export class WindowFlipable {
  constructor(public front: HTMLElement, public back: HTMLElement) {}
  flip(showBack: boolean) {
    this.front.style.display = showBack ? 'none' : '';
    this.back.style.display = showBack ? '' : 'none';
  }
}
