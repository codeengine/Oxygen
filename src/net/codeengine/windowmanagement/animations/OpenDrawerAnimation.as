package net.codeengine.windowmanagement.animations {
    import mx.effects.Move;
    import mx.events.EffectEvent;
    
    import net.codeengine.windowmanagement.Drawer;
    import net.codeengine.windowmanagement.IDrawerProxy;
    
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;

    public class OpenDrawerAnimation extends AbstractAnimation implements IDrawerAnimation {
        private var _proxy:IDrawerProxy;

        public function play(target:IDrawerProxy):void {
            this._proxy=target;
            
            var a:Animate = new Animate(_proxy.drawer);
            var v:Vector.<MotionPath> = new Vector.<MotionPath>();
            a.motionPaths=v;
            a.duration = 300;
           
            var move:SimpleMotionPath = new SimpleMotionPath();
            //var move:Move=new Move(target.drawer);
            switch (target.drawer.location) {
                case Drawer.LOCATION_RIGHT:
                    move.property="x";
                    move.valueFrom=target.drawer.window.x;
                    move.valueTo=target.drawer.x;
                    break;
                case Drawer.LOCATION_LEFT:
                    move.property="x";
                    move.valueFrom=target.drawer.window.x;
                    move.valueTo=target.drawer.window.x - target.drawer.width;
                    break;
                case Drawer.LOCATION_BOTTON:
                    move.property="y";
                    move.valueFrom=target.drawer.window.y;
                    move.valueTo=target.drawer.y;
                    break;
            }
            v.push(move);
            a.play();
        }

    }
}