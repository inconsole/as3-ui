package com.ph4nf4n.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class UIHtmlControl extends Sprite
	{
		public var _x:int;
		public var _y:int;
		public var _width:int;
		public var _height:int;
		
		public function UIHtmlControl(x:int=0,y:int=0,width:int=0,height:int=0)
		{
			super();	
			if(x) _x = x;
			if(y) _y = y;
			if(width) _width = width;
			if(height) _height = height;
		}
		
		public function setFrame(x:int,y:int,width:int,height:int):void {
			_x = x;
			_y = y;
			_width = width;
			_height = height;
		}
		
		public function set text(str:String):void {
			scanText(str);
		}
		
		private function scanText(str:String):void {
			var tmp:String;
			for(var i:int=0;i<str.length;i++) 
			{
				trace(str.charAt(i));
				tmp = str.charAt(i);
				if(tmp == '<') {
					trace(str.substring(i,4));
					break;
				}
				
			}
		}
	}
}
/*
example:
	var html:UIHtmlControl = new UIHtmlControl();
	html.setFrame(0,0,200,20);
	html.text="<span>我的中文名字叫<a href=''>猪猪侠</a>,</span><img src="http://m.baidu.com/image/a.jpg"><span>还差189点经验升级</span>";



*/