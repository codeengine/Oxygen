package net.codeengine.windowmanagement.animations
{
	import flash.events.EventDispatcher;
	
	import mx.effects.Resize;
	import mx.events.EffectEvent;
	
	import net.codeengine.windowmanagement.ISheetProxy;
	import net.codeengine.windowmanagement.Sheet;
	import net.codeengine.windowmanagement.WindowManager;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;

	public class SheetDisappearAnimation extends AbstractAnimation implements ISheetAnimation
	{
		private var _proxy:ISheetProxy;

		public function play(target:ISheetProxy):void
		{
			this._proxy=target;

			WindowManager.instance.addChild(target.image);
			/*var resize:Resize=new Resize(target.image);
			resize.heightFrom=target.sheet.height;
			resize.heightTo=0;
			resize.widthFrom=target.sheet.width;
			resize.widthTo=target.sheet.width;
			resize.duration=300;
			target.image.maintainAspectRatio=false;
			resize.play();
			resize.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);*/

			var a:Animate=new Animate(_proxy.image);
			_proxy.image.maintainAspectRatio=false;
			var v:Vector.<MotionPath>=new Vector.<MotionPath>();
			a.motionPaths=v;
			a.duration=WindowManager.ANIMATION_SPEED;

			var resizeHeight:SimpleMotionPath=new SimpleMotionPath("height", target.image.height, 0);
			v.push(resizeHeight);
			var resizeWidth:SimpleMotionPath=new SimpleMotionPath("width", target.image.width, target.image.width);
			v.push(resizeWidth);

			var fade:SimpleMotionPath=new SimpleMotionPath("alpha", Sheet.MAXIMUM_ALPHA, Sheet.MINIMUM_ALPHA);
			v.push(fade);
			a.addEventListener(EffectEvent.EFFECT_END, onEffectEnd);
			a.play();
		}

		public function onEffectEnd(event:EffectEvent):void
		{
			WindowManager.instance.removeChild(this._proxy.image);
			var animationEvent:SheetAnimationEvent=new SheetAnimationEvent(SheetAnimationEvent.SHEET_CLOSING_ANIMATION_COMPLETE);
			animationEvent.sheet=this._proxy.sheet;
			dispatchEvent(animationEvent);
			this._proxy = null;
		}

	}
}