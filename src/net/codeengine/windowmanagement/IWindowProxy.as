package net.codeengine.windowmanagement
{
	import spark.components.Image;
    
    public interface IWindowProxy
    {
        function get image():Image;
        function set image(value:Image):void;
        function get window():IWindow
        function set window(value: IWindow):void;
    }
}