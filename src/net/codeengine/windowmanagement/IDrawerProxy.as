package net.codeengine.windowmanagement {
    import mx.controls.Image;
    
    
    public interface IDrawerProxy {
        function get image():Image;
        function set image(value:Image):void;
        function get drawer():IDrawer
        function set drawer(value:IDrawer):void;
    }
}