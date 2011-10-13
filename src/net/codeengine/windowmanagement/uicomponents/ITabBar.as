package net.codeengine.windowmanagement.uicomponents
{
	import mx.collections.IList;
	import mx.containers.ViewStack;

	public interface ITabBar
	{
		function get viewStack():ViewStack;
		function set viewStack(value:ViewStack):void;
	
		function get id():String;
		function set id(value:String):void;
		
		function add(tab:ITabBarItem):void;
		
		function select(id:String):void;
		
		function draw():void;
	}
}