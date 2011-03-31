package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;
    import flash.filters.DropShadowFilter;


    public class SheetDecoration extends AbstractDecoration implements IDecoration {

        public function decorate(target:DisplayObject):void {
            if (!super.isDecoratable(target)) {
                return;
            }
            this.addDropshadow(target);
        }

        private function addDropshadow(target:DisplayObject):void {
            var dropshadow1:DropShadowFilter=new DropShadowFilter();

            dropshadow1.alpha=0.2;
            dropshadow1.blurX=10;
            dropshadow1.blurY=10;
            dropshadow1.angle=90; //45;
            dropshadow1.color=0x202020;
            dropshadow1.distance=6;
            target.filters=[dropshadow1];
        }
    }
}