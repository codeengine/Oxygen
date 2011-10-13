package net.codeengine.windowmanagement
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.filters.GradientGlowFilter;
	import flash.utils.setTimeout;
	
	import mx.controls.Label;
	import mx.controls.Spacer;
	
	import net.codeengine.windowmanagement.decorations.GlowDecoration;
	import net.codeengine.windowmanagement.decorator.Decorator;
	import net.codeengine.windowmanagement.events.WindowEvent;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.supportClasses.DisplayLayer;
	import spark.filters.DropShadowFilter;
	import spark.filters.GlowFilter;
	import spark.filters.GradientFilter;
	
	public class WindowTitlebar extends BorderContainer implements IWindowTitleBar
	{
		[Embed(source="assets/images/titlebar10x80.png")]
		private var bgClass:Class;
		[Bindable]private var _title:String = null;
		[Bindable]private var _label:spark.components.Label = null;
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
		//Settings
		[Embed(source="assets/images/flipside.png")]
		private var _settingsButtonSkin:Class;
		private var titlebarHGroup:HGroup = new HGroup();
		private var titlebarButtons:HGroup=new HGroup();
		private var _showCloseButton:Boolean = true;
		private var _showMaximizeButton:Boolean = true;
		private var _showMinimizeButton:Boolean = true;
		private var buttonMinimize:Image=new Image();
		private var buttonMaximize:Image=new Image();
		private var buttonClose:Image=new Image();
		private var _initialDrawCompleted:Boolean = false;
		
		private var buttonFlip:Image;
		//private var buttonResize:Image=new Image();

		private var _window:IWindow;
		public function get window():IWindow { return _window; }
		
		public function set window(value:IWindow):void
		{
			if (_window == value)
				return;
			_window = value;
		}
		
		public function WindowTitlebar()
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
			draw();
			
		}	
		
		public function draw():void{
			var myWidth:Number;
			var myWindowWidth:Number;
			try
			{
				myWidth = width;
				myWindowWidth = window.width;
				if (myWidth != myWindowWidth)myWidth = myWindowWidth;
				width = myWidth;
				trace("myWidth: " + width + " myWindowWidth: " + window.width);
				_label.text = title;
			} 
			catch(error:Error) 
			{
				
			}
			
			
			if (!_initialDrawCompleted){
				this.setStyle("backgroundAlpha",0);
				this.setStyle("borderAlpha", 0);
				x = 0;
				y = 0;
				percentWidth = 100;
				if (window is IWindowFlipable){
					buttonFlip = new Image();
				}
				
				titlebarHGroup.left = 2;
				titlebarHGroup.right = 2;
				titlebarHGroup.top = 3;
				titlebarHGroup.bottom = 0;
				addElement(titlebarHGroup);
				
				
				addTitleBarButtons();
				
				var spacer:Group = new Group();
				spacer.percentWidth = 100;
				titlebarHGroup.addElement(spacer);
				
//				if (null != title){
					_label = new spark.components.Label();
					
					_label.verticalCenter = 0;
					_label.horizontalCenter = !window is IWindowFlipside ? -46 : -50;
					_label.setStyle("fontFamily", "Verdana");
					_label.setStyle("fontSize", 15);
					spacer.addElement(_label);
					//var etch:DropShadowFilter = new DropShadowFilter(1, 90, 0xffffff, 0.8, 2, 2);
					//_label.filters = [etch];
//				}
				
				addSettingsButton();
				addEventListeners();
				_initialDrawCompleted = true;
			}
			
			deactivateDisabledTitleBarButtonsVisually();
			
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
		
		private function addSettingsButton():void{
			if (window is IWindowFlipable){
				var f:DropShadowFilter = new DropShadowFilter(2, 90, 0xffffff, 0.8, 2, 2);
				buttonFlip.height=14;
				buttonFlip.width=14;
				buttonFlip.source=_settingsButtonSkin;
				buttonFlip.filters = [f];	
				var spacer:Spacer = new Spacer();
				spacer.percentWidth = 100;
				titlebarButtons.addElement(spacer);
				titlebarHGroup.addElement(buttonFlip);
				buttonFlip.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			}
		}

		private function onClick(event:MouseEvent):void
		{
			if(window.isDrawerActive)window.drawer.close();
			setTimeout((window as IWindowFlipable).flip, 500);
		}
		private function addTitleBarButtons():void
		{
			if (window is IWindowFlipside){
				return;
			}
			
			//var f:DropShadowFilter = new DropShadowFilter(2, 90, 0xffffff, 0.8, 2, 2);
			titlebarButtons.left=10;
			titlebarButtons.top=3;
			titlebarHGroup.addElement(titlebarButtons);
			
			buttonClose.height=14;
			buttonClose.width=14;
			buttonClose.source=_closeButtonSkin;
			//buttonClose.filters = [f];
			buttonClose.alpha = showCloseButton ? 1 : 0.5;
			
			buttonMaximize.height=14;
			buttonMaximize.width=14;
			buttonMaximize.source=_maximizeButtonSkin;
			//buttonMaximize.filters = [f];
			buttonMaximize.alpha = showMaximizeButton ? 1 : 0.5;
			
			buttonMinimize.height=14;
			buttonMinimize.width=14;
			buttonMinimize.source=_minizeButtonSkin;
			//buttonMinimize.filters = [f];
			buttonMinimize.alpha = showMinimizeButton ? 1 : 0.5;
			
			titlebarButtons.addElement(buttonClose);
			titlebarButtons.addElement(buttonMaximize);
			titlebarButtons.addElement(buttonMinimize);
			
			registerTitleBarButtonEventListeners(buttonClose);
			registerTitleBarButtonEventListeners(buttonMaximize);
			registerTitleBarButtonEventListeners(buttonMinimize);
			
		
		}
		
		private function registerTitleBarButtonEventListeners(target:DisplayObject):void{
			target.addEventListener(MouseEvent.MOUSE_OVER, onTitleBarButtonMouseOver);
			target.addEventListener(MouseEvent.MOUSE_OUT, onTitleBarButtonMouseOut);
		}
		
		private function onTitleBarButtonMouseOver(event:MouseEvent):void{
		}
		
		private function onTitleBarButtonMouseOut(event:MouseEvent):void{
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			graphics.clear();
			graphics.beginBitmapFill( new bgClass().bitmapData, null, true, true);
			graphics.drawRoundRectComplex(-1, 0, width, height, 6, 6, 0, 0);
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