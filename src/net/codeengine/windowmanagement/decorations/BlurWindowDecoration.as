package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;

    public class BlurWindowDecoration extends AbstractDecoration implements IDecoration {
        public function BlurWindowDecoration() {
        }

        public function decorate(window:DisplayObject):void {
            if (!super.isDecoratable(window)) {
                return;
            }
            var blur:BlurFilter=new BlurFilter();
            blur.blurX=4;
            blur.blurY=4;
            blur.quality=BitmapFilterQuality.MEDIUM;
            this.addFilter(window, blur);
        }

    }
}