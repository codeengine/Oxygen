package net.codeengine.windowmanagement.animations {
    import flash.display.DisplayObject;
    import flash.events.EventDispatcher;

    import mx.effects.Fade;
    import mx.effects.IEffect;
    import mx.effects.Move;
    import mx.events.EffectEvent;

    import net.codeengine.windowmanagement.uicomponents.IPopover;

    public class DisappearPopoverAnimation extends AbstractAnimation implements IPopoverAnimation {

        private var _animation:int=PopoverAnimationConstants.K_FADE_OUT;
        private var duration:int=300;

        private var _target:IPopover;

        public function AppearPopoverAnimation():void {
        }

        public function get animation():int {
            return this._animation;
        }

        public function set animation(value:int):void {
            this._animation=value;
        }

        public function play(target:IPopover):void {
            this._target=target;


            var effect:IEffect;
            switch (this._animation) {
                case PopoverAnimationConstants.K_FADE_OUT:
                    effect=new Fade(target);
                    (effect as Fade).alphaFrom=1;
                    (effect as Fade).alphaTo=0;
                    (effect as Fade).duration=duration;
                    effect.play();
                    break;
                case PopoverAnimationConstants.K_SLIDE_TO_BOTTOM:
                    effect=new Move(target);
                    (effect as Move).yTo=target.window.height;
                    (effect as Move).yFrom=(target.window.height / 2) - ((target as DisplayObject).height / 2);
                    (effect as Move).xTo=(target.window.width / 2) - ((target as DisplayObject).width / 2);
                    (effect as Move).xFrom=(target.window.width / 2) - ((target as DisplayObject).width / 2);
                    effect.play();
                    break;

            }
            effect.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
        }

        private function onEffectEnd(event:EffectEvent):void {
            var e:PopoverAnimationEvent=new PopoverAnimationEvent(PopoverAnimationEvent.POPOVER_DISAPPEAR_COMPLETE);
            e.popover=this._target;
            dispatchEvent(e);
        }



    }
}