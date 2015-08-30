package com.ph4nf4n.components
{
	import flash.text.TextField;  
	import flash.text.TextFieldAutoSize;  
	import flash.text.TextFieldType;  
	import flash.text.TextFormat; 
	
	public class UITextView  extends TextField 
	{
		public function UITextView($x:Number=0,$y:Number=0,$width:Number=240,$height:Number=80)
		{
			super();  
			
			x = $x;  
			y = $y;  
			width = $width;  
			height = $height;  
			
			var _tft:TextFormat = new TextFormat();
			_tft.size = 12;
			_tft.font = "Microsoft Yahei,STXihei,SimSun,Arial,Verdana";
			defaultTextFormat = _tft;
			
			//输入状态
			type = TextFieldType.INPUT;
			
			//换行
			wordWrap = true;
			
			//边框
			border=true;
			borderColor = 0xf90f90;
			
			//背景
			background=true;
			backgroundColor=0xFFFFFF;
			
		}
	}
}