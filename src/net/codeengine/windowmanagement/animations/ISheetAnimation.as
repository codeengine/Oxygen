package net.codeengine.windowmanagement.animations {
    import flash.events.IEventDispatcher;
    
    import net.codeengine.windowmanagement.ISheetProxy;
    
    public interface ISheetAnimation extends IEventDispatcher {
        function play(target:ISheetProxy):void
    }
}