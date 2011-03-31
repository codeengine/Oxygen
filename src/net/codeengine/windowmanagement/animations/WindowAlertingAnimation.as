package net.codeengine.windowmanagement.animations {
    import flash.events.EventDispatcher;

    import mx.effects.Move;
    import mx.effects.Sequence;
    import mx.events.EffectEvent;

    import net.codeengine.windowmanagement.IWindowProxy;
    import net.codeengine.windowmanagement.WindowManager;
    import net.codeengine.windowmanagement.events.WindowAnimationDirectorEvent;

    public class WindowAlertingAnimation extends AbstractAnimation implements IWindowAnimation {
        public function play(target:IWindowProxy):void {
            var sequence:Sequence=new Sequence();
            var move1:Move=new Move();
            move1.xBy=5;
            move1.duration=50;
            sequence.addChild(move1);

            var move2:Move=new Move();
            move2.xBy=-10;
            move2.duration=50;
            sequence.addChild(move2);

            var move3:Move=new Move();
            move3.xBy=10;
            move3.duration=50;
            sequence.addChild(move3);

            var move4:Move=new Move();
            move4.xBy=-10;
            move4.duration=50;
            sequence.addChild(move4);

            var move5:Move=new Move();
            move5.xBy=10;
            move5.duration=50;
            sequence.addChild(move5);

            var move6:Move=new Move();
            move6.xBy=-5;
            move6.duration=50;
            sequence.addChild(move6);
            sequence.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
            sequence.play([target.window]);
        }

        public function onEffectEnd(event:EffectEvent):void {
            var e:WindowAnimationDirectorEvent=new WindowAnimationDirectorEvent(WindowAnimationDirectorEvent.ALERT_ANIMATION_COMPLETE);
            dispatchEvent(e);
        }
    }
}