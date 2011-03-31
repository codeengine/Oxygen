package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;

    public class NullDecoration extends AbstractDecoration implements IDecoration {
        public var blurX:int=4;
        public var blurY:int=4;

        public function decorate(target:DisplayObject):void {
            target.filters=new Array();
        }

    }
}