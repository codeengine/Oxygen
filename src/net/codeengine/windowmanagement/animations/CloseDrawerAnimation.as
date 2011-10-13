package net.codeengine.windowmanagement.animations {
    import flash.display.DisplayObject;
    
    import mx.events.EffectEvent;
    
    import net.codeengine.windowmanagement.Drawer;
    import net.codeengine.windowmanagement.IDrawerProxy;
    import net.codeengine.windowmanagement.WindowManager;
    
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;

    public class CloseDrawerAnimation extends AbstractAnimation implements IDrawerAnimation {
        private var _proxy:IDrawerProxy;
        
       
        public function play(target:IDrawerProxy):void {
            
            this._proxy=target;
            
            var a:Animate = new Animate(target.drawer);
            var v:Vector.<MotionPath> = new Vector.<MotionPath>();
            a.motionPaths=v;
            a.duration = WindowManager.ANIMATION_SPEED;
            
            var move:SimpleMotionPath = new SimpleMotionPath();
            
            switch (target.drawer.location) {
                case Drawer.LOCATION_RIGHT:
                    move.property="x";
                    move.valueFrom=target.drawer.x;
                    move.valueTo=target.drawer.window.x;
                    break;
                case Drawer.LOCATION_LEFT:
                    move.valueFrom=target.drawer.x;
                    move.valueTo=target.drawer.window.x;
                    break;
                case Drawer.LOCATION_BOTTON:
                    move.valueFrom=target.drawer.y;
                    move.valueTo=target.drawer.window.y;
                    break;
            }
           
            a.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
            v.push(move);
            a.play();
        }

        public function onEffectEnd(event:EffectEvent):void {
        	WindowManager.instance.removeChild(this._proxy.drawer as DisplayObject);
        }
    }
}