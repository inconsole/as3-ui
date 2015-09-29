package com.ph4nf4n.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	public class UILabel extends Sprite
	{
		private var _label:Sprite;
		private var _textField:TextField;
		private var _TextFormat:TextFormat;
		
		public var _x:int;
		public var _y:int;
		public var _width:int;
		public var _height:int;
		protected var _text:String = "";
		
		// 参数列表
		private var options:Object = {};
		
		// 默认参数列表
		private var setting:Object = {
			x: 0,
			y: 0,
			width: 160,
			height: 26,
			text: "UILabel",
			bgColor: 0xFFFFFF,
			txtColor: 0xf90f90,
			txtFontSize: 12,
			border: 0,
			borderColor: 0xf90f90,
			borderRadius: 0
		};

		
		public function UILabel(x:int=0,y:int=0,width:int=0,height:int=0)
		{
			super();	
			if(x) _x = x;
			if(y) _y = y;
			if(width) _width = width;
			if(height) _height = height;
			
			addChildren();
			
			//draw();
			
			/*
			_textField = new TextField();
			addChild(_textField);

			
			
			_TextFormat = new TextFormat();
			_TextFormat.size = options.txtFontSize;
			//_TextFormat.font = "Microsoft Yahei,STXihei,SimSun,Arial,Verdana";
			_textField.defaultTextFormat = _TextFormat;
			
			_textField.text = options.text;
			_textField.textColor = options.txtColor;
			_textField.width = options.width;
			_textField.height = _textField.textHeight+5;
			_textField.x = options.x;
			_textField.y = (options.height - _textField.height) / 2 + options.y;
			*/
			
		}

		public function setFrame(x:int,y:int,width:int,height:int):void {
			_x = x;
			_y = y;
			_width = width;
			_height = height;
		}

		/*
		* @method 确定舞台上需要添加的对象
		*/
		private function addChildren():void {
			_label = new Sprite();
			_textField = new TextField();
			
			drawTxt();
			
			_label.addChild(_textField);
			addChild(_label);
			
		}
		
		public function set text(str:String):void {
			_textField.text = str;
			
		}
		
		public function set htmlText(str:String):void {
			_textField.htmlText = str;
		}
		
		public function set backgroundColor(color:uint):void {
			drawBg(color);
		}
		
		public function set textColor(color:uint):void {
			_textField.textColor = color;
		}

		/*
		* @method 改变文本样式
		*/
		private function drawTxt():void {
			_TextFormat = new TextFormat();
			_TextFormat.size = 14;
			//_TextFormat.font = "Microsoft Yahei,STXihei,SimSun,Arial,Verdana";
			_textField.defaultTextFormat = _TextFormat;

			_textField.text = _text;
			_textField.x = _x;
			_textField.y = _y;
			_textField.width = _width;
			_textField.height = 18;
			_textField.selectable = false;
			_textField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		private function drawBg(color:uint):void {
			_label.graphics.clear();
			_label.graphics.beginFill(color, 1);
			_label.graphics.drawRoundRect(_x, _y, _width,_height,0, 0);
			_label.graphics.endFill();
		}
	}
}

/*
example:
	//UILable
	var title:UILabel = new UILabel(100,150,160,20);
	/title.setFrame(100,150,160,20);
	title.text = "还差183点经验值";
	//title.htmlText = "还差<font color='#F00F00'> 183 </font>点经验值";
	//title.backgroundColor = 0x296898;
	//title.textColor = 0xF00F00;
	addChild(title);



*/