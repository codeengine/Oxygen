export abstract class AbstractDecoration {
  constructor(public element: HTMLElement) {}
  abstract apply(): void;
}
