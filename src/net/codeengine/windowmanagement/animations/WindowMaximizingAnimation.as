package net.codeengine.windowmanagement.animations
{
	import flash.events.EventDispatcher;
	
	import net.codeengine.windowmanagement.IWindow;
	import net.codeengine.windowmanagement.IWindowProxy;
	import net.codeengine.windowmanagement.Window;
	import net.codeengine.windowmanagement.WindowManager;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;

	public class WindowMaximizingAnimation extends AbstractAnimation implements IWindowAnimation
	{
		private var window:IWindow;
		private var margin:int=30;

		public function play(target:IWindowProxy):void
		{
			this.window=target.window;

			var a:Animate=new Animate(target.window);
			var v:Vector.<MotionPath>=new Vector.<MotionPath>();
			a.motionPaths=v;
			a.duration=WindowManager.ANIMATION_SPEED

			//Move
			var moveX:SimpleMotionPath=new SimpleMotionPath("x", null, margin);
			var moveY:SimpleMotionPath=new SimpleMotionPath("y", null, margin);
			v.push(moveX);
			v.push(moveY);

			//Resize
			if ((target.window as Window)._isZoomed){
				var resizeHeight:SimpleMotionPath=new SimpleMotionPath("height", target.window.height, (target.window as Window)._prezoomheight);
				var resizeWidth:SimpleMotionPath=new SimpleMotionPath("width", target.window.width, (target.window as Window)._prezoomwidth);
				v.push(resizeHeight);
				v.push(resizeWidth);
				(target.window as Window)._isZoomed = false;
			}else{
				var resizeHeight:SimpleMotionPath=new SimpleMotionPath("height", null, WindowManager.instance.height() - 2 * margin);
				var resizeWidth:SimpleMotionPath=new SimpleMotionPath("width", null, WindowManager.instance.width() - 2 * margin);
				v.push(resizeHeight);
				v.push(resizeWidth);
				(target.window as Window)._isZoomed = true;
			}
			

			a.duration=500;
			a.play();
		}

	}
}

