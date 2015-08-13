package com.ph4nf4n.events
{
	import flash.events.Event;
	
	public class CheckBoxEvent extends Event 
	{
		public static const ON_CHECKED_CHANGED:String="ON_CHECKED_CHANGED";
		
		public function CheckBoxEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,bubbles, cancelable);
		}
	}
}