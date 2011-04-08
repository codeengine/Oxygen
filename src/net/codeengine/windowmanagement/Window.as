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
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.controls.Image;
	import mx.controls.LinkButton;
	import mx.core.Container;
	import mx.core.EdgeMetrics;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.effects.Parallel;
	import mx.events.EffectEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	import mx.graphics.ImageSnapshot;
	import mx.graphics.LinearGradient;
	import mx.managers.CursorManager;
	import mx.skins.halo.WindowBackground;
	
	import net.codeengine.windowmanagement.animations.AppearPopoverAnimation;
	import net.codeengine.windowmanagement.animations.DisappearPopoverAnimation;
	import net.codeengine.windowmanagement.animations.IPopoverAnimation;
	import net.codeengine.windowmanagement.animations.PopoverAnimationEvent;
	import net.codeengine.windowmanagement.animations.PulseAnimation;
	import net.codeengine.windowmanagement.decorations.*;
	import net.codeengine.windowmanagement.decorator.IDecorator;
	import net.codeengine.windowmanagement.events.*;
	import net.codeengine.windowmanagement.skins.BorderSkin;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.effects.Animate;
	import spark.effects.Fade;
	import spark.effects.Move;
	import spark.effects.Resize;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.filters.BlurFilter;
	import spark.filters.DropShadowFilter;
	import spark.filters.ShaderFilter;

	/**
	 * A window is a visual component with extended functionality.
	 * <p>Since windows are containers, you can add any child elements you wish to them.
	 * <p>Windows can be dragged about, resized, maximized, minimized and closed.
	 * <p>All of the title bar buttons (minimize, maximize, resize and close) can be either enabled (visible) or disabled (hidden).
	 * <p>Windows support sheets (modal window level components) and drawers.
	 */

	public class Window extends net.codeengine.windowmanagement.WindowBackground implements IWindow
	{

		/* ************************************************************ *
		 * Class Properties                                             *
		 * ************************************************************ */
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

		[Bindable]
		private var buttonMinimize:Image=new Image();

		[Bindable]
		private var buttonMaximize:Image=new Image();

		[Bindable]
		private var buttonClose:Image=new Image();

		[Bindable]
		private var buttonResize:Image=new Image();

		/* Button Up Skin */
		//Close
		//[Embed(source="assets/images/buttons/oxygenButtonCloseUp.png")]
		[Embed(source="assets/images/titlebarbutton.png")]
		private var _closeButtonSkin:Class;
		//Zoom
		[Embed(source="assets/images/titlebarbutton.png")]
		private var _maximizeButtonSkin:Class;
		//Minimize
		[Embed(source="assets/images/titlebarbutton.png")]
		private var _minizeButtonSkin:Class;

		/* Button Over Skin */
		//Close
		[Embed(source="assets/images/titlebarbutton.png")]
		private var _closeButton_overSkin:Class;

		//Zoom
		[Embed(source="assets/images/titlebarbutton.png")]
		private var _maximizeButton_overSkin:Class;

		//Minimize
		[Embed(source="assets/images/titlebarbutton.png")]
		private var _minizeButton_overSkin:Class;

		[Embed(source="assets/images/titlebarbg.png")]
		private var bg:Class;


		private var titlebar:BorderContainer=new BorderContainer();
		private var titlebarButtons:HGroup=new HGroup();
		
		private var blocker:BorderContainer;



		[Embed(source="assets/images/buttons/resizeHandle11x11.png")]
		private var _buttonResizeSkin:Class;

		[Embed(source="assets/images/resizeCursor.png")]
		[Bindable]
		public var resizeCursor:Class;


		private var busy:IBusy=new BusyIndicator();

		private var _windowManager:IWindowManager;

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

		public function Window()
		{
			this.repeatImage=Window.oxygenWindowBackground;
			this.setStyle("borderThickness", 1);
			this.setStyle("borderAlpha", 1);
			this.setStyle("borderStyle", "solid");
			this.setStyle("borderColor", 0xb1b1b1);
		}

		/* ************************************************************ *
		 * Property Accessors                                           *
		 * ************************************************************ */
		public function getTitlebarHeight():int
		{
			return this.titlebar.height;
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
			this.redrawMyTitlebarButtons();
		}

		[Inspectable(category="General")]
		public function get showMaximizeButton():Boolean
		{
			return this._showMaximizeButton
		}

		public function set showMaximizeButton(value:Boolean):void
		{
			this._showMaximizeButton=value;
			this.redrawMyTitlebarButtons();
		}

		[Inspectable(category="General")]
		public function get showMinimizeButton():Boolean
		{
			return this._showMinimizeButton
		}

		public function set showMinimizeButton(value:Boolean):void
		{
			this._showMinimizeButton=value;
			this.redrawMyTitlebarButtons();
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
			this.redrawMyTitlebarButtons();
		}

		[Inspectable(category="Styles")]
		public function get minimizeButtonSkin():Class
		{
			return _minizeButtonSkin
		}

		public function set minimizeButtonSkin(value:Class):void
		{
			_minizeButtonSkin=value;
		}

		[Inspectable(category="Styles")]
		public function get maximizeButtonSkin():Class
		{
			return _maximizeButtonSkin
		}

		public function set maximizeButtonSkin(value:Class):void
		{
			_maximizeButtonSkin=value;
		}

		[Inspectable(category="Styles")]
		public function get closeButtonSkin():Class
		{
			return _closeButtonSkin
		}

		public function set closeButtonSkin(value:Class):void
		{
			_closeButtonSkin=value;
		}



		[Inspectable(category="General")]
		[Bindable]
		public function get windowManager():IWindowManager
		{
			return _windowManager
		}

		public function set windowManager(value:IWindowManager):void
		{
			_windowManager=value;
			//Dispatch a change event
			dispatchEvent(new Event("windowmanagerChanged"));
		}

		private function createTitlebar():void
		{
			titlebar.height=this._titlebarHeight;
			titlebar.left=0;
			titlebar.right=0;
			titlebar.top=-22;
			
			titlebar.setStyle("cornerRadius", 6);
			titlebar.setStyle("skinClass", Class(BorderSkin));
		
			var l:Label=new Label();
			l.text=this.title;
			l.setStyle("fontSize", 14);
			l.setStyle("fontFamily", "verdana");
			l.horizontalCenter=0;
			l.verticalCenter=0;
			titlebar.addElement(l);
		}


		protected override function createChildren():void
		{
			if (this.minWidth == 0)
			{
				this.minWidth=this.width;
			}
			if (this.minHeight == 0)
			{
				this.minHeight=this.height;
			}
			super.createChildren();
			doubleClickEnabled=true;
			addEventHandlers();

			try
			{
				this.decorate(new ForegroundDecoration());
			}
			catch (e:*)
			{
			}



			/* Create the Title Bar */

			this.createTitlebar();

			this.addTitleBarButtons();


			/*titlebar.addEventListener(MouseEvent.DOUBLE_CLICK, onTitleBarDoubleClick);
			titlebar.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void{

				removeActiveContextMenu();
				if (_transparentOnMove) {
					alpha=0.8;
				}

				var r:Rectangle = new Rectangle(windowManager.container.x + 20,windowManager.container.y + 20,windowManager.container.width-20,windowManager.container.height-20);
				startDrag(false, r);
				_isDragging=true;
				windowManager.sendWindowToFront(windowId);
				var e:WindowEvent=new WindowEvent(WindowEvent.ON_FOCUS);
				e.window=windowManager.getWindowById(windowId);
				dispatchEvent(e);
			});
			titlebar.addEventListener(MouseEvent.MOUSE_UP, onTitleBarMouseUp);*/

			this.addElement(titlebar);




		/* Sparkify
		this.verticalScrollPolicy="off";
		this.horizontalScrollPolicy="off";
		*/
		}

		private function redrawMyTitlebarButtons():void
		{
			this.deactivateDisabledTitleBarButtonsVisually();
		}

		private function deactivateDisabledTitleBarButtonsVisually():void
		{
			this.buttonClose.alpha=this.showCloseButton ? 1 : 0.2;
			this.buttonMinimize.alpha=this.showMinimizeButton ? 1 : 0.2;
			this.buttonMaximize.alpha=this.showMaximizeButton ? 1 : 0.2;
		}

		private function positionTitleBarButtons():void
		{



		}

		private function addTitleBarButtons():void
		{


			titlebarButtons.right=10;
			titlebarButtons.top=3;
			titlebar.addElement(titlebarButtons);

			buttonMinimize.height=14;
			buttonMinimize.width=14;
			buttonMinimize.source=_minizeButtonSkin;


			buttonMaximize.height=14;
			buttonMaximize.width=14;
			buttonMaximize.source=_maximizeButtonSkin;


			buttonClose.height=14;
			buttonClose.width=14;
			buttonClose.source=_closeButtonSkin;

			buttonResize.height=11;
			buttonResize.width=11;
			buttonResize.source=_buttonResizeSkin;
			buttonResize.right=5;
			buttonResize.bottom=5;

			this.titlebarButtons.addElement(buttonMinimize);
			this.titlebarButtons.addElement(buttonMaximize);
			this.titlebarButtons.addElement(buttonClose);

			if (_showResizeHandle)
			{
				this.addElement(buttonResize);
			}
			else
			{
				this.removeElement(buttonResize);
			}
		}

		private function titlebarButtonMouseOverEffect(target:DisplayObject):void
		{
			var glow:GlowDecoration=new GlowDecoration();
			glow.color=0x676767;

			glow.decorate(target);
		}

		private function titlebarButtonMouseOutEffect(target:DisplayObject):void
		{
			target.filters=[];
		}

		private function onMinimizeMouseOver(event:MouseEvent):void
		{
			this.buttonMinimize.source=this._minizeButton_overSkin;
			this.titlebarButtonMouseOverEffect(event.target as DisplayObject);
		}

		private function onMaximizeMouseOver(event:MouseEvent):void
		{
			this.buttonMaximize.source=this._maximizeButton_overSkin;

			this.titlebarButtonMouseOverEffect(event.target as DisplayObject);
		}

		private function onCloseMouseOver(event:MouseEvent):void
		{
			this.buttonClose.source=this._closeButton_overSkin;

			this.titlebarButtonMouseOverEffect(event.target as DisplayObject);
		}

		private function onMinimizeMouseOut(event:MouseEvent):void
		{
			this.buttonMinimize.source=this._minizeButtonSkin;
			this.titlebarButtonMouseOutEffect(event.currentTarget as DisplayObject);
		}

		private function onMaximizeMouseOut(event:MouseEvent):void
		{
			this.buttonMaximize.source=this._maximizeButtonSkin;
			this.titlebarButtonMouseOutEffect(event.currentTarget as DisplayObject);
		}

		private function onCloseMouseOut(event:MouseEvent):void
		{
			this.buttonClose.source=this._closeButtonSkin;
			this.titlebarButtonMouseOutEffect(event.currentTarget as DisplayObject);
		}

		private function addEventHandlers():void
		{

			titlebar.addEventListener(MouseEvent.DOUBLE_CLICK, onTitleBarDoubleClick);
			titlebar.addEventListener(MouseEvent.MOUSE_DOWN, onTitleBarMouseDown);
			titlebar.addEventListener(MouseEvent.MOUSE_UP, onTitleBarMouseUp);


			this.addEventListener(ResizeEvent.RESIZE, onResize);
			this.addEventListener(WindowEvent.ON_MINIMIZE, onMinimize);
			this.addEventListener(MouseEvent.CLICK, this.onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.addEventListener("windowmanagerChanged", onWindowManagerChanged);
			this.addEventListener(MoveEvent.MOVE, onMove);
			this.addEventListener(WindowEvent.ON_WINDOW_CREATION_COMPLETE, onCreationComplete)
			this.addEventListener(WindowEvent.HALT_DRAGGING, function(event:WindowEvent):void
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
					var e:WindowEvent=new WindowEvent(WindowEvent.WINDOW_AUTOMATICALLY_REPOSITIONED);
					e.window=windowManager.getWindowById(windowId);
					dispatchEvent(e);
					undimDrawer();
					undimSheet();
				});
				animate.play();


			});

			buttonMinimize.addEventListener(MouseEvent.MOUSE_UP, onMinimizeClick);
			buttonMaximize.addEventListener(MouseEvent.CLICK, onMaximizeClick);
			buttonClose.addEventListener(MouseEvent.CLICK, onCloseClick);

			buttonMinimize.addEventListener(MouseEvent.MOUSE_OVER, onMinimizeMouseOver);
			buttonMaximize.addEventListener(MouseEvent.MOUSE_OVER, onMaximizeMouseOver);
			buttonClose.addEventListener(MouseEvent.MOUSE_OVER, onCloseMouseOver);

			buttonMinimize.addEventListener(MouseEvent.MOUSE_OUT, onMinimizeMouseOut);
			buttonMaximize.addEventListener(MouseEvent.MOUSE_OUT, onMaximizeMouseOut);
			buttonClose.addEventListener(MouseEvent.MOUSE_OUT, onCloseMouseOut);

			buttonResize.addEventListener(MouseEvent.MOUSE_DOWN, onResizeMouseDown);
			buttonResize.addEventListener(MouseEvent.MOUSE_OVER, onResizeMouseOver);
			buttonResize.addEventListener(MouseEvent.MOUSE_OUT, onResizeMouseOut);
		}

		private function removeEventListeners():void
		{
			/* Sparkify*/
			titlebar.removeEventListener(MouseEvent.DOUBLE_CLICK, onTitleBarDoubleClick);
			titlebar.removeEventListener(MouseEvent.MOUSE_DOWN, onTitleBarMouseDown);
			titlebar.removeEventListener(MouseEvent.MOUSE_UP, onTitleBarMouseUp);


			this.removeEventListener(ResizeEvent.RESIZE, onResize);
			this.removeEventListener(WindowEvent.ON_MINIMIZE, onMinimize);
			this.removeEventListener(MouseEvent.CLICK, this.onMouseDown);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener("windowmanagerChanged", onWindowManagerChanged);
			this.removeEventListener(MoveEvent.MOVE, onMove);

			buttonMinimize.removeEventListener(MouseEvent.MOUSE_UP, onMinimizeClick);
			buttonMaximize.removeEventListener(MouseEvent.CLICK, onMaximizeClick);
			buttonClose.removeEventListener(MouseEvent.CLICK, onCloseClick);

			buttonResize.removeEventListener(MouseEvent.MOUSE_DOWN, onResizeMouseDown);
			buttonResize.removeEventListener(MouseEvent.MOUSE_OVER, onResizeMouseOver);
			buttonResize.removeEventListener(MouseEvent.MOUSE_OUT, onResizeMouseOut);
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
			this.windowManager.addSheet(sheet, this);
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
			this.windowManager.removeSheet(sheet, this);
			this.sheet=null;
		}

		public function addDrawer(drawer:IDrawer):void
		{

			if (this.isDrawerActive)
			{
				//Check if the drawer that is being added is of the same kind, and if it is, ignore it.
				if (flash.utils.getQualifiedClassName(this.drawer) == flash.utils.getQualifiedClassName(drawer) && this.drawer.location == drawer.location)
				{
					return;
				}
				this.removeDrawer(this.drawer);
			}
			/* Private API */
			(this.windowManager as WindowManager).addDrawer(drawer, this);
			this.drawer=drawer;
			drawer.window=this;
			this.isDrawerActive=true;
		}

		public function removeDrawer(drawer:IDrawer):void
		{
			if (drawer == null)
			{
				return;
			}
			/* Private API */
			(this.windowManager as WindowManager).removeDrawer(drawer, this);
			this.drawer=null;
			isDrawerActive=false;
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
				this.windowManager.removeWindow(this);
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
			timer.addEventListener(TimerEvent.TIMER, onCloseWithDelayTimer);
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
			effect.addEventListener(PopoverAnimationEvent.POPOVER_DISAPPEAR_COMPLETE, onPopoverDisappearAnimationComplete);

			effect.play(popover);

		}

		private function onPopoverDisappearAnimationComplete(event:PopoverAnimationEvent):void
		{
			this.removeChild(event.popover as DisplayObject);
		}



		/**
		 * Block the window from receiving any input or interaction from the user.
		 */

		private var preBlockFilters:Array;
		public function block():void
		{
			
			this.preBlockFilters = this.filters;
			
			var filter:BlurFilter = new BlurFilter();
			var fs:Array = new Array();
			for each (var f:Object in this.filters){
				fs.push(f);
			}
			fs.push(filter);
			this.filters = fs;
			
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
			this.filters = this.preBlockFilters;
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
			this.windowManager.decorator.decorate(decoration, this);
		}

		public function maximize():void
		{
			if (this.currentWindowState != WINDOW_STATE_MAXIMIZED && this.currentWindowState != this.WINDOW_STATE_MINIMIZED)
			{
				this.windowManager.maximizeWindow(this);
				this.currentWindowState=this.WINDOW_STATE_MAXIMIZED
			}
			else if (this.currentWindowState == this.WINDOW_STATE_MAXIMIZED)
			{
				this.windowManager.restoreWindow(this);
				this.currentWindowState=this.WINDOW_STATE_NORMAL;
			}
			this.redrawMyTitlebarButtons();
		}

		public function showBusyIndicator():void
		{
			this.addElement(busy as IVisualElement);
			this._isBusyIndicatorShowing=true;
			var fade:spark.effects.Fade=new spark.effects.Fade(busy);
			fade.alphaFrom=0;
			fade.alphaTo=1;
			fade.duration=500;
			fade.play();
		}

		public function removeBusyIndicator():void
		{
			this._isBusyIndicatorShowing=false;
			var fade:spark.effects.Fade=new spark.effects.Fade(busy);
			fade.alphaFrom=1;
			fade.alphaTo=0;
			fade.duration=500;
			fade.play();

			fade.addEventListener(EffectEvent.EFFECT_END, function(event:EffectEvent):void
			{
				removeElement(busy as IVisualElement);
			});
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
			this.windowManager.addChild(contextMenu as DisplayObject);
			var localp:Point=new Point(contentMouseX, contentMouseY);
			var globalp:Point=contentToGlobal(localp);
			(contextMenu as DisplayObject).x=globalp.x;
			(contextMenu as DisplayObject).y=globalp.y;
			(this.windowManager as WindowManager).bringToFront(contextMenu as DisplayObject);
			this._isContextMenuActive=true;
			this._currentActiveContextMenu=contextMenu;
			contextMenu.window=this;
		}

		//TODO: Undocumented API
		public function removeContextMenu(contextMenu:IContextMenu):void
		{
			if (contextMenu == null)
				return;
			this.windowManager.removeChild(contextMenu as DisplayObject);
			this._currentActiveContextMenu=null;
			this._isContextMenuActive=false;
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

		private function onMinimizeClick(event:MouseEvent):void
		{
			removeActiveContextMenu();
			if (this._isSheetActive || this._isDrawerActive)
			{
				return;
			}

			if (!this.showMinimizeButton)
				return;

			this.windowManager.minimizeWindow(this);
			//trace("Window: imgMinimizeClickHandler");
		}

		private function onCloseClick(event:MouseEvent):void
		{
			removeActiveContextMenu();
			if (this.isSheetActive)
			{
				return;
			}
			if (!this.showCloseButton)
				return;
			//trace("Window: imgCloseClickHandler");
			close();
		}

		private function onMaximizeClick(event:MouseEvent):void
		{
			removeActiveContextMenu();
			if (this.isSheetActive || this._isDrawerActive)
			{
				return;
			}
			if (!this.showMaximizeButton)
				return;
			this.maximize();

			//trace("Window: imgMaximizeClickHandler");
		}

		private function onResize(event:ResizeEvent):void
		{
			removeActiveContextMenu();
			this.redrawMyTitlebarButtons();
			//trace("Window: resizeEventHandler");
			var e:WindowEvent=new WindowEvent(WindowEvent.ON_RESIZE);
			e.window=this;
			dispatchEvent(e);
		}

		private function onResizeMouseDown(event:MouseEvent):void
		{
			removeActiveContextMenu();
			CursorManager.setCursor(this.resizeCursor);
			event.stopImmediatePropagation();
			buttonResize.addEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp);
			systemManager.addEventListener(MouseEvent.MOUSE_MOVE, onSystemMouseMove);
			systemManager.addEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp);
			//trace("Window: resize_mouseDownHandler");
		}

		private function onResizeMouseOver(event:MouseEvent):void
		{
			removeActiveContextMenu();
			CursorManager.setCursor(this.resizeCursor);
		}

		private function onResizeMouseOut(event:MouseEvent):void
		{
			removeActiveContextMenu();
			CursorManager.removeAllCursors();
		}

		private function onResizeMouseUp(event:MouseEvent):void
		{
			removeActiveContextMenu();

			event.stopImmediatePropagation();

			buttonResize.removeEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp);

			systemManager.removeEventListener(MouseEvent.MOUSE_MOVE, onSystemMouseMove);
			systemManager.removeEventListener(MouseEvent.MOUSE_UP, onResizeMouseUp);
			//trace("Window: resize_mouseUpHandler");
			CursorManager.removeAllCursors();
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
				var e:WindowEvent=new WindowEvent(WindowEvent.ON_FOCUS);
				e.window=this;
				this.dispatchEvent(e);
			}
		}

		private function onTitleBarMouseDown(event:MouseEvent):void
		{
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
			this.windowManager.sendWindowToFront(this.windowId);
			var e:WindowEvent=new WindowEvent(WindowEvent.ON_FOCUS);
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
			var e:WindowEvent=new WindowEvent(WindowEvent.ON_MOVE);
			e.window=this;
			this.undimDrawer();
			this.undimSheet();
			this.dispatchEvent(e);
		}

		private function dimDrawer():void
		{
			if (this.isDrawerActive)
			{
				var a:Animate=new Animate(this.drawer as DisplayObject);
				a.duration=WindowManager.ANIMATION_SPEED;
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
			if (this.isSheetActive)
			{
				var a:Animate=new Animate(this.sheet as DisplayObject);
				a.duration=WindowManager.ANIMATION_SPEED;
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
			if (this.isSheetActive)
			{
				var a:Animate=new Animate(this.sheet as DisplayObject);
				a.duration=WindowManager.ANIMATION_SPEED;
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
			if (this.isDrawerActive)
			{
				var a:Animate=new Animate(this.drawer as DisplayObject);
				a.duration=WindowManager.ANIMATION_SPEED;
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

		private function onMinimize(event:WindowEvent):void
		{
			//trace("Window: onMinimize");
		}

		private function onMaximize(event:WindowEvent):void
		{
			//trace("Window: onMaximize");
		}

		private function onRestore(event:WindowEvent):void
		{
			if (this.currentWindowState == WINDOW_STATE_MINIMIZED)
			{
				this.currentWindowState=WINDOW_STATE_NORMAL;
			}
			redrawMyTitlebarButtons();
			//trace("Window: onRestore");

		}

		private function onShake(event:WindowEvent):void
		{
			//trace("Window: onShake");
		}

		private function onAppear(event:WindowEvent):void
		{
			//trace("Window: onAppear");
		}

		private function onWindowManagerChanged(event:Event):void
		{
			//trace("Window: onWindowManagerChanged");
			this.windowManager.addWindow(this);

		}

		private function onMouseMove(event:MouseEvent):void
		{
			//trace("Window: onMouseMove");
			if (this._isDragging)
			{
				var windowEvent:WindowEvent=new WindowEvent(WindowEvent.ON_MOVE);
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

		public function get title():String
		{
			return this._title;
		}

		public function set title(value:String):void
		{
			this._title=value;
		}
	}
}

