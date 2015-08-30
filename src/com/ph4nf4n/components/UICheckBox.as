package com.ph4nf4n.components
{
	import com.ph4nf4n.events.CheckBoxEvent;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class UICheckBox extends Sprite
	{
		private var _label:TextField;  
		private var _tick:Shape;  
		private var _checked:Boolean=false;  
		private var _isDowned:Boolean=false;  
		private var _outlineGlowFilter:GlowFilter;  
		private var _innerlineGlowFilter:GlowFilter;  
		
		private var _width:Number;
		private var _height:Number;
		
		public function get text():String  
		{  
			return _label.text;  
		}  
		
		public function set text(value:String):void  
		{  
			if(_label.text!=value)  
			{  
				_label.text=value;  
				_label.y=-5/2;  
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
				refreshBackground();  
				dispatchEvent(new CheckBoxEvent(CheckBoxEvent.ON_CHECKED_CHANGED));  
			}  
		}  
		
		public function UICheckBox($x:Number=0, $y:Number=0, $w:Number=80, $h:Number=20)  
		{  
			//super();  
			this.x = $x;
			this.y = $y;
			this._width = $w;
			this._height = $h;
			
			initialize();
		}  
		
		//protected override function initialize():void  
		public function initialize():void  
		{  
			this.mouseChildren=false;  
			
			_outlineGlowFilter=new GlowFilter(0x00ff00,1,3,3,2);  
			_innerlineGlowFilter=new GlowFilter(0x00ff00,1,3,3,2,1,true);  
			
			_label=new TextField();  
			_label.x=20;
			_label.y=20;
			
			var _tft:TextFormat = new TextFormat();
			//_tft.align = TextFormatAlign.CENTER;
			_tft.size = 12;
			//_tft.color = 0xFFFF00;
			_tft.font = "Microsoft Yahei,STXihei,SimSun,Arial,Verdana";
			_label.defaultTextFormat = _tft;
			_label.selectable = false;
			
			addChild(_label);  
			
			_tick=new Shape();
			_tick.x=5;
			_tick.y=3;
			addChild(_tick);  
			
			if(stage)  
			{  
				onAddedToStageHandler();  
			}  
			else  
			{  
				addEventListener(Event.ADDED_TO_STAGE,onAddedToStageHandler);  
			}  
			
			refreshBackground();  
			
			_tick.filters=[_outlineGlowFilter];  
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
				//_label.x-=1;  
				//_label.y-=1;  
			}  
		}  
		
		private function onMouseDownHandler(e:MouseEvent):void  
		{  
			if(!_isDowned)  
			{  
				_isDowned=true;  
				//_label.x+=1;  
				//_label.y+=1;  
			}  
		}  
		
		private function onMouseOutHandler(e:MouseEvent):void  
		{  
			removeEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);  
			addEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);  
			
			onMouseUpHandler();  
			
			_tick.filters=[_outlineGlowFilter];  
		}  
		
		private function onMouseOverHandler(e:MouseEvent):void  
		{  
			removeEventListener(MouseEvent.MOUSE_OVER,onMouseOverHandler);  
			addEventListener(MouseEvent.MOUSE_OUT,onMouseOutHandler);  
			
			_tick.filters=[_outlineGlowFilter,_innerlineGlowFilter];  
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
		
		//protected override function refreshBackground():void
		public function refreshBackground():void  
		{  
			_tick.graphics.clear();  
			
			_tick.graphics.beginFill(0x00ff00,0.01);  
			_tick.graphics.drawCircle(5,5,4);  
			_tick.graphics.endFill();  
			
			_tick.graphics.lineStyle(1);  
			_tick.graphics.moveTo(0,0);  
			_tick.graphics.lineTo(10,0);  
			_tick.graphics.lineTo(10,10);  
			_tick.graphics.lineTo(0,10);  
			_tick.graphics.lineTo(0,0);  
			
			if(_checked)  
			{  
				_tick.graphics.lineStyle(2);  
				_tick.graphics.moveTo(2,5);  
				_tick.graphics.lineTo(4,8);  
				_tick.graphics.lineTo(8,2);  
			}  
		}
		
		public function test():void {
			graphics.clear();
			graphics.beginFill(0xffffff);
			graphics.drawRoundRect(0, 0,this._width,this._height,0,0);
			graphics.endFill();
		}
	}
}