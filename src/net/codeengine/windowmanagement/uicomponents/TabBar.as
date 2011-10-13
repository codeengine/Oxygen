package net.codeengine.windowmanagement.uicomponents
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.containers.ViewStack;
	import mx.controls.Spacer;
	import mx.core.IVisualElement;
	import mx.events.CollectionEvent;
	
	import spark.components.BorderContainer;
	import spark.components.HGroup;
	
	public class TabBar extends BorderContainer implements ITabBar
	{
		//[Embed(source="assets/images/tabbar/bg.png")]
		///private var _bg:Class;
		
		public var _tabbarItems:Array = [];
		private var _hgroup:HGroup;
		private var _viewStack:ViewStack;
		
		public function TabBar()
		{
			super();
			//setStyle("backgroundImage", _bg);
			//setStyle("backgroundImageFillMode", "repeat");
			setStyle("borderAlpha", 0);
			setStyle("backgroundAlpha", 0);
			
		}
		
		
		
		protected override function createChildren():void{
			draw();
		}
		
		public function draw():void{
			try{
				removeElement(_hgroup);
			}catch(e:*){
				trace(e);
			}
			_hgroup = new HGroup();
			height = 58;
			_hgroup.left = 12;
			_hgroup.percentWidth = 100;
			addElement(_hgroup);
			var s:Spacer = new Spacer();
			s.width = 20;
			for each (var t:ITabBarItem in _tabbarItems){
				_hgroup.addElement(t as IVisualElement);
				
				_hgroup.addElement(s);
			}
		}
		
		public function select(id:String):void{
			for each (var item:TabBarItem in _tabbarItems){
				if (item.id != id){
					item.selected = false;
					item.redraw();
				}
			}
		}

		public function get viewStack():ViewStack
		{
			return _viewStack;
		}

		public function set viewStack(value:ViewStack):void
		{
			_viewStack = value;
		}

		public function add(tab:ITabBarItem):void
		{
			_tabbarItems.push(tab);
		}

	
	}
}