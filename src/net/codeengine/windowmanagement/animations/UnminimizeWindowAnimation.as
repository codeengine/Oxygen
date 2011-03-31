package net.codeengine.windowmanagement.animations {
    import flash.display.DisplayObject;
    import flash.events.EventDispatcher;
    import mx.events.EffectEvent;
    import net.codeengine.windowmanagement.IWindowProxy;
    import net.codeengine.windowmanagement.WindowManager;
    import net.codeengine.windowmanagement.events.WindowAnimationDirectorEvent;
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;

    public class UnminimizeWindowAnimation extends AbstractAnimation implements IWindowAnimation {
        private var windowProxy:IWindowProxy;

        public function play(target:IWindowProxy):void {
            this.windowProxy=target;
            target.window.windowManager.container.setChildIndex(target.image as DisplayObject, target.window.windowManager.container.getChildren().length - 1);
                   
            var animate:Animate = new Animate(windowProxy.image);
            var v:Vector.<MotionPath> = new Vector.<MotionPath>();
            animate.motionPaths = v;
            
            //Move
            var moveX:SimpleMotionPath = new SimpleMotionPath("x", null, target.window.x);
            var moveY:SimpleMotionPath = new SimpleMotionPath("y", null, target.window.y);
            v.push(moveX);
            v.push(moveY);
                        
            //Resize
            var resizeWidth:SimpleMotionPath = new SimpleMotionPath("width", null, target.window.width);
            var resizeHeight:SimpleMotionPath = new SimpleMotionPath("height", null, target.window.height);
            v.push(resizeWidth);
            v.push(resizeHeight);
            
            animate.addEventListener(EffectEvent.EFFECT_END, this.onEffectEnd);
            animate.play();
        }

        private function onEffectEnd(event:EffectEvent):void {
            var e:WindowAnimationDirectorEvent=new WindowAnimationDirectorEvent(WindowAnimationDirectorEvent.UNMINIMIZE_ANIMATION_COMPLETE);
            e.windowProxy=windowProxy;
            this.dispatchEvent(e);
        }
    }
}