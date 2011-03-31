package net.codeengine.windowmanagement {
    import mx.controls.Image;
    
    
    public interface ISheetProxy {
        function get image():Image;
        function set image(value:Image):void;
        function get sheet():ISheet
        function set sheet(value:ISheet):void;
    }
}