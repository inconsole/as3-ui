package com.ph4nf4n.core.MQTT
{
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
		
		public function MQTTSocket(host:String=null, port:int=1883,username:String=null, password:String=null, topicname:String=null, clientid:String=null, will:Boolean=true,cleanSession:Boolean=true){
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
			if (clientid)
				this.clientid = clientid;
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
			//
		}
		
		protected function onClose(event:Event):void {
			print_debug("onClose: {0}", event);
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			print_debug("onError: {0}", event);
		}
		
		protected function onSecError(event:SecurityErrorEvent):void
		{
			print_debug("onSecError: {0}", event);
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
		
		public function MQTTClient()
		{
			//
		}
	}
}