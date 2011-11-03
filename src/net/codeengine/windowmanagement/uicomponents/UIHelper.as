package net.codeengine.windowmanagement.uicomponents
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	import mx.effects.Blur;
	import mx.graphics.ImageSnapshot;

	public class UIHelper
	{
		public static function getSectionFromBehindComponent(areaBehind:*, component:*):BitmapData
		{
			component.visible = false;
			var areaBehind_BitmapData:BitmapData=ImageSnapshot.captureBitmapData(areaBehind);
			component.visible = true;
			return UIHelper.copyFrom(areaBehind_BitmapData, component.x, component.y, component.width, component.height);
		}
	
		private static function copyFrom(bitmapData:BitmapData, x:Number, y:Number, width:Number, height:Number):BitmapData
		{
			var data:BitmapData=new BitmapData(width, height, true, 0x00ffffff);
			var rect:Rectangle=new Rectangle(x, y, width, height);
			var pt:Point=new Point(0, 0);
			data.copyPixels(bitmapData, rect, pt);
			return data;
		}

	}
}