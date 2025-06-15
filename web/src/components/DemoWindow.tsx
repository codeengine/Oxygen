import React, { useEffect } from 'react';
import { useWindowManager } from './WindowManagerProvider';

const DemoWindow: React.FC = () => {
  const { addWindow, removeWindow } = useWindowManager();
  useEffect(() => {
    addWindow({ id: 'demo', title: 'Demo Window' });
    return () => removeWindow('demo');
  }, []);

  return (
    <div style={{ border: '1px solid #ccc', padding: 8, marginTop: 16 }}>
      <h3>Demo Window</h3>
      <p>This is a demo window managed by WindowManagerProvider.</p>
    </div>
  );
};

export default DemoWindow;
