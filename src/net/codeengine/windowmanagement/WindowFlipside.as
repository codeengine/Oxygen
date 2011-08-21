package net.codeengine.windowmanagement
{
	public class WindowFlipside extends Window implements IWindowFlipside
	{
		private var _window:IWindowFlipable
		private var _isActive:Boolean = false;

		public function WindowFlipside()
		{
			super();
		}
		
		public function flip():void
		{
			(_window as IWindow).windowManager.flip(_window);
		}
		
		public function get isActive():Boolean
		{
			return _isActive;
		}
		
		public function set isActive(value:Boolean):void
		{
			_isActive = value;			
		}
		
		
		public function get window():IWindowFlipable
		{
			return _window;
		}
		
		public function set window(value:IWindowFlipable):void
		{
			_window = value;			
		}
		
	}
}