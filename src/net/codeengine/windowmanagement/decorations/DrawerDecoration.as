package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;
    import flash.filters.DropShadowFilter;
    import flash.geom.Rectangle;
    
    import mx.geom.RoundedRectangle;
    import mx.graphics.SolidColorStroke;
    
    import spark.components.Group;
    import spark.effects.AnimateFilter;
    import spark.filters.DropShadowFilter;
    import spark.filters.GlowFilter;


    public class DrawerDecoration extends AbstractDecoration implements IDecoration {

        public function decorate(target:DisplayObject):void {
            if (!super.isDecoratable(target)) {
                return;
            }
			this.addBorder(target);
			this.addDropshadow(target);
        }
		
		private function addDropshadow(target:DisplayObject):void {
			var dropshadow1:spark.filters.DropShadowFilter=new spark.filters.DropShadowFilter;
			
			dropshadow1.alpha=0.2;
			dropshadow1.blurX=10;
			dropshadow1.blurY=10;
			dropshadow1.angle=90; //45;
			dropshadow1.color=0x202020;
			
			dropshadow1.distance=6;
			this.addFilter(target, dropshadow1);
		}
		
		private function addBorder(target:DisplayObject):void {
		var gf:GlowFilter = new GlowFilter(0x979797, 0.8, 3, 3, 3, 3, true, false);
		this.addFilter(target, gf);
			
		}
    }
}