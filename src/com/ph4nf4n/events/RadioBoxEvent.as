package com.ph4nf4n.events
{
	import flash.events.Event;
	
	public class RadioBoxEvent extends Event
	{
		public static const ON_RADIO_CHANGED:String="ON_RADIO_CHANGED";
		public function RadioBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,bubbles, cancelable);
		}
	}
}