package net.codeengine.windowmanagement {
    import mx.controls.Image;
    
    public class DrawerProxy implements IDrawerProxy {
        private var _image:Image = new Image();
        
        private var _drawer:IDrawer;
        
        public function DrawerProxy() {
        }
        
        public function get image():Image {
            return this._image;
        }
        
        public function set image(value:Image):void {
            this._image = value;
        }
        
        public function get drawer():IDrawer {
            return this._drawer;
        }
        
        public function set drawer(value:IDrawer):void {
            this._drawer = value;
        }
    
    }
}