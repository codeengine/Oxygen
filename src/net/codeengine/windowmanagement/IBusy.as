package net.codeengine.windowmanagement {
    import flash.events.IEventDispatcher;

    public interface IBusy extends IEventDispatcher {
        function get window():IWindow;
        function set window(window:IWindow):void;
        function get message():String;
        function set message(value:String):void;
		
		function activate(target:*):void;
		function deactivate():void;
    }
}