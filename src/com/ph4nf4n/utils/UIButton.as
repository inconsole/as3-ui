package com.ph4nf4n.utils
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class UIButton extends Sprite
	{
		// 按钮组件
		private var btn:Sprite;
		private var btnMask:Sprite;
		
		// 按钮文本
		private var btnTxt:TextField;
		private var btnTxtFormat:TextFormat;
		
		// 参数列表
		private var options:Object = {};
		
		// 默认参数列表
		private var setting:Object = {
			x: 0,
			y: 0,
			width: 60,
			height: 30,
			text: "按钮",
			bgColor: 0xf90f90,
			overColor: 0x296898,
			clickDownColor: 0xFDAA24,
			txtColor: 0xFFFFFF,
			txtOverColor: 0xFFFFFF,
			txtClickDownColor: 0xFFFFFF,
			txtFontSize: 12,
			border: 0,
			borderColor: 0xFFFFFF,
			borderRadius: 0
		};
		
		
		public function UIButton(option:Object)
		{
			super();
			
			options = extend(option, setting);
			
			console(options);
			addChildren();
			draw();
			innerEventListener();
		}
		
		/*
		* @method 打印对象中的属性
		*/
		public function console(obj:Object):void {
			trace("{\n");
			for (var item:String in obj) {
				trace("  " + item + ": " + obj[item] + "\n");
			}
			trace("}\n")
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
			btn = new Sprite();
			btnMask = new Sprite();
			btnTxt = new TextField();
			
			btn.addChild(btnTxt);
			btn.addChild(btnMask);
			
			addChild(btn);
		}
		
		/*
		* @method 实现舞台上需要添加的对象
		*/
		private function draw():void {
			drawBg(options.bgColor);
			drawBtnTxt();
			drawBtnMask();
		}
		
		/*
		* @method 绘按钮的背景色、目前只允许纯色按钮
		*/
		private function drawBg(color:uint):void {
			btn.graphics.clear();
			btn.graphics.beginFill(color, 1);
			btn.graphics.drawRoundRect(options.x,options.y, options.width, options.height,options.borderRadius, options.borderRadius);
			//btn.graphics.drawRoundRect(0, 0,options.width, 30,0, 0);

			btn.graphics.endFill();
		}
		
		/*
		* @method 给按钮添加文本、以及改变文本样式
		*/
		private function drawBtnTxt():void {
			btnTxtFormat = new TextFormat();
			btnTxtFormat.size = options.txtFontSize;
			btnTxtFormat.align = TextFormatAlign.CENTER;
			
			btnTxt.defaultTextFormat = btnTxtFormat;
			btnTxt.text = options.text;
			btnTxt.textColor = options.txtColor;
			btnTxt.width = options.width;
			btnTxt.height = btnTxt.textHeight + 5;
			btnTxt.x = options.x;
			btnTxt.y = (options.height - btnTxt.height) / 2 + options.y;
		}
		
		/*
		* @method 给按钮添加事件的事件监听器
		*/
		private function drawBtnMask():void {
			btnMask.graphics.clear();
			btnMask.graphics.beginFill(0x000000, 0);
			btnMask.graphics.drawRoundRect(options.x, options.y, options.width, options.height,
				options.borderRadius, options.borderRadius);
			btnMask.graphics.endFill();
			btnMask.buttonMode = true;
		}

		/*
		* @method 插件内置事件监听器
		* */
		private function innerEventListener():void {
			if (options.bgColor != options.overColor) {
				btnMask.addEventListener(MouseEvent.MOUSE_OVER, function():void {
					drawBg(options.overColor);
					btnTxt.textColor = options.txtOverColor;
				},false,2);
				
				btnMask.addEventListener(MouseEvent.MOUSE_OUT, function():void {
					drawBg(options.bgColor);
					btnTxt.textColor = options.textColor;
				},false,2);
				/*
				btnMask.addEventListener(MouseEvent.MOUSE_UP, function():void {
					drawBg(options.bgColor);
					btnTxt.textColor = options.txtColor;
				},false,3);
				*/
			}
		}
		
		/*
		* @method 给按钮绑定指定的事件
		* @param {Function} click 当按钮点击后发生的事件
		* @param {Function} MouseOver 当按钮移过发生的事件
		* @param {Function} MouseOut 当按钮移出后发生的事件
		* @param {Function} MouseDown 当按键按下发生的事件
		* @param {Function} MouseUp 当按键抬起发生的事件
		*/
		public function addBtnEventListener(eventObj:Object):void {
			for (var item:String in eventObj) {
				switch(item) {
					case "Click":
						btnMask.addEventListener(MouseEvent.CLICK, eventObj[item]);
						break;
					case "MouseOver":
						btnMask.addEventListener(MouseEvent.MOUSE_OVER, eventObj[item]);
						break;
					case "MouseOut":
						btnMask.addEventListener(MouseEvent.MOUSE_OUT, eventObj[item]);
						break;
					case "MouseDown":
						btnMask.addEventListener(MouseEvent.MOUSE_DOWN, eventObj[item]);
						break;
					case "MouseUp":
						btnMask.addEventListener(MouseEvent.MOUSE_UP, eventObj[item]);
						break;
					default:
						break;
				}
			}
		}
	}
}

/**
 var testBtn:Button = new Button({
 	x : 0,		//x
	y : 0,		//y
    width: 60, // 按钮宽度
	height: 30, // 按钮高度
	text: "发送", // 按钮文字
	bgColor: 0xF49909, // 按钮背景
	overColor: 0xFDAA24, // 按钮鼠标划过背景
	clickDownColor: 0xFDAA24, // 按钮鼠标按下时背景
	txtColor: 0xFFFFFF, // 按钮字体颜色
	txtOverColor: 0xFFFFFF, // 按钮字体鼠标划过颜色
	txtClickDownColor: 0xFFFFFF, // 按钮字体鼠标按下颜色
	txtFontSize: 12, // 按钮字体大小

	border: 0, // 按钮的border值
	borderColor: 0xFFFFFF, // 按钮的border颜色
	borderRadius: 0 // 按钮是否圆角及圆角大小
});
 
//给按钮添加自定义的事件
testBtn.addBtnEventListener({
    Click: function(e:MouseEvent):void {
        trace("hello world!");
    },
	
	....
	
    MouseUp: function(e:MouseEvent):void {
        trace("mouse up!")
    }
});
 *
 *
 **/
