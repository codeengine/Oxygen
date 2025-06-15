import React, { createContext, useContext, useState } from 'react';
import { WindowManager } from '../oxygen/WindowManager';
import { IWindow } from '../oxygen/IWindow';

export interface WindowDescriptor extends IWindow {}

interface WindowManagerContextProps {
  windows: WindowDescriptor[];
  addWindow: (win: WindowDescriptor) => void;
  removeWindow: (id: string) => void;
}

const WindowManagerContext = createContext<WindowManagerContextProps | undefined>(undefined);
const manager = new WindowManager();

export const useWindowManager = (): WindowManagerContextProps => {
  const ctx = useContext(WindowManagerContext);
  if (!ctx) {
    throw new Error('useWindowManager must be used within WindowManagerProvider');
  }
  return ctx;
};

const WindowManagerProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [windows, setWindows] = useState<WindowDescriptor[]>(manager.windows);

  const addWindow = (win: WindowDescriptor) => {
    manager.addWindow(win);
    setWindows([...manager.windows]);
  };
  const removeWindow = (id: string) => {
    manager.removeWindow(id);
    setWindows([...manager.windows]);
  };

  return (
    <WindowManagerContext.Provider value={{ windows, addWindow, removeWindow }}>
      {children}
    </WindowManagerContext.Provider>
  );
};

export default WindowManagerProvider;
