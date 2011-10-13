package net.codeengine.windowmanagement.events {
    import flash.events.Event;
    
    import net.codeengine.windowmanagement.IWindow;
    
    
    public class WindowManagerEvent extends Event {
        public static const windowDidMaximize:String = "windowMaximized";
        public static const windowDidMinimize:String = "windowMinimized";
        public static const windowDidRestore:String = "windowRestored";
        public static const windowDidGainFocus:String = "windowGainedFocus";
        public static const windowDidMove:String = "windowMoved";
        public static const windowDidResize:String = "windowResized";
        public static const didAddSheetToWindow:String = "sheetAddedToWindow";
        public static const didRemoveSheetFromWindow:String = "sheetRemovedFromWindow";
        public static const didAddDrawerToWindow:String = "drawerAddedToWindow";
        public static const didRemoveDrawerFromWindow:String = "drawerRemovedFromWindow";
        public static const windowDidClose:String = "windowClosed";
        
        public var window:IWindow;
        
        public var EVENT_ID:String;
        
        public function WindowManagerEvent(type:String) {
            super(type);
            this.EVENT_ID = type;
        }
    
    }
}