package net.codeengine.windowmanagement {
    import spark.components.Panel;

    [ExcludeClass]
    public class Popover extends Panel implements IPopover {
        private var _window:IWindow;

        public function Popover() {
            super();
        }

        public function get window():IWindow {
            return this._window;
        }

        public function set window(value:IWindow):void {
            this._window=value;
        }

    }
}