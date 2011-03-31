package net.codeengine.windowmanagement.decorator {
    import flash.display.DisplayObject;
    
    import net.codeengine.windowmanagement.decorations.IDecoration;
    
    
    public interface IDecorator {
        function decorate(decoration:IDecoration, object:DisplayObject):void;
    }
}