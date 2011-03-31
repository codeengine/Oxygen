package net.codeengine.windowmanagement {
    import mx.controls.Image;
    
    
    public class SheetProxy implements ISheetProxy {
        private var _image:Image = new Image();
        
        private var _sheet:ISheet;
        
        public function SheetProxy() {
        }
        
        public function get image():Image {
            return this._image;
        }
        
        public function set image(value:Image):void {
            this._image = value;
        }
        
        public function get sheet():ISheet {
            return this._sheet;
        }
        
        public function set sheet(value:ISheet):void {
            this._sheet = value;
        }
    
    }
}