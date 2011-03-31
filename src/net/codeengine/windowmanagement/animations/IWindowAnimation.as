package net.codeengine.windowmanagement.animations {
    import flash.events.IEventDispatcher;
    
    import net.codeengine.windowmanagement.IWindowProxy;
    
    public interface IWindowAnimation extends IEventDispatcher {
        function play(target:IWindowProxy):void;
    }
}