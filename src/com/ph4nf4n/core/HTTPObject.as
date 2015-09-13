package com.ph4nf4n.core
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class HTTPObject
	{
		public var urlLoader:URLLoader = new URLLoader();
		public var data_type:String = "text";
		public var resultData:Object;
		public function HTTPObject()
		{
			//
		}
		//
		
		public function GET(url:String):void {
			urlLoader.load(new URLRequest(url));
			//urlLoader.addEventListener(Event.COMPLETE, httpComplete);
		}

		public function GetJson(url:String,eventObj:Object):void {
			GET(url);
			addHttpEventListener(eventObj);
		}
		
		public function addHttpEventListener(eventObj:Object):void {
			for (var item:String in eventObj) {
				switch(item) {
					case "complete":
						urlLoader.addEventListener(Event.COMPLETE, eventObj[item]);
						break;
					default:
						break;
				}
			}
		}
		
	}
}