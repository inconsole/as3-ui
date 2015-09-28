package com.ph4nf4n.components
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class UIImage  extends Sprite
	{
		public var _x:int;
		public var _y:int;
		public var _width:int;
		public var _height:int;
		public var _image:String;
		public var _eventObj:Object = new Object();
		
		private var imageOutLoader:Loader = new Loader();
		private var imageOverLoader:Loader = null;
		
		private var imageSprite:Sprite =new Sprite();
		
		
		public function UIImage(x:int=0,y:int=0,width:int=0,height:int=0)
		{
			super();
			if(x) _x = x;
			if(y) _y = y;
			if(width) _width = width;
			if(height) _height = height;
			
			imageSprite.buttonMode = true;
			addChild(imageSprite);
			innerEventListener();
		}
		
		public function setFrame(x:int,y:int,width:int,height:int):void {
			_x = x;
			_y = y;
			_width = width;
			_height = height;
		}
		
		/*
		* @method 默认事件监听器
		*/
		private function innerEventListener():void {
			imageOutLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void{
				//image.load.complete
				imageOutLoader.content.x = _x;
				imageOutLoader.content.y = _y;
				imageOutLoader.content.width = _width;
				imageOutLoader.content.height = _height;
				if(_eventObj.Complete != undefined) _eventObj.Complete.apply(this);
			});
			
			imageOutLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function():void{
				//image.load.error
				if(_eventObj.Error != undefined) _eventObj.Error.apply(this);
			});
			
			imageSprite.addEventListener(MouseEvent.ROLL_OVER,function():void{
				if(imageOverLoader) {
					imageSprite.removeChild(imageOutLoader);
					imageSprite.addChild(imageOverLoader);
				}
				if(_eventObj.MouseOver != undefined) _eventObj.MouseOver.apply(this);
			});
			imageSprite.addEventListener(MouseEvent.ROLL_OUT,function():void{
				if(imageOverLoader) {
					imageSprite.removeChild(imageOverLoader);
					imageSprite.addChild(imageOutLoader);
				}
				if(_eventObj.MouseOut != undefined) _eventObj.MouseOut.apply(this);
			});
		}
		
		/*
		* @method 传入外部自定义事件监听器
		*/
		public function EventListener(eventObj:Object):void {
			_eventObj = eventObj;
			for (var item:String in eventObj) {
				switch(item) {
					case "Click":
						imageSprite.addEventListener(MouseEvent.CLICK,eventObj[item]);
						break;
					case "MouseOver":
						//loader.addEventListener(MouseEvent.MOUSE_OVER,eventObj[item]);
						break;
					case "MouseOut":
						//loader.addEventListener(MouseEvent.MOUSE_OUT,eventObj[item]);
					case "Complete":
						//loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventObj[item]);
						break;
					case "Error":
						//loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventObj[item]);
						break;
					default:
						break;
				}
			}
		}
		
		public function set image(url:String):void {
			imageOutLoader.load(new URLRequest(url));
			imageSprite.addChild(imageOutLoader);
		}
		
		public function set hoverImage(url:String):void {
			imageOverLoader = new Loader();
			imageOverLoader.load(new URLRequest(url));
			
			imageOverLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function():void{
				//image.load.complete
				imageOverLoader.content.x = _x;
				imageOverLoader.content.y = _y;
				imageOverLoader.content.width = _width;
				imageOverLoader.content.height = _height;
				if(_eventObj.Complete != undefined) _eventObj.Complete.apply(this);
			});
			
			imageOverLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function():void{
				//image.load.error
				imageOverLoader = null;
				if(_eventObj.Error != undefined) _eventObj.Error.apply(this);
			});
		}
	}
}


/*
Example:

var userIcon:UIImage=new UIImage();
addChild(userIcon);
userIcon.setFrame(100,200,20,20);
userIcon.image = "assets/a.png";
userIcon.hoverImage = "http://img.iknow.bdimg.com/avatar/100/r6s1g11.gif"; //可选hover

//事件可选
userIcon.EventListener({
	Complete:function():void {
		trace('图片加载成功');
	},
	Error:function():void {
		trace('图片加载失败');
	},
	Click:function():void{
		trace('图片点击事件');
	},
	MouseOver:function():void{
		trace("鼠标移入Hover事件");
	},
	MouseOut:function():void{
		trace("鼠标移出事件");
	}
});

*/