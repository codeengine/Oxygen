package net.codeengine.windowmanagement {
    import flash.events.IEventDispatcher;
    
    
    import net.codeengine.windowmanagement.decorator.IDecorator;
    
    
    public interface ISheet extends IEventDispatcher {
        function get width():Number;
        function set width(value:Number):void;
        function get height():Number;
        function set height(value:Number):void;
        function get x():Number;
        function set x(value:Number):void;
        function get y():Number;
        function set y(value:Number):void;
        function close():void;
        function get decorator():IDecorator;
        function get proxy():ISheetProxy
        function get windowManager():IWindowManager;
        function set windowManager(value:IWindowManager):void;
        function get window():IWindow;
        function set window(value:IWindow):void;
    }
}