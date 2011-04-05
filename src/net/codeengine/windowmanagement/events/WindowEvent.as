package net.codeengine.windowmanagement.events {
    import flash.display.DisplayObject;
    import flash.events.Event;
    
    import net.codeengine.windowmanagement.IWindow;
    
    
    
    public class WindowEvent extends Event {
        public static const ON_MAXIMIZE:String = "onMaximize";
        
        public static const ON_MINIMIZE:String = "onMinimize";
        
        public static const ON_RESTORE:String = "onRestore";
        
        public static const ON_SHAKE:String = "onShake";
        
        public static const ON_FOCUS:String = "onWindowFocus";
        
        public static const ON_MOVE:String = "onWindowMoved";
        
        public static const ON_RESIZE:String = "onWindowResize";
        
        public static const ON_SHEET_ADDED:String = "onSheetAdded";
        
        public static const ON_SHEET_REMOVED:String = "onSheetRemoved";
        
        public static const ON_DRAWER_ADDED:String = "onDrawerAdded";
        
        public static const ON_DRAWER_REMOVED:String = "onDrawerRemoved";
        
        public static const ON_WINDOW_CLOSED:String = "onWindowClosed";
        
        public static const ON_WINDOW_CREATION_COMPLETE:String = "onWindowCreationComplete";
		public static const HALT_DRAGGING:String = "haltDragging";
		public static const WINDOW_AUTOMATICALLY_REPOSITIONED:String = "automaticallyRepositioned";
        
        public var window:IWindow;
        
        public var EVENT_ID:String;
        
        public function WindowEvent(type:String) {
            super(type);
            this.EVENT_ID = type;
        }
    
    }
}