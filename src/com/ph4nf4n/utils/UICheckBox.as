package com.ph4nf4n.utils
{
	import flash.display.Shape;  
	import flash.display.Sprite;  
	import flash.events.Event;  
	import flash.events.MouseEvent;  
	import flash.filters.GlowFilter;
	
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.text.TextFormat;
	
	public class UICheckBox extends Sprite
	{
		private var _tf:TextField;  
		private var _circle:Shape;  
		private var _checked:Boolean=false;  
		private var _isDowned:Boolean=false;
		
		public function get text():String  
		{  
			return _tf.text;  
		}  
		
		public function set text(value:String):void  
		{  
			if(_tf.text!=value)  
			{  
				_tf.text=value;  
				_tf.y=-5/2;  
			}  
		}  
		
		public function get checked():Boolean  
		{  
			return _checked;  
		}  
		
		public function set checked(value:Boolean):void  
		{  
			if(_checked!=value)  
			{  
				_checked=value;  
				redraw();  
				//dispatchEvent(new RadioButtonEvent(RadioButtonEvent.ON_CHECKED_CHANGED));  
			}  
		}  
		
		public function UICheckBox()  
		{  
			super();  
			initialize();  
		}  
		
		private function initialize():void  
		{  
			_tf=new TextField();  
			_tf.x=10;
			
			var _tft:TextFormat = new TextFormat();
			_tft.align = TextFormatAlign.CENTER;
			_tft.size = 12;
			//_tft.color = 0xFFFF00;
			_tft.font = "Microsoft Yahei,STXihei,SimSun,Arial,Verdana";
			_tf.defaultTextFormat = _tft;
			
			addChild(_tf);  
			
			_circle=new Shape();  
			addChild(_circle);  
			
			if(stage)  
			{  
				onAddedToStageHandler();  
			}  
			else  
			{  
				addEventListener(Event.ADDED_TO_STAGE,onAddedToStageHandler);  
			}  
			
			redraw();  
		}  
		
		private function onAddedToStageHandler(e:Event=null):void  
		{  
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStageHandler);  
			
			addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStageHandler);  
			
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);  
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);  
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);  
			addEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);  
			addEventListener(MouseEvent.CLICK,onClickHandler);  
		}  
		
		private function onClickHandler(e:MouseEvent):void  
		{  
			checked=!checked;  
		}  
		
		private function onMouseUpHandler(e:MouseEvent=null):void  
		{  
			if(_isDowned)  
			{  
				_isDowned=false;  
				this.x-=1;  
				this.y-=1;  
			}  
		}  
		
		private function onMouseDownHandler(e:MouseEvent):void  
		{  
			if(!_isDowned)  
			{  
				_isDowned=true;  
				this.x+=1;  
				this.y+=1;  
			}  
		}  
		
		private function onMouseOutHandler(e:MouseEvent):void  
		{  
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);  
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);  
			
			onMouseUpHandler();  
			
			_circle.filters=null;  
		}  
		
		private function onMouseOverHandler(e:MouseEvent):void  
		{  
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);  
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);  
			
			_circle.filters=[new GlowFilter(0x00ff00,1,3,3,3)];  
		}  
		
		private function onRemovedFromStageHandler(e:Event):void  
		{  
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStageHandler);  
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);  
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);  
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownHandler);  
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUpHandler);  
			removeEventListener(MouseEvent.CLICK,onClickHandler);  
		}  
		
		private function redraw():void  
		{  
			_circle.graphics.clear();  
			
			_circle.graphics.lineStyle(1);  
			_circle.graphics.moveTo(5+5,0+5);  
			
			var perAngle:Number=(Math.PI*2)/180;  
			for (var i:int = 0; i < 180; i++)   
			{  
				_circle.graphics.lineTo(Math.cos(i*perAngle)*5+5,Math.sin(i*perAngle)*5+5);   
			}  
			
			//          _circle.graphics.lineTo(5,0);  
			
			if(_checked)  
			{  
				_circle.graphics.beginFill(0x00ff00,0.5);  
				_circle.graphics.drawCircle(5,5,4);  
				_circle.graphics.endFill();  
			}  
		}  
	}
}
