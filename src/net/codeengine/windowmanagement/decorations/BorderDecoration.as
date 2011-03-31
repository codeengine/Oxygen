package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;

    import mx.graphics.Stroke;

    public class BorderDecoration extends AbstractDecoration implements IDecoration {
        public var color:uint=0x000000;

        override public function decorate(target:DisplayObject):void {
            super.decorate(target);
            var stroke:GlowFilter=new GlowFilter();
            stroke.color=this.color;
            stroke.blurX=1;
            stroke.blurY=1;
            stroke.strength=1;
            this.addFilter(target, stroke);
        }

    }
}