package net.codeengine.windowmanagement.animations {
    import flash.display.DisplayObject;
    import flash.events.EventDispatcher;

    import mx.effects.Fade;
    import mx.effects.IEffect;
    import mx.effects.Move;

    import net.codeengine.windowmanagement.IPopover;

    public class AppearPopoverAnimation extends AbstractAnimation implements IPopoverAnimation {

        private var _animation:int=PopoverAnimationConstants.K_FADE_IN;
        private var duration:int=300;

        public function AppearPopoverAnimation() {
        }

        public function get animation():int {
            return this._animation;
        }

        public function set animation(value:int):void {
            this._animation=value;
        }

        public function play(target:IPopover):void {
            var effect:IEffect;
            switch (this._animation) {
                case PopoverAnimationConstants.K_FADE_IN:
                    effect=new Fade(target);
                    (effect as Fade).alphaFrom=0;
                    (effect as Fade).alphaTo=1;
                    (effect as Fade).duration=duration;
                    effect.play();
                    break;
                case PopoverAnimationConstants.K_SLIDE_FROM_BOTTOM:
                    effect=new Move(target);
                    (effect as Move).yFrom=target.window.height;
                    (effect as Move).yTo=(target.window.height / 2) - ((target as DisplayObject).height / 2);
                    (effect as Move).xFrom=(target.window.width / 2) - ((target as DisplayObject).width / 2);
                    (effect as Move).xTo=(target.window.width / 2) - ((target as DisplayObject).width / 2);
                    effect.play();
                    break;

            }
        }



    }
}