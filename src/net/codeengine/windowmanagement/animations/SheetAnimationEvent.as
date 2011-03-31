package net.codeengine.windowmanagement.animations {
    import flash.events.Event;
    
    import net.codeengine.windowmanagement.ISheet;
    
    public class SheetAnimationEvent extends Event {
        public static const SHEET_CLOSING_ANIMATION_COMPLETE:String = "animationComplete";
        
        public var sheet:ISheet;
        
        public function SheetAnimationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }
    
    }
}