/*
The following Intellectual Property Notice applies and replaces any similar 
notice contained in this software.

Intellectual Property Notice

(c) 2011 Business Intelligence Systems Solutions Holdings B.V. - All rights reserved.

This software contains valuable confidential and proprietary information of 
Business Intelligence Systems Solutions Holdings B.V. the use of which is subject to 
the applicable licensing agreement.
*/
package net.codeengine.windowmanagement.uicomponents
{
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.containers.Canvas;
	import mx.controls.Label;
	import mx.effects.Fade;
	import mx.events.EffectEvent;
	
	import net.codeengine.windowmanagement.IBusy;
	import net.codeengine.windowmanagement.IWindow;

	public class BusyIndicator extends Canvas implements IBusy
	{
		static private const DEFAULT_ROTATION_INTERVAL:Number = 50;
		static private const RADIANS_PER_DEGREE:Number = Math.PI / 180;
		private var _target:*;
		private var _message:String = "Busy...";
		private var _animate:Boolean = true;
		private var rotationTimer:Timer;
		private var spinnerDiameter:int = 50;
		private var currentRotation:Number = 0;
		private var spinnerCanvas:Canvas = new Canvas();		
		private var ic:Canvas;
		private var _y:Number = 10;
		
		private var spokeColor:uint = 0xffffff;
		private var _showMessage:Boolean = true;
		public function BusyIndicator(message:String=null, animate:Boolean = true, spinnerDiameter:int=50, y:Number=20)
		{
			if (null != message && "" != message){
				_message = message;				
			}else{
				_showMessage = false;
			}
			
			_animate = animate;
			
			this.spinnerDiameter = spinnerDiameter;
			
			_y = y;
		}
		
		public function activate(target:*):void{
			_target = target;	
			_target.addElement(this);
			_y = y;
			if(_animate){
				playAppearAnimation();				
			}
		}
		
		public function deactivate():void{
			if (_animate){
				playDisappearAnimation();
			}else{
				_target.removeElement(this);	
			}	
		}
		
		private function playAppearAnimation():void{
			var fade:Fade = new Fade(this);
			fade.alphaFrom = 0;
			fade.alphaTo = 1;
			fade.play();
		}
		
		
		private function playDisappearAnimation():void{
			var fade:Fade = new Fade(this);
			fade.alphaFrom = 1;
			fade.alphaTo = 0;
			fade.play();
			fade.addEventListener(EffectEvent.EFFECT_END, onDisappearAnimationComplete);
		}
		
		private function onDisappearAnimationComplete(event:EffectEvent):void{
			try{_target.removeElement(this);}catch(e:*){trace(e);}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			setStyle("backgroundColor", 0xF0F0F0);
			setStyle("backgroundAlpha", 0.1);
			percentHeight = 100;
			percentWidth = 100;
			ic = createInnerCanvas();
			ic.height = 100;
			
			if (_showMessage){
				var l:Label = createMessageLabel(_message);
				ic.addElement(l);
			}else{
				ic.height = spinnerDiameter + 20;
				ic.width = spinnerDiameter + 20;
			}
			
			
			
			//spinnerCanvas.x = 0.5 * ic.width;
			spinnerCanvas.setStyle("horizontalCenter", - 0.5 * spinnerDiameter);
			spinnerCanvas.y = 10;
			
			ic.addElement(spinnerCanvas);
			
			addElement(ic);
			drawSpinner();
			startRotation();
		}
				
		private function createInnerCanvas():Canvas{
			var innerCanvas:Canvas = new Canvas();
			//innerCanvas.minHeight = 100;
			//innerCanvas.minWidth = 200;
			innerCanvas.setStyle("verticalCenter", 0);
			innerCanvas.setStyle("horizontalCenter", 0);
			innerCanvas.setStyle("backgroundColor", 0x000000);
			innerCanvas.setStyle("backgroundAlpha", 0.8);
			innerCanvas.setStyle("borderStyle", "solid");
			innerCanvas.setStyle("cornerRadius", 8);
			innerCanvas.setStyle("borderThickness", 0);
			innerCanvas.setStyle("borderColor", 0xffffff);
			return innerCanvas;
		}
		
		private function createMessageLabel(message:String):Label{
			var l:Label = new Label;
			l.text = message;
			l.setStyle("fontSize", 18);
			l.setStyle("color", 0xffffff);
			l.setStyle("bottom", 10);
			l.setStyle("horizontalCenter", 0);
			return l;
		}
		
		public function applyThreeSixtyDegreeDropShadow(target:DisplayObject):void
		{
			var filter:DropShadowFilter=new DropShadowFilter();
			filter.angle=0;
			filter.alpha=0.6;
			filter.blurX=10;
			filter.blurY=10;
			filter.distance=0;
			
			target.filters = [filter];
		}
		
		private function drawSpoke(spokeAlpha:Number, degrees:int,
								   spokeWidth:Number, 
								   spokeHeight:Number, 
								   spokeColor:uint, 
								   spinnerRadius:Number, 
								   eHeight:Number,
								   spinnerPadding:Number):void
		{
			var g:Graphics = spinnerCanvas.graphics;
			var outsidePoint:Point = new Point();
			var insidePoint:Point = new Point();
			
			g.lineStyle(spokeWidth, spokeColor, spokeAlpha, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
			outsidePoint = calculatePointOnCircle(spinnerRadius, spinnerRadius - eHeight - spinnerPadding, degrees);
			insidePoint = calculatePointOnCircle(spinnerRadius, spinnerRadius - spokeHeight + eHeight - spinnerPadding, degrees);
			g.moveTo(outsidePoint.x, outsidePoint.y);
			g.lineTo(insidePoint.x,  insidePoint.y);
			
		}
		
		private function calculatePointOnCircle(center:Number, radius:Number, degrees:Number):Point
		{
			var point:Point = new Point();
			var radians:Number = degrees * RADIANS_PER_DEGREE;
			point.x = center + radius * Math.cos(radians);
			point.y = center + radius * Math.sin(radians);
			
			return point;
		}
		
		private function drawSpinner():void{
			// TODO Auto-generated method stub
			var g:Graphics = spinnerCanvas.graphics;
			var spinnerRadius:int = spinnerDiameter / 2;
			var spinnerWidth:int = spinnerDiameter;
			var spokeHeight:Number = spinnerDiameter / 3.7;
			var insideDiameter:Number = spinnerDiameter - (spokeHeight * 2); 
			var spokeWidth:Number = insideDiameter / 5;
			var eHeight:Number = spokeWidth / 2;
			var spinnerPadding:Number = 0;
			
			g.clear();
			
			// 1
			drawSpoke(0.20, currentRotation + 300, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 2
			drawSpoke(0.25, currentRotation + 330, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 3
			drawSpoke(0.30, currentRotation, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 4
			drawSpoke(0.35, currentRotation + 30, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 5
			drawSpoke(0.40, currentRotation + 60, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 6
			drawSpoke(0.45, currentRotation + 90, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 7
			drawSpoke(0.50, currentRotation + 120, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 8
			drawSpoke(0.60, currentRotation + 150, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 9
			drawSpoke(0.70, currentRotation + 180, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 10
			drawSpoke(0.80, currentRotation + 210, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 11
			drawSpoke(0.90, currentRotation + 240, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
			// 12
			drawSpoke(1.0, currentRotation + 270, spokeWidth, spokeHeight, spokeColor, spinnerRadius, eHeight, spinnerPadding);
			
		}
		
		private function startRotation():void
		{
			if (!rotationTimer)
			{
				var rotationInterval:Number = getStyle("rotationInterval");
				if (isNaN(rotationInterval))
					rotationInterval = DEFAULT_ROTATION_INTERVAL;
				
				if (rotationInterval < 16.6)
					rotationInterval = 16.6;
				
				rotationTimer = new Timer(rotationInterval);
			}
			
			if (!rotationTimer.hasEventListener(TimerEvent.TIMER))
			{
				rotationTimer.addEventListener(TimerEvent.TIMER, timerHandler);
				rotationTimer.start();
			}
			
		}
			
		private function timerHandler(event:TimerEvent):void
		{
			currentRotation += 30;
			if (currentRotation >= 360)
				currentRotation = 0;
			
			drawSpinner();
			event.updateAfterEvent();
		}
		
		public function get message():String
		{
			return _message;
		}
		
		public function set message(value:String):void
		{
			_message = value;
			
		}
		
		public function get window():IWindow
		{
			return _target as IWindow;
		}
		
		public function set window(window:IWindow):void
		{
			_target = window;
		}
		
	}
}