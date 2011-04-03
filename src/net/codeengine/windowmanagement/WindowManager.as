package net.codeengine.windowmanagement {
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Image;
    import mx.core.Container;
    import mx.core.IVisualElement;
    import mx.effects.Parallel;
    import mx.events.EffectEvent;
    import mx.events.ResizeEvent;
    
    import net.codeengine.windowmanagement.animations.*;
    import net.codeengine.windowmanagement.decorations.BackgroundDecoration;
    import net.codeengine.windowmanagement.decorations.BorderDecoration;
    import net.codeengine.windowmanagement.decorations.DrawerDecoration;
    import net.codeengine.windowmanagement.decorations.ForegroundDecoration;
    import net.codeengine.windowmanagement.decorations.NullDecoration;
    import net.codeengine.windowmanagement.decorations.SheetDecoration;
    import net.codeengine.windowmanagement.decorator.Decorator;
    import net.codeengine.windowmanagement.decorator.IDecorator;
    import net.codeengine.windowmanagement.events.WindowAnimationDirectorEvent;
    import net.codeengine.windowmanagement.events.WindowAnimatorEvent;
    import net.codeengine.windowmanagement.events.WindowEvent;
    import net.codeengine.windowmanagement.events.WindowManagerEvent;
    
    import spark.components.BorderContainer;
    import spark.components.Group;
    import spark.components.Panel;
    import spark.effects.Animate;
    import spark.effects.Fade;
    import spark.effects.Move;
    import spark.effects.Resize;
    import spark.effects.animation.MotionPath;
    import spark.effects.animation.SimpleMotionPath;
    import spark.effects.easing.Sine;

    [Bindable]
    public class WindowManager extends EventDispatcher implements IWindowManager {
        /* ************************************************************ *
         * Class Properties                                             *
         * ************************************************************ */
        public static var ENABLE_DECORATIONS:Boolean=true;
        public static var ENABLE_ANIMATIONS:Boolean=true;
        
        public static var ORPHAN_TOP_THRESHOLD:Number = 5;
        public static var ORPHAN_LEFT_THRESHOLD:Number = 10;
        public static var ORPHAN_RIGHT_THRESHOLD:Number = 10;
        public static var ORPHAN_BOTTOM_THRESHOLD:Number = 10;
        private var _version:String="2.0.20";

        private var _windowHeaderHeight:Number=20;
        private var _cornerRadius:Number=5;

        private var _container:Container=null;

        private var addNewWindowsByCentering:Boolean=true;

        private var addNewWindowsInCascadingOrder:Boolean=false;

        private var allMyWindows:ArrayCollection=new ArrayCollection();

        private var snapshotsOfWindows:ArrayCollection=new ArrayCollection();

        private var windowCount:int=0;

        private var minimizedWindows:ArrayCollection=new ArrayCollection();

        private var _sheets:ArrayCollection=new ArrayCollection();

        private var _addWindowAnimation:IWindowAnimation=new WindowAppearAnimation;

        private var _closeWindowAnimation:IWindowAnimation=new WindowDisappearAnimation;

        private var _resizeWindowAnimation:IWindowAnimation=new WindowMaximizingAnimation;

        private var _focusWindowAnimation:IWindowAnimation=new WindowAlertingAnimation;

        // private var _minimizeWindowAnimation:IWindowAnimation = new WindowMinimizingAnimation;

        private var _unminimizeWindowAnimation:IWindowAnimation=new UnminimizeWindowAnimation();

        private var _openSheetAnimation:ISheetAnimation=new SheetAppearAnimation();

        private var _closeSheetAnimation:ISheetAnimation=new SheetDisappearAnimation();

        private var _decorator:IDecorator=new Decorator();

        private var isWindowAnimationInProgress:Boolean=false;


        public function get enableAnimation():Boolean {
            return ENABLE_ANIMATIONS;
        }

        public function set enableAnimation(value:Boolean):void {
            ENABLE_ANIMATIONS=value;
        }

        public function WindowManager() {
            this.addEventListener("containerChanged", onContainerChanged);
            this.addEventListeners();
        }

        public function getActiveWindow():IWindow {
            return this.getTopMostWindow();
        }

        public function getMinimizedWindows():ArrayCollection {
            return this.minimizedWindows;
        }

        public function getActiveWindows():ArrayCollection {
            return this.allMyWindows;
        }

        public function cascadeWindows():void {
            var x:int=20;
            var y:int=20;
            for each (var window:IWindow in this.allMyWindows) {
                window.x=x;
                window.y=y;
                x+=10;
                y+=10;
            }
        }

        private function addEventListeners():void {
            //Add all of the window manager system wide event listeners.
            this._closeWindowAnimation.addEventListener(WindowAnimationDirectorEvent.CLOSE_ANIMATION_COMPLETE, this.onWindowClosingAnimationComplete);
            this._closeSheetAnimation.addEventListener(SheetAnimationEvent.SHEET_CLOSING_ANIMATION_COMPLETE, onSheetClosingAnimationComplete)
            this._addWindowAnimation.addEventListener(WindowAnimationDirectorEvent.OPEN_ANIMATION_COMPLETE, onWindowOpeningAnimationComplete);
            this._unminimizeWindowAnimation.addEventListener(WindowAnimationDirectorEvent.UNMINIMIZE_ANIMATION_COMPLETE, onWindowUnminimizeAnimationComplete);
            this.addEventListener(WindowManagerEvent.DRAWER_ADDED_TO_WINDOW, onDrawerAddedToWindow);
            this.addEventListener(WindowManagerEvent.DRAWER_REMOVED_FROM_WINDOW, onDrawerRemovedFromWindow);
            this.addEventListener(WindowManagerEvent.SHEET_ADDED_TO_WINDOW, onSheetAddedToWindow);
            this.addEventListener(WindowManagerEvent.SHEET_REMOVED_FROM_WINDOW, onSheetRemovedFromWindow);
            this.addEventListener(WindowManagerEvent.WINDOW_CLOSED, onWindowClosed);
            this.addEventListener(WindowManagerEvent.WINDOW_MAXIMIZED, onWindowMaximized);
            this.addEventListener(WindowManagerEvent.WINDOW_MINIMIZED, onWindowMinimized);
            this.addEventListener(WindowManagerEvent.WINDOW_MOVED, onWindowMoved);
            this.addEventListener(WindowManagerEvent.WINDOW_RESIZED, onWindowResized);
            this.addEventListener(WindowManagerEvent.WINDOW_RESTORED, onWindowRestored);
            //Be sure to remove all the added event listeners.
        }

        private function bringSheetToFront(sheet:ISheet):void {
            if (sheet == null) {
                return;
            }
            try {
                this.container.setChildIndex(sheet as DisplayObject, this.container.getChildren().length - 1);
            } catch (e:*) {
                trace("WindowManager: bringSheetToFront: " + e);
            }
        }

        //TODO: Undocumented API	
        public function bringToFront(object:DisplayObject):void {
            try {
                this.container.setChildIndex(object, this.container.getChildren().length - 1);
            } catch (e:*) {
                trace("WindowManager: bringToFront: " + e);
            }
        }

        private function isOrphaned(window:IWindow):Boolean {
            /* Check if the window that we encoutered is actually managed by
             * this window manager. If it is not managed by this instance then it
             * is an orphan.
             */
            return !this.isWindowManaged(window);
        }

        private function manage(window:IWindow):void {
            //Don't remanage existing windows.
            if (this.allMyWindows.contains(window)) {
                return;
            }
            this.allMyWindows.addItem(window);
        }

        //TODO: PRIVATE API
        public function addNotificationWindow(notificationWindow:INotificationWindow):void {
            (notificationWindow as NotificationWindow).windowManager=this;
            this.container.addChild(notificationWindow as DisplayObject);
            (notificationWindow as DisplayObject).x=this.container.width - (notificationWindow as DisplayObject).width - 5;

            var move:Move=new Move(notificationWindow);
            move.yFrom=-1 * (notificationWindow as DisplayObject).height;
            move.yTo=0;
            move.duration=1000;
            move.easer=new spark.effects.easing.Sine();/*function(t:Number, b:Number, c:Number, d:Number):Number {
                var ts:Number=(t/=d) * t;
                var tc:Number=ts * t;
                return b + c * (33 * tc * ts + -106 * ts * ts + 126 * tc + -67 * ts + 15 * t);
            };*/
            move.play();

        }

        //TODO: Private API
        private var nw:INotificationWindow;

        public function removeNotificationWindow(notificationWindow:INotificationWindow):void {
            this.nw=notificationWindow;
            var move:Move=new Move(notificationWindow);
            move.yFrom=0
            move.yTo=-1 * (notificationWindow as DisplayObject).height;
            move.duration=500;
            move.addEventListener(EffectEvent.EFFECT_END, function(event:EffectEvent):void {
                var index:int=container.getChildIndex(nw as DisplayObject);
                container.removeChildAt(index);
                nw=null;
            });
            move.play();


        }


        public function minimizeAllWindows():void {
            for each (var window:IWindow in this.allMyWindows) {
                this.minimizeWindow(window);
            }
        }

        private function unblockAllWindows():void {
            for each (var w:IWindow in this.allMyWindows) {
                w.unblock();
            }
        }

        private function positionSheetRelativeToWindow(sheet:ISheet, window:IWindow):void {
            if (sheet == null) {
                return;
            }

            var headerHeight:Number=(window as Window).getTitlebarHeight() == undefined ? this._windowHeaderHeight : (window as Window).getTitlebarHeight();

            sheet.x=window.x + window.width / 2 - sheet.width / 2;
            sheet.y=window.y + headerHeight + 2;
        }

        private function positionDrawerRelativeToWindow(drawer:IDrawer, window:IWindow):void {
            if (drawer == null) {
                return;
            }
            var height:Number;
            var width:Number;
            var x:Number;
            var y:Number;
            var paddingBottom:Number=20;
            var paddingTop:Number=20;
            var paddingRight:Number=20;
            var paddingLeft:Number=20;
            var windowTitleBarHeight:Number=20;
            var windowOverlap:Number=10;
            switch (drawer.location) {
                case Drawer.LOCATION_RIGHT:
                    //Height is the height of the window - titlebar height - padding
                    height=window.height - windowTitleBarHeight - paddingBottom - paddingTop;
                    //Width is left up to the user to define
                    drawer.height=height;
                    x=window.x + window.width - windowOverlap;
                    y=window.y + windowTitleBarHeight + paddingTop;
                    break;
                case Drawer.LOCATION_LEFT:
                    //Height is the height of the window - titlebar height - padding
                    height=window.height - windowTitleBarHeight - paddingBottom - paddingTop;
                    //Width is left up to the user to define
                    drawer.height=height;
                    x=window.x - drawer.width + windowOverlap;
                    y=window.y + windowTitleBarHeight + paddingTop;
                    break;
                case Drawer.LOCATION_BOTTON:
                    width=window.width - paddingLeft - paddingRight;
                    drawer.width=width;
                    x=window.x + paddingLeft;
                    y=window.y + window.height - windowOverlap;
                    break;

            }
            drawer.x=x;
            drawer.y=y;
            this.bringWindowToFront(window);
            //drawer.x = window.x + window.width / 2 - drawer.width / 2;
            //drawer.y = window.y + 22;
            //trace("x:" + drawer.x + "\ty: " + drawer.y + "\tw:" + drawer.width + "\th:" + drawer.height);
        }

        private function _addWindow(window:IWindow, x:Number=-1, y:Number=-1):String {
            var windowId:String;
            this.addWindowListeners(window);

            /* try {
                 (window as Container).setStyle("borderAlpha", 0);
             } catch (e:*) {
                 trace("WindowManager:_addWindow-->Unable to set border alpha");
             }*/

            //(window as Panel).setStyle("headerHeight", this._windowHeaderHeight);
            //(window as Panel).setStyle("cornerRadius", this._cornerRadius);
            //(window as Panel).setStyle("borderColor",0xFFFFFF);

            /* Center window? */
            if (this.addNewWindowsByCentering && x == -1 && y == -1) {
                window.x=(this.container.width - window.width) / 2;
                window.y=(this.container.height - window.height) / 2;
            } else {
                window.x=x;
                window.y=y;
            }
            //trace("WindowManager: _addWindow: Window x:" + x + " y:" + y);
            if (window.windowId == "" || window.windowId == null) {
                //Every window must have a windowId so that it can be tracked
                //within the window management system.
                //Generate a windowid if none is specified.
                windowId=String(new Date().getTime() + Math.round(Math.random() * 1000));
                window.windowId=windowId;
            } else {
                windowId=window.windowId;
            }

            //Assign this instance to manage the window, if it is not already managed by us
            if (window.windowManager != this) {
                window.windowManager=this;
                    //trace("AbstractWindowManager: addWindow: managing window: " + window.windowId);
            } else {
                //trace("AbstractWindowManager: addWindow: already managing window: " + window.windowId);
            }

            /* We will only display this window provided that there is no modal window
             * currently displaying. If we find a modal window, we will draw attention to it and return.
             */
            if (this.getTopMostWindow() != null && this.getTopMostWindow().isModal) {
                trace("A Modal Window is active, cannot create new window!");
                //Draw attention to the modal window.
                this._focusWindowAnimation.play(this.getTopMostWindow().proxy);
                return windowId;
            }


            this.container.addChild((window as DisplayObject));
            this.bringWindowToFront(window);
            this.windowCount++;
            window.visible=!ENABLE_ANIMATIONS;
            return windowId;
        }


        private function addWindowListeners(window:IWindow):void {
            //Add window specific event listeners.
            window.addEventListener(WindowEvent.ON_FOCUS, onWindowFocus);
            window.addEventListener(mx.events.FlexEvent.CREATION_COMPLETE, onWindowCreationComplete);
            window.addEventListener(WindowEvent.ON_MOVE, onWindowMoved);
            window.addEventListener(WindowEvent.ON_RESIZE, onWindowResize);
        }

        private function addSheetListeners(sheet:ISheet):void {
            //Add sheet specific event listeners.
            if (sheet == null)
                return;
            sheet.addEventListener(mx.events.FlexEvent.CREATION_COMPLETE, this.onSheetCreationComplete);
            sheet.addEventListener(SheetEvent.CLOSE_SHEET, this.onCloseSheet);
            sheet.addEventListener(SheetEvent.MOUSE_MOVE, onSheetMouseMove);
        }

        private function addDrawerListeners(drawer:IDrawer):void {
            //Add drawer specific event listeners.
            drawer.addEventListener(mx.events.FlexEvent.CREATION_COMPLETE, this.onDrawerCreationComplete)
        }

        private function removeWindowListeners(window:IWindow):void {
            window.removeEventListener(WindowEvent.ON_FOCUS, onWindowFocus);
            window.removeEventListener(mx.events.FlexEvent.CREATION_COMPLETE, onWindowCreationComplete);
            window.removeEventListener(WindowEvent.ON_MOVE, onWindowMoved);
            window.removeEventListener(WindowEvent.ON_RESIZE, onWindowResize);
        }

        private function removeSheetListeners(sheet:ISheet):void {
            sheet.removeEventListener(SheetEvent.MOUSE_MOVE, onSheetMouseMove);
        }

        private function removeDrawerListeners(drawer:IDrawer):void {

        }



        public function get version():String {
            return this._version;
        }

        /**
         * This method should be used in favour of add.
         *
         * <p>This is the main entry point for a window object into the
         * WindowManager system.</p>
         *
         * @param window IWindow object to be managed by the WindowManagement Subsystem.
         * @param enableAnimation Choose if the added window should allow animation effects to itself. Default value is true.
         * @param x Explicitly set the x position of the window. -1 to ignore.
         * @param y Explicitly set the y position of the window. -1 to ignore.
         *
         * @return String containing the windowId.
         *
         */
        public function addWindow(window:IWindow, x:Number=-1, y:Number=-1):String {
            return this._addWindow(window, x, y);
        }

        public function get decorator():IDecorator {
            return this._decorator;
        }

        internal function addDrawer(drawer:IDrawer, window:IWindow):void {
            drawer.windowManager=this;
            this.addChild(drawer as DisplayObject);
            this.positionDrawerRelativeToWindow(drawer, window);

            this.addDrawerListeners(drawer);


            var event:WindowManagerEvent=new WindowManagerEvent(WindowManagerEvent.DRAWER_ADDED_TO_WINDOW);
            event.window=window;
            dispatchEvent(event);

        }

        internal function removeDrawer(drawer:IDrawer, window:IWindow):void {
            this.removeDrawerListeners(drawer);
            /* Don't play the drawer closing animation if the window is currently closing */
            if (window.isClosing) {
                this.removeChild(drawer as DisplayObject);
            } else {
                var animation:IDrawerAnimation=new CloseDrawerAnimation();
                animation.play(drawer.proxy);
            }

            var event:WindowManagerEvent=new WindowManagerEvent(WindowManagerEvent.DRAWER_REMOVED_FROM_WINDOW);
            event.window=window;
            dispatchEvent(event);
        }

        /**
         * Bring the specified window to the top of the window stack.
         *
         * @param window IWindow object to be brought to the forefront.
         */
        public function bringWindowToFront(window:IWindow):void {
            //Don't bring this window to the front if it has a context menu active...
            //NOTE: Use of undocumented API
            try {
                if ((window as Window).isContextMenuActive) {
                    return;
                }
            } catch (e:*) {
                return;
            }

            //Remove all existing context menus for any windows...
            for each (var tmp_window:Window in this.allMyWindows) {
                tmp_window.removeActiveContextMenu();
            }



            if (window == null) {
                return;
            }

            if (this.getTopMostWindow().isModal) {
                return;
            }
            /*if (window.hasFocus) {
               return;
             }*/
            for each (var w:IWindow in this.allMyWindows) {
                w.hasFocus=false;
                if (w.windowId != window.windowId) {
                    this._decorator.decorate(new BackgroundDecoration(), w as DisplayObject);
                }
            }
            try {
                if (window.isDrawerActive) {
                    //Bring the window drawer to the top of the stack.
                    this.container.setChildIndex(window.drawer as DisplayObject, this.container.getChildren().length - 1);
                }
                if (window.isSheetActive) {
                    //Bring the window sheet to the top of the window stack.
                    this.container.setChildIndex(window.sheet as DisplayObject, this.container.getChildren().length - 1);
                }

                //Bring the actual window to the top of the window stack.
                this.container.setChildIndex(window as DisplayObject, this.container.getChildren().length - 1);
            } catch (e:*) {
                trace("WindowManager: bringToFront: There was a problem bringing the window to the top of the window stack -->" + e);
            }
            window.hasFocus=true;
            //trace("WindowManager: bringToFront: " + window.windowId + " to the front.");
        }

        /**
         * Get the container object that this window manager is operating on.
         * @return The container object that this window manager object is operating on.
         */
        public function get container():Container {
            return this._container;
        }

        public function set container(value:Container):void {
            this._container=value;
            //Generate a property change event
            dispatchEvent(new Event("containerChanged"));
        }

        /**
         *  Adds a child DisplayObject to this Container.
         *  The child is added after other existing children,
         *  so that the first child added has index 0,
         *  the next has index 1, an so on.
         *
         *  <p><b>Note: </b>While the <code>child</code> argument to the method
         *  is specified as of type DisplayObject, the argument must implement
         *  the IUIComponent interface to be added as a child of a container.
         *  All Flex components implement this interface.</p>
         *
         *  <p>Children are layered from back to front.
         *  In other words, if children overlap, the one with index 0
         *  is farthest to the back, and the one with index
         *  <code>numChildren - 1</code> is frontmost.
         *  This means the newly added children are layered
         *  in front of existing children.</p>
         *
         *  @param child The DisplayObject to add as a child of this Container.
         *  It must implement the IUIComponent interface.
         *
         *  @return The added child as an object of type DisplayObject.
         *  You typically cast the return value to UIComponent,
         *  or to the type of the added component.
         *
         *  @see mx.core.IUIComponent
         *
         *  @tiptext Adds a child object to this container.
         */
        public function addChild(child:DisplayObject):void {
            if (child == null)
                return;
            this.container.addChild(child);
        }

        /**
         *  A container typically contains child components, which can be enumerated
         *  using the <code>Container.getChildAt()</code> method and
         *  <code>Container.numChildren</code> property.  In addition, the container
         *  may contain style elements and skins, such as the border and background.
         *  Flash Player and AIR do not draw any distinction between child components
         *  and skins.  They are all accessible using the player's
         *  <code>getChildAt()</code> method  and
         *  <code>numChildren</code> property.
         *  However, the Container class overrides the <code>getChildAt()</code> method
         *  and <code>numChildren</code> property (and several other methods)
         *  to create the illusion that
         *  the container's children are the only child components.
         *
         *  <p>If you need to access all of the children of the container (both the
         *  content children and the skins), then use the methods and properties
         *  on the <code>rawChildren</code> property instead of the regular Container methods.
         *  For example, use the <code>Container.rawChildren.getChildAt())</code> method.
         *  However, if a container creates a ContentPane Sprite object for its children,
         *  the <code>rawChildren</code> property value only counts the ContentPane, not the
         *  container's children.
         *  It is not always possible to determine when a container will have a ContentPane.</p>
         *
         *  <p><b>Note:</b>If you call the <code>addChild</code> or
         *  <code>addChildAt</code>method of the <code>rawChildren</code> object,
         *  set <code>tabEnabled = false</code> on the component that you have added.
         *  Doing so prevents users from tabbing to the visual-only component
         *  that you have added.</p>
         */
        public function containerAddToRawChildren(child:*):void {
            this.container.rawChildren.addChild(child);
        }

        /**
         *  Removes a child DisplayObject from the child list of this Container.
         *  The removed child will have its <code>parent</code>
         *  property set to null.
         *  The child will still exist unless explicitly destroyed.
         *  If you add it to another container,
         *  it will retain its last known state.
         *
         *  @param child The DisplayObject to remove.
         *
         *  @return The removed child as an object of type DisplayObject.
         *  You typically cast the return value to UIComponent,
         *  or to the type of the removed component.
         */
        public function removeChild(child:DisplayObject):void {
            try {
                this.container.removeChild(child);
            } catch (e:*) {
                trace(e);
            }
        }

        /**
         *  Gets the <i>n</i>th child component object.
         *
         *  <p>The children returned from this method include children that are
         *  declared in MXML and children that are added using the
         *  <code>addChild()</code> or <code>addChildAt()</code> method.</p>
         *
         *  @param childIndex Number from 0 to (numChildren - 1).
         *
         *  @return Reference to the child as an object of type DisplayObject.
         *  You typically cast the return value to UIComponent,
         *  or to the type of a specific Flex control, such as ComboBox or TextArea.
         */
        public function getChildAtIndex(index:int):DisplayObject {
            return this.container.getChildAt(index);
        }

        /**
         *  Number that specifies the height of the component, in pixels,
         *  in the parent's coordinates.
         *  The default value is 0, but this property will contain the actual component
         *  height after Flex completes sizing the components in your application.
         *
         *  <p>Note: You can specify a percentage value in the MXML
         *  <code>height</code> attribute, such as <code>height="100%"</code>,
         *  but you cannot use a percentage value for the <code>height</code>
         *  property in ActionScript;
         *  use the <code>percentHeight</code> property instead.</p>
         *
         *  <p>Setting this property causes a <code>resize</code> event to be dispatched.
         *  See the <code>resize</code> event for details on when
         *  this event is dispatched.
         *  If the component's <code>scaleY</code> property is not 100,
         *  the height of the component from its internal coordinates
         *  will not match.
         *  Thus a 100 pixel high component with a <code>scaleY</code>
         *  of 200 will take 100 pixels in the parent, but will
         *  internally think it is 50 pixels high.</p>
         */
        public function height():Number {
            return this.container.height;
        }

        /**
         *  Gets the zero-based index of a specific child.
         *
         *  <p>The first child of the container (i.e.: the first child tag
         *  that appears in the MXML declaration) has an index of 0,
         *  the second child has an index of 1, and so on.
         *  The indexes of a container's children determine
         *  the order in which they get laid out.
         *  For example, in a VBox the child with index 0 is at the top,
         *  the child with index 1 is below it, etc.</p>
         *
         *  <p>If you add a child by calling the <code>addChild()</code> method,
         *  the new child's index is equal to the largest index among existing
         *  children plus one.
         *  You can insert a child at a specified index by using the
         *  <code>addChildAt()</code> method; in that case the indices of the
         *  child previously at that index, and the children at higher indices,
         *  all have their index increased by 1 so that all indices fall in the
         *  range from 0 to <code>(numChildren - 1)</code>.</p>
         *
         *  <p>If you remove a child by calling <code>removeChild()</code>
         *  or <code>removeChildAt()</code> method, then the indices of the
         *  remaining children are adjusted so that all indices fall in the
         *  range from 0 to <code>(numChildren - 1)</code>.</p>
         *
         *  <p>If <code>myView.getChildIndex(myChild)</code> returns 5,
         *  then <code>myView.getChildAt(5)</code> returns myChild.</p>
         *
         *  <p>The index of a child may be changed by calling the
         *  <code>setChildIndex()</code> method.</p>
         *
         *  @param child Reference to child whose index to get.
         *
         *  @return Number between 0 and (numChildren - 1).
         */
        public function getChildIndex(child:DisplayObject):Number {
            var index:int=-1;
            try {
                this.container.getChildIndex(child);
            } catch (e:*) {
                trace("containerIndexForChild threw error: " + e);
            }
            return index;
        }

        /**
         *  Number that specifies the width of the component, in pixels,
         *  in the parent's coordinates.
         *  The default value is 0, but this property will contain the actual component
         *  width after Flex completes sizing the components in your application.
         *
         *  <p>Note: You can specify a percentage value in the MXML
         *  <code>width</code> attribute, such as <code>width="100%"</code>,
         *  but you cannot use a percentage value in the <code>width</code>
         *  property in ActionScript.
         *  Use the <code>percentWidth</code> property instead.</p>
         *
         *  <p>Setting this property causes a <code>resize</code> event to
         *  be dispatched.
         *  See the <code>resize</code> event for details on when
         *  this event is dispatched.
         *  If the component's <code>scaleX</code> property is not 1.0,
         *  the width of the component from its internal coordinates
         *  will not match.
         *  Thus a 100 pixel wide component with a <code>scaleX</code>
         *  of 2 will take 100 pixels in the parent, but will
         *  internally think it is 50 pixels wide.</p>
         */
        public function width():Number {
            return this.container.width;
        }

        /**
         *  Number that specifies the component's horizontal position,
         *  in pixels, within its parent container.
         *
         *  <p>Setting this property directly or calling <code>move()</code>
         *  will have no effect -- or only a temporary effect -- if the
         *  component is parented by a layout container such as HBox, Grid,
         *  or Form, because the layout calculations of those containers
         *  set the <code>x</code> position to the results of the calculation.
         *  However, the <code>x</code> property must almost always be set
         *  when the parent is a Canvas or other absolute-positioning
         *  container because the default value is 0.</p>
         *
         *  @default 0
         */
        public function x():Number {
            return this.container.x;
        }

        /**
         *  Number that specifies the component's vertical position,
         *  in pixels, within its parent container.
         *
         *  <p>Setting this property directly or calling <code>move()</code>
         *  will have no effect -- or only a temporary effect -- if the
         *  component is parented by a layout container such as HBox, Grid,
         *  or Form, because the layout calculations of those containers
         *  set the <code>x</code> position to the results of the calculation.
         *  However, the <code>x</code> property must almost always be set
         *  when the parent is a Canvas or other absolute-positioning
         *  container because the default value is 0.</p>
         *
         *  @default 0
         */
        public function y():Number {
            return this.container.y;
        }

        /**
         * Request the title of a window object matchng the given windowId.
         *
         * @param windowId A String representing the id of a unique window.
         * @return The title (if set) of a given window.
         */
        public function getWindowTitle(windowId:String):String {
            return this.getWindowById(windowId).title;
        }


        /**
         * Checks whether or not the specified window is managed by this window manager.
         *
         * @param window A window object.
         * @return true if the specified window is managed by this window manager.
         */
        public function isWindowManaged(window:IWindow):Boolean {
            return this.getWindowById(window.windowId) != null
        }


        public function maximizeWindow(window:IWindow):void {
            var maximizeAnimation:IWindowAnimation=new WindowMaximizingAnimation();
            maximizeAnimation.play(window.proxy);
        }

        /**
         * Minimizes the specified window object.
         *
         * @param window IWindow object to be managed by the WindowManagement Subsystem.
         */
        public function minimizeWindow(window:IWindow):void {
            var _minimizeWindowAnimation:IWindowAnimation=new WindowMinimizingAnimation()
            _minimizeWindowAnimation.play(window.proxy);
            _minimizeWindowAnimation.addEventListener(WindowAnimationDirectorEvent.MINIMIZE_ANIMATION_COMPLETE, this.onWindowMinimizingAnimationComplete);
            _minimizeWindowAnimation.addEventListener(WindowAnimationDirectorEvent.MINIMIZED_WINDOW_CLICK, onMinimizedWindowClick);

            var event:WindowManagerEvent=new WindowManagerEvent(WindowManagerEvent.WINDOW_MINIMIZED);
            event.window=window;
            dispatchEvent(event);
        }

        /**
         * Remove the specified window from the window manager.
         *
         * @param window A Window object.
         * @param animate Specify if the window should be removed with animation.
         */
        public function removeWindow(window:IWindow):void {
            /* Adopt if orphaned*/
            if (this.isOrphaned(window))
                this.manage(window);
            var tmw:IWindow=this.getTopMostWindow();
            if (tmw.isModal && tmw.windowId != window.windowId)
                return;
            if (tmw.isModal && tmw.windowId == window.windowId) {
                this.unblockAllWindows();
            }

            //Play the window closing animation.
            if (ENABLE_ANIMATIONS) {
                var zo:WindowDisappearAnimation=new WindowDisappearAnimation();
                this._closeWindowAnimation.play(window.proxy);
            }

            //Remove window Listeners
            this.removeWindowListeners(window);

            //Remove the window from our stack.
            var indexOfItemToRemove:int=this.allMyWindows.getItemIndex(window);
            this.allMyWindows.removeItemAt(indexOfItemToRemove);

            //Remove the window from the container.
            this.container.removeChild(window as DisplayObject)

            var event:WindowManagerEvent=new WindowManagerEvent(WindowManagerEvent.WINDOW_CLOSED);
            dispatchEvent(event);

        }

        /**
         * Send the specified window to the top of the window stack.
         *
         * @param windowId The window id that you want to remove from the window manager.
         */
        public function sendWindowToFront(windowId:String):void {
            this.bringWindowToFront(this.getWindowById(windowId));
        }

        /**
         * Get the window that is currently at the top of the window stack.
         *
         * @return A window object representing the top most window on the display stack.
         */
        public function getTopMostWindow():IWindow {
            var totalChildren:int=this.container.getChildren().length;
            var index:int=totalChildren - 1;
            var object:Object;

            for (index; index >= 0; index--) {
                object=this.container.getChildAt(index);
                if (object is IWindow)
                    break;
                else
                    object=null;
            }
            return IWindow(object);
        }

        //TODO: Implement
        public function restoreWindow(window:IWindow):void {
            //This method should restore a window to its pre-maximized state.
            trace("WindowManager: unmaximize: Not Implemented");
        }

        //TODO: Implement
        public function verifyWindowPosition(window:IWindow):void {
            //This method should validate whether or not a window is currently
            //positioned safely within the container.
            trace("WindowManager: verifyWindowPosition: Not Implemented");
        }


        /**
         * Get a window from the window manager stack based on its window id.
         *
         * @return An existing window object or null if no window matches the specified window id.
         */
        public function getWindowById(forWindowId:String):IWindow {
            var window:IWindow=null;
            for each (window in this.allMyWindows) {
                if (window.windowId == forWindowId)
                    break;
            }
            return window;
        }

        /**
         * Remove the specified sheet from the specified window.
         *
         * @param sheet The sheet that you want to remove from the window.
         * @param window The window that you want to remove the sheet from.
         */
        public function removeSheet(sheet:ISheet, window:IWindow):void {
            var index:int=this._sheets.getItemIndex(sheet);
            if (index != -1) {
                this._sheets.removeItemAt(index);
            }
            //(window as Panel).enabled=true;
            (sheet as DisplayObject).visible=false;
            var animation:SheetDisappearAnimation=new SheetDisappearAnimation();
            animation.play(sheet.proxy);
            window.isSheetActive=false;
            this.removeSheetListeners(sheet);
            window.sheet=null;

            var event:WindowManagerEvent=new WindowManagerEvent(WindowManagerEvent.SHEET_REMOVED_FROM_WINDOW);
            event.window=window;
            dispatchEvent(event);
            window.unblock();
        }


        /**
         * Add the specified sheet to the specified window.
         *
         * @param sheet The sheet that you want to add to the window.
         * @param window The window that you want to add the sheet to.
         */
        public function addSheet(sheet:ISheet, window:IWindow):void {
            if (sheet == null)
                return;
            this.addSheetListeners(sheet);
            this._sheets.addItem(sheet);
            this.addChild(sheet as DisplayObject);
            this.positionSheetRelativeToWindow(sheet, window);

            sheet.windowManager=this;
            sheet.window=window;
            (sheet as DisplayObject).visible=false;
            //(window as Panel).enabled=false;
            window.block();
            window.isSheetActive=true;
            window.sheet=sheet;

            var event:WindowManagerEvent=new WindowManagerEvent(WindowManagerEvent.SHEET_ADDED_TO_WINDOW);
            event.window=window;
            dispatchEvent(event);
        }


        /* ************************************************************ *
         * Event Handlers                                               *
         * ************************************************************ */
        private function onSheetClosingAnimationComplete(event:SheetAnimationEvent):void {
            this.removeChild(event.sheet as DisplayObject);
        }

        private function onContainerChanged(event:Event):void {
            this.container.addEventListener(ResizeEvent.RESIZE, onContainerResize);
            this.container.horizontalScrollPolicy="off";
            this.container.verticalScrollPolicy="off";

            this.addEventListener(WindowAnimatorEvent.kDidFinishPlayingWindowAppearAnimation, this.onDidFinishPlayingWindowAppearAnimation);
            this.addEventListener(WindowAnimatorEvent.kDidFinishPlayingWindowClosingAnimation, this.onDidFinishPlayingWindowClosingAnimation);

            this.container.systemManager.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }

        private function onDidFinishPlayingWindowAppearAnimation(event:WindowAnimatorEvent):void {
            //Clean up.
            event.image.visible=false;
            this.container.removeChild(event.image);
            this.getWindowById(event.windowId).visible=true;
            //Move the window to the top of the window stack.
            this.bringWindowToFront(this.getWindowById(event.windowId));
            var e:WindowAnimatorEvent=new WindowAnimatorEvent(WindowAnimatorEvent.kDidFinishPlayingWindowAppearAnimation);
            this.getWindowById(event.windowId).dispatchEvent(e);
            (this.getWindowById(event.windowId) as IWindow).refresh();
        }

        private function onDidFinishPlayingWindowClosingAnimation(event:WindowAnimatorEvent):void {
            //Clean up.
            this.container.removeChild(event.image);
        }



        private function onWindowCreationComplete(event:Event):void {
            var window:IWindow=IWindow(event.currentTarget);
            window.visible=false;
            window.dispatchEvent(new WindowEvent(WindowEvent.ON_WINDOW_CREATION_COMPLETE));
            window.visible=true;
            this.manage(window);
            var dontAnimate:Boolean=!ENABLE_ANIMATIONS;
            if (dontAnimate || isWindowAnimationInProgress) {
                if (window.isModal) {
                    bringWindowToFront(window);
                    for each (var otherWindow:IWindow in this.allMyWindows) {
                        if (window.windowId != otherWindow.windowId) {
                            otherWindow.block();
                        }
                    }
                } else {
                    //Force the window to the front
                    var count:int=0;
                    while (getTopMostWindow().windowId != window.windowId) {
                        bringWindowToFront(window);
                        count++;
                    }
                    trace("WindowManager->onWindowCreationComplete-> It took " + count + " attempts to bring the window to the front");
                }
            } else {
                this.isWindowAnimationInProgress=true;
                window.visible=false;
                this._addWindowAnimation.play(window.proxy);
            }


        }

        private function onSheetCreationComplete(event:Event):void {
            var sheet:ISheet=ISheet(event.currentTarget);
            this.decorator.decorate(new SheetDecoration(), sheet as DisplayObject);
            var animation:ISheetAnimation=new SheetAppearAnimation();
            animation.addEventListener(WindowAnimationDirectorEvent.OPEN_ANIMATION_COMPLETE, onSheetOpeningAnimationComplete);
            animation.play(sheet.proxy);
        }

        private function onSheetOpeningAnimationComplete(event:WindowAnimationDirectorEvent):void {
            //Cleanup
        }

        private function onWindowOpeningAnimationComplete(event:WindowAnimationDirectorEvent):void {
            this.isWindowAnimationInProgress=false;
            //Move the window to the top of the window stack
            event.windowProxy.window.visible=true;
            event.windowProxy.window.refresh();
            if (event.windowProxy.window.isModal) {
                for each (var window:IWindow in this.allMyWindows) {
                    if (window.windowId != (event.windowProxy.window.windowId)) {
                        window.block();
                    }
                }
                /* Be sure to bring the modal window into focus */
            }
            try {
                this.bringWindowToFront(event.windowProxy.window);
            } catch (e:*) {
                trace(e);
            }
        }

        private function onWindowMinimizingAnimationComplete(event:WindowAnimationDirectorEvent):void {
            /* Add the window the minimized window collection */
            this.minimizedWindows.addItem(event.windowProxy);
            /* Layout the minimized windows */
            var lo:LayoutMinimizedWindows=new LayoutMinimizedWindows();
            lo.play(this.minimizedWindows);
        }

        private function onWindowClosingAnimationComplete(event:WindowAnimationDirectorEvent):void {
            /* Check if the window is modal, if it is, make sure to unblock all windows */
            if (event.windowProxy.window.isModal) {
                for each (var window:IWindow in this.allMyWindows) {
                    window.unblock();
                }
            }
            this.container.removeChild((event.windowProxy.window as DisplayObject));
        }

        private function onWindowFocus(event:WindowEvent):void {
            //Set all the windows to background window style.
            //Check if the current window at the top of the stack is modal, and ignore
            //any attempts to focus it.
            for each (var window:IWindow in this.allMyWindows) {
                if (event.window.windowId != window.windowId) {
                    this._decorator.decorate(new BackgroundDecoration(), window as DisplayObject);
                }
            }
            this._decorator.decorate(new ForegroundDecoration(), event.window as DisplayObject);
            try {
                this.bringWindowToFront(event.currentTarget as IWindow);
                if (event.window.isSheetActive) {
                    this.bringSheetToFront(event.window.sheet);
                }
                if (this.getTopMostWindow().isModal && this.getTopMostWindow().windowId != event.currentTarget.windowId) {
                    this.bringWindowToFront(event.currentTarget as IWindow);
                    var alert:IWindowAnimation=new WindowAlertingAnimation();
                    alert.play(this.getTopMostWindow().proxy);
                    return;
                }
            } catch (e:*) {
                trace("AbstractWindowManager: onWindowFocus: " + e);
            }
        }

        private function onMinimizedWindowClick(event:WindowAnimationDirectorEvent):void {
            var proxy:IWindowProxy=event.windowProxy;
            this._unminimizeWindowAnimation.play(proxy);
        }

        private function onWindowUnminimizeAnimationComplete(event:WindowAnimationDirectorEvent):void {
            var index:int=this.minimizedWindows.getItemIndex(event.windowProxy);

            if (index > -1) {
                this.minimizedWindows.removeItemAt(index);
            }
            this.removeChild(event.windowProxy.image);
            event.windowProxy.window.visible=true;
            this.bringWindowToFront(event.windowProxy.window);
        }

        private function onCloseSheet(event:SheetEvent):void {
            this.removeSheet(event.sheet, event.sheet.window);
        }

        
        private function onWindowMoved(event:WindowEvent):void {
            //Track window to make sure the sheet follows it.
            if (event.window.isSheetActive) {
                this.positionSheetRelativeToWindow(event.window.sheet, event.window);
            }
            //Track window to make sure the drawer follows it.
            if (event.window.isDrawerActive) {
                this.positionDrawerRelativeToWindow(event.window.drawer, event.window);
            }
            this.bringSheetToFront(event.window.sheet);

            trace("Window Overlapping? " + this.isWindowOverlapping(event.window));
            if (
                (event.window.x < this.container.x - ORPHAN_LEFT_THRESHOLD || event.window.x > this.container.width - ORPHAN_RIGHT_THRESHOLD) ||
                (event.window.y < this.container.y - ORPHAN_TOP_THRESHOLD || event.window.y > this.container.height - ORPHAN_BOTTOM_THRESHOLD)){
                var we:WindowEvent = new WindowEvent(WindowEvent.HALT_DRAGGING);
                we.window = event.window;
                event.window.dispatchEvent(we);
            }
        }


        private var exposeProxys:ArrayCollection=new ArrayCollection();

        public function expose():void {
            var MAX_AVAILABLE_WIDTH:int=this.container.width;
            var MAX_AVAILABLE_HEIGHT:int=this.container.height;
            var TOTAL_WINDOWS:int=this.allMyWindows.length;
            var horizontalPadding:Number=20;

            MAX_AVAILABLE_WIDTH=(MAX_AVAILABLE_WIDTH - (TOTAL_WINDOWS + 1) * horizontalPadding);

            var sumOfWindowWidths:Number=0;
            var optimalWindowWidth:Number=this.container.width;
            var optimalWindowHeight:Number=this.container.height;


            for each (var window:IWindow in this.allMyWindows) {
                sumOfWindowWidths+=window.width;
                trace("Sum of Window Widths: " + sumOfWindowWidths);
                if (sumOfWindowWidths > MAX_AVAILABLE_WIDTH) {
                    //Need to work out the optimal width for each window...
                    optimalWindowWidth=MAX_AVAILABLE_WIDTH / TOTAL_WINDOWS;
                    optimalWindowHeight=MAX_AVAILABLE_HEIGHT / TOTAL_WINDOWS;
                }
            }

            var sumOfScaledWindowWidths:Number=0;
            for each (window in this.allMyWindows) {
                if (window.width > optimalWindowWidth) {
                    var ratio:Number=window.width / optimalWindowWidth;
                    sumOfScaledWindowWidths+=(window as DisplayObject).width / ratio;
                }
            }

            var startingXPosition:Number=(this.container.width - sumOfScaledWindowWidths - ((TOTAL_WINDOWS - 1) * horizontalPadding)) / 2;
            var startingYPosition:Number=(this.container.height - optimalWindowHeight) / 2;

            for each (window in this.allMyWindows) {
                if (window.width > optimalWindowWidth) {
                    //Scale down this window
                    var tmpWidth:Number;
                    var tmpHeight:Number;
                    ratio=window.width / optimalWindowWidth;
                    //var tmpScaleX:Number = (window as DisplayObject).scaleX / ratio;
                    //var tmpScaleY:Number = (window as DisplayObject).scaleY / ratio;
                    var proxy:IWindowProxy=window.proxy;
                    var image:Image=proxy.image;
                    image.id=window.windowId;
                    this.exposeProxys.addItem(proxy);

                    this.addChild(image);


                    var p:Parallel=new Parallel(image);
                    var resize:Resize=new Resize(image);
                    var move:Move=new Move(image);

                    resize.heightFrom=(window as DisplayObject).height;
                    resize.heightTo=(window as DisplayObject).height / ratio;
                    resize.widthFrom=(window as DisplayObject).width;
                    resize.widthTo=(window as DisplayObject).width / ratio;
                    resize.duration=500;

                    move.xFrom=(window as DisplayObject).x;
                    move.xTo=startingXPosition;
                    move.yFrom=(window as DisplayObject).y;
                    move.yTo=startingYPosition;

                    startingXPosition+=(window as DisplayObject).width / ratio;
                    startingXPosition+=horizontalPadding;

                    p.addChild(move);
                    p.addChild(resize);
                    p.play();

                    window.visible=false;

                    image.addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent):void {
                        var d:Decorator=new Decorator();
                        d.decorate(new ForegroundDecoration(), event.currentTarget as DisplayObject);
                    });

                    image.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):void {
                        var d:Decorator=new Decorator();
                        d.decorate(new BackgroundDecoration(), event.currentTarget as DisplayObject);
                    });


                    image.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
                        //Clean up, remove all exposé windows
                        for each (var proxy:WindowProxy in exposeProxys) {
                            proxy.window.visible=true;
                            container.removeChildAt(container.getChildIndex(proxy.image));
                            var fade:Fade=new Fade(proxy.window);
                            fade.alphaFrom=0.5;
                            fade.alphaTo=1;
                            fade.duration=500;
                            fade.play();
                        }
                        var id:String=event.currentTarget.id;
                        var window:IWindow=getWindowById(id);
                        bringWindowToFront(window);
                        exposeProxys.removeAll();
                    });
                }
            }
        }

        private function isWindowOverlapping(window:IWindow):Boolean {
            trace("Checking to see if the window is overlapping any other window");
            var result:Boolean=false;
            //If any one of the following conditions is met, the window is not overlapping
            for each (var otherWindow:IWindow in this.allMyWindows) {
                if (window != otherWindow) {
                    var a:Boolean=window.x > otherWindow.x + otherWindow.width;
                    var b:Boolean=window.x + window.width < otherWindow.x;
                    var c:Boolean=window.y > otherWindow.y + otherWindow.height;
                    var d:Boolean=window.y + window.height < otherWindow.y;
                    result=!(a || b || c || d);
                    if (result) {
                        break;
                    }
                }
            }
            trace("Overlapping: " + result);
            return result;
        }

        private function onSheetMouseMove(event:SheetEvent):void {
            //Make sure that the sheet is displayed correctly, in case the window has somehow moved
            //without the sheet having been able to track it.
            this.positionSheetRelativeToWindow(event.sheet, event.sheet.window);
        }

        private function onContainerResize(event:ResizeEvent):void {
            //TODO: Implement
            trace("WindowManager::onContainerResize::Not Implemented");
        }

        private function onWindowResize(event:WindowEvent):void {
            //TODO: Broken?
            if (event.window.isDrawerActive) {
                this.positionDrawerRelativeToWindow(event.window.drawer, event.window);
            }
        }

        private function onDrawerCreationComplete(event:Event):void {
            //trace("AbstractWindowManager: onDrawerCreationComplete");
            var drawer:IDrawer=IDrawer(event.currentTarget);
            this.decorator.decorate(new DrawerDecoration(), drawer as DisplayObject);
            var animation:IDrawerAnimation=new OpenDrawerAnimation();
            this.bringToFront(drawer.window as DisplayObject);
            //animation.addEventListener(WindowAnimationDirectorEvent.OPEN_ANIMATION_COMPLETE, onSheetOpeningAnimationComplete);
            animation.play(drawer.proxy);
        }

        private function onDrawerAddedToWindow(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("WindowManager::onDrawerAddedToWindow::Not Implemented");
        }

        private function onDrawerRemovedFromWindow(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("WindowManager::onDrawerRemovedFromWindow::Not Implemented");
        }

        private function onSheetAddedToWindow(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("WindowManager::onSheetAddedToWindow::Not Implemented");
        }

        private function onSheetRemovedFromWindow(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("WindowManager::onSheetRemovedFromWindow::Not Implemented");
        }

        private function onWindowClosed(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("Not onWindowClosed");
        }

        private function onWindowMaximized(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("WindowManager::onWindowMaximized::Not Implemented");
        }

        private function onWindowMinimized(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("WindowManager::onWindowMinimized::Not Implemented");
        }

        private function onWindowResized(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("WindowManager::onWindowResized::Not Implemented");
        }

        private function onWindowRestored(event:WindowManagerEvent):void {
            //TODO: Implement
            trace("WindowManager::onWindowRestored::Not Implemented");
        }

        public function onKeyUp(event:KeyboardEvent):void {
            trace(event.charCode);
            if (event.charCode == 27) {
                if (this.getTopMostWindow().isSheetActive) {
                    this.getTopMostWindow().removeSheet(this.getTopMostWindow().sheet);
                } else {
                    this.getTopMostWindow().close();
                }
            }
        }

    }
}


