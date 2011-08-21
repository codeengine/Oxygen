package net.codeengine.windowmanagement
{
	public interface IWindowFlipable
	{
		function get flipside():String;
		function set flipside(value:String):void;
		
		function get windowFlipside():IWindowFlipside;
		function set windowFlipside(value:IWindowFlipside):void;
		
		function get isFlipSideActive():Boolean;
		function set isFlipSideActive(value:Boolean):void;
		
		function flip():void;
	}
}