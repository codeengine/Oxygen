package net.codeengine.windowmanagement.decorations
{
    import flash.display.DisplayObject;
    
    public interface IDecoration
    {
        function decorate(target:DisplayObject):void;
    }
}