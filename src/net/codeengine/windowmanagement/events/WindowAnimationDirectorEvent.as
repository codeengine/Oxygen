package net.codeengine.windowmanagement.events
{
    import flash.events.Event;
    
    import net.codeengine.windowmanagement.IWindow;
    import net.codeengine.windowmanagement.IWindowProxy;

    public class WindowAnimationDirectorEvent extends Event
    {
        public static var OPEN_ANIMATION_COMPLETE:String = "windowOpeningAnimationCompleted";
        public static var CLOSE_ANIMATION_COMPLETE:String = "windowClosingAnimationCompleted";
        public static var ALERT_ANIMATION_COMPLETE:String = "windowAlertingAnimationCompleted";
        public static var MINIMIZE_ANIMATION_COMPLETE:String = "windowMinimizingAnimationComplete";
        public static var MINIMIZED_WINDOW_CLICK:String = "windowMinimizedClick";
        public static var UNMINIMIZE_ANIMATION_COMPLETE:String = "windowUnminimizedAnimationComplete";
        public var windowProxy:IWindowProxy;
        public function WindowAnimationDirectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
        
    }
}