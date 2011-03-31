package net.codeengine.windowmanagement
{
    import mx.controls.Image;
    
    public interface IWindowProxy
    {
        function get image():Image;
        function set image(value:Image):void;
        function get window():IWindow
        function set window(value: IWindow):void;
    }
}