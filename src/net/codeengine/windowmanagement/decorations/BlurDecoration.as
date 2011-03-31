package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;

    public class BlurDecoration extends AbstractDecoration implements IDecoration {
        public var blurX:int=4;
        public var blurY:int=4;

        public function decorate(target:DisplayObject):void {
            if (!super.isDecoratable(target)) {
                return;
            }
            var blur:BlurFilter=new BlurFilter();
            blur.blurX=blurX;
            blur.blurY=blurY;
            blur.quality=BitmapFilterQuality.MEDIUM;
            this.addFilter(target, blur);
        }

    }
}