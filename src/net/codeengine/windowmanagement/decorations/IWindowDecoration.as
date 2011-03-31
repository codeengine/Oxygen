package net.codeengine.windowmanagement.decorations {
    import net.codeengine.windowmanagement.IWindow;


    public interface IWindowDecoration {
        function decorate(window:IWindow):void;
    }
}