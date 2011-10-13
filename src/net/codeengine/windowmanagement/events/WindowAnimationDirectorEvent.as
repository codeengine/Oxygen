package net.codeengine.windowmanagement.events
{
    import flash.events.Event;
    
    import net.codeengine.windowmanagement.IWindow;
    import net.codeengine.windowmanagement.IWindowProxy;

    public class WindowAnimationDirectorEvent extends Event
    {
        public static var openingAnimationDidPlay:String = "windowOpeningAnimationCompleted";
        public static var closingAnimationDidPlay:String = "windowClosingAnimationCompleted";
        public static var alertAnimationDidPlay:String = "windowAlertingAnimationCompleted";
        public static var minimizeAnimationDidPlay:String = "windowMinimizingAnimationComplete";
        public static var minimizedWindowDidReceiveClick:String = "windowMinimizedClick";
        public static var unminimizeAnimationDidPlay:String = "windowUnminimizedAnimationComplete";
        public var windowProxy:IWindowProxy;
        public function WindowAnimationDirectorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
        
    }
}