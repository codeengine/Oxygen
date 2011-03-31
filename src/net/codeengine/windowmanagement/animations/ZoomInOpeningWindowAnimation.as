package net.codeengine.windowmanagement.animations {
    import flash.events.EventDispatcher;
    
    import mx.controls.Image;
    import mx.events.EffectEvent;
    
    import net.codeengine.windowmanagement.IWindowProxy;
    import net.codeengine.windowmanagement.events.WindowAnimationDirectorEvent;
    
    import spark.effects.Animate;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;

    public class ZoomInOpeningWindowAnimation extends AbstractAnimation implements IWindowAnimation {
        private var target:IWindowProxy;

        private var proxy:Image;

        public function play(target:IWindowProxy):void {
            this.target=target;
            proxy=target.image;
            target.window.windowManager.addChild(proxy);
            this.resizeAboutCenter(proxy, true);
        }

        private function resizeAboutCenter(image:Image, sizeUp:Boolean):void {
            
            
            
            
            var t:Number;
            t=300;
            /* Calculate the static centers of the image. */
            var scX:Number=0;
            var scY:Number=0;
            scX=image.x + (image.width / 2);
            scY=image.y + (image.height / 2);
            trace("Center: " + scX + ", " + scY);


            var iW:Number=0; //Initial width.
            var eW:Number=0; //Eventual width.
            var iH:Number=0; //Initial height.
            var eH:Number=0; //Eventual height.
            if (!sizeUp) {
                iW=image.width;
                iH=image.height;
                eW=0.5 * iW;
                eH=0.5 * iH;
            } else {
                iW=0.5 * image.width;
                iH=0.5 * image.height;
                eW=image.width;
                eH=image.height;
            }

            var iX:Number=0;
            var iY:Number=0;
            var eX:Number=0;
            var eY:Number=0;
            if (!sizeUp) {
                iX=image.x;
                iY=image.y;
                eX=scX - (eW / 2);
                eY=scY - (eH / 2);
            } else {
                iX=scX - (iW / 2);
                iY=scY - (iH / 2);
                eX=image.x;
                eY=image.y;
            }


            var animate:Animate = new Animate(image);
            animate.duration = t;
            var v:Vector.<MotionPath> = new Vector.<MotionPath>();
           
            /* Resize. */
            var resizeHeight:SimpleMotionPath = new SimpleMotionPath("height",iH,eH);
            var resizeWidth:SimpleMotionPath = new SimpleMotionPath("width", iW, eW);
            v.push(resizeHeight);
            v.push(resizeWidth);
          

            /* Move from source to destination. */
            var moveX:SimpleMotionPath = new SimpleMotionPath("x", iX, eX);
            var moveY:SimpleMotionPath = new SimpleMotionPath("y", iY, eY);
            v.push(moveX);
            v.push(moveY);

            /* Fade */
            var fade:SimpleMotionPath = new SimpleMotionPath("alpha");
            v.push(fade);
            
            if (!sizeUp) {
                fade.valueFrom=1.0;
                fade.valueTo=0.00;
            } else {
                fade.valueFrom=0.0;
                fade.valueTo=1;
            }

            animate.motionPaths = v;
            animate.play();
            animate.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
            
            
        }

        private function easing(t:Number, b:Number, c:Number, d:Number):Number {
            var ts:Number=(t/=d) * t;
            var tc:Number=ts * t;
            return b + c * (1 * tc * ts + -5 * ts * ts + 10 * tc + -10 * ts + 5 * t);
        }

        private function onEffectEnd(event:EffectEvent):void {
            trace("ZoomInOpeningWindowAnimation: onEffectEnd");
            this.target.window.windowManager.removeChild(this.proxy);
            var e:WindowAnimationDirectorEvent=new WindowAnimationDirectorEvent(WindowAnimationDirectorEvent.OPEN_ANIMATION_COMPLETE);
            e.windowProxy=this.target;
            this.dispatchEvent(e);
            this.target.window.visible=true;
        }
    }
}