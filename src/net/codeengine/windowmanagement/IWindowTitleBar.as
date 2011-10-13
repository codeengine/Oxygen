package net.codeengine.windowmanagement
{
	import flash.events.IEventDispatcher;

	public interface IWindowTitleBar extends IEventDispatcher
	{
		
		function get title():String;

		function set title(value:String):void;

		function get showCloseButton():Boolean;

		function set showCloseButton(value:Boolean):void;

		function get showMaximizeButton():Boolean;

		function set showMaximizeButton(value:Boolean):void;

		function get showMinimizeButton():Boolean;

		function set showMinimizeButton(value:Boolean):void;
		
		function get height():Number;
		
		function set height(value:Number):void;
		
		function get width():Number;
		
		function set width(value:Number):void;
		
		function deactivateDisabledTitleBarButtonsVisually():void;
		
		function get window():IWindow;
		
		function set window(value:IWindow):void;
		
		function draw():void;
	}
}