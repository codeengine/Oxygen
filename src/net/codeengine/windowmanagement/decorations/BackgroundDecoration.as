package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;
    import flash.filters.DropShadowFilter;


    public class BackgroundDecoration extends AbstractDecoration implements IDecoration {

        public function decorate(target:DisplayObject):void {
            if (!super.isDecoratable(target)) {
                return;
            }
            this.addDropshadow(target);
        }

        private function addDropshadow(target:DisplayObject):void {
            var dropshadow1:DropShadowFilter=new DropShadowFilter();

            dropshadow1.alpha=0.4;
            dropshadow1.blurX=20;
            dropshadow1.blurY=20;
            dropshadow1.color=0x202020;
            dropshadow1.distance=1;

            target.filters=[dropshadow1];
        }
    }
}