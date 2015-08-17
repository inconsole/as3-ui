package com.ph4nf4n.utils
{
	import com.ph4nf4n.utils.UIComponents;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class UILabel extends UIComponents
	{
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
			txtColor: 0x000000,
			txtFontSize: 12,
			border: 0,
			borderColor: 0x000000,
			borderRadius: 0
		};
		
		public function UILabel(option:Object)
		{
			super();  
			options = super.extend(option, setting);
			
			_textField = new TextField();
			addChild(_textField);
			
			draw();
			
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
		
		/*
		* @method 实现舞台上需要添加的对象
		*/
		private function draw():void {
			//drawBg(options.bgColor);
		}
		
		private function drawBg(color:uint):void {
			graphics.clear();
			graphics.beginFill(color, 1);
			graphics.drawRoundRect(options.x,options.y, options.width, options.height,options.borderRadius, options.borderRadius);
			graphics.endFill();
		}
	}
}