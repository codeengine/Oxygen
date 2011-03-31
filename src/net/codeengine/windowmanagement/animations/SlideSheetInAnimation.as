package net.codeengine.windowmanagement.animations {
    import flash.display.DisplayObject;
    import flash.events.EventDispatcher;
    
    import mx.effects.Resize;
    import mx.effects.easing.Elastic;
    import mx.events.EffectEvent;
    
    import net.codeengine.windowmanagement.ISheetProxy;
    
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;

    public class SlideSheetInAnimation extends AbstractAnimation implements ISheetAnimation {
        private var _proxy:ISheetProxy;

        public function play(target:ISheetProxy):void {
            this._proxy=target;
            target.sheet.windowManager.addChild(target.image);
            
            var a:Animate = new Animate(_proxy.image);
            var v:Vector.<MotionPath> = new Vector.<MotionPath>();
            a.motionPaths=v;
            a.duration = 300;
            
            var resizeHeight:SimpleMotionPath = new SimpleMotionPath("height", 0, target.sheet.height);
            v.push(resizeHeight);
            
            var resizeWidth:SimpleMotionPath = new SimpleMotionPath("width", null, _proxy.sheet.width);
            v.push(resizeWidth);
                
            a.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
            a.play();
            
            
        }



        public function onEffectEnd(event:EffectEvent):void {
            this._proxy.sheet.windowManager.removeChild(this._proxy.image);
            (this._proxy.sheet as DisplayObject).visible=true;
        }

    }
}