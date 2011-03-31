package net.codeengine.windowmanagement.decorator {
    import flash.display.DisplayObject;
    
    import net.codeengine.windowmanagement.decorations.IDecoration;
    
    
    public class Decorator implements IDecorator {
        public function decorate(decoration:IDecoration, object:DisplayObject):void {
            /* Remove all decorations */
            object.filters = new Array();
            decoration.decorate(object);
        }
    }
}