package net.codeengine.windowmanagement.animations
{
	import flash.events.EventDispatcher;
	import net.codeengine.windowmanagement.IWindow;
	import net.codeengine.windowmanagement.IWindowProxy;
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
			var resizeHeight:SimpleMotionPath=new SimpleMotionPath("height", null, target.window.windowManager.height() - 2 * margin);
			var resizeWidth:SimpleMotionPath=new SimpleMotionPath("width", null, target.window.windowManager.width() - 2 * margin);
			v.push(resizeHeight);
			v.push(resizeWidth);

			a.duration=500;
			a.play();
		}

	}
}

