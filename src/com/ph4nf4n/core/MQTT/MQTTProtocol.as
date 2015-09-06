package com.ph4nf4n.core.MQTT
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	public class MQTTProtocol extends ByteArray
	{
		public static const PROTOCOL_NAME:String="MQIsdp";
		public static const PROTOCOL_VERSION:Number=3;
		
		/* Message types */
		public static const CONNECT:uint=0x10;
		public static const CONNACK:uint=0x20;
		public static const PUBLISH:uint=0x30;
		public static const PUBACK:uint=0x40;
		public static const PUBREC:uint=0x50;
		public static const PUBREL:uint=0x60;
		public static const PUBCOMP:uint=0x70;
		public static const SUBSCRIBE:uint=0x80;
		public static const SUBACK:uint=0x90;
		public static const UNSUBSCRIBE:uint=0xA0;
		public static const UNSUBACK:uint=0xB0;
		public static const PINGREQ:uint=0xC0;
		public static const PINGRESP:uint=0xD0;
		public static const DISCONNECT:uint=0xE0;
		//
		public static const CONNACK_ACCEPTED:uint=0;
		public static const CONNACK_REFUSED_PROTOCOL_VERSION:int=1;
		public static const CONNACK_REFUSED_IDENTIFIER_REJECTED:int=2;
		public static const CONNACK_REFUSED_SERVER_UNAVAILABLE:int=3;
		public static const CONNACK_REFUSED_BAD_USERNAME_PASSWORD:int=4;
		public static const CONNACK_REFUSED_NOT_AUTHORIZED:int=5;
		
		public function MQTTProtocol()
		{
		}
	}
}