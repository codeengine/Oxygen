package net.codeengine.windowmanagement.animations {
    import flash.events.IEventDispatcher;
    
    import net.codeengine.windowmanagement.IPopover;

    public interface IPopoverAnimation extends IEventDispatcher {
        function play(target:IPopover):void;
        function set animation(value:int):void;
        function get animation():int;

    }
}