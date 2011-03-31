package net.codeengine.windowmanagement.events {
    import flash.events.Event;
    
    import net.codeengine.windowmanagement.IWindow;
    
    
    public class WindowManagerEvent extends Event {
        public static const WINDOW_MAXIMIZED:String = "windowMaximized";
        
        public static const WINDOW_MINIMIZED:String = "windowMinimized";
        
        public static const WINDOW_RESTORED:String = "windowRestored";
        
        public static const WINDOW_GAINED_FOCUS:String = "windowGainedFocus";
        
        public static const WINDOW_MOVED:String = "windowMoved";
        
        public static const WINDOW_RESIZED:String = "windowResized";
        
        public static const SHEET_ADDED_TO_WINDOW:String = "sheetAddedToWindow";
        
        public static const SHEET_REMOVED_FROM_WINDOW:String = "sheetRemovedFromWindow";
        
        public static const DRAWER_ADDED_TO_WINDOW:String = "drawerAddedToWindow";
        
        public static const DRAWER_REMOVED_FROM_WINDOW:String = "drawerRemovedFromWindow";
        
        public static const WINDOW_CLOSED:String = "windowClosed";
        
        public var window:IWindow;
        
        public var EVENT_ID:String;
        
        public function WindowManagerEvent(type:String) {
            super(type);
            this.EVENT_ID = type;
        }
    
    }
}