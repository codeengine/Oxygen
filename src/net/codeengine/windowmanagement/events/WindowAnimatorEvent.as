package net.codeengine.windowmanagement.events {
    import flash.events.Event;

    import mx.controls.Image;


    public class WindowAnimatorEvent extends Event {
        public static const didFinishPlayingWindowAppearAnimation : String = "DidFinishPlayingWindowAppearAnimation";
        public static const didFinishPlayingWindowClosingAnimation : String = "DidFinishPlayingWindowClosingAnimation";
        public var image : Image;
        public var windowId : String;

        public function WindowAnimatorEvent(type : String) {
            super(type);
        }

    }
}