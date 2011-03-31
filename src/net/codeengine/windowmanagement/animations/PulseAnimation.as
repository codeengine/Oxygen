package net.codeengine.windowmanagement.animations {
    import flash.display.DisplayObject;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    import mx.effects.Fade;

    public class PulseAnimation extends AbstractAnimation {
        private var timer:Timer=new Timer(800);
        private var fadeIn:Fade;
        private var fadeOut:Fade;
        private var target:DisplayObject;
        private var mode:Boolean=true;

        public function PulseAnimation(alphaFrom:Number=1, alphaTo:Number=0.80, duration:int=500) {
            this.timer.addEventListener(TimerEvent.TIMER, onTimer);

            fadeIn=new Fade(target);
            fadeIn.alphaFrom=alphaFrom;
            fadeIn.alphaTo=alphaTo;
            fadeIn.duration=duration;

            fadeOut=new Fade(target);
            fadeOut.alphaFrom=alphaTo;
            fadeOut.alphaTo=alphaFrom;
            fadeOut.duration=duration;
        }

        public function play(target:DisplayObject):void {
            this.target=target;
            this.timer.start();
        }

        private function onTimer(event:TimerEvent):void {
            if (mode) {
                fadeIn.play([target]);
            } else {
                fadeOut.play([target]);
            }
            mode=!mode;
        }

    }
}