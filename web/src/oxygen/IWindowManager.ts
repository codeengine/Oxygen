import { IWindow } from './IWindow';

export interface IWindowManager {
  windows: IWindow[];
  addWindow(win: IWindow): void;
  removeWindow(id: string): void;
}
