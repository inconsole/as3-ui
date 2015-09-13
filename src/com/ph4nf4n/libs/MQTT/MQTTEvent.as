package com.ph4nf4n.core.MQTT
{
	import flash.events.Event;
	
	public class MQTTEvent extends Event
	{
		public var message:String;
		public var msgObj:Object;
		public static const CONNECT:String = "mqttConnect";
		public static const CLOSE:String   = "mqttClose";
		public static const MESSAGE:String  = "mqttMessage";
		public static const ERROR:String   = "mqttError";
		public static const PUBLISH:String = "mqttPublish";
		
		public function MQTTEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,message:String=null,msgObj:Object=null)
		{
			super(type, bubbles, cancelable);
			//
			this.message = message;
			this.msgObj = msgObj;
		}
		
		override public function clone():Event
		{
			return new MQTTEvent(type,bubbles,cancelable,message,msgObj);
		}
	}
}