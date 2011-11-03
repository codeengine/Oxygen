package net.codeengine.windowmanagement
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import net.codeengine.windowmanagement.uicomponents.PreferenceTabBarEvent;
	import net.codeengine.windowmanagement.uicomponents.TabBar;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;

	public class PreferenceWindow extends Window
	{	
		private var _model:*;
		
		public function PreferenceWindow()
		{
			super();
			titlebar = new PreferenceWindowTitlebar();
		}
		
		public function get preferences():TabBar{
			return (titlebar as PreferenceWindowTitlebar).preferences;
		}
		
		override protected function createChildren():void{
			super.createChildren();
			addEventListener(PreferenceTabBarEvent.didReceiveRequestToChangeView, didReceiveRequestToChangeView);
		}
		
		private function didReceiveRequestToChangeView(event:PreferenceTabBarEvent):void{
			var didChange:PreferenceTabBarEvent = new PreferenceTabBarEvent(PreferenceTabBarEvent.didReceiveResponseToRequestToChangeView);
			
			if (!isSheetActive){
				currentState  = event.requestedView;
			}
			
			didChange.didViewChangeSuccessfully = currentState == event.requestedView;
			(event.tabBarItem as UIComponent).dispatchEvent(didChange);
			
		}
		
		override public function close():void{
			removeEventListener(PreferenceTabBarEvent.didReceiveRequestToChangeView, didReceiveRequestToChangeView);
			super.close();
		}
	}
}