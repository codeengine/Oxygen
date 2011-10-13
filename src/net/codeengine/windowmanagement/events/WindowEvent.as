package net.codeengine.windowmanagement.events {
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    import net.codeengine.windowmanagement.IWindow;
    
    
    
    public class WindowEvent extends Event {
        public static const didMaximize:String = "onMaximize";
        public static const didMinimize:String = "onMinimize";
        public static const didRestore:String = "onRestore";
        public static const didShake:String = "onShake";
        public static const didGainFocus:String = "onWindowFocus";
        public static const didMove:String = "onWindowMoved";
        public static const didResize:String = "onWindowResize";
        public static const didAddSheet:String = "onSheetAdded";
        public static const didRemoveSheet:String = "onSheetRemoved";
        public static const didAddDrawer:String = "onDrawerAdded";
        public static const didRemoveDrawer:String = "onDrawerRemoved";
        public static const didClose:String = "onWindowClosed";
        public static const didCreate:String = "onWindowCreationComplete";
		public static const didHaltDragging:String = "haltDragging";
		public static const didAutmaticallyReposition:String = "automaticallyRepositioned";
        
        public var window:IWindow;
        
        public var EVENT_ID:String;
        
        public function WindowEvent(type:String) {
            super(type);
            this.EVENT_ID = type;
        }
    
    }
}