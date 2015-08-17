package com.ph4nf4n.utils
{
	import flash.display.Sprite;
	
	public class UIComponents extends Sprite
	{
		public function UIComponents()
		{
		}
		
		/*
		* @method 合并默认参数和传递参数
		*/
		protected function extend(des:Object, sor:Object):Object {
			for (var item:String in sor) {
				if (!des[item]) {
					des[item] = sor[item];
				}
			}
			return des;
		}
	}
}