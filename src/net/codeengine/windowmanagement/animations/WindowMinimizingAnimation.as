package net.codeengine.windowmanagement.animations {
    import flash.display.SimpleButton;
    import flash.events.EventDispatcher;
    import flash.events.MouseEvent;
    
    import mx.events.EffectEvent;
    
    import net.codeengine.windowmanagement.IWindowProxy;
    import net.codeengine.windowmanagement.WindowManager;
    import net.codeengine.windowmanagement.events.WindowAnimationDirectorEvent;
    
    import spark.components.Image;
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;


    public class WindowMinimizingAnimation extends AbstractAnimation implements IWindowAnimation {
        private var proxy:Image;
        private var windowProxy:IWindowProxy;

        public function play(target:IWindowProxy):void {
            this.windowProxy=target;
            this.windowProxy.window.visible=false;
            var minimizedWindowHeight:int=64;
            var marginFromBotton:int=10;
            var marginFromLeft:int=20;
            proxy=windowProxy.image;
            proxy.addEventListener(MouseEvent.CLICK, onMouseClick);
			WindowManager.instance.addChild(proxy);
       
            var ratio:Number=windowProxy.window.height / minimizedWindowHeight;
     
            var animate:Animate = new Animate(proxy);
            var v:Vector.<MotionPath> = new Vector.<MotionPath>();
            animate.motionPaths = v;
			animate.duration= WindowManager.ANIMATION_SPEED
            
            //Move
            var moveX:SimpleMotionPath = new SimpleMotionPath("x", null, marginFromLeft);
            var moveY:SimpleMotionPath = new SimpleMotionPath("y", null, WindowManager.instance.height() - marginFromBotton - minimizedWindowHeight);
            v.push(moveX);
            v.push(moveY);
            
            
            //Resize
            var resizeWidth:SimpleMotionPath = new SimpleMotionPath("width", null, proxy.width / ratio);
            var resizeHeight:SimpleMotionPath = new SimpleMotionPath("height", null, minimizedWindowHeight);
            v.push(resizeWidth);
            v.push(resizeHeight);
            
            animate.addEventListener(EffectEvent.EFFECT_END, this.onEffectEnd);
            animate.play();
        }

        private function onEffectEnd(event:EffectEvent):void {
            var e:WindowAnimationDirectorEvent=new WindowAnimationDirectorEvent(WindowAnimationDirectorEvent.minimizeAnimationDidPlay);
            e.windowProxy=windowProxy;
            this.dispatchEvent(e);
        }

        private function onMouseClick(event:MouseEvent):void {
            var e:WindowAnimationDirectorEvent=new WindowAnimationDirectorEvent(WindowAnimationDirectorEvent.minimizedWindowDidReceiveClick);
            e.windowProxy=windowProxy;
            this.dispatchEvent(e);
        }
    }
}