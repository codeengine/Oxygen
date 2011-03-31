package net.codeengine.windowmanagement.decorations {
    import flash.display.DisplayObject;

    import net.codeengine.windowmanagement.WindowManager;


    public class AbstractDecoration {
        protected function addFilter(target:DisplayObject, filter:Object):void {
            var filters:Array=new Array();
            for each (var filter:Object in target.filters) {
                filters.push(filter);
            }
            filters.push(filter);
            target.filters=filters;
        }

        public function isDecoratable(target:DisplayObject):Boolean {
            return WindowManager.ENABLE_DECORATIONS;
        }
    }
}