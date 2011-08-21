package net.codeengine.windowmanagement {
    import flash.display.DisplayObject;
    import flash.events.IEventDispatcher;
    
    import mx.collections.ArrayCollection;
    import mx.core.Container;
    import mx.core.IVisualElementContainer;
    import mx.core.UIComponent;
    
    import net.codeengine.windowmanagement.decorator.IDecorator;

    public interface IWindowManager extends IEventDispatcher {
        function addWindow(window:IWindow, x:Number=-1, y:Number=-1):String;
        function removeWindow(window:IWindow):void;
        function minimizeWindow(window:IWindow):void;
        function minimizeAllWindows():void;
        function maximizeWindow(window:IWindow):void;
        function restoreWindow(window:IWindow):void;
        function addSheet(sheet:ISheet, window:IWindow):void;
        function removeSheet(sheet:ISheet, window:IWindow):void;
        function bringWindowToFront(windowId:IWindow):void;
        function getTopMostWindow():IWindow;
        function getWindowById(windowId:String):IWindow;
        function x():Number;
        function y():Number;
        function height():Number;
        function width():Number;
        function addChild(child:DisplayObject):void;
        function removeChild(child:DisplayObject):void;
        function getChildIndex(child:DisplayObject):Number;
        function getChildAtIndex(index:int):DisplayObject;
        function sendWindowToFront(windowId:String):void;
        function get container():UIComponent;
        function set container(value:UIComponent):void;
        function get version():String;
        function get decorator():IDecorator;
        function getActiveWindow():IWindow;
        function getMinimizedWindows():ArrayCollection;
        function getActiveWindows():ArrayCollection;
        function get enableAnimation():Boolean;
        function set enableAnimation(value:Boolean):void;
		
		function flip(flipbableWindow:IWindowFlipable):void;

    }
}