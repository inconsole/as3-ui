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
	
	[Event(name="mqttConnect", type="com.ph4nf4n.core.MQTT.MQTTEvent")]
	[Event(name="mqttClose", type="com.ph4nf4n.core.MQTT.MQTTEvent")]
	[Event(name="mqttMessage", type="com.ph4nf4n.core.MQTT.MQTTEvent")]
	[Event(name="mqttError", type="com.ph4nf4n.core.MQTT.MQTTEvent")]
	[Event(name="mqttPublish", type="com.ph4nf4n.core.MQTT.MQTTEvent")]
	
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
		
		//参数集合
		private var options:Object = {};
		// 默认参数
		private var def_setting:Object = {
			host: null,
			port: 1883,
			username: null,
			password: null,
			topicname: null,
			clientid: null,
			will: true,
			cleanSession: true
		};
		
		private var keep_alive_timer:Timer;
		private var servicing:Boolean;
		private var _isConnect:Boolean;
		public  var messageObj:Object=null;
		
		private var connectMessage:MQTTProtocol;
		private var pingMessage:ByteArray;
		private var disconnectMessage:ByteArray;
		private var subscribeMessage:MQTTProtocol;
		private var publishMessage:MQTTProtocol;
		
		public function MQTTClient(host:String=null, port:int=1883,username:String=null, password:String=null, topicname:String=null, clientid:String=null, will:Boolean=true,cleanSession:Boolean=true){
		//public function MQTTClient(option:Object){
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

			//options = extend(option, def_setting);
			

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
		
		/*
		* @method 合并默认参数和传递参数
		*/
		private function extend(des:Object, sor:Object):Object {
			for (var item:String in sor) {
				if (!des[item]) {
					des[item] = sor[item];
				}
			}
			return des;
		}
		
		//连接
		public function connect(host:String=null, port:int=1883):void
		{
			if (host)
				this.host=host;
			if (port)
				this.port=port;
			socket.connect(this.host, this.port);
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
			
			//trace("MQTT publishMessage.length:{0}", this.publishMessage.length);
			this.socket.writeBytes(this.publishMessage, 0, this.publishMessage.length);
			this.socket.flush();
		}
		
		/*
		 *Event
		 *
		*/
		//TCP连接成功
		protected function onConnect(event:Event):void {
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

				//Keep Alive timer
				bytes.writeByte(keepalive >> 8); //Keepalive MSB
				bytes.writeByte(keepalive & 0xff); //Keepaliave LSB = 60
				writeString(bytes, clientid);
				writeString(bytes, username ? username : "");
				writeString(bytes, password ? password : "");
				this.connectMessage.messageType(MQTTProtocol.CONNECT); //Connect
				this.connectMessage.writeMessageValue(bytes); //Connect
			}
			//trace("MQTT connectMesage.length:{0}", this.connectMessage.length);
			this.socket.writeBytes(this.connectMessage, 0, this.connectMessage.length);
			this.socket.flush();
			//dispatch event
			//just TCP/IP connection not MQTT connection
			//this.dispatchEvent(new MQTTEvent(MQTTEvent.CONNECT, false, false));
			this._isConnect = true;
		}
		
		protected function onClose(event:Event):void {
			keep_alive_timer.stop();
			this._isConnect = false;
			
			this.dispatchEvent(new MQTTEvent(MQTTEvent.CLOSE, false, false));
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false));
		}
		
		protected function onSecError(event:SecurityErrorEvent):void
		{
			this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false));
		}
		
		protected function onSocketData(event:ProgressEvent):void {
			var type:uint = socket.readUnsignedByte();
			//trace(socket.readUnsignedByte());
			//trace("0x",type.toString(16));
			
			while( socket.bytesAvailable ){
				var data:ByteArray = new ByteArray();
				socket.readBytes(data);
				
				switch (type)
				{
					case MQTTProtocol.CONNACK:	//0x20 连接成功
						onConnack(data);
						break;
					case MQTTProtocol.PUBLISH:	//0x30	订阅消息接收
						onPublish(data);
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
				case 0x00:	//MQTT连接成功
					servicing = true;
					keep_alive_timer.start();
					//dispatch event
					this.dispatchEvent(new MQTTEvent(MQTTEvent.CONNECT, false, false,"Socket connected"));
					break;
				case 0x01:
					//dispatch event
					this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false, "Connection Refused: unacceptable protocol version"));
					break;
				case 0x02:
					//dispatch event
					this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false, "Connection Refused: identifier rejected"));
					break;
				case 0x03:
					//dispatch event
					this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false, "Connection Refused: server unavailable"));
					break;
				case 0x04:
					//dispatch event
					this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false, "Connection Refused: bad user name or password"));
					break;
				case 0x05:
					//dispatch event
					this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false, "Connection Refused: not authorized"));
					break;
				default:
					this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false, "Connection error: return unknown code"));
					break;
			}
		}
		
		//订阅成功返回
		protected function onSuback(data:ByteArray):void
		{
			//TODO
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
		
		//订阅消息接收
		protected function onPublish(data:ByteArray):void{
			/*
			两种状态
			1:消息小于127
			2:消息大于127
			
			ep: topicname:demo msg:123456
			0x0 0x4 0x64 0x65 0x6d 0x6f 0x31 0x32 0x33 0x34 0x35 0x36
			
			ep: topicname:demo msg:123456 ....... ( msg > 127)
			0x5 0x0 0x4 0x64 0x65 0x6d 0x6f 0x31 0x32 0x33 0x34 0x35 0x36
			
			订阅返回的消息，根据回来的数据包得出
			1:第一个字节不是(0x0)或者 第二个字节等于(0x0) 为 消息大于127的类型
			2: 0x0 0x4 为topicname 的长度   
			3: topicname完了之后，后面的全部为 msg 的内容
			
			(0x64 0x65 0x6d 0x6f) = demo
			(0x31 0x32 0x33 0x34 0x35 0x36) = 123456
			*/
			var data_length:uint = data.length;
			var tmp:ByteArray= new ByteArray();
			var topicName:String;
			var topicContent:String;
			var offst:int;
			
			//trace(data.length);
			//print_debug(data);
			
			data.position=1;
			data.readBytes(tmp,0,1);
			
			print_debug(tmp);
			tmp.position=0;
			var len:uint = tmp.readUnsignedByte();
			
			if(len == 0x00) { //内容长度大于>127, var-header多各字节
				data.position=2;
				tmp.position=0;
				
				data.readBytes(tmp,0,1);
				len = tmp.readUnsignedByte();
				
				//topicName
				data.position=3;
				topicName=data.readMultiByte(len, "utf");
				
				//topicContent
				data.position = 3 +len;
				topicContent=data.readMultiByte(data_length-3-len, "gb2312");
			}
			else { //<127
				//topicName
				data.position=2;
				topicName=data.readMultiByte(len, "utf");
				
				//topicContent
				data.position = 2 +len;
				topicContent=data.readMultiByte(data_length-2-len, "gb2312");
			}
			
			//trace("Publish TopicName {0}", topicName);
			//trace("Publish TopicContent {0}", topicContent);
			if(messageObj == null) {
				messageObj = new Object();
			}
			messageObj['topic'] = topicName;
			messageObj['payload'] = topicContent;
			
			this.dispatchEvent(new MQTTEvent(MQTTEvent.MESSAGE, false, false,topicName,messageObj));
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
			this.dispatchEvent(new MQTTEvent(MQTTEvent.CLOSE, false, false));
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

	}
}