/*
package com.ph4nf4n.utils
{
	public class RadioButton
	{
		public function RadioButton()
		{
		}
	}
}
*/

package com.ph4nf4n.utils
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * StormUI-RadioButton组件(单选框组件)
	 * @author xuechong 
	 * @version v20121023.0.6.1
	 * @date 2012.10.23
	 * 
	 * this  -->  radio(mc)独立一个单选框
	 * */
	public class RadioButton extends Sprite
	{
		private var _labels:Array = null;    //公有
		private var _dataArr:Array = null;    //公有
		private var _radioArr:Array = null;    //私有
		private var _skinClass:Class;
		private var _layout:String;
		private var _radioWidth:Number = 0;
		private var _radioHeight:Number = 0;
		private var _columns:int = 0;
		private var _offsetx:Number = 0;
		private var _offsety:Number = 0;
		private var _selectedIndex:int = -1;
		private var _skinType:int = 0;
		
		/**
		 * @param $x 此组件的x位置值
		 * @param $y 此组件的x位置值
		 * */
		public function RadioButton($x:Number, $y:Number)
		{
			this.x = $x;
			this.y = $y;
			_radioArr = [];
		}
		
		public function setSkin(cls:Class, skinType:int):void
		{
			_skinClass = cls;
			_skinType = skinType;
		}
		
		/**
		 * @param columns 每行的列数
		 * @param offsetx 横向偏移量
		 * @param offsety 纵向偏移量
		 * */
		public function layout(columns:int, offsetx:Number, offsety:Number):void
		{
			_columns = columns;
			_offsetx = offsetx;
			_offsety = offsety;
		}
		
		public function get labels():Array
		{
			return _labels;
		}
		
		public function set labels(value:Array):void
		{
			if(value)
			{
				if(_labels == null)
				{
					_labels = value;
					var ww:int = 0;
					var hh:int = 0;
					var i:int = 0;
					var j:int = -1;
					var k:int = 0;
					for each(var label:String in _labels)
					{
						if(j < _columns - 1)
						{
							j++;
						}
						else
						{
							j = 0;
							k++;
						}
						if(this.numChildren > k * _columns)
						{
							var che:Sprite = this.getChildAt(k * _columns) as Sprite;
							ww += che.width;
							if(j > 0)
							{
								ww += _offsetx;
							}
						}
						else
						{
							ww = 0;
							hh = this.height;
							if(k > 0)
							{
								hh += _offsety;
							}
						}
						var radio:MovieClip = new MovieClip();
						this.addChild(radio);
						radio.name = String(i);
						radio.x = ww;
						radio.y = hh;
						radio.addEventListener(MouseEvent.ROLL_OVER, onOverHandler);
						radio.addEventListener(MouseEvent.ROLL_OUT, onOutHandler);
						//radio.addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
						radio.addEventListener(MouseEvent.MOUSE_UP, onClickHandler);
						//var skin:RadioButtonSkin = new _skinClass() as RadioButtonSkin;
						//skin.selected = false;
						//radio["skin"] = skin;
						if(i == _selectedIndex)
						{
							//skin.selected = true;
						}
						//skin.initSkin(radio, this, _skinType);
						var tf:TextField = new TextField();
						tf.name = "tfText";
						tf.x = radio.width;
						tf.autoSize = TextFieldAutoSize.LEFT;
						tf.selectable = tf.mouseEnabled = tf.mouseWheelEnabled = false;
						tf.text = label;
						radio.addChild(tf);
						_radioArr.push(radio);
						i++;
					}
				}
				else
				{
					_labels = [];
					_labels = value;
					var m:int = 0;
					for each(var r:MovieClip in _radioArr)
					{
						(r.getChildByName("tfText") as TextField).text = _labels[m];
						m++;
					}
				}
			}
		}
		
		public function get selectedText():String
		{
			return _labels[_selectedIndex];
		}
		
		public function get selectedData():Object
		{
			return _dataArr[_selectedIndex];
		}
		
		public function get dataArr():Array
		{
			return _dataArr;
		}
		
		public function set dataArr(value:Array):void
		{
			_dataArr = value;
		}
		
		private function onOverHandler(event:MouseEvent):void
		{
			var check:MovieClip = event.currentTarget as MovieClip;
			//(check["skin"] as RadioButtonSkin).styleOver();
		}
		
		private function onOutHandler(event:MouseEvent):void
		{
			var check:MovieClip = event.currentTarget as MovieClip;
			//(check["skin"] as RadioButtonSkin).styleNormal();
		}
		
		private function onClickHandler(event:MouseEvent):void
		{
			var spr:Sprite = event.currentTarget as Sprite;
			selectedIndex = int(spr.name);
		}
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex != value)
			{
				if(value >= 0)
				{
					_selectedIndex = value;
					updateView();
					//var e:RadioButtonEvent = new RadioButtonEvent(RadioButtonEvent.SELECTED);
					//e.selectedIndex = _selectedIndex;
					if(_labels != null)
					{
						//e.text = _labels[_selectedIndex];
					}//
					if(_dataArr != null)
					{
						//e.data = _dataArr[_selectedIndex];
					}
					//this.dispatchEvent(e);
				}
			}
		}
		
		private function updateView():void
		{
			if(_labels)
			{
				var n:int = this.numChildren;
				for(var i:int = 0; i < n; i++)
				{
					if(_selectedIndex != -1)
					{
						var radio:MovieClip = this.getChildAt(i) as MovieClip;
						//var skin:RadioButtonSkin = radio["skin"] as RadioButtonSkin;
						if(i != _selectedIndex)
						{
							//skin.selected = false;
							//skin.styleNormal();
						}
						else
						{
							//skin.selected = true;
							//skin.styleOver();
						}
					}
				}
			}
		}
		
		public function get radioHeight():Number
		{
			return _radioHeight;
		}
		
		public function set radioHeight(value:Number):void
		{
			_radioHeight = value;
		}
		
		public function get radioWidth():Number
		{
			return _radioWidth;
		}
		
		public function set radioWidth(value:Number):void
		{
			_radioWidth = value;
		}
		
		public function destroy():void
		{
			var i:int = _labels.length - 1;
			while(i >= 0)
			{
				_labels[i] = null;
				i--;
			}
			_labels.length = 0;
			_labels = null;
			if(_dataArr)
			{
				i = _dataArr.length - 1;
				while(i >= 0)
				{
					_dataArr[i] = null;
					i--;
				}
				_dataArr.length = 0;
				_dataArr = null;
			}
			i = _radioArr.length - 1;
			while(i >= 0)
			{
				(_radioArr[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OVER, onOverHandler);
				(_radioArr[i] as MovieClip).removeEventListener(MouseEvent.ROLL_OUT, onOutHandler);
				//(_radioArr[i] as MovieClip).removeEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
				(_radioArr[i] as MovieClip).removeEventListener(MouseEvent.MOUSE_UP, onClickHandler);
				//((_radioArr[i] as MovieClip)["skin"] as RadioButtonSkin).destroy();
				(_radioArr[i] as MovieClip)["skin"] = null;
				delete (_radioArr[i] as MovieClip)["skin"];
				_radioArr[i] = null;
				i--;
			}
			_radioArr.length = 0;
			_radioArr = null;
			_skinClass = null;
			_layout = null;
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
	}
}