package com.ph4nf4n.utils
{
	import flash.text.TextField;  
	import flash.text.TextFieldAutoSize;  
	import flash.text.TextFieldType;  
	import flash.text.TextFormat;
	
	//TODO:
	/*
	1:文字垂直居中问题
	*/
	public class UITextField extends TextField
	{
		public function UITextField($x:Number=0,$y:Number=0,$width:Number=100,$height:Number=20)
		{
			super();  
			x = $x;  
			y = $y;  
			width = $width;  
			height = $height;  
			
			//defaultTextFormat = new TextFormat("Verdana", 10, 0);  
			//autoSize = TextFieldAutoSize.LEFT;
			var _tft:TextFormat = new TextFormat();
			_tft.size = 14;
			_tft.font = "Microsoft Yahei,STXihei,SimSun,Arial,Verdana";
			defaultTextFormat = _tft;

			//输入状态
			type = TextFieldType.INPUT;
			
			//边框
			border=true;
			borderColor = 0xf90f90;
			
			//背景
			background=true;
			backgroundColor=0xFFFFFF;
		}
		
	}
}