package net.codeengine.windowmanagement.animations
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.graphics.ImageSnapshot;
	
	import spark.components.Group;

	public class WindowFlipAnimation
	{
		private static var _instance:WindowFlipAnimation = new WindowFlipAnimation();
		private var _fieldOfView:Number=10;
		private var _fps:Number=100;
		private var _msInSecond:int=1000;
		private var _frequency:Number=_msInSecond / _fps;
		private var _activeView:UIComponent;
		private var _flipViewContainer:Group;
		public var container:*;
		private var _startView_Image:Image=new Image();
		private var _endView_Image:Image=new Image();
		public var id:String;

		public function WindowFlipAnimation(){
			if (_instance){
				throw new Error("SingletonError: Cannot instantiate Singleton. Use .instance instead.");
			}
		}
		
		public static function get instance():WindowFlipAnimation{
			return _instance;
		}

		private function createCenteredProjection(target:*, _fieldOfView:Number):PerspectiveProjection
		{

			var projection:PerspectiveProjection=new PerspectiveProjection();
			projection.fieldOfView=_fieldOfView;
			projection.projectionCenter=new Point(target.width / 2, target.height / 2);
			return projection;
		}

		public function flip(fromView:*, toView:*, container:*, direction:String="left"):void
		{
			_flipViewContainer=new Group();

			//Hide the actual components
			fromView.visible=false;
			toView.visible=false;

			//Make sure the two views are lined up
			toView.x=fromView.x;
			toView.y=fromView.y;


			//Copy the filters to the images, to keep the illusion that the
			//container itself is being animated
			_startView_Image.filters=fromView.filters;
			_endView_Image.filters=toView.filters;


			//Setup the flip view container
			_flipViewContainer.width=fromView.width > toView.width ? fromView.width : toView.width;
			_flipViewContainer.height=fromView.height > toView.height ? fromView.height : toView.height;
			container.addElement(_flipViewContainer);


			//Match the width/height of the views
			toView.width=_flipViewContainer.width;
			fromView.width=_flipViewContainer.width;

			toView.height=_flipViewContainer.height;
			fromView.height=_flipViewContainer.height;

			//Setup the perspective, values approach 180 have a distant perspective,
			//values approach 0 have a closer perspective
			_flipViewContainer.transform.perspectiveProjection=createCenteredProjection(_flipViewContainer, _fieldOfView);

			//Position the flip view container
			_flipViewContainer.x=fromView.x + fromView.width * 0.5;
			_flipViewContainer.y=fromView.y + fromView.height * 0.5;

			//Setup the images representing the views
			_startView_Image.source=getViewAsBitmap(fromView);
			_endView_Image.source=getViewAsBitmap(toView);

			//Add the views and position them appropriately to the container
			_flipViewContainer.addElement(_endView_Image);
			_flipViewContainer.addElement(_startView_Image);

			_startView_Image.x=-_flipViewContainer.width * 0.5;
			_startView_Image.y=-_flipViewContainer.height * 0.5;
			_startView_Image.visible=true;

			_endView_Image.x=_flipViewContainer.width * 0.5;
			_endView_Image.y=-_flipViewContainer.height * 0.5;
			_endView_Image.visible=true;

			_endView_Image.scaleX=-1;

			var timer:Timer=new Timer(_msInSecond / _fps);
			timer.addEventListener(TimerEvent.TIMER, function(event:Event):void
			{
				//startView.rotationY +=10;
				//startView.x +=10;

				_flipViewContainer.rotationY+=direction == "left" ? 10 : -10;
				if (_flipViewContainer.rotationY == 90 + _fieldOfView)
				{
					_endView_Image.visible=true;
					_startView_Image.visible=false;
				}
				if (_flipViewContainer.rotationY == -90 + _fieldOfView)
				{
					_endView_Image.visible=false;
					_startView_Image.visible=true;
				}
				trace(_flipViewContainer.rotationY);
				if (_flipViewContainer.rotationY == 180 || _flipViewContainer.rotationY == -180)
				{
					timer.stop();
					container.removeElement(_flipViewContainer);
					toView.visible=true;
					fromView.visible=false;
				}
			});
			timer.start();

		}

		private function getViewAsBitmap(view:*):Bitmap
		{
			//Store initial visibility
			var initialVisibility:Boolean=view.visible;
			//Ensure the view is visible for snapping
			view.visible=true;
			var bitmapData:BitmapData=ImageSnapshot.captureBitmapData(view);
			view.visible=initialVisibility;
			return new Bitmap(bitmapData);
		}


	}
}