package net.codeengine.windowmanagement {
    import flash.events.IEventDispatcher;
    
    
    public interface IWindow extends IEventDispatcher {
        function close():void;
        function get isModal():Boolean;
        function set isModal(value:Boolean):void;
        function get windowId():String;
        function set windowId(value:String):void;
        function get visible():Boolean;
        function set visible(value:Boolean):void;
        function get title():String;
        function set title(value:String):void;
        function get windowManager():IWindowManager;
        function set windowManager(value:IWindowManager):void;
        function get filters():Array;
        function set filters(value:Array):void;
        function get x():Number;
        function set x(value:Number):void;
        function get y():Number;
        function set y(value:Number):void;
        function get width():Number;
        function set width(value:Number):void;
        function get height():Number;
        function set height(value:Number):void;
        function get hasFocus():Boolean;
        function set hasFocus(value:Boolean):void;
        function get currentWindowState():int;
        function set currentWindowState(value:int):void;
        function get proxy():IWindowProxy
        function get sheet():ISheet;
        function set sheet(value:ISheet):void;
        function get drawer():IDrawer;
        function set drawer(value:IDrawer):void;
        function addSheet(sheet:ISheet):void;
        function removeSheet(sheet:ISheet):void;
        function addDrawer(drawer:IDrawer):void;
        function removeDrawer(drawer:IDrawer):void;
        function refresh():void;
        function showBusyIndicator():void;
        function removeBusyIndicator():void;
        function get showCloseButton():Boolean;
        function set showCloseButton(value:Boolean):void;
        function get showMaximizeButton():Boolean;
        function set showMaximizeButton(value:Boolean):void;
        function get showMinimizeButton():Boolean;
        function set showMinimizeButton(value:Boolean):void;
        function get showResizeHandle():Boolean;
        function set showResizeHandle(value:Boolean):void;
        // function get isDisplayingDialogWindow():Boolean;
        //function set isDisplayingDialogWindow(value:Boolean);
        
        function block():void;
        function unblock():void;
        
        function get isSheetActive():Boolean;
        function set isSheetActive(value:Boolean):void;
        
        function get isDrawerActive():Boolean;
        function set isDrawerActive(value:Boolean):void;
        
        function get isClosing():Boolean;
        function set isClosing(value:Boolean):void;
        
        function get busyIndicator():IBusy;
        function set busyIndicator(indicator:IBusy):void;
        
        function toggleBusyIndicator():void;
    }
}