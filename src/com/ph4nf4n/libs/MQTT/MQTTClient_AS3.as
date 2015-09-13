package
{
	import flash.display.Sprite;
	import flash.system.Security;
	
	import com.ph4nf4n.core.MQTT.MQTTClient;
	import com.ph4nf4n.core.MQTT.MQTTEvent;
	
	
	public class MQTTClient_AS3 extends Sprite
	{

		private var mqttSocket:MQTTClient;
		//private static const MY_HOST:String="127.0.0.1"; 
		//private static const MY_PORT:Number=1883;

		public function MQTTClient_AS3()
		{
			this.mqttSocket=new MQTTClient("127.0.0.1");
			
			Security.allowDomain("*");
			mqttSocket.addEventListener(MQTTEvent.CONNECT, onConnect);
			mqttSocket.addEventListener(MQTTEvent.CLOSE, onClose);
			mqttSocket.addEventListener(MQTTEvent.ERROR, onError);
			mqttSocket.addEventListener(MQTTEvent.MESSAGE, onMessage);
			
			mqttSocket.connect();
		}
		
		private function onConnect(event:MQTTEvent):void
		{
			trace("连接MQTT服务器成功");
			
			//订阅频道(两个:system,demo)
			mqttSocket.subscribe(Vector.<String>(["system","demo"]), Vector.<int>([1,2]), 1);
		
			//发布消息
			mqttSocket.publish("demo","this a message test ",1);
		}
		
		private function onClose(event:MQTTEvent):void
		{
			trace("MQTT服务器关闭");
		}
		
		private function onMessage(event:MQTTEvent):void {
			trace("接收消息");
			
			var TopicName:String = event.msgObj['topic'];
			var TopicContent:String = event.msgObj['payload'];
			
			trace("topic :",TopicName);
			trace("payload :",TopicContent);
		}
		
		private function onError(event:MQTTEvent):void
		{
			trace("MQTT 出错");
		}
	}
	
}