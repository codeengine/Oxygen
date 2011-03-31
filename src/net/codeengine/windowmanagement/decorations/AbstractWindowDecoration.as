package net.codeengine.windowmanagement.decorations
{
    import net.codeengine.windowmanagement.IWindow;
    

    public class AbstractWindowDecoration
    {
        protected function addFilter(window:IWindow, filter:Object):void
        {
            var filters:Array=new Array();
            for each (var filter:Object in window.filters)
            {
                filters.push(filter);
            }
            filters.push(filter);
            window.filters=filters;
        }
    }
}