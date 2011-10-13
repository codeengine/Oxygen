package net.codeengine.windowmanagement.uicomponents
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import mx.containers.Canvas;
	import mx.controls.Image;
	import mx.core.DragSource;
	import mx.graphics.ImageSnapshot;
	import mx.managers.DragManager;
	
	public class ColorPalate extends Canvas
	{
		private var _individualColorWidth		:int 		= 16;
		private var _individualColorHeight		:int 		= 16;
		private var _numberOfIndividualColors	:int 		= 5;
		private var _compensation				:int		= 0;
		private var _colors						:Array		= [0xEFF3FF, 0xBDD7E7, 0x6BAED6, 0x3182BD, 0x08519C];
		private var _useHorizontalLayout		:Boolean	= false;
		private var _allowColorResampling		:Boolean	= true;
		private var _startingColor				:uint;
		private var _endingColor				:uint;
		private var _resampleAmount				:int		= 5;
		
		
		
		public function ColorPalate(colors:Array=null)
		{
			super();
			try{
				_colors = colors;
				if (allowColorResampling){
					_resampleAmount = _colors.length;
					
					initResamplingValues(colors[0], colors[colors.length - 1]);
				}
				init();
			}catch(e:*){
				trace("ColorPalate:: ColorPalate InitializationException");
			}
		}
		
		private function initResamplingValues(color1:uint, color2:uint):void{
			if ((_startingColor != color1 || _startingColor == 0) && color1 != 0){
				_startingColor = color1;
			}
			
			if ((_endingColor != color2 || _endingColor == 0)  && color2 != 0){
				_endingColor = color2;
			}
			
		}
		
		
		private function init():void{
			setupStyles();
			calculateAndSetDimensions();
			drawColorSwatches();	
		}
		
		[Inspectable(category="General")]
		public function get useHorizontalLayout():Boolean
		{
			return _useHorizontalLayout;
		}

		public function set useHorizontalLayout(value:Boolean):void
		{
			_useHorizontalLayout = value;
		}

		[Inspectable(category="General")]
		public function get colors():Array
		{
			return _colors;
		}
		
		public function set colors(value:Array):void
		{
			_colors = value;
			drawColorSwatches();
		}
		
		[Inspectable(category="General")]
		public function get allowColorResampling():Boolean { return _allowColorResampling; }
		
		public function set allowColorResampling(value:Boolean):void
		{
			if (_allowColorResampling == value)
				return;
			_allowColorResampling = value;
		}
		
		public function resample(numberOfSegments:int, color1:uint=0, color2:uint=0):void{
			if (!allowColorResampling)return;
			initResamplingValues(color1, color2);
			_resampleAmount = numberOfSegments;
			trace("ColorPalate::resample s: " + _startingColor + " e: " + _endingColor);
			colors = _resample(_startingColor, _endingColor, numberOfSegments);
			init();
			drawColorSwatches();
		}
		
		override protected function createChildren():void{
			super.createChildren();
			addEventListeners();
		}
		
		private function onMouseMove(event:MouseEvent):void 
		{                
			var dragInitiator:Canvas=Canvas(event.currentTarget);
			var ds:DragSource = new DragSource();
			ds.addData(dragInitiator, "ColorPalateComponent");               
			var imageProxyBitmap:Bitmap = preview.source as Bitmap;
			var imageProxy:Image = new Image();
			imageProxy.source = imageProxyBitmap;
			
			DragManager.doDrag(dragInitiator, ds, event, imageProxy, 0, 0, 0.85);
		}
		
		private function setupStyles():void{
			setStyle("borderWidth", 1);
			setStyle("borderColor", 0x444444);
			setStyle("borderStyle", "solid");
		}
		
		private function drawColorSwatches():void{
			var posX:int = 0;
			var posY:int = 0;
			graphics.clear();
			for (var i:int = 0; i < _colors.length; i++) 
			{
				var color:uint = _colors[i];
				drawSwatch(posX, posY, color, _individualColorWidth, _individualColorHeight, 0x000000, 1);
				if (_useHorizontalLayout)posX += _individualColorWidth else posY += _individualColorHeight;
			}
		}
		
		private function drawSwatch(atPositionX:int, atPositionY:int, usingColor:uint, withWidth:int, withHeight:int, usingBorderColorOf:uint, usingBorderWidthOf:uint):void{
			graphics.beginFill(usingColor);
			graphics.drawRect(atPositionX, atPositionY, withWidth, withHeight);
			graphics.endFill();
		}
		
		private function calculateAndSetDimensions():void{
			calculateAndSetHeight();
			calculateAndSetWidth();
		}
		
		private function calculateAndSetHeight():void{
			var factor:int = allowColorResampling ? _resampleAmount : colors.length;
			var h:Number = _useHorizontalLayout ? _individualColorHeight + (2 * _compensation) : factor * _individualColorHeight + (2 * _compensation);
			height = h;
		}
		
		private function calculateAndSetWidth():void{
			var factor:int = allowColorResampling ? _resampleAmount : colors.length;
			var w:Number = _useHorizontalLayout ? factor * _individualColorWidth + (2 * _compensation) : _individualColorWidth + (2 * _compensation);
			width = w;
		}
		
		private function addEventListeners():void{
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		/* Event Handlers */
		private function onMouseOver(event:MouseEvent):void{
			
		}
		private function onMouseOut(event:MouseEvent):void{
			
		}
		
		private var _preHighlightFilters = [];
		private function highlight():void{
			var filter:GlowFilter = new GlowFilter(0xFFFFB2, 0.8, 10, 10);
			_preHighlightFilters = filters;
			filters = [filter];
		}
		
		private function stopHighlight():void{
			filters = _preHighlightFilters;
		}
		
		public function get preview():Image{
			var image:Image = new Image();
			try{
				var bitmap:Bitmap = new Bitmap();
				var bitmapdata:BitmapData = ImageSnapshot.captureBitmapData(this);
				bitmap.bitmapData = bitmapdata;
				image.source = bitmap;
				image.x = x;
				image.y = y;
				image.filters = filters;
			}catch(e:*){
				
			}
			return image;
		}
		
		public static function convertColorToRgb(col:uint):Array{
			var r:int;
			var g:int;
			var b:int;
			r = col >> 16;
			g = (col ^ col >> 16 << 16) >> 8;
			b = col >> 8 << 8 ^ col;
			return [r, g, b];
		}
		
		public static function convertRgbToColor(rgb:Array):uint
		{
			var col:uint = 0;
			col += rgb[0] << 16;
			col += rgb[1] << 8;
			col += rgb[2];
			return col;
		}
		
		private function _resample(startingColor:uint, endingColor:uint, totalSwatches:int):Array{
			var swatches		:Array = [];
			
			var startingRgb		:Array = convertColorToRgb(startingColor);
			var endingRgb		:Array = convertColorToRgb(endingColor);
			
			//Now, build up each color channel, starting wit the starting color
			for (var i:int = 1; i <= totalSwatches; i++)
			{
				var rgb:Array = new Array(startingRgb.length);
				for (var col:int = 0; col<startingRgb.length; col++)
				{
					rgb[col] = calcBreakPoint(startingRgb[col], endingRgb[col], i, totalSwatches);
				}
				swatches.push(rgb);
			}			
			var colors	:Array = [];
			//Convert the swatches into colors
			for (var j:int = 0; j < swatches.length; j++){
				colors.push(convertRgbToColor(swatches[j]));
			}
			return colors;
		}
		
		private function calcBreakPoint(v1:int, v2:int, step:int, totalSteps:int):int
		{
			return v1 + (v2-v1)*step/totalSteps;				
		}
	}
}