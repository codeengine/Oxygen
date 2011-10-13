package net.codeengine.windowmanagement.uicomponents
{	
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	import mx.controls.Text;
	import mx.core.Container;
	import mx.core.IVisualElement;
	
	import net.codeengine.windowmanagement.IWindowTitleBar;
	
	import spark.components.BorderContainer;
	import spark.components.Group;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	import spark.components.VGroup;
	
	[Bindable]
	public class TabBarItem extends BorderContainer implements ITabBarItem
	{
		private var _labelText:String;
		private var _iconSource:*;
		private var _label:Label;
		private var _icon:Image;
		private var _selected:Boolean;
		private var _manager:ITabBar;
		private var _parent:*;
		private var _view:String;
		
		[Embed(source="assets/images/tabbar/selectedbgleft.png")]
		private var _selectedLeftBorderSource:Class;
		
		[Embed(source="assets/images/tabbar/selectedbgright.png")]
		private var _selectedRightBorderSource:Class;
		
		private var leftBorderImage:Image = new Image();
		private var rightBorderImage:Image = new Image();
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void
		{
			if (_selected == value)
				return;
			_selected = value;
		}
		
		private var _id:String;
		
		
		public function get view():String { return _view; }
		
		public function set view(value:String):void
		{
			if (_view == value)
				return;
			_view = value;
		}
		
		[Embed(source="assets/images/tabbar/selectedbg.png")]
		private var _bg:Class;
		public function TabBarItem(id:String, label:String, icon:*, view:String, manager:ITabBar, parent:*, selected:Boolean=false, width:Number=54)
		{
			super();
			
			_labelText = label;
			_iconSource = icon;
			_selected = selected;
			_id = id;
			_view = view;
			_manager = manager;
			_parent = parent;
			this.width = width;
		}
		
		protected override function createChildren():void{
			left = 10;
			right = 10;
			top = 0;
			bottom = 0;
			
			height = 54;
			
			addEventListener(MouseEvent.CLICK, onClick);
			
			addEventListener(PreferenceTabBarEvent.didReceiveResponseToRequestToChangeView, didReceiveResponseToRequestToChangeView);
			
			
			setStyle("borderAlpha", 0);
			
			setStyle("backgroundImage", _bg);
			setStyle("backgroundImageFillMode", "repeat");
			
			if (_selected){
				setStyle("backgroundAlpha", 1);
			}else{
				setStyle("backgroundAlpha", 0);
			}
			
			
			_label = new Label();
			_label.setStyle("fontSize", 11);
			_label.setStyle("horizontalCenter", 0);
			_label.setStyle("fontFamily", "Verdana");
			//_label_Label.setStyle("color", 0x41403E);
			_label.top = 40;
			//var f:DropShadowFilter = new DropShadowFilter(1, 90, 0xffffff, 0.5, 1, 1);
			//_label_Label.filters = [f];
			_label.text = _labelText;
			addElement(_label);	
			
			_icon = new Image();
			_icon.source = _iconSource;
			_icon.setStyle("horizontalCenter", 0);
			_icon.top = 5;
			//_icon_Image.filters = [new DropShadowFilter(1, 90, 0xffffff, 0.9, 1, 1, 1, 1, false, false)];
			addElement(_icon);
			
			
			leftBorderImage.source = _selectedLeftBorderSource;
			leftBorderImage.visible = _selected;
			addElement(leftBorderImage);
			
			rightBorderImage.source = _selectedLeftBorderSource;
			rightBorderImage.visible = _selected;
			rightBorderImage.right = 0;
			rightBorderImage.bottom = 2;
			addElement(rightBorderImage);
		}

		private function onClick(event:MouseEvent):void
		{
			var e:PreferenceTabBarEvent = new PreferenceTabBarEvent(PreferenceTabBarEvent.didReceiveRequestToChangeView);
			e.requestedView = view;
			e.tabBarItem = this;
			_parent.dispatchEvent(e);
		}
		
		private function didReceiveResponseToRequestToChangeView(event:PreferenceTabBarEvent):void{
			
			if (selected == event.didViewChangeSuccessfully)return;
			
			selected = event.didViewChangeSuccessfully;
			_manager.select(id);
			setStyle("backgroundAlpha", 1);
			leftBorderImage.visible = _selected;
			redraw();
		}
		
		public function redraw():void{
			
			leftBorderImage.visible = _selected;
			rightBorderImage.visible = _selected;
			if (_selected){
				setStyle("backgroundAlpha", 1);
			}else{
				setStyle("backgroundAlpha", 0);
			}
		}
		
		public function get label():String
		{
			return _labelText;
		}
		
		public function set label(value:String):void
		{
			_labelText = value;
		}
		
		public function get icon():String
		{
			return _iconSource;
		}
		
		public function set icon(value:String):void
		{
			_iconSource = value;
		}
		
		override public function get id():String { return _id; }
		
		override public function set id(value:String):void
		{
			if (_id == value)
				return;
			_id = value;
			
			super.id = value;
		}
	}
}