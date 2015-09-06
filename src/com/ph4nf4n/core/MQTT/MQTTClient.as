package com.ph4nf4n.core.MQTT
{
	import com.ph4nf4n.core.MQTT.MQTTProtocol;
	import com.ph4nf4n.core.MQTT.MQTTUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	public class MQTTClient
	{
		private var socket:Socket;
		public var host:String;
		public var port:Number;
		public var clientid:String; 
		public var will:Array; 
		public var username:String;
		public var password:String;
		public var cleanSession:Boolean=true;
		public var topicname:String="system";
		public var debug:Boolean = false;
		
		private var servicing:Boolean;
		private var _isConnect:Boolean;
		
		private var connectMessage:MQTTProtocol;
		
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
				this.clientid = MQTTUtil.createUID();
			}
			if (cleanSession)
				this.cleanSession = cleanSession;
			
			Security.allowDomain("*");
			socket=new Socket(host, port);
			socket.addEventListener(Event.CONNECT, onConnect); //dispatched when the connection is established
			socket.addEventListener(Event.CLOSE, onClose); //dispatched when the connection is closed
			socket.addEventListener(IOErrorEvent.IO_ERROR, onError); //dispatched when an error occurs
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData); //dispatched when socket can be read
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecError); //dispatched when security gets in the way

			//keep_alive_timer=new Timer(keepalive / 2 * 1000);
			//keep_alive_timer.addEventListener(TimerEvent.TIMER, onPing);
		}
		
		/*
		 *Event
		 *
		*/
		protected function onConnect(event:Event):void {
			if (this.connectMessage == null)
			{
				this.connectMessage=new MQTT_Protocol();
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
				this.connectMessage.writeMessageType(MQTT_Protocol.CONNECT); //Connect
				this.connectMessage.writeMessageValue(bytes); //Connect
			}
		}
		
		protected function onClose(event:Event):void {
			print_debug("onClose: ");
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			print_debug("onError: ");
		}
		
		protected function onSecError(event:SecurityErrorEvent):void
		{
			print_debug("onSecError: ");
			//dispatch event
			//this.dispatchEvent(new MQTTEvent(MQTTEvent.ERROR, false, false));
		}
		
		protected function onSocketData(event:ProgressEvent):void {
			//
		}
		
		
		protected function print_debug(str:String):void {
			if(this.debug) {
				trace(str);
			}
		}
		
		public function test():void
		{
			trace("demo");
		}
	}
}