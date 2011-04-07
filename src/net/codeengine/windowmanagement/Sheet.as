package net.codeengine.windowmanagement
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.events.MouseEvent;
	
	import mx.controls.HRule;
	import mx.graphics.ImageSnapshot;
	
	import net.codeengine.windowmanagement.decorator.IDecorator;
	
	import spark.components.BorderContainer;
	import spark.filters.DropShadowFilter;

	/**
	 * A sheet is window level modal visual component. Once added,
	 * the sheet becomes the focus of interaction, leaving the window inaccessible until
	 * the sheet is dismissed.
	 * <p>A window may only ever have one sheet displaying at any given point in time.
	 *
	 * <p>Sheets are standard containers, and as such may contain any elements that you would normally
	 * add to a container.
	 */
	public class Sheet extends Background implements ISheet
	{

		private var _windowDecorator:IDecorator;

		private var _windowManager:IWindowManager;

		private var _window:IWindow;
		private var blocker:BorderContainer;

		/**
		 * Get the window manager that this window is managed by.
		 *
		 *
		 * @return The window manager of this window.
		 */
		public function get windowManager():IWindowManager
		{
			return this._windowManager;
		}

		public function set windowManager(value:IWindowManager):void
		{
			this._windowManager=value;
		}

		/**
		 * Get the parent window (the window that this sheet belongs too).
		 *
		 *
		 * @return The parent window of this sheet (the window that this sheet is attached too).
		 */
		public function get window():IWindow
		{
			return this._window;
		}


		/**
		 * Set the parent window (the window that this sheet belongs too).
		 *
		 *
		 * @param value The parent window.
		 */
		public function set window(value:IWindow):void
		{
			this._window=value;
		}

		public function Sheet()
		{
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.repeatImage=Window.oxygenSheetBackground;
			this.radius=0;
			this.isInset=false;
			this.alpha = 0.95;
		}

		public function get decorator():IDecorator
		{
			return this._windowDecorator;
		}

		public function close():void
		{
			var event:SheetEvent=new SheetEvent(SheetEvent.CLOSE_SHEET);
			event.sheet=this;
			this.dispatchEvent(event);
		}

		/**
		 * Returns a proxy object representing this sheet.
		 *
		 *
		 * @return A proxy object referencing this sheet.
		 */
		public function get proxy():ISheetProxy
		{
			var proxy:ISheetProxy=new SheetProxy();
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
			proxy.sheet=this;
			return proxy;
		}

		private function getFrame(source:IBitmapDrawable):Bitmap
		{
			var imageBitmapData:BitmapData=ImageSnapshot.captureBitmapData(source);
			return new Bitmap(imageBitmapData);
		}

		private function onMouseMove(event:MouseEvent):void
		{
			//trace("Sheet: onMouseMove");
			var e:SheetEvent=new SheetEvent(SheetEvent.MOUSE_MOVE);
			e.sheet=this;
			dispatchEvent(e);
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