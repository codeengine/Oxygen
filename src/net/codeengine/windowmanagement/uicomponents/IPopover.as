package net.codeengine.windowmanagement.uicomponents
{
	import net.codeengine.windowmanagement.IWindow;

	public interface IPopover
	{
		function get window():IWindow;
		function set window(value:IWindow):void;
	}
}