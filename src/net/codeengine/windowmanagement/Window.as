package net.codeengine.windowmanagement
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.DateField;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.core.Container;
	import mx.core.IVisualElement;
	import mx.events.EffectEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	import mx.graphics.ImageSnapshot;
	import mx.managers.CursorManager;
	
	import net.codeengine.windowmanagement.animations.AppearPopoverAnimation;
	import net.codeengine.windowmanagement.animations.DisappearPopoverAnimation;
	import net.codeengine.windowmanagement.animations.IPopoverAnimation;
	import net.codeengine.windowmanagement.animations.PopoverAnimationEvent;
	import net.codeengine.windowmanagement.decorations.*;
	import net.codeengine.windowmanagement.decorator.IDecorator;
	import net.codeengine.windowmanagement.events.*;
	import net.codeengine.windowmanagement.uicomponents.BusyIndicator;
	import net.codeengine.windowmanagement.uicomponents.IPopover;
	
	import spark.components.BorderContainer;
	import spark.effects.Animate;
	import spark.effects.Fade;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;

	/**
	 * A window is a visual component with extended functionality.
	 * <p>Since windows are containers, you can add any child elements you wish to them.
	 * <p>Windows can be dragged about, resized, maximized, minimized and closed.
	 * <p>All of the title bar buttons (minimize, maximize, resize and close) can be either enabled (visible) or disabled (hidden).
	 * <p>Windows support sheets (modal window level components) and drawers.
	 */

	public class Window extends BorderContainer implements IWindow
	{

		/* ************************************************************ *
		 * Class Properties                                             *
		 * ************************************************************ */
		public static var DIM_DURATION_SHEET:int=0;
		public static var DIM_DURATION_DRAWER:int=0;
		public static var UNDIM_DURATION_SHEET:int=0;
		public static var UNDIM_DURATION_DRAWER:int=0;
		
		[Bindable]private var _model:*;
		public function get model():* { return _model; }
		
		public function set model(value:*):void
		{
			if (_model == value)
				return;
			_model = value;
		}
		
		

		[Bindable]
		[Embed(source='assets/images/oxygenGroupBackground.png')]
		public static var oxygenGroupBackground:Class;

		[Bindable]
		[Embed(source='assets/images/oxygenWindowBackground.png')]
		public static var oxygenWindowBackground:Class;


		[Bindable]
		[Embed(source='assets/images/oxygenSheetBackground.png')]
		public static var oxygenSheetBackground:Class;
		[Bindable]
		private var _showCloseButton:Boolean=true;

		[Bindable]
		private var _showMaximizeButton:Boolean=true;

		[Bindable]
		private var _showMinimizeButton:Boolean=true;

		[Bindable]
		private var _showResizeHandle:Boolean=true;

		public var windowManager:WindowManager = WindowManager.instance;
		

		[Embed(source="assets/images/titlebarbg.png")]
		private var bg:Class;


		protected var titlebar:IWindowTitleBar=new WindowTitlebar();

		private var blocker:BorderContainer;



		[Embed(source="assets/images/buttons/resizeHandle11x11.png")]
		private var _buttonResizeSkin:Class;

		[Embed(source="assets/images/resizeCursor.png")]
		[Bindable]
		public var resizeCursor:Class;


		private var busy:IBusy=new net.codeengine.windowmanagement.uicomponents.BusyIndicator(null, true, 50, getTitlebarHeight());

		private var _windowManager:WindowManager = WindowManager.instance;

		private var _hasFocus:Boolean=false;

		private const WINDOW_STATE_NORMAL:int=0;

		private const WINDOW_STATE_MINIMIZED:int=1;

		private const WINDOW_STATE_MAXIMIZED:int=2;

		private var _currentWindowState:int=WINDOW_STATE_NORMAL;

		private var _transparentOnMove:Boolean=false;

		private var _windowId:String;

		private var _isModal:Boolean=false;

		private var windowProxy:Image;

		private var dialogWindowProxy:Image;

		private var _windowDecorator:IDecorator;

		private var _isDragging:Boolean=false;

		private var _isSheetActive:Boolean=false;

		public var _sheet:ISheet;

		private var _isDrawerActive:Boolean=false;

		private var _drawer:IDrawer;

		private var _isClosing:Boolean;

		private var _isBusyIndicatorShowing:Boolean=false;
		private var _isPopoverShowing:Boolean=false;

		private var _isContextMenuActive:Boolean=false;

		private var _currentActiveContextMenu:IContextMenu=null;

		private var _defaultContextMenu:IContextMenu=null;

		private var _titlebarHeight:int=22;

		[Bindable]
		private var _preRollUpHeight:int;
		private var _titleBarDoubleClickAction:String="Rollup";

		[Embed(source='assets/images/oxygenWindowBackground.png')]
		private var windowBackground:Class;

		private var _premovex:Number;
		private var _premovey:Number;
		
		public var _prezoomwidth:Number;
		public var _prezoomheight:Number;
		public var _isZoomed:Boolean = false;

		public function Window()
		{
			//this.repeatImage=Window.oxygenWindowBackground;
//			this.setStyle("backgroundColor", 0xE6E6E6);
			this.setStyle("backgroundColor", 0xF0F0F0);
			
			this.setStyle("borderThickness", 1);
//			this.setStyle("borderAlpha", 0);
			this.setStyle("cornerRadius", 4);
			this.setStyle("borderStyle", "solid");
			this.setStyle("borderColor", 0xDBDBDB);
			
			model = new Object();
		}

		/* ************************************************************ *
		 * Property Accessors                                           *
		 * ************************************************************ */
		public function getTitlebarHeight():int
		{
			return titlebar.height;
		}

		public function setTitlebarHeight(value:int):void
		{
			this._titlebarHeight=value;
		}

		public function get busyIndicator():IBusy
		{
			return this.busy;
		}

		public function set busyIndicator(indicator:IBusy):void
		{
			this.busy=indicator;
		}


		public function set defaultContextMenu(value:IContextMenu):void
		{
			this._defaultContextMenu=value;
			this._defaultContextMenu.window=this;
		}

		public function get isContextMenuActive():Boolean
		{
			return this._isContextMenuActive;
		}

		public function get sheet():ISheet
		{
			return _sheet;
		}

		public function set sheet(value:ISheet):void
		{
			this._sheet=value;
		}

		public function get currentWindowState():int
		{
			return this._currentWindowState
		}

		public function set currentWindowState(value:int):void
		{
			this._currentWindowState=value
		}

		public function get hasFocus():Boolean
		{
			return this._hasFocus
		}

		public function set hasFocus(value:Boolean):void
		{
			this._hasFocus=value
		}

		public function get isSheetActive():Boolean
		{
			return this._isSheetActive;
		}

		public function set isSheetActive(value:Boolean):void
		{
			this._isSheetActive=value;
		}

		public function get isDrawerActive():Boolean
		{
			return this._isDrawerActive;
		}

		public function set isDrawerActive(value:Boolean):void
		{
			this._isDrawerActive=value;
		}

		public function get drawer():IDrawer
		{
			return this._drawer;
		}

		public function set drawer(value:IDrawer):void
		{
			this._drawer=value;
		}

		public function get isClosing():Boolean
		{
			return this._isClosing;
		}

		public function set isClosing(value:Boolean):void
		{
			this._isClosing=value;
		}

		public function superCreateChildren():void
		{
			super.createChildren();
		}

		/**
		 * Get a proxy object representing this window. A proxy is a pointer to this window
		 * and an image representing this window.
		 *
		 * @return A Window Proxy, especially useful for animations and keeping a reference to the window.
		 */
		public function get proxy():IWindowProxy
		{
			var proxy:IWindowProxy=new WindowProxy();
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
			proxy.window=this;
			return proxy;
		}

		/* ************************************************************ *
		 * Inspectable Properties                                       *
		 * ************************************************************ */

		[Inspectable(category="General")]
		public function get showCloseButton():Boolean
		{
			return this._showCloseButton;
		}

		public function set showCloseButton(value:Boolean):void
		{
			this._showCloseButton=value;
			this.redrawTitleBar();
		}

		[Inspectable(category="General")]
		public function get showMaximizeButton():Boolean
		{
			return _showMaximizeButton
		}

		public function set showMaximizeButton(value:Boolean):void
		{
			this._showMaximizeButton=value;
			//this.redrawTitleBar();
		}

		[Inspectable(category="General")]
		public function get showMinimizeButton():Boolean
		{
			return this._showMinimizeButton
		}

		public function set showMinimizeButton(value:Boolean):void
		{
			this._showMinimizeButton=value;
			//this.redrawTitleBar();
		}

		[Inspectable(category="General")]
		public function get windowId():String
		{
			return this._windowId;
		}

		[Inspectable(category="General", enumeration="Maximize,Rollup")]
		public function set titleBarDoubleClickAction(action:String):void
		{
			this._titleBarDoubleClickAction=action;
		}

		[Inspectable(category="General", enumeration="true,false")]
		public function set transparentOnMove(value:String):void
		{
			//TODO
		}

		public function set windowId(value:String):void
		{
			this._windowId=value;
		}

		[Inspectable(category="General")]
		public function get isModal():Boolean
		{
			return this._isModal;
		}

		public function set isModal(value:Boolean):void
		{
			this._isModal=value;
		}

		[Inspectable(category="General")]
		public function get showResizeHandle():Boolean
		{
			return this._showResizeHandle;
		}

		public function set showResizeHandle(value:Boolean):void
		{
			this._showResizeHandle=value;
			this.redrawTitleBar();
		}

		private function createTitlebar():void
		{
	
			//titlebar.setStyle("skinClass", Class(TitleBarSkin));

			//var l:Label=new Label();
			//l.text=this.title;
			//l.setStyle("fontSize", 14);
			//l.setStyle("fontFamily", "verdana");
			//l.horizontalCenter=0;
			//l.verticalCenter=0;
			//titlebar.addElement(l);
			//titlebar = new WindowTitlebar();
		
			titlebar.width = width;
			titlebar.title = title;
			titlebar.height = _titlebarHeight;
			titlebar.showCloseButton = showCloseButton;
			titlebar.showMaximizeButton = showMaximizeButton;
			titlebar.showMinimizeButton = showMinimizeButton;
			titlebar.window = this;
			
			//titlebar.draw();
			
			//try{this.removeElement(titlebar as IVisualElement);}catch(e:*){trace(e);}
			//this.addElement(titlebar as IVisualElement);
		}


		protected override function createChildren():void
		{
			if (this.minWidth == 0)this.minWidth=this.width;
			if (this.minHeight == 0)this.minHeight=this.height;
			
			super.createChildren();
			doubleClickEnabled=true;
			addEventHandlers();

			try
			{
				this.decorate(new ForegroundDecoration());
			}
			catch (e:*)
			{
				trace("Window:: createChildren: ForegroundDecorationException");
			}
			
			this.createTitlebar();
			this.addElement(titlebar as IVisualElement);
		}

		private function redrawTitleBar():void
		{
			titlebar.draw();
		}

		
		private function addEventHandlers():void
		{
			titlebar.addEventListener(MouseEvent.DOUBLE_CLICK, onTitleBarDoubleClick, false, 0, true);
			titlebar.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarMouseDown, false, 0, true);
			titlebar.addEventListener(MouseEvent.MOUSE_UP, onTitleBarMouseUp, false, 0, true);
			
			this.addEventListener(ResizeEvent.RESIZE, didResize, false, 0, true);
			this.addEventListener(WindowEvent.didMinimize, didMinimize, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, onMouseDown, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
			this.addEventListener("windowmanagerChanged", didChangeWindowManager, false, 0, true);
			this.addEventListener(MoveEvent.MOVE, onMove, false, 0, true);
			this.addEventListener(WindowEvent.didCreate, onCreationComplete, false, 0, true);
			this.addEventListener(WindowEvent.didHaltDragging, function(event:WindowEvent):void
			{
				stopDrag();
				
				
				var animate:Animate=new Animate(event.window);
				var moveX:SimpleMotionPath=new SimpleMotionPath();
				moveX.property="x";
				moveX.valueFrom=event.window.x;
				moveX.valueTo=_premovex;
				
				var moveY:SimpleMotionPath=new SimpleMotionPath();
				moveY.property="y";
				moveY.valueFrom=event.window.y;
				moveY.valueTo=_premovey;
				
				var vc:Vector.<MotionPath>=new Vector.<MotionPath>();
				vc.push(moveX);
				vc.push(moveY);
				
				animate.duration=500;
				animate.motionPaths=vc;
				animate.addEventListener(EffectEvent.EFFECT_END, function(event:Event):void
				{
					var e:WindowEvent=new WindowEvent(WindowEvent.didAutmaticallyReposition);
					e.window=WindowManager.instance.getWindowById(windowId);
					dispatchEvent(e);
					undimDrawer();
					undimSheet();
				}, false, 0, true);
				animate.play();
			}, false, 0, true);
		}
		

		private function removeEventListeners():void
		{
			/* Sparkify*/
			titlebar.removeEventListener(MouseEvent.DOUBLE_CLICK, onTitleBarDoubleClick);
			titlebar.removeEventListener(MouseEvent.MOUSE_DOWN, onTitleBarMouseDown);
			titlebar.removeEventListener(MouseEvent.MOUSE_UP, onTitleBarMouseUp);


			this.removeEventListener(ResizeEvent.RESIZE, didResize);
			this.removeEventListener(WindowEvent.didMinimize, didMinimize);
			this.removeEventListener(MouseEvent.CLICK, this.onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener("windowmanagerChanged", didChangeWindowManager);
			this.removeEventListener(MoveEvent.MOVE, onMove);

			
		}

		private function getFrame(source:IBitmapDrawable):Bitmap
		{
			var imageBitmapData:BitmapData=ImageSnapshot.captureBitmapData(source);
			return new Bitmap(imageBitmapData);
		}

		/**
		 * Add a sheet to the this window.
		 *
		 * @param sheet The sheet that you want to add to this window.
		 */
		public function addSheet(sheet:ISheet):void
		{
			sheet.model = model;
			WindowManager.instance.addSheet(sheet, this);
			/* Store our own reference to the sheet */
			this.sheet=sheet;
		}

		/**
		 * Remove the active sheet from this window.
		 *
		 * @param sheet The sheet that you want to remove from this window.
		 */
		public function removeSheet(sheet:ISheet):void
		{
			WindowManager.instance.removeSheet(sheet, this);
			this.sheet=null;
			sheet.model = null;
		}

		public function addDrawer(drawer:IDrawer):void
		{

			if (this.isDrawerActive)
			{
				//Check if the drawer that is being added is of the same kind, and if it is, ignore it, unless it's location is different.
				if (flash.utils.getQualifiedClassName(this.drawer) == flash.utils.getQualifiedClassName(drawer) && this.drawer.location == drawer.location)
				{
					return;
				}
				this.removeDrawer(this.drawer);
			}
			/* Private API */
			WindowManager.instance.addDrawer(drawer, this);
			this.drawer=drawer;
			drawer.window=this;
			this.isDrawerActive=true;
			drawer.model = model;
		}

		public function removeDrawer(drawer:IDrawer):void
		{
			if (drawer == null)
			{
				return;
			}
			/* Private API */
			WindowManager.instance.removeDrawer(drawer, this);
			this.drawer=null;
			isDrawerActive=false;
			drawer.model = null;
		}

		/**
		 * Close this window and remove it from the display stack as well as the window manager subsystem.
		 *
		 */
		public function close():void
		{
			//If this window has an active context menu, close it!
			this.removeActiveContextMenu();

			if (this._isSheetActive)
			{
				this.removeSheet(this._sheet);
				this.closeWithDelay(1500);
			}
			else
			{
				//Indicate that this window is closing.
				this.isClosing=true;
				WindowManager.instance.removeWindow(this);
				//Remove any active drawers
				if (this.isDrawerActive)
				{
					this.removeDrawer(this.drawer);
				}
					//trace("Window: close");
			}
		}

		private function closeWithDelay(delay:int):void
		{
			var timer:Timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onCloseWithDelayTimer, false, 0, true);
			timer.start();
		}

		private function onCloseWithDelayTimer(event:TimerEvent):void
		{
			event.currentTarget.stop();
			this.close();
		}


		private var _popovers:Array=new Array();

		public function isPopoverShowing():Boolean
		{
			var showing:Boolean=false;
			if (this._popovers.length > 0)
			{
				showing=true;
			}
			return showing;
		}

		public function addPopover(popover:IPopover):void
		{
			//block();
			popover.window=this;
			this.addChild(popover as DisplayObject);
			(popover as Container).setStyle("verticalCenter", 0);
			(popover as Container).setStyle("horizontalCenter", 0);
			this._isPopoverShowing=true;
			var effect:IPopoverAnimation=new AppearPopoverAnimation();
			//(popover as DisplayObject).visible = false;
			effect.play(popover);
		}

		public function removePopover(popover:IPopover):void
		{
			//if (!this._isPopoverShowing) return;
			//this.unblock();
			var effect:IPopoverAnimation=new DisappearPopoverAnimation();
			effect.addEventListener(PopoverAnimationEvent.POPOVER_DISAPPEAR_COMPLETE, onPopoverDisappearAnimationComplete, false, 0, true);

			effect.play(popover);

		}

		private function onPopoverDisappearAnimationComplete(event:PopoverAnimationEvent):void
		{
			this.removeElement(event.popover as IVisualElement);
		}



		/**
		 * Block the window from receiving any input or interaction from the user.
		 */
		public function block():void
		{
			if (this.isSheetActive)
			{
				this.sheet.block();
			}
			if (this.isDrawerActive)
			{
				//(this.drawer as Object).enabled=false;
				this.drawer.block();
			}
			blocker=new BorderContainer();
			blocker.alpha=0;
			blocker.setStyle("borderVisible", false);
			blocker.width=this.width - 1;
			blocker.height=this.height - this.titlebar.height - 2;
			blocker.y=this.titlebar.height;
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
			if (!this.isSheetActive)
			{
				this.enabled=true;
			}
			else
			{
				//(this.sheet as Object).enabled=true;
				this.sheet.unblock();
			}
			if (this.isDrawerActive)
			{
				//(this.drawer as Object).enabled=true;
				this.drawer.unblock();
			}
		}

		/**
		 * Force the window to refresh itself.
		 */
		public function refresh():void
		{
			invalidateDisplayList();
			validateNow();

		}

		public function decorate(decoration:IDecoration):void
		{
			WindowManager.instance.decorator.decorate(decoration, this);
		}

		public function maximize():void
		{
			if (!this._isZoomed){
				this._prezoomheight = this.height;
				this._prezoomwidth = this.width;
			}
			WindowManager.instance.maximizeWindow(this);
			
			this.redrawTitleBar();
		}

		public function showBusyIndicator():void
		{
//			this.addElement(busy as IVisualElement);
			this._isBusyIndicatorShowing=true;
//			var fade:spark.effects.Fade=new spark.effects.Fade(busy);
//			fade.alphaFrom=0;
//			fade.alphaTo=1;
//			fade.duration=500;
//			fade.play();
			
			
			busy.activate(this);
		}

		public function removeBusyIndicator():void
		{
			this._isBusyIndicatorShowing=false;
//			var fade:spark.effects.Fade=new spark.effects.Fade(busy);
//			fade.alphaFrom=1;
//			fade.alphaTo=0;
//			fade.duration=500;
//			fade.play();
//
//			fade.addEventListener(EffectEvent.EFFECT_END, function(event:EffectEvent):void
//			{
//				removeElement(busy as IVisualElement);
//			}, false, 0, true);
			
			busy.deactivate();
		}

		//Undocumented API
		public function toggleBusyIndicator():void
		{
			if (this._isBusyIndicatorShowing)
			{
				this.unblock();
				this.removeBusyIndicator();
			}
			else if (!this._isBusyIndicatorShowing)
			{
				this.block();
				this.showBusyIndicator();
			}
		}

		//TODO: Undocumented API
		public function addContextMenu(contextMenu:IContextMenu):void
		{
			WindowManager.instance.addChild(contextMenu as DisplayObject);
			var localp:Point=new Point(contentMouseX, contentMouseY);
			var globalp:Point=contentToGlobal(localp);
			(contextMenu as DisplayObject).x=globalp.x;
			(contextMenu as DisplayObject).y=globalp.y;
			WindowManager.instance.bringToFront(contextMenu as DisplayObject);
			this._isContextMenuActive=true;
			this._currentActiveContextMenu=contextMenu;
			contextMenu.window=this;
		}

		//TODO: Undocumented API
		public function removeContextMenu(contextMenu:IContextMenu):void
		{
//			if (contextMenu == null)
//				return;
//			WindowManager.instance.removeElement(contextMenu as DisplayObject);
//			this._currentActiveContextMenu=null;
//			this._isContextMenuActive=false;
		}

		//TODO: Undocumented API
		public function removeActiveContextMenu():void
		{
			if (this._currentActiveContextMenu != null)
			{
				this.removeContextMenu(this._currentActiveContextMenu);
			}
		}

		//TODO: Undocumented API
		public function addDefaultContextMenu():void
		{
			if (this._defaultContextMenu != null)
			{
				this.addContextMenu(this._defaultContextMenu);
			}
		}

		/* ************************************************************ *
		 * Event Handlers                                               *
		 * ************************************************************ */
		private function onTitleBarDoubleClick(event:MouseEvent):void
		{

			if (this._titleBarDoubleClickAction == "Rollup")
			{
				//TODO: Fix
				return;
				var a:Animate=new Animate(this);
				a.duration=500;
				var v:Vector.<MotionPath>=new Vector.<MotionPath>();
				a.motionPaths=v;
				var r:SimpleMotionPath;
				if (this.isSheetActive || this.isDrawerActive)
				{
					return;
				}
				if (this.height == (this.titlebar.height))
				{
					//this.height=this._preRollUpHeight;
					r=new SimpleMotionPath("height", this.titlebar.height, this._preRollUpHeight);
					/*var resize:Resize =new Resize(this);
					resize.heightTo = this._preRollUpHeight;
					resize.heightFrom = this.titlebar.height;
					resize.duration = 500;
					resize.play();*/
				}
				else
				{
					this._preRollUpHeight=this.height;
					r=new SimpleMotionPath("height", this.height, this.titlebar.height);
						//this.height=this.titlebar.height;
					/*var resize:Resize =new Resize(this);
					resize.heightFrom = this.height;
					resize.heightTo = this.titlebar.height;
					resize.duration = 500;
					resize.play();*/
				}
				v.push(r);

				a.play();
			}
			else if (this._titleBarDoubleClickAction == "Maximize")
			{
				this.maximize();
			}
		}

		

		private function didResize(event:ResizeEvent):void
		{
			redrawTitleBar();
			removeActiveContextMenu();
			//trace("Window: resizeEventHandler");
			var e:WindowEvent=new WindowEvent(WindowEvent.didResize);
			e.window=this;
			dispatchEvent(e);
		}

		private function onResizeMouseDown(event:MouseEvent):void
		{
//			removeActiveContextMenu();
//			CursorManager.setCursor(this.resizeCursor);
//			event.stopImmediatePropagation();
//			buttonResize.addEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp, false, 0, true);
//			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onSystemMouseMove, false, 0, true);
//			systemManager.addEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp, false, 0, true);
			//trace("Window: resize_mouseDownHandler");
		}

		private function onResizeMouseOver(event:MouseEvent):void
		{
//			removeActiveContextMenu();
//			CursorManager.setCursor(this.resizeCursor);
		}

		private function onResizeMouseOut(event:MouseEvent):void
		{
//			removeActiveContextMenu();
//			CursorManager.removeAllCursors();
		}

		private function onResizeMouseUp(event:MouseEvent):void
		{
//			removeActiveContextMenu();
//
//			event.stopImmediatePropagation();
//
//			buttonResize.removeEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp);
//
//			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onSystemMouseMove);
//			systemManager.removeEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp);
//			//trace("Window: resize_mouseUpHandler");
//			CursorManager.removeAllCursors();
		}



		private function onMouseDown(event:MouseEvent):void
		{
			//Remove any existing context menu
			removeActiveContextMenu();
			//Modified Click?
			if (event.ctrlKey)
			{
				this.addDefaultContextMenu();
			}

			//Don't bring the window to the front if a LinkButton was clicked
			if (event.target is LinkButton || event.target is DateField)
			{

			}
			else
			{
				var e:WindowEvent=new WindowEvent(WindowEvent.didGainFocus);
				e.window=this;
				this.dispatchEvent(e);
			}
		}

		private function onTitleBarMouseDown(event:MouseEvent):void
		{
			trace("x: " + x  + " y: " + y);
			removeActiveContextMenu();
			if (this._transparentOnMove)
			{
				this.alpha=0.8;
			}

			//var r:Rectangle = new Rectangle(this.windowManager.container.x + 20,this.windowManager.container.y + 20,this.windowManager.container.width-20,this.windowManager.container.height-20);
			this._premovex=this.x;
			this._premovey=this.y;
			this.startDrag(false);
			this._isDragging=true;
			WindowManager.instance.sendWindowToFront(this.windowId);
			var e:WindowEvent=new WindowEvent(WindowEvent.didGainFocus);
			e.window=this;
			this.dispatchEvent(e);
			this.dimDrawer();
			this.dimSheet();
		}

		private function onTitleBarMouseUp(event:MouseEvent):void
		{
			removeActiveContextMenu();
			if (this._transparentOnMove)
			{
				this.alpha=1.0;
			}

			this.stopDrag();
			this._isDragging=false;
			var e:WindowEvent=new WindowEvent(WindowEvent.didMove);
			e.window=this;
			this.undimDrawer();
			this.undimSheet();
			this.dispatchEvent(e);
		}

		private function dimDrawer():void
		{
			return;
			if (this.isDrawerActive)
			{
				var a:Animate=new Animate(this.drawer as DisplayObject);
				a.duration=Window.DIM_DURATION_DRAWER;
				var v:Vector.<MotionPath>=new Vector.<MotionPath>();
				/* Fade */
				var fade:SimpleMotionPath=new SimpleMotionPath("alpha");
				fade.valueFrom=1;
				fade.valueTo=0;
				v.push(fade);
				a.motionPaths=v;
				a.play();
			}
		}

		private function dimSheet():void
		{
			return;
			if (this.isSheetActive)
			{
				var a:Animate=new Animate(this.sheet as DisplayObject);
				a.duration=Window.DIM_DURATION_SHEET;
				var v:Vector.<MotionPath>=new Vector.<MotionPath>();
				/* Fade */
				var fade:SimpleMotionPath=new SimpleMotionPath("alpha");
				fade.valueFrom=1;
				fade.valueTo=0;
				v.push(fade);
				a.motionPaths=v;
				a.play();
			}
		}

		private function undimSheet():void
		{
			return;
			if (this.isSheetActive)
			{
				var a:Animate=new Animate(this.sheet as DisplayObject);
				a.duration=Window.UNDIM_DURATION_SHEET
				var v:Vector.<MotionPath>=new Vector.<MotionPath>();
				/* Fade */
				var fade:SimpleMotionPath=new SimpleMotionPath("alpha");
				fade.valueFrom=Sheet.MINIMUM_ALPHA;
				fade.valueTo=Sheet.MAXIMUM_ALPHA;
				v.push(fade);
				a.motionPaths=v;
				a.play();
			}
		}

		private function undimDrawer():void
		{
			return;
			if (this.isDrawerActive)
			{
				var a:Animate=new Animate(this.drawer as DisplayObject);
				a.duration=Window.UNDIM_DURATION_DRAWER;
				var v:Vector.<MotionPath>=new Vector.<MotionPath>();
				/* Fade */
				var fade:SimpleMotionPath=new SimpleMotionPath("alpha");
				fade.valueFrom=0;
				fade.valueTo=1;
				v.push(fade);
				a.motionPaths=v;
				a.play();
			}
		}

		private function didMinimize(event:WindowEvent):void
		{
			//trace("Window: onMinimize");
		}

		private function didMaximize(event:WindowEvent):void
		{
			//trace("Window: onMaximize");
		}

		private function didRestore(event:WindowEvent):void
		{
			if (this.currentWindowState == WINDOW_STATE_MINIMIZED)
			{
				this.currentWindowState=WINDOW_STATE_NORMAL;
			}
			redrawTitleBar();
			//trace("Window: onRestore");

		}

		private function didShake(event:WindowEvent):void
		{
			//trace("Window: onShake");
		}

		private function didAppear(event:WindowEvent):void
		{
			//trace("Window: onAppear");
		}

		private function didChangeWindowManager(event:Event):void
		{
			//trace("Window: onWindowManagerChanged");
			WindowManager.instance.addWindow(this);

		}

		private function onMouseMove(event:MouseEvent):void
		{
			//trace("Window: onMouseMove");
			if (this._isDragging)
			{
				var windowEvent:WindowEvent=new WindowEvent(WindowEvent.didMove);
				windowEvent.window=this;
				dispatchEvent(windowEvent);
			}
		}


		private function onSystemMouseMove(event:MouseEvent):void
		{
			CursorManager.setCursor(this.resizeCursor);
			var stagePoint:Point=new Point(event.stageX + 10, event.stageY + 10);
			var parentPoint:Point=parent.globalToLocal(stagePoint);
			var newWidth:Number=stagePoint.x - x;
			var newHeight:Number=stagePoint.y - y;

			//Prevent the window from being resized to nothingness.

			if (newWidth > minWidth)
			{
				this.width=newWidth;
			}
			else
			{

			}
			if (newHeight > minHeight)
			{
				this.height=newHeight;
			}
			else
			{

			}
			//trace("Window: onSystemMouseMove");
		}


		private function onMove(event:MoveEvent):void
		{
			//trace("Window: onMove");
		}



		private function onCreationComplete(event:WindowEvent):void
		{
		}

		[Bindable]
		private var _title:String;

		
		[Inspectable(category="Common")]
		public function get title():String
		{
			return this._title;
		}

		public function set title(value:String):void
		{
			this._title=value;
		}
		
		public function minimize():void{
			WindowManager.instance.minimizeWindow(this);
		}
		
		public function maxmize():void{
			WindowManager.instance.maximizeWindow(this);
		}
	}
}

