package net.codeengine.windowmanagement.uicomponents
{
	public interface IComponent
	{
		function activate(container:*):void;
		function deactivate():void;
	}
}