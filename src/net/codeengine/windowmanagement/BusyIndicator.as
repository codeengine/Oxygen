package net.codeengine.windowmanagement
{
	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	
	import spark.components.BorderContainer;

	public class BusyIndicator extends BorderContainer implements IBusy
	{
		private var _target:*;
		private var _message:String="Busy...";
		private var _animate:Boolean=true;

		private var _window:IWindow;
		private var l:Label;

		public function BusyIndicator(message:String="", animate:Boolean=true)
		{
			if (null != message && "" != message)
			{
				_message=message;
			}

			_animate=animate;
		}

		public function activate(target:*):void
		{
			
			_target=target;
			_target.addElement(this);
			if (_message != l.text){
				l.text = _message;
			}
			if (_animate)
			{
				playAppearAnimation();
			}
		}

		public function deactivate():void
		{
			if (_animate)
			{
				playDisappearAnimation();
			}
			else
			{
				_target.removeElement(this);
			}
		}

		private function playAppearAnimation():void
		{
			var fade:Fade=new Fade(this);
			fade.alphaFrom=0;
			fade.alphaTo=1;
			fade.play();
		}


		private function playDisappearAnimation():void
		{
			var fade:Fade=new Fade(this);
			fade.alphaFrom=1;
			fade.alphaTo=0;
			fade.play();
			fade.addEventListener(EffectEvent.EFFECT_END, onDisappearAnimationComplete);
		}

		private function onDisappearAnimationComplete(event:EffectEvent):void
		{
			_target.removeElement(this);
		}

		protected override function createChildren():void
		{
			super.createChildren();

			setStyle("backgroundColor", 0xF0F0F0);
			setStyle("backgroundAlpha", 0.8);
			
			setStyle("borderStyle", "none");
			//percentHeight=100;
			top = 22;
			bottom = 0;
			percentWidth=100;
			var ic:BorderContainer=createInnerCanvas();
			var l:Label=createMessageLabel(_message);

			ic.addElement(l);

			addElement(ic);

			applyThreeSixtyDegreeDropShadow(ic);
		}

		private function createInnerCanvas():BorderContainer
		{
			var innerCanvas:BorderContainer=new BorderContainer();
			//innerCanvas.minHeight = 100;
			//innerCanvas.minWidth = 200;
			innerCanvas.setStyle("verticalCenter", 0);
			innerCanvas.setStyle("horizontalCenter", 0);
			innerCanvas.setStyle("backgroundColor", 0x000000);
			innerCanvas.setStyle("backgroundAlpha", 0.8);
			innerCanvas.setStyle("borderStyle", "solid");
			innerCanvas.setStyle("cornerRadius", 8);
			innerCanvas.setStyle("borderThickness", 2);
			innerCanvas.setStyle("borderColor", 0xffffff);
			return innerCanvas;
		}

		private function createMessageLabel(message:String):Label
		{
			l = new Label;
			l.text=message;
			l.setStyle("fontSize", 18);
			l.setStyle("color", 0xffffff);
			l.setStyle("verticalCenter", 0);
			l.setStyle("horizontalCenter", 0);
			return l;
		}

		public function applyThreeSixtyDegreeDropShadow(target:DisplayObject)
		{
			var filter:DropShadowFilter=new DropShadowFilter();
			filter.angle=0;
			filter.alpha=0.6;
			filter.blurX=10;
			filter.blurY=10;
			filter.distance=0;

			target.filters=[filter];
		}

		public function get window():IWindow
		{
			return _window;
		}

		public function set window(window:IWindow):void
		{
			_window=window;
		}

		public function get message():String
		{
			return _message;
		}

		public function set message(value:String):void
		{
			_message=message;
		}
	}
}
