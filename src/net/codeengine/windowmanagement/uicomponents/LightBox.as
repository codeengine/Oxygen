/*
The following Intellectual Property Notice applies and replaces any similar 
notice contained in this software.

Intellectual Property Notice

(c) 2011 Business Intelligence Systems Solutions Holdings B.V. - All rights reserved.

This software contains valuable confidential and proprietary information of 
Business Intelligence Systems Solutions Holdings B.V. the use of which is subject to 
the applicable licensing agreement.

Author:      Kit Venter
*/
package net.codeengine.windowmanagement.uicomponents
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.setTimeout;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.core.Container;
	import mx.effects.Fade;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.effects.Resize;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.graphics.ImageSnapshot;
	
	public class LightBox extends Canvas implements IComponent
	{
		/* Private Properties */
		private var _container:*;
		private var _currentImage:Image;
		private var _draggable:Canvas;
		
		public function LightBox()
		{
			super();
		}
		
		override protected function createChildren():void{
			super.createChildren();
			
			var dropshadowFilter:DropShadowFilter = new DropShadowFilter(1, 90, 0x000000, 0.8, 20, 20);
			filters = [dropshadowFilter];
			
			setStyle("borderColor", 0xffffff);
			setStyle("borderStyle", "solid");
			setStyle("borderThickness", 1);
			setStyle("cornerRadius", 8);
			
			setStyle("horizontalScrollPolicy", "off");
			setStyle("verticalScrollPolicy", "off");
			_draggable = new Canvas();
			_draggable.x = 5;
			_draggable.y = 2;
			_draggable.width = width - 20;
			_draggable.height = 12;
			_draggable.addEventListener(MouseEvent.MOUSE_DOWN, function():void{startDrag();});
			_draggable.addEventListener(MouseEvent.MOUSE_UP, function():void{stopDrag();});
			addChild(_draggable);
		}
		
		protected override function measure():void{
			super.measure();
			_draggable.width = width - 20;
			_draggable.height = 12;
		}
		
		public function get preview():Image{
			var image:Image = new Image();
			var bitmap:Bitmap = new Bitmap();
			var bitmapdata:BitmapData = ImageSnapshot.captureBitmapData(this);
			bitmap.bitmapData = bitmapdata;
			image.source = bitmap;
			image.x = x;
			image.y = y;
			image.filters = filters;
			return image;
		}
		
		public function activate(container:*):void{
				x = 0.5 * (container.width - width);
				y = 0.5 * (container.height - height);
				_container = container;
				addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
				_container.addChild(this);
				//Ensure that this is always forced to the top of the view stack
				(_container as Container).setChildIndex(this, (_container as Container).getChildren().length - 1);
		}
		
		public function deactivate():void{
			_container.addChild(_currentImage);
			_container.removeChild(this);
			playClosingAnimation(_currentImage);
			
		}
		
		private function onCreationComplete(event:FlexEvent):void{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			visible = false;
			setTimeout(function():void{
				_currentImage = preview;
				_currentImage.addEventListener(FlexEvent.CREATION_COMPLETE, onImageCreationComplete);
				_container.addChild(_currentImage);
			}, 250);
		}
		
		private function onImageCreationComplete(event:FlexEvent):void{
			event.currentTarget.removeEventListener(FlexEvent.CREATION_COMPLETE, onImageCreationComplete);
			playOpeningAnimation(event.currentTarget as Image);
		}
		
		private function playOpeningAnimation(image:Image):void{
			resizeAboutCenter(image, true);
		}
		
		private function playClosingAnimation(image:Image):void{
			image.x = x;
			image.y = y;
			resizeAboutCenter(image, false);
		}
		
		private function resizeAboutCenter(image:Image, sizeUp:Boolean):void {
			
			var t:Number;
			t=300;
			/* Calculate the static centers of the image. */
			var scX:Number=0;
			var scY:Number=0;
			scX=image.x + (image.width / 2);
			scY=image.y + (image.height / 2);
			trace("Center: " + scX + ", " + scY);
			
			
			var iW:Number=0; //Initial width.
			var eW:Number=0; //Eventual width.
			var iH:Number=0; //Initial height.
			var eH:Number=0; //Eventual height.
			if (!sizeUp) {
				iW=image.width;
				iH=image.height;
				eW=0.5 * iW;
				eH=0.5 * iH;
			} else {
				iW=0.5 * image.width;
				iH=0.5 * image.height;
				eW=image.width;
				eH=image.height;
			}
			
			var iX:Number=0;
			var iY:Number=0;
			var eX:Number=0;
			var eY:Number=0;
			if (!sizeUp) {
				iX=image.x;
				iY=image.y;
				eX=scX - (eW / 2);
				eY=scY - (eH / 2);
			} else {
				iX=scX - (iW / 2);
				iY=scY - (iH / 2);
				eX=image.x;
				eY=image.y;
			}
			
			
//			var animate:Animate = new Animate(image);
//			animate.duration = t;
//			var v:Vector.<MotionPath> = new Vector.<MotionPath>();
			var p:Parallel = new Parallel();
			p.duration = t;
			
			/* Resize. */
//			var resizeHeight:SimpleMotionPath = new SimpleMotionPath("height",iH,eH);
//			var resizeWidth:SimpleMotionPath = new SimpleMotionPath("width", iW, eW);
//			v.push(resizeHeight);
//			v.push(resizeWidth);
			var resizeHeight:Resize = new Resize(image);
			resizeHeight.heightFrom = iH;
			resizeHeight.heightTo = eH;
			p.addChild(resizeHeight);
			
			var resizeWidth:Resize = new Resize(image);
			resizeWidth.widthFrom = iW;
			resizeWidth.widthTo = eW;
			p.addChild(resizeWidth);
			
			
			/* Move from source to destination. */
//			var moveX:SimpleMotionPath = new SimpleMotionPath("x", iX, eX);
//			var moveY:SimpleMotionPath = new SimpleMotionPath("y", iY, eY);
//			v.push(moveX);
//			v.push(moveY);
			var moveX:Move = new Move(image);
			var moveY:Move = new Move(image);
			moveX.xFrom = iX;
			moveX.xTo = eX;
			moveY.yFrom = iY;
			moveY.yTo = eY;
			p.addChild(moveX);
			p.addChild(moveY);
			
			/* Fade */
//			var fade:SimpleMotionPath = new SimpleMotionPath("alpha");
//			v.push(fade);
			var fade:Fade = new Fade(image);
			p.addChild(fade);
			
			if (!sizeUp) {
				//fade.valueFrom=1.0;
				//fade.valueTo=0.00;
				fade.alphaFrom = 1;
				fade.alphaTo = 0;
			} else {
//				fade.valueFrom=0.0;
//				fade.valueTo=1;
				fade.alphaFrom = 0;
				fade.alphaTo = 1;
			}
			
//			animate.motionPaths = v;
//			animate.play();
//			animate.addEventListener(EffectEvent.EFFECT_END, onEffectEnd, false, 0, true);
			p.addEventListener(EffectEvent.EFFECT_END, onEffectEnd, false, 0, true);
			p.play([image]);
			
			
		}
		
		private function onEffectEnd(event:EffectEvent):void {
			_container.removeChild(_currentImage);
			visible = true;
		}
	}
}