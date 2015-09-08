package com.ph4nf4n.core.MQTT
{
	import com.ph4nf4n.core.MQTT.MQTTEvent;
	import com.ph4nf4n.core.MQTT.MQTTProtocol;
	import com.ph4nf4n.core.MQTT.MQTTUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	[Event(name="mqttConnect", type="com.godpaper.mqtt.as3.core.MQTTEvent")]
	[Event(name="mqttClose", type="com.godpaper.mqtt.as3.core.MQTTEvent")]
	[Event(name="mqttMessage", type="com.godpaper.mqtt.as3.core.MQTTEvent")]
	[Event(name="mqttError", type="com.godpaper.mqtt.as3.core.MQTTEvent")]
	[Event(name="mqttPublish", type="com.godpaper.mqtt.as3.core.MQTTEvent")]
	
	public class MQTTClient extends EventDispatcher
	{
		private static const MAX_LEN_UUID:int=23;
		private static const MAX_LEN_TOPIC:int=7;
		private static const MAX_LEN_USERNAME:int=12;
		
		private var socket:Socket;
		private var msgid:int=1;
		public var host:String;
		public var port:Number;
		public var clientid:String; 
		public var will:Array; 
		public var username:String;
		public var password:String;
		public var cleanSession:Boolean=true;
		public var topicname:String="system";
		public var keepalive:int=10;
		public var debug:Boolean = false;
		
		private var keep_alive_timer:Timer;
		private var servicing:Boolean;
		private var _isConnect:Boolean;
		
		private var connectMessage:MQTTProtocol;
		private var pingMessage:ByteArray;
		private var disconnectMessage:ByteArray;
		private var subscribeMessage:MQTTProtocol;
		private var publishMessage:MQTTProtocol;
		
		public function MQTTClient(host:String=null, port:int=1883,username:String=null, password:String=null, topicname:String=null, clientid:String=null, will:Boolean=true,cleanSession:Boolean=true){
			if (host)
				this.host=host;
			if (port)
				this.port=port;
			if (username)
				this.username = username;
			if (password) 
				this.password = password;
			if (topicname)
				this.topicname = topicname;
			if (clientid) {
				this.clientid = clientid;
			}
			else {
				this.clientid = MQTTUtil.createUID(MAX_LEN_UUID);
			}
			if (will)
				this.will = MQTTProtocol.WILL;
			if (cleanSession)
				this.cleanSession = cleanSession;
			
			Security.allowDomain("*");
			socket=new Socket(host, port);
			socket.addEventListener(Event.CONNECT, onConnect); //dispatched when the connection is established
			socket.addEventListener(Event.CLOSE, onClose); //dispatched when the connection is closed
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError); //dispatched when an error occurs
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData); //dispatched when socket can be read
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecError); //dispatched when security gets in the way

			keep_alive_timer=new Timer(keepalive / 2 * 1000);
			keep_alive_timer.addEventListener(TimerEvent.TIMER, onPing);
		}
		
		//订阅
		public function subscribe(topicnames:Vector.<String>, Qoss:Vector.<int>, QoS:int=0):void
		{
			var bytes:ByteArray = new ByteArray();
			
			if( QoS ) msgid++;
			bytes.writeByte(msgid >> 8);
			bytes.writeByte(msgid % 256);
			
			var i:int;			
			for(i = 0; i < topicnames.length; i++){
				writeString(bytes, topicnames[i]);
				bytes.writeByte(Qoss[i]);
			}
			//TODO:send subscribe message
			var type:int=MQTTProtocol.SUBSCRIBE;
			type += (QoS << 1);
			
			this.subscribeMessage=new MQTTProtocol();
			this.subscribeMessage.subscribeData(type,bytes);
			socket.writeBytes(this.subscribeMessage);
			socket.flush();
			
			trace("Subscribe sent");
		}
		
		//发布
		public function publish(topicname:String, message:String, QoS:int=0, retain:int=0):void {
			var bytes:ByteArray=new ByteArray();
			writeString(bytes, topicname);
			if (QoS)
			{
				msgid++;
				bytes.writeByte(msgid >> 8);
				bytes.writeByte(msgid % 256);
			}
			writeString(bytes, message);
			//
			var type:int=MQTTProtocol.PUBLISH;
			//	type += (QoS << 1);
			if(QoS) type += (QoS << 1); //@ph4nf4n.fix
			if (retain)
				type += 1;
			this.publishMessage=new MQTTProtocol();
			this.publishMessage.publishData(type,bytes);
			
			this.publishMessage.debug(bytes);
			this.publishMessage.debug(this.publishMessage);
			
			trace("MQTT publishMessage.length:{0}", this.publishMessage.length);
			this.socket.writeBytes(this.publishMessage, 0, this.publishMessage.length);
			this.socket.flush();
			
			//
			trace("Publish sent");
		}
		
		/*
		 *Event
		 *
		*/
		protected function onConnect(event:Event):void {
			trace("connect");
			if (this.connectMessage == null)
			{
				this.connectMessage=new MQTTProtocol();
				var bytes:ByteArray=new ByteArray();
				bytes.writeByte(0x00); //0
				bytes.writeByte(0x06); //6
				bytes.writeByte(0x4d); //M
				bytes.writeByte(0x51); //Q
				bytes.writeByte(0x49); //I
				bytes.writeByte(0x73); //S
				bytes.writeByte(0x64); //D
				bytes.writeByte(0x70); //P
				bytes.writeByte(0x03); //Protocol version = 3
				//Connect flags
				var type:int=0;
				if (cleanSession)
					type+=2;
				//			Will flag is set (1)
				//			Will QoS field is 1
				//			Will RETAIN flag is clear (0)
				if (will)//(willFlag,willQos,willRetain)
				{
					type+=4;
					type+=this.will['qos'] << 3;
					if (this.will['retain'])
						type+=32;
				}
				if (username)
					type+=128;
				if (password)
					type+=64;
				bytes.writeByte(type); //Clean session only
				this.connectMessage.debug(bytes,"p-c");
				//Keep Alive timer
				bytes.writeByte(keepalive >> 8); //Keepalive MSB
				bytes.writeByte(keepalive & 0xff); //Keepaliave LSB = 60
				writeString(bytes, clientid);
				writeString(bytes, username ? username : "");
				writeString(bytes, password ? password : "");
				this.connectMessage.messageType(MQTTProtocol.CONNECT); //Connect
				this.connectMessage.writeMessageValue(bytes); //Connect
			}
			trace("MQTT connectMesage.length:{0}", this.connectMessage.length);
			this.socket.writeBytes(this.connectMessage, 0, this.connectMessage.length);
			this.socket.flush();
			//dispatch event
			//just TCP/IP connection not MQTT connection
			//this.dispatchEvent(new MQTTEvent(MQTTEvent.CONNECT, false, false));
			this._isConnect = true;
		}
		
		protected function onClose(event:Event):void {
			trace("onClose: ");
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			trace("onError: ");
		}
		
		protected function onSecError(event:SecurityErrorEvent):void
		{
			trace("onSecError: ");
			//dispatch event
			//this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false));
		}
		
		protected function onSocketData(event:ProgressEvent):void {
			var type:uint = socket.readUnsignedByte();
			trace(socket.readUnsignedByte());
			trace("0x",type.toString(16));
			
			while( socket.bytesAvailable ){
				var data:ByteArray = new ByteArray();
				socket.readBytes(data);
				
				switch (type)
				{
					case MQTTProtocol.CONNACK:	//0x20 连接成功
						onConnack(data);
						break;
					case MQTTProtocol.PINGRESP:	//0xd0	ping成功返回
						onPingresp(data);
						break;
					case MQTTProtocol.SUBACK:	//0x90	订阅返回
						onSuback(data);
						break;
					case MQTTProtocol.PUBACK:	//0x40	qos=1 publish响应
						onPuback(data);
						break;
					case MQTTProtocol.PUBREC:	//		qos=2 publish响应
						onPubrec(data);
						break;
					default:
						break;
				}
			}


		}
		
		protected function onConnack(data:ByteArray):void
		{
			data.position=1;
			switch (data.readUnsignedByte())
			{
				case 0x00:	//连接成功
					trace("socket connect");
					servicing = true;
					keep_alive_timer.start();
					//dispatch event
					subscribe(Vector.<String>(["system","demo","zhangsan123"]), Vector.<int>([1,2,2]), 1);
					break;
				default:
					break;
			}
		}
		
		//订阅成功返回
		protected function onSuback(data:ByteArray):void
		{
			//TODO
			publish("demo","123456中文看看9月7日上午 123456中文看看9月7日上午 123456中文看看9月7日上午12345678901234567890",1);
		}
		
		//pushlish成功返回
		protected function onPuback(data:ByteArray):void
		{
			//TODO
		}
		
		protected function onPubrec(data:ByteArray):void
		{
			//TODO
		}

		//向服务器发送ping心跳包
		protected function onPing(event:TimerEvent):void
		{
			if (this.pingMessage == null)
			{
				this.pingMessage=new ByteArray();
				
				this.pingMessage.writeByte(MQTTProtocol.PINGREQ);
				this.pingMessage.writeByte(0);
				this.pingMessage.writeBytes(new ByteArray);
			}
			//trace("MQTT pingMessage.length:{0}", this.pingMessage.length);
			socket.writeBytes(this.pingMessage, 0, this.pingMessage.length);
			socket.flush();
		}
		
		//服务器ping返回
		protected function onPingresp(data:ByteArray):void
		{
			//TODO
		}
		
		//关闭服务器连接
		public function close():void
		{
			if (this.disconnectMessage == null)
			{
				this.disconnectMessage=new ByteArray();
				this.disconnectMessage.writeByte(MQTTProtocol.DISCONNECT);
				this.disconnectMessage.writeByte(0);
				this.disconnectMessage.writeBytes(new ByteArray);
			}
			socket.writeBytes(this.disconnectMessage);
			socket.flush();
			socket.close();
			//dispatch event
			//this.dispatchEvent(new MQTTEvent(MQTTEvent.CLOSE, false, false));
		}
		
		protected function writeString(bytes:ByteArray, str:String):void
		{
			var len:int=str.length;
			var msb:int=len >> 8;
			var lsb:int=len % 256;
			bytes.writeByte(msb);
			bytes.writeByte(lsb);
			bytes.writeMultiByte(str, 'utf-8');
		}
		
		protected function print_debug(bytes:ByteArray):void {
			var s:String = "";
			bytes.position = 0;
			while (bytes.bytesAvailable)
			{
				s += "0x" + bytes.readByte().toString(16) + " ";
				//trace("" + bytes.readByte().toString(2) + "  " + "0x" + bytes.readByte().toString(16) + "");
			}
			if (s.length > 0) s = s.substr(0, s.length - 1);
			trace("---------------------------->");
			trace("bytes:", s);
		}
		
		public function test():void
		{
			trace("demo");
		}
	}
}