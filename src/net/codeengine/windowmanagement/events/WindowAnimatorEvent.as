package net.codeengine.windowmanagement.events {
    import flash.events.Event;

    import mx.controls.Image;


    public class WindowAnimatorEvent extends Event {
        public static const kDidFinishPlayingWindowAppearAnimation : String = "DidFinishPlayingWindowAppearAnimation";
        public static const kDidFinishPlayingWindowClosingAnimation : String = "DidFinishPlayingWindowClosingAnimation";
        public var image : Image;
        public var windowId : String;

        public function WindowAnimatorEvent(type : String) {
            super(type);
        }

    }
}