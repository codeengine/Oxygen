export abstract class AbstractAnimation {
  constructor(public element: HTMLElement) {}
  abstract start(): void;
}
