package com.ph4nf4n.components
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UILabel extends Sprite
	{
		private var _label:Sprite;
		private var _textField:TextField;
		private var _TextFormat:TextFormat;
		
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

		
		public function UILabel(option:Object)
		{
			super();
			
			options = extend(option, setting);
			
			addChildren();
			
			draw();
			
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
		* @method 确定舞台上需要添加的对象
		*/
		private function addChildren():void {
			_label = new Sprite();
			_textField = new TextField();
			
			_label.addChild(_textField);
			
			addChild(_label);
		}
		
		/*
		* @method 实现舞台上需要添加的对象
		*/
		private function draw():void {
			drawBg(options.bgColor);
			drawTxt();
		}
		
		/*
		* @method 改变文本样式
		*/
		private function drawTxt():void {
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
		}
		
		private function drawBg(color:uint):void {
			this.graphics.clear();
			this.graphics.beginFill(color, 1);
			this.graphics.drawRoundRect(options.x,options.y, options.width, options.height,options.borderRadius, options.borderRadius);
			this.graphics.endFill();
		}
	}
}