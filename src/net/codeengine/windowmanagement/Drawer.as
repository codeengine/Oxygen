package net.codeengine.windowmanagement
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;

	import mx.graphics.ImageSnapshot;

	import net.codeengine.windowmanagement.decorations.BackgroundDecoration;
	import net.codeengine.windowmanagement.decorator.IDecorator;

	import spark.components.BorderContainer;

	/**
	 * A drawer is a window level visual component. Drawers, once added, are permanently attached to their parent window (until dismissed), and can be displayed in the following three locations:
	 * Left, right and bottom.
	 *
	 * <p>A window may only ever have one active drawer at a time, however windows support on the fly switching
	 * of drawers; this means that if a drawer is active, adding another drawer will simply swap out the current drawer and swap in the new drawer.
	 */
	public class Drawer extends Background implements IDrawer
	{
		private var _windowDecorator:IDecorator;

		[Bindable]private var _windowManager:WindowManager = WindowManager.instance;

		[Bindable]private var _window:IWindow;

		private var _location:String="right";

		public static const LOCATION_LEFT:String="left";

		public static const LOCATION_RIGHT:String="right";

		public static const LOCATION_BOTTON:String="bottom";
		private var blocker:BorderContainer;

		public function Drawer()
		{
			this.repeatImage=Window.oxygenSheetBackground;
		}

		public function close():void
		{
			this.window.removeDrawer(this);
		}

		public function get decorator():IDecorator
		{
			return this._windowDecorator;
		}

		public function get window():IWindow
		{
			return this._window;
		}

		public function set window(value:IWindow):void
		{
			this._window=value;
		}

		public function get location():String
		{
			return this._location;
		}

		public function set location(value:String):void
		{
			this._location=value;
		}

		/**
		 * Returns a proxy object representing this drawer.
		 *
		 *
		 * @return A proxy object referencing this drawer.
		 */
		public function get proxy():IDrawerProxy
		{
			var proxy:IDrawerProxy=new DrawerProxy();
			var didChangeVisibility:Boolean=false;
			if (!this.visible)
			{
				this.visible=true;
				didChangeVisibility=true;
			}
			proxy.image.source=getFrame(this as DisplayObject);
			proxy.image.x=this.x;
			proxy.image.y=this.y
			proxy.image.width=this.width;
			proxy.image.height=this.height;
			proxy.image.source.x=this.x;
			proxy.image.source.y=this.y
			if (didChangeVisibility)
				this.visible=!this.visible;

			/* Copy the window filters */
			proxy.image.filters=this.filters;
			proxy.drawer=this;
			return proxy;
		}

		private function getFrame(source:IBitmapDrawable):Bitmap
		{
			var imageBitmapData:BitmapData=ImageSnapshot.captureBitmapData(source);
			return new Bitmap(imageBitmapData);
		}


		public function block():void
		{

			blocker=new BorderContainer();
			blocker.alpha=0;
			blocker.setStyle("borderVisible", false);
			blocker.width=this.width - 1;
			blocker.height=this.height;
			blocker.y=this.y;
			blocker.x=-1;
			this.addElement(blocker);
		}

		/**
		 * Remove a previously created block on this window, and resume receiving input and user interaction on this window.
		 */
		public function unblock():void
		{
			try
			{
				this.removeElement(blocker);
			}
			catch (e:*)
			{

			}
		}
	}
}