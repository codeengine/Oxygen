package net.codeengine.windowmanagement {
    import flash.events.Event;
    
    import spark.components.BorderContainer;


    public class NotificationWindow extends BorderContainer implements INotificationWindow {
        public var windowManager:WindowManager;

        public function NotificationWindow() {
            super();

        }
    }
}