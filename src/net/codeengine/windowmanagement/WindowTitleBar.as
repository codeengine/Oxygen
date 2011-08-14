package net.codeengine.windowmanagement
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.controls.Label;
	
	import net.codeengine.windowmanagement.decorations.GlowDecoration;
	import net.codeengine.windowmanagement.decorator.Decorator;
	
	import spark.components.BorderContainer;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.filters.DropShadowFilter;
	
	public class WindowTitleBar extends BorderContainer implements IWindowTitleBar
	{
		[Embed(source="assets/images/titlebarbg.png")]
		private var bgClass:Class;
		private var _title:String = null;
		private var _label:spark.components.Label = null;
		/* Button Up Skin */
		//Close
		[Embed(source="assets/images/titlebarbuttonred.png")]
		private var _closeButtonSkin:Class;
		//Zoom
		[Embed(source="assets/images/titlebarbuttonamber.png")]
		private var _maximizeButtonSkin:Class;
		//Minimize
		[Embed(source="assets/images/titlebarbuttongreen.png")]
		private var _minizeButtonSkin:Class;
		private var titlebarButtons:HGroup=new HGroup();
		private var _showCloseButton:Boolean = true;
		private var _showMaximizeButton:Boolean = true;
		private var _showMinimizeButton:Boolean = true;
		private var buttonMinimize:Image=new Image();
		private var buttonMaximize:Image=new Image();
		private var buttonClose:Image=new Image();
		//private var buttonResize:Image=new Image();

		private var _window:IWindow;
		public function get window():IWindow { return _window; }
		
		public function set window(value:IWindow):void
		{
			if (_window == value)
				return;
			_window = value;
		}
		
		public function WindowTitleBar()
		{
			super();
		}
		

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get showCloseButton():Boolean
		{
			return _showCloseButton;
		}

		public function set showCloseButton(value:Boolean):void
		{
			_showCloseButton = value;
		}

		public function get showMaximizeButton():Boolean
		{
			return _showMaximizeButton;
		}

		public function set showMaximizeButton(value:Boolean):void
		{
			_showMaximizeButton = value;
		}

		public function get showMinimizeButton():Boolean
		{
			return _showMinimizeButton;
		}

		public function set showMinimizeButton(value:Boolean):void
		{
			_showMinimizeButton = value;
		}

		protected override function createChildren():void{
			super.createChildren();
			this.setStyle("backgroundAlpha",0);
			this.setStyle("borderAlpha", 0);
			x = 0;
			y = 0;
			percentWidth = 100;
			
			if (null != title){
				_label = new spark.components.Label();
				_label.text = title;
				_label.verticalCenter = 0;
				_label.horizontalCenter = 0;
				_label.setStyle("fontFamily", "Verdana");
				_label.setStyle("fontSize", 13);
				addElement(_label);
				var etch:DropShadowFilter = new DropShadowFilter(1, 90, 0xffffff, 0.8, 4, 4);
				_label.filters = [etch];
			}
			
			addTitleBarButtons();
			
			addEventListeners();
		}	
		
		public function deactivateDisabledTitleBarButtonsVisually():void
		{
			this.buttonClose.alpha=this.showCloseButton ? 1 : 0.2;
			this.buttonMinimize.alpha=this.showMinimizeButton ? 1 : 0.2;
			this.buttonMaximize.alpha=this.showMaximizeButton ? 1 : 0.2;
		}

		private function addEventListeners():void{
			buttonMinimize.addEventListener(MouseEvent.MOUSE_UP, onMinimizeClick, false, 0, true);
			buttonMaximize.addEventListener(MouseEvent.CLICK, onMaximizeClick, false, 0, true);
			buttonClose.addEventListener(MouseEvent.CLICK, onCloseClick, false, 0, true);
		}
		
		
		private function removeEventListeners():void
		{
			
			buttonMinimize.removeEventListener(MouseEvent.MOUSE_UP, onMinimizeClick);
			buttonMaximize.removeEventListener(MouseEvent.CLICK, onMaximizeClick);
			buttonClose.removeEventListener(MouseEvent.CLICK, onCloseClick);
		}
		
		private function addTitleBarButtons():void
		{
			
			
			titlebarButtons.left=10;
			titlebarButtons.top=3;
			addElement(titlebarButtons);
			
			buttonClose.height=14;
			buttonClose.width=14;
			buttonClose.source=_closeButtonSkin;
			
			buttonMaximize.height=14;
			buttonMaximize.width=14;
			buttonMaximize.source=_maximizeButtonSkin;
			
			buttonMinimize.height=14;
			buttonMinimize.width=14;
			buttonMinimize.source=_minizeButtonSkin;

			titlebarButtons.addElement(buttonClose);
			titlebarButtons.addElement(buttonMaximize);
			titlebarButtons.addElement(buttonMinimize);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var cr:Number = getStyle("cornerRadius");
			var bc:Number = getStyle("backgroundColor");
		
			graphics.beginBitmapFill( new bgClass().bitmapData, null, true, true);
			graphics.drawRoundRectComplex(-1, 0, width + 2, height, 6, 6, 0, 0);
			graphics.endFill();
		}
		
		private function onMinimizeClick(event:MouseEvent):void
		{
			(window as Window).removeActiveContextMenu();
			if (window.isSheetActive || window.isDrawerActive)
			{
				return;
			}
			
			if (!this.showMinimizeButton)
				return;
			
			window.minimize();
		}
		
		private function onCloseClick(event:MouseEvent):void
		{
			(window as Window).removeActiveContextMenu();
			if (window.isSheetActive)
			{
				return;
			}
			if (!this.showCloseButton)
				return;
			window.close();
		}
		
		private function onMaximizeClick(event:MouseEvent):void
		{
			(window as Window).removeActiveContextMenu();
			if (window.isSheetActive || window.isDrawerActive)
			{
				return;
			}
			if (!this.showMaximizeButton)
				return;
			window.maximize();
		}
	}
}