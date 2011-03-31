package net.codeengine.windowmanagement.animations
{
    import flash.events.IEventDispatcher;
    
    import mx.collections.ArrayCollection;
    
    public interface IWindowsAnimation extends IEventDispatcher
    {
        function play(target:ArrayCollection):void
    }
}