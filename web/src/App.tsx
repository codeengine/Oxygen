import React, { useState } from 'react';
import WindowManagerProvider from './components/WindowManagerProvider';
import DemoWindow from './components/DemoWindow';

const App: React.FC = () => {
  const [showDemo, setShowDemo] = useState(true);
  return (
    <WindowManagerProvider>
      <div style={{ padding: 16 }}>
        <button onClick={() => setShowDemo(!showDemo)}>
          {showDemo ? 'Close Demo' : 'Open Demo'}
        </button>
        {showDemo && <DemoWindow />}
      </div>
    </WindowManagerProvider>
  );
};

export default App;
