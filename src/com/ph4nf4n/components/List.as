package com.ph4nf4n.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.getTimer;
	/**
	 * List组件
	 * @author dauring@gmail.com
	 */
	[InspectableList("disabled", "visible", "itemRenderer", "scrollBar", "rowHeight","rowCount","dataProvider","drag","mouseWheel")]
	public class List extends Sprite
	{
		/**
		 * 要显示的列数
		 */
		private var _rowCount:Number = 5;
		/**
		 * itemRender高度
		 */
		private var _rowHeight:Number = 20;
		
		/**
		 * ItemRenderer的类引用，实例化该对象
		 */
		private var _itemRenderer:String = "org.component.AfItemRenderer";
		
		/**
		 * 是否可用
		 */
		private var _disabled:Boolean = false;
		
		/**
		 * 是否可以拖曳
		 */
		private var _drag:Boolean = false;
		
		/**
		 * 滚动条对象
		 */
		private var _scrollBar:String;
		
		private var _scrollBarTarget:DisplayObject;
		/**
		 * 数据
		 */
		private var _dataProvider:Array;
		
		/**
		 * 是否在拖曳中
		 */
		private var _isDragging:Boolean = false;
		/**
		 * 存放itemRenderer对象的数组
		 */
		//protected var _itemRenderList:Vector.<AfItemRenderer>;
		protected var _itemRenderList;
		
		/**
		 * 当前选中的item
		 */
		//private var _selectItem:AfItemRenderer;
		private var _selectItem;
		
		/**
		 * 当前选中的索引
		 */
		private var _selectIndex:int = -1;
		
		/**
		 * 滚轮滚动时的幅度,一次滚动几行
		 */
		private var _mouseWheel:int = 1;
		
		/**
		 * 当前滚动的列
		 */
		private var _currentIndex:int = 0;
		
		//不可视的背景，用于固定大小
		protected var _bg:Sprite;
		
		//存放itemRenderer的数组
		protected var _ctr:Sprite;
		
		protected var _mouseDownPoint:Point;
		
		protected var _mask:Sprite;
		
		protected var _isInit:Boolean = false;
		
		[Inspectable(defaultValue = "20", verbose = 1)]
		/**
		 * itemRender高度
		 */
		public function get rowHeight():Number 
		{
			return _rowHeight;
		}                
		public function set rowHeight(value:Number):void 
		{
			_rowHeight = value;
		}                
		
		[Inspectable(defaultValue = "org.component.AfItemRenderer", verbose = 1)]
		/**
		 * ItemRenderer的类引用，实例化该对象
		 */
		public function get itemRenderer():String 
		{
			return _itemRenderer;
		}                
		public function set itemRenderer(value:String):void 
		{
			_itemRenderer = value;
		}
		
		[Inspectable(defaultValue = "false", verbose = 1)]
		/**
		 * 是否可用
		 */
		public function get disabled():Boolean 
		{
			return _disabled;
		}
		
		public function set disabled(value:Boolean):void 
		{
			_disabled = value;
		}
		
		[Inspectable(defaultValue = "true", verbose = 1)]
		override public function get visible():Boolean 
		{
			return super.visible;
		}                
		override public function set visible(value:Boolean):void 
		{
			super.visible = value;
		}
		
		[Inspectable(defaultValue = "", verbose = 1)]
		/**
		 * 滚动条对象
		 */
		public function get scrollBar():String 
		{
			return _scrollBar;
		}                
		public function set scrollBar(value:String):void 
		{
			_scrollBar = value;
		}
		
		[Inspectable(defaultValue = "", verbose = 1)]
		/**
		 * 数据
		 */
		public function get dataProvider():Array 
		{
			return _dataProvider;
		}                
		public function set dataProvider(value:Array):void 
		{
			_dataProvider = value;
			update();
		}
		
		[Inspectable(defaultValue = "false", verbose = 1)]
		/**
		 * 是否可以拖曳
		 */
		public function get drag():Boolean 
		{
			return _drag;
		}                
		public function set drag(value:Boolean):void 
		{
			_drag = value;rowCount
		}
		
		
		[Inspectable(defaultValue = "5", verbose = 1)]
		/**
		 * 要显示的列数
		 */
		public function get rowCount():Number 
		{
			return _rowCount;
		}                
		public function set rowCount(value:Number):void 
		{
			_rowCount = value;
		}
		[Inspectable(defaultValue = "1", verbose = 1)]
		/**
		 * 滚轮滚动时的幅度,一次滚动几行
		 */
		public function get mouseWheel():int 
		{
			return _mouseWheel;
		}                
		public function set mouseWheel(value:int):void 
		{
			_mouseWheel = value;
		}        
		
		/**
		 * 当前滚动的列
		 */
		public function get currentIndex():int 
		{
			return _currentIndex;
		}                
		public function set currentIndex(value:int):void 
		{
			_currentIndex = value;
			if (_currentIndex > maxScrollPosition)
				_currentIndex = maxScrollPosition;
			else if (_currentIndex < 0)
				_currentIndex = 0;
			_ctr.y = -_currentIndex * rowHeight;
			if (_scrollBarTarget)
			{
				_scrollBarTarget["scrollPosition"] = _currentIndex;
			}
		}
		/**
		 * 当前选中的item
		 */
		public function get selectItem():AfItemRenderer 
		{                        
			return _selectItem;
		}                
		/**
		 * 当前选中的索引
		 */
		public function get selectIndex():int 
		{
			return _selectIndex;
		}                
		public function set selectIndex(value:int):void 
		{
			if(_selectIndex >=0 && _selectIndex< dataProvider.length)
				_itemRenderList[_selectIndex].selected = false;
			_selectIndex = value;
			if(_selectIndex >=0 && _selectIndex< dataProvider.length)
				_itemRenderList[_selectIndex].selected = true;
		}
		
		public function List() 
		{
			
		}
		private function init(evt:Event)
		{
			removeEventListener(Event.ACTIVATE, init);
			_isInit = true;
			
			_bg = this["bg"];
			_bg.visible = false;
			_bg.width = this.width;
			_bg.height = this.height;
			this.scaleX = 1;
			this.scaleY = 1;
			
			_ctr = new Sprite;
			addChild(_ctr);
			
			_ctr.addEventListener(MouseEvent.MOUSE_DOWN, $onMouseDown);
			_ctr.addEventListener(MouseEvent.MOUSE_OVER, $onMouseOver);
			initMask();
			
			initScrollBar();
			
			_itemRenderList = new Vector.<AfItemRenderer>;
			configUI();
			update();
		}
		protected function configUI():void
		{
			
		}
		
		private function initMask():void
		{
			_mask = new Sprite;
			_mask.graphics.beginFill(0xffffff);
			_mask.graphics.drawRect(0, 0, _bg.width, rowCount * rowHeight);
			_mask.graphics.endFill();                
			_ctr.mask = _mask;
			addChild(_mask);
		}
		private function initScrollBar():void
		{
			if (!_scrollBar)
			{
				_scrollBarTarget = null;
				return;                        
			}
			if (this.parent && this.parent[_scrollBar])
			{
				_scrollBarTarget = this.parent[_scrollBar];
				_scrollBarTarget.x = _mask.width+this.x;
				_scrollBarTarget.y = this.y;
				_scrollBarTarget.height = _mask.height;
			}
			else if(this.parent && _scrollBar)
			{                
				var ScrollBar:Class = ApplicationDomain.currentDomain.getDefinition(String(_scrollBar)) as Class;
				_scrollBarTarget = new ScrollBar as DisplayObject
				_scrollBarTarget.x = _mask.width+this.x;
				_scrollBarTarget.y = this.y;
				_scrollBarTarget.name = _scrollBar;
				_scrollBarTarget.height = _mask.height;
				this.parent.addChild(_scrollBarTarget);
			}
			_scrollBarTarget.addEventListener("scroll", onScroll);
		}
		private function onScroll(evt:Object):void
		{
			currentIndex = evt["position"];
		}
		/**
		 * 取得最大滚动数
		 * @return
		 */
		public function get maxScrollPosition():int
		{
			var val:int = _dataProvider.length - rowCount;
			if ( val > 0)
				return val;
			return 0;
			
		}
		
		public function update():void
		{                        
			if (!_isInit)
				return;
			if (!dataProvider)
				return;
			var len:int = _dataProvider.length;
			if (len > _itemRenderList.length)
			{
				addItem(len - _itemRenderList.length);
			}
			else
			{
				minusItem(_itemRenderList.length - len);
			}
			for (var i:int = 0; i < len; i++)
			{
				_itemRenderList[i].setData(i,_dataProvider[i]);
				_itemRenderList[i].y = _rowHeight * i;
				_itemRenderList[i].width = _bg.width;
				_itemRenderList[i].height = _rowHeight;
				_itemRenderList[i].owner = this;
				_ctr.addChild(_itemRenderList[i]);
			}
			if (_scrollBarTarget)
			{
				_scrollBarTarget["maxScrollPosition"] = maxScrollPosition;
				_scrollBarTarget["minScrollPosition"] = 0;
			}
		}
		private function addItem(len:int):void
		{
			var ItemRenderClass:Class = ApplicationDomain.currentDomain.getDefinition(_itemRenderer) as Class;
			for (var i:int = 0; i < len; i++)
			{
				_itemRenderList.push(new ItemRenderClass());
			}
		}
		private function minusItem(len:int):void
		{
			_itemRenderList.splice(_itemRenderList.length - 1, len);
		}
		protected function setIntegerPos():void
		{
			currentIndex = -Math.round(_ctr.y / rowHeight);
		}
		private function $onMouseDown(evt:MouseEvent):void
		{
			if (drag)
			{
				_mouseDownPoint = new Point(this.mouseX, this.mouseY);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, $onMouseMove);
				var heigh:Number = _ctr.height - _mask.height > 0?(_ctr.height - _mask.height):0;
				_ctr.startDrag(false,new Rectangle(0,0,0,-heigh));
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, $onMouseUp);
		}
		private function $onMouseMove(evt:MouseEvent):void
		{
			if (Math.abs(_mouseDownPoint.y - mouseY) > 10)
				_isDragging = true;
			
		}
		private function $onMouseUp(evt:MouseEvent):void
		{
			if (drag)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, $onMouseMove);
				_ctr.stopDrag();
				setIntegerPos();                                
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, $onMouseUp);
			if (_isDragging && drag)
			{
				_isDragging = false;
				return;
			}
			if(_selectIndex >=0 && _selectIndex< dataProvider.length)
				_itemRenderList[_selectIndex].selected = false;
			var renderer:AfItemRenderer = checkIsRenderer(evt.target as DisplayObject);
			if (renderer)
			{                        
				renderer.selected = true;
				_selectItem = renderer;
				_selectIndex = renderer.index;
			}
		}
		private function $onMouseOver(evt:MouseEvent):void
		{
			_ctr.addEventListener(MouseEvent.MOUSE_OUT, $onMouseOut);
			_ctr.addEventListener(MouseEvent.MOUSE_WHEEL, $onMouseWheel);
		}
		private function $onMouseOut(evt:MouseEvent):void
		{
			_ctr.removeEventListener(MouseEvent.MOUSE_OUT, $onMouseOut);
			_ctr.removeEventListener(MouseEvent.MOUSE_WHEEL, $onMouseWheel);
		}
		private function $onMouseWheel(evt:MouseEvent):void
		{
			var goalPos:Number;
			//向上滚动
			if (evt.delta > 0)
			{
				currentIndex -= mouseWheel;
			}
			else//向下滚动
			{
				currentIndex += mouseWheel;
			}
		}
		private function getCorrectPos(pos:Number):Number
		{
			if (pos > 0)
				pos = 0;
			else if (_ctr.height < _mask.height)
				pos = 0;
			else if ( pos < _mask.height-_ctr.height)
				pos =_mask.height- _ctr.height;
			return pos;
		}
		private function checkIsRenderer(target:DisplayObject):AfItemRenderer
		{
			while (target != _ctr && target != stage)
			{
				if (target is AfItemRenderer)
					return target as AfItemRenderer;
				else
					target = target.parent;
			}
			return null;
		}
	}
	
}