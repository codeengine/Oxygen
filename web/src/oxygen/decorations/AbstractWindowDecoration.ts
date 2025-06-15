export abstract class AbstractWindowDecoration {
  constructor(public windowEl: HTMLElement) {}
  abstract apply(): void;
}
