package net.codeengine.windowmanagement.uicomponents
{
	import mx.core.IVisualElement;

	public interface ITabBarItem
	{
		function get label():String;
		function set label(value:String):void;
		function get icon():String;
		function set icon(value:String):void;
		function get view():String;
		function set view(value:String):void;
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
		function get id():String;
		function set id(value:String):void;
		
		function redraw():void;
	}
}