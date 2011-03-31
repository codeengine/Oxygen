package net.codeengine.windowmanagement.animations
{
	import flash.events.Event;
	
	import net.codeengine.windowmanagement.IPopover;

	public class PopoverAnimationEvent extends Event
	{
        public static const POPOVER_DISAPPEAR_COMPLETE:String = "animationComplete";
        
        public var popover:IPopover;
		public function PopoverAnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}