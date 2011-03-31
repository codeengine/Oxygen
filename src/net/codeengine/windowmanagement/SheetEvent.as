package net.codeengine.windowmanagement {
    import flash.events.Event;
    
    public class SheetEvent extends Event {
        public static const CLOSE_SHEET:String = "closeSheet";
        
        public static const MOUSE_MOVE:String = "sheetMouseMove";
        
        public var sheet:ISheet;
        
        public function SheetEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }
    
    }
}