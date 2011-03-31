package net.codeengine.windowmanagement.animations {
    import net.codeengine.windowmanagement.IDrawerProxy;
    
    public interface IDrawerAnimation {
        function play(target:IDrawerProxy):void
    }
}