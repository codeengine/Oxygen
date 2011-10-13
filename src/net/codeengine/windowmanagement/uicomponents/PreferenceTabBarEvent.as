package net.codeengine.windowmanagement.uicomponents
{
	import flash.events.Event;
	
	public class PreferenceTabBarEvent extends Event
	{
		public static const didReceiveRequestToChangeView:String = "didReceiveRequestToChangeView";
		public static const didReceiveResponseToRequestToChangeView:String = "didReceiveResponseToRequestToChangeView";
			
		public var requestedView:String = "";
		public var didViewChangeSuccessfully:Boolean = false;
		public var tabBarItem:ITabBarItem;
		
		public function PreferenceTabBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}