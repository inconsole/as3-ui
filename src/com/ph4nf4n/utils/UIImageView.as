package com.ph4nf4n.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class UIImageView  extends Sprite
	{
		protected var bitmap : Bitmap;
		private var loader : Loader;
		private var imageURL : String;
		// 参数列表
		private var options:Object = {};
		
		// 默认参数列表
		private var setting:Object = {
			x: 0,
			y: 0,
			width: 60,
			height: 30,
			imageUrl:null
		};
		
		public function UIImageView(option:Object)
		{
			super();
			options = extend(option, setting);
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
		
		/*
		* @method 插件内置事件监听器
		* */
		private function innerEventListener():void {
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onImageLoaded);
		}
		
		/*
		* @method 给按钮绑定指定的事件
		* @param {Function} click 当按钮点击后发生的事件
		* @param {Function} MouseOver 当按钮移过发生的事件
		* @param {Function} MouseOut 当按钮移出后发生的事件
		* @param {Function} MouseDown 当按键按下发生的事件
		* @param {Function} MouseUp 当按键抬起发生的事件
		*/
		public function addImageEventListener(eventObj:Object):void {
			loader = new Loader ();
			for (var item:String in eventObj) {
				switch(item) {
					case "Complete":
						loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventObj[item]);
						break;
					case "IO_Error":
						loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventObj[item]);
						break;
					default:
						break;
				}
			}
		}
		
		public function load(url:String):void {
			innerEventListener();
			
			this.options.imageUrl = url;
			loader.load (new URLRequest (this.options.imageUrl), new LoaderContext (true));
		}
		
		public function onImageLoaded(e:Event):void {
			var bytes : ByteArray = loader.contentLoaderInfo.bytes;
			if(loader) {
				//loader.unload ();
				loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onImageBytesLoaded);
				
				var lc:LoaderContext = new LoaderContext();
				lc.allowCodeImport = true;
				loader.loadBytes (bytes,lc);
			}
		}
		
		private function onImageBytesLoaded (e:Event) : void
		{
			//var bitmapData : BitmapData = new BitmapData (loader.contentLoaderInfo.width, loader.contentLoaderInfo.height);
			var bitmapData : BitmapData = new BitmapData (100, 70);
			bitmapData.draw (loader);
			
			bitmap = new Bitmap (bitmapData);
			bitmap.smoothing = true;
			
			addChild (bitmap);
			
			loader.unload ();
			loader = null;
		}
		
		public function test():void {
			trace("test");
		}
	}
}