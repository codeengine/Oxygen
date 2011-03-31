package net.codeengine.windowmanagement.animations {
    import flash.display.DisplayObject;
    import flash.events.EventDispatcher;

    import net.codeengine.windowmanagement.WindowManager;

    public class AbstractAnimation extends EventDispatcher {
        public function AbstractAnimation() {
        }

        public function isAnimatable(target:DisplayObject = null):Boolean {
            return WindowManager.ENABLE_ANIMATIONS;
        }
    }
}