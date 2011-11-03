package net.codeengine.windowmanagement {
	import spark.components.Image;
    
    public class WindowProxy implements IWindowProxy {
        private var _image:Image;
        
        private var _window:IWindow;
        
        public function WindowProxy() {
            this._image = new Image();
        }
        
        /**
         * Get a frame (as an Image) representing the window at this point in time.
         *
         * @return An image representing this window.
         */
        public function get image():Image {
            return this._image;
        }
        
        public function set image(value:Image):void {
            this._image = value;
        }
        
        /**
         * Get a reference to the window that this proxy represents.
         *
         * @return A reference to the window that this proxy represents.
         */
        public function get window():IWindow {
            return this._window;
        }
        
        public function set window(value:IWindow):void {
            this._window = value;
        }
    
    }
}