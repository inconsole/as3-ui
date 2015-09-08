package com.ph4nf4n.core.MQTT
{
	import flash.events.Event;
	
	public class MQTTEvent extends Event
	{
		public var message:String;
		public static const CONNECT:String = "mqttConnect";
		public static const CLOSE:String   = "mqttClose";
		public static const MESSGE:String  = "mqttMessage";
		public static const ERROR:String   = "mqttError";
		public static const PUBLISH:String = "mqttPublish";
		
		public function MQTTEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,message:String=null)
		{
			super(type, bubbles, cancelable);
			//
			this.message = message;
		}
		
		override public function clone():Event
		{
			return new MQTTEvent(type,bubbles,cancelable,message);
		}
	}
}