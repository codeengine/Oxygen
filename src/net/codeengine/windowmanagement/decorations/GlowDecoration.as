package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;
    import flash.filters.GlowFilter;

    public class GlowDecoration extends AbstractDecoration implements IDecoration {
        [Bindable]
        public var color:int=0xFFFFFF;
        [Bindable]
        public var strength:int=2;
        [Bindable]
        public var blurX:int=5;
        [Bindable]
        public var blurY:int=5;

        public function decorate(window:DisplayObject):void {
            if (!super.isDecoratable(window)) {
                return;
            }
            var glow:GlowFilter=new GlowFilter();
            glow.color=this.color;
            glow.strength=this.strength;
            glow.blurX=this.blurX;
            glow.blurY=this.blurY;
            glow.alpha=0.8;
            this.addFilter(window, glow);
        }

    }
}