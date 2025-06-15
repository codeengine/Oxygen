import { IWindowManager } from './IWindowManager';
import { IWindow } from './IWindow';

export class WindowManager implements IWindowManager {
  windows: IWindow[] = [];

  addWindow(win: IWindow): void {
    this.windows.push(win);
  }

  removeWindow(id: string): void {
    this.windows = this.windows.filter(w => w.id !== id);
  }
}
