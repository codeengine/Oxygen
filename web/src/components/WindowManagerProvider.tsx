import React, { createContext, useContext, useState } from 'react';

export interface WindowDescriptor {
  id: string;
  title: string;
}

interface WindowManagerContextProps {
  windows: WindowDescriptor[];
  addWindow: (win: WindowDescriptor) => void;
  removeWindow: (id: string) => void;
}

const WindowManagerContext = createContext<WindowManagerContextProps | undefined>(undefined);

export const useWindowManager = (): WindowManagerContextProps => {
  const ctx = useContext(WindowManagerContext);
  if (!ctx) {
    throw new Error('useWindowManager must be used within WindowManagerProvider');
  }
  return ctx;
};

const WindowManagerProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [windows, setWindows] = useState<WindowDescriptor[]>([]);

  const addWindow = (win: WindowDescriptor) => setWindows(ws => [...ws, win]);
  const removeWindow = (id: string) => setWindows(ws => ws.filter(w => w.id !== id));

  return (
    <WindowManagerContext.Provider value={{ windows, addWindow, removeWindow }}>
      {children}
    </WindowManagerContext.Provider>
  );
};

export default WindowManagerProvider;
