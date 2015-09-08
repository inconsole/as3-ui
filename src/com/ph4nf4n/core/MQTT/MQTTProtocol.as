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
		
		
		protected var fixHead:ByteArray;	//固定
		protected var varHead:ByteArray;	//可变
		protected var payLoad:ByteArray;	//
		
		protected var type:uint;
		protected var remainingLength:uint;
		
		public static var WILL:Array;
		/* static block */
		{
			WILL = [];
			//fake manual writing (big-endian)
			WILL['qos'] = 0x01;
			WILL['retain'] = 0x01;
		}
		
		public function MQTTProtocol():void
		{
			super();
		}
		
		public function messageType(value:int):void {
			type = value & 0xF0;
		}
		
		public function writeMessageType(value:int):void {
			//
		}
		
		public function writeMessageValue(value:*):void {
			if( payLoad == null )
				payLoad = new ByteArray();
			payLoad.writeBytes(value);
			this.serialize();
		}
		
		public function serialize():void {
			switch( type ){
				case CONNECT:
					remainingLength = payLoad.length;
					
					if( fixHead == null )
						fixHead = new ByteArray();
					fixHead.clear();
					fixHead.writeByte(CONNECT);
					fixHead.writeByte(remainingLength);

					this.position=0;
					this.writeBytes(fixHead);
					
					this.position = 2;
					this.writeBytes(payLoad);
					break;
				case SUBSCRIBE:
					remainingLength = payLoad.length;
					
					if( fixHead == null )
						fixHead = new ByteArray();
					fixHead.writeByte(130);
					fixHead.writeByte(remainingLength);
					
					this.position=0;
					this.writeBytes(fixHead);
					
					this.position = 2;
					this.writeBytes(payLoad);
					break;
				default:
					break;
			}
		}
		
		//构造订阅数据包
		public function subscribeData(msgType:int,buffer:ByteArray):void {
			var remaining_length:int  = buffer.length; //剩余长度
			
			this.position=0;
			//fix
			this.writeByte(msgType);
			this.writeByte(remaining_length);
			
			//payload
			this.writeBytes(buffer);
		}
		
		//构造发布数据包
		public function publishData(msgType:int,buffer:ByteArray):void {
			var remaining_length:int  = buffer.length;
			
			this.position=0;
			//fix
			this.writeByte(msgType);
			this.writeByte(remaining_length);
			
			//payload
			this.writeBytes(buffer);
		}
		
		//计算publish消息长度
		public function setmsglength(len:int) {
			//
			/*
			$string = "";
			do{
			$digit = $len % 128;
			$len = $len >> 7;
			// if there are more digits to encode, set the top bit of this digit
			if ( $len > 0 )
			$digit = ($digit | 0x80);
			$string .= chr($digit);
			}while ( $len > 0 );
			return $string;
			*/
			
		}
		
		
		public function debug(bytes:ByteArray,type:String="info"):void {
			var s:String = "";
			bytes.position = 0;
			while (bytes.bytesAvailable)
			{
				s += "0x" + bytes.readByte().toString(16) + " ";
			}
			if (s.length > 0) s = s.substr(0, s.length - 1);
			trace("[",type,"]","bytes:", s);
		}
	}
}