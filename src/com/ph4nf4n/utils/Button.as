package com.ph4nf4n.utils 
{
	import com.ph4nf4n.events.ButtonEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	//TODO:
	/*
	1:鼠标放上去手势
	2:文字居中问题
	*/
	public class Button extends Sprite
	{
		private var button:Sprite = new Sprite();
		
		public  var textLabel:TextField;
		private var _text:String;
		private var _width:Number;
		private var _height:Number;
		private var _noraml_background_color:uint=0xf90f90;
		private var _hover_background_color:uint=0xD4D4D4;

		
		public function Button($x:Number=0, $y:Number=0, $w:Number=50, $h:Number=20)
		{
			this.x = $x;
			this.y = $y;
			this._width = $w;
			this._height = $h;
		
			draw();
			button.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler, false, 0, true);
			button.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler, false, 0, true);
			button.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler, false, 0, true);
			button.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler, false, 0, true);
			addChild(button);
		}
		
		private function draw():void {
			button.graphics.clear();
			button.graphics.beginFill(_noraml_background_color);
			button.graphics.drawRoundRect(0, 0,this._width,this._height,0,0);
			button.graphics.endFill();

			textLabel= new TextField();
			textLabel.text = "Button";
			textLabel.x = 0;
			textLabel.y = 11;
			textLabel.width = this._width;
			textLabel.height = this._height;

			textLabel.selectable = false;
			var _tft:TextFormat = new TextFormat();
			_tft.align = TextFormatAlign.CENTER;
			_tft.size = 12;
			//_tft.color = 0xFFFF00;
			_tft.font = "Microsoft Yahei,STXihei,SimSun,Arial,Verdana";
			textLabel.defaultTextFormat = _tft;

			button.addChild(textLabel);			
		}


		
		/**
		 *设置按钮背景颜色
		 * */
		public function set backGroundColor($color:uint):void 
		{
			button.graphics.clear();
			button.graphics.beginFill($color); // grey color
			button.graphics.drawRoundRect(0,0,this.width,this.height, 2, 2); // x, y, width, height, ellipseW, ellipseH
			button.graphics.endFill();
		} 
		
		/**
		 * 响应鼠标按钮进入事件
		 * */
		public function onMouseOverHandler(event:MouseEvent):void
		{
			trace("onMouseOverHandler2");			
			this.backGroundColor=0x296898;
			
			//Mouse.cursor = "button";
		}
		
		/**
		 * 响应鼠标从按钮离开事件
		 * */
		public function onMouseOutHandler(event:MouseEvent):void
		{
			trace("onMouseOutHandler");
			this.backGroundColor=this._noraml_background_color;
		}
		
		/**
		 * 响应鼠标从按钮按下事件
		 * */
		public function onMouseDownHandler(event:MouseEvent):void
		{
			trace("onMouseDownHandler");
			dispatchEvent(new ButtonEvent(ButtonEvent.ON_BUTTON_CLICK));
		}
		
		/**
		 * 响应鼠标从按钮抬起事件
		 * */
		public function onMouseUpHandler(event:MouseEvent):void
		{
			trace("onMouseUpHandler");
		}
		
		
		/*
		Units.test
		
		btn = new Button(50,100,120,45);
		btn.textLabel.text= "button.text";
		btn.addEventListener(ButtonEvent.ON_BUTTON_CLICK,onBtnClick);
		addChild(btn);
		
		public function onBtnClick(event:ButtonEvent):void {
			btn.textLabel.text= "btn.click";
		}

		*/
		
	}
}