import React, { useEffect } from 'react';
import { useWindowManager } from './WindowManagerProvider';

const DemoWindow: React.FC = () => {
  const { addWindow, removeWindow } = useWindowManager();
  useEffect(() => {
    addWindow({
      id: 'demo',
      title: 'Demo Window',
      content: (
        <div>
          <h3>Demo Window</h3>
          <p>This is a demo window managed by WindowManagerProvider.</p>
        </div>
      )
    });
    return () => removeWindow('demo');
  }, []);

  return null;
};

export default DemoWindow;
