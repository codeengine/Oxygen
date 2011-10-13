package net.codeengine.windowmanagement
{
	import net.codeengine.windowmanagement.events.WindowEvent;
	import net.codeengine.windowmanagement.uicomponents.TabBar;

	public class PreferenceWindowTitlebar extends WindowTitlebar
	{
		public var preferences:TabBar = new net.codeengine.windowmanagement.uicomponents.TabBar();
		override protected function createChildren():void{
			height = 80;
			showMaximizeButton = false;

			super.createChildren();
			preferences.bottom = 0;
			preferences.horizontalCenter = 0;
			addElement(preferences);
		}
	}
}