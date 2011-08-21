package net.codeengine.windowmanagement
{
	public interface IWindowFlipside
	{
		function get window():IWindowFlipable;
		function set window(value:IWindowFlipable):void;
		
		function get isActive():Boolean;
		function set isActive(value:Boolean):void;
		
		function flip():void;
	}
}