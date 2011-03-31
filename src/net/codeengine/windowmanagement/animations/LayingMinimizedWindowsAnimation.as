package net.codeengine.windowmanagement.animations {
    import flash.events.EventDispatcher;

    import mx.collections.ArrayCollection;
    import mx.effects.Move;

    import net.codeengine.windowmanagement.IWindowProxy;

    public class LayingMinimizedWindowsAnimation extends AbstractAnimation {
        private var startingX:int=20;
        private var startingY:int;
        private var spacingX:int=20;
        private var spacingY:int=20;
        private var target:ArrayCollection;
        private var currentX:int=startingX;
        private var currentY:int;

        public function play(target:ArrayCollection):void {
            this.target=target;
            if (target.length > 0) {
                this.startingY=(target[0] as IWindowProxy).window.windowManager.height() - (target[0] as IWindowProxy).image.height - 40
                this.currentY=startingY;
            }
            for each (var proxy:IWindowProxy in target) {
                var move:Move=new Move(proxy.image);
                move.xTo=currentX;
                move.yTo=currentY;
                currentX+=spacingX;
                currentX+=proxy.image.width;
                move.play();
            }
        }

    }
}