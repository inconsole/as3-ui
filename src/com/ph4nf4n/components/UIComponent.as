package com.ph4nf4n.components
{
	import flash.display.Sprite;
	
	public class UIComponent  extends Sprite
	{
		protected var _x:int;
		protected var _y:int;
		protected var _width:int;
		protected var _height:int;
		
		public function UIComponent()
		{
			//
		}
		
		public function setFrame(x:int,y:int,width:int,height:int):void {
			_x = x;
			_y = y;
			_width = width;
			_height = height;
		}
	}
}