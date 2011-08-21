package net.codeengine.windowmanagement
{
	public class WindowFlipable extends Window implements IWindowFlipable
	{
		private var _flipside:String = "";
		private var _windowFlipside:IWindowFlipside;
		private var _isFlipSideActive:Boolean = false;
		public function WindowFlipable()
		{
			super();
		}
		
		public function flip():void
		{
			windowManager.flip(this);
		}
		
		public function get isFlipSideActive():Boolean
		{
			return _isFlipSideActive;
		}
		
		public function set isFlipSideActive(value:Boolean):void
		{
			_isFlipSideActive = value;			
		}
		
		
		public function get flipside():String
		{
			return _flipside;
		}
		
		public function set flipside(value:String):void
		{
			_flipside = value;
			
		}
		
		public function get windowFlipside():IWindowFlipside
		{
			return _windowFlipside;		
		}
		
		public function set windowFlipside(value:IWindowFlipside):void
		{
			_windowFlipside = value;
			
		}
		
	}
}