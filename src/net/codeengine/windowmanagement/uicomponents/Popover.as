package net.codeengine.windowmanagement.uicomponents
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Image;
	
	import spark.components.BorderContainer;
	import spark.filters.DropShadowFilter;
	
	public class Popover extends BorderContainer
	{
		[Inspectable(category="Styles")]
		public var backgroundColor:uint=0xF2F3F7;
		[Inspectable(category="Styles")]
		public var backgroundAlpha:Number=1;
		[Inspectable(category="Common", enumeration="North,East,South,West")]
		public var anchorLocation:String="North";
		[Bindable]
		private var transparentBlurOverlay_bitmap:Bitmap=new Bitmap();
		[Bindable]
		private var transparentBlurOverlay_bitmapData:BitmapData;
		[Bindable]
		private var transparentBlurOverlay:Image=new Image();
		[Bindable]
		private var __container:*;
		private var _isDragging:Boolean=false;
		
		public function Popover()
		{
			addEventListeners();
		}
		
		private function addEventListeners():void
		{
			//			addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void
			//			{
			//				if (event.target is Image)
			//				{
			//					startDrag();
			//					_isDragging=true;
			//				}
			//			});
			//			addEventListener(MouseEvent.MOUSE_MOVE, function(event:MouseEvent):void
			//			{
			//				if (_isDragging)
			//				{
			//					simulateBlurryTransparency();
			//				}
			//			});
			//			addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void
			//			{
			//				stopDrag();
			//				_isDragging=false;
			//				simulateBlurryTransparency();
			//			});
		}
		
		public function activate(container:*, animate:Boolean=false):void
		{
			__container=container;
			simulateBlurryTransparency();
			container.addElement(this);
		}
		
		public function deactivate(animate:Boolean=false):void
		{
			__container.removeElement(this);
		}
		
		protected function simulateBlurryTransparency():void
		{
			try{
				var rect:Rectangle=new Rectangle(x, y, width, height);
				this.visible=false;
				transparentBlurOverlay_bitmap.bitmapData=UIHelper.getSectionFromBehindComponent(__container, this);
				this.visible=true;
				var blur_filter:BlurFilter=new BlurFilter(20, 20, 1);
				transparentBlurOverlay.filters=[blur_filter];
			}catch (e:*){
			}
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			transparentBlurOverlay.source=transparentBlurOverlay_bitmap;
			transparentBlurOverlay.width=width;
			transparentBlurOverlay.height=height;
			transparentBlurOverlay.x=0;
			transparentBlurOverlay.y=0;
			transparentBlurOverlay.alpha=0.16;
			addElementAt(transparentBlurOverlay, 0);
			
			setStyle("backgroundColor", backgroundColor);
			setStyle("backgroundAlpha", backgroundAlpha);
			
			drawAnchor(anchorLocation);
		}
		
		private function drawAnchor(direction:String="north"):void
		{
			direction=direction.toLowerCase();
			draw_triangle(direction);
		}
		
		private function draw_triangle(direction:String="north"):void
		{
			var x_position_x_axis:Number;
			var y_position_y_axis:Number;
			
			var points:Array=[];
			
			var north:Boolean=(direction == "north");
			var east:Boolean=direction == "east";
			var south:Boolean=direction == "south";
			var west:Boolean=(direction == "west");
			
			var line_len:Number=20;
			
			
			//East or South, same is best!
			if (east || south)
			{
				x_position_x_axis=width;
				y_position_y_axis=height;
			}
			else if (north)
			{ //North or West, opposites best!
				x_position_x_axis=width;
				y_position_y_axis=0;
			}
			else if (west)
			{
				x_position_x_axis=0;
				y_position_y_axis=height;
			}
			
			if (north || south)
			{
				points.push(new Point((x_position_x_axis / 2 - line_len), y_position_y_axis));
				points.push(new Point((x_position_x_axis / 2), south ? y_position_y_axis + line_len : y_position_y_axis - line_len));
				points.push(new Point((x_position_x_axis / 2 + line_len), y_position_y_axis));
			}
			else if (east || west)
			{
				points.push(new Point(x_position_x_axis, (y_position_y_axis / 2) - line_len));
				points.push(new Point(west ? x_position_x_axis - line_len : x_position_x_axis + line_len, y_position_y_axis / 2));
				points.push(new Point(x_position_x_axis, (y_position_y_axis / 2) + line_len));
			}
			
			//Draw the Triangle
			graphics.beginFill(0xF0F0F0, backgroundAlpha);
			graphics.moveTo(points[0].x, points[0].y);
			for (var i:int=0; i < points.length; i++)
			{
				graphics.lineTo(points[i].x, points[i].y);
			}
			graphics.endFill();
			
		}
	}
}
