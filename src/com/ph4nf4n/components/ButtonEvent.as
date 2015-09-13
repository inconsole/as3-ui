package com.ph4nf4n.events
{
	import flash.events.Event;
	
	public class ButtonEvent extends Event
	{
		public static const ON_BUTTON_CLICK:String="ON_BUTTON_CLICK";
		public function ButtonEvent(type:String)
		{
			super(type);
		}
	}
}