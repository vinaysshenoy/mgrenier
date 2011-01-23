package com.mgrenier.fexel
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.fexel.display.DisplayObject;
	import com.mgrenier.fexel.display.Screen;
	import com.mgrenier.utils.Disposable;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;

	/**
	 * Stage
	 * 
	 * @author Michael Grenier
	 */
	public class Stage implements Disposable
	{
		protected var screens:Vector.<Screen>;
		protected var childs:Vector.<DisplayObject>;
		
		/**
		 * Constructor
		 */
		public function Stage()
		{
			this.screens = new Vector.<Screen>();
			this.childs = new Vector.<DisplayObject>();
		}
		
		/**
		 * Dispose
		 */
		public function dispose ():void
		{
			var s:Screen,
				c:DisplayObject
			while (s = this.screens.pop())
			{
				s.dispose();
				s = null;
			}
			this.screens = null;
			
			while (c = this.childs.pop())
			{
				c = this.childs.pop();
				c.dispose();
				c = null;
			}
			this.childs = null;
			
			super.dispose();
		}
		
		/**
		 * Update buffer
		 * 
		 * @param	rate
		 */
		public function update (rate:int = 0):void
		{
			var i:int,
				n:int,
				c:DisplayObject;
			
			for (i = 0, n = this.childs.length; i < n; ++i)
			{
				c = this.childs[i];
				c.update(rate);
			}
		}
		
		/**
		 * Render
		 */
		public function render():void
		{
			if (!this.screens.length)
				return;
			
			var i:int, n:int, s:Screen;
			for (i = 0, n = this.screens.length; i < n; ++i)
				this.screens[i].render(this);
		}
		
		/**
		 * Add Screen
		 * 
		 * @param	s
		 */
		public function addScreen (s:Screen):void
		{
			this.screens.push(s);
		}
		
		/**
		 * Remove Screen
		 * 
		 * @param
		 */
		public function removeScreen (s:Screen):void
		{
			this.removeScreenAt(this.screens.indexOf(s));
		}
		
		/**
		 * Remove Screen at index
		 * 
		 * @param	i
		 */
		public function removeScreenAt(i:int):void
		{
			var screens:Vector.<Screen> = this.screens.splice(i, 1),
				screen:Screen;
			while (screen = screens.pop())
			{
				screen.dispose();
				screen = null;
			}
			screens = null;
		}
		
		/**
		 * Get Childrens
		 */
		public function children():Vector.<DisplayObject>
		{
			return this.childs;
		}
		
		/**
		 * Add child
		 * 
		 * @param	e
		 * @return
		 */
		public function addChild (c:DisplayObject):DisplayObject
		{
			c.setStage(this);
			c.setParent(null);
			this.childs.push(c);
			return c;
		}
		
		/**
		 * Remove child
		 * 
		 * @param	e
		 * @return
		 */
		public function removeChild (c:DisplayObject):DisplayObject
		{
			return this.removeChildAt(this.childs.indexOf(c));
		}
		
		/**
		 * Remove child at index
		 * 
		 * @param	e
		 * @return
		 */
		public function removeChildAt (i:int):DisplayObject
		{
			var splice:Vector.<DisplayObject> = this.childs.splice(i, 1);
			if (splice.length == 0)
				return null;
			splice[0].setStage(null);
			splice[0].setParent(null);
			return splice[0];
		}
		
		/**
		 * Remove childs
		 */
		public function removeAllChilds ():Stage
		{
			for (var n:int = this.childs.length - 1; n >= 0; n--)
			{
				this.childs[n].setStage(null);
				this.childs[n].setParent(null);
				this.childs[n] = null;
			}
			this.childs = new Vector.<DisplayObject>();
			return this;
		}
		
		/**
		 * Change position of an existing entity
		 * 
		 * @param	e
		 * @param	index
		 * @return
		 */
		public function setChildIndex (c:DisplayObject, index:int):Stage
		{
			this.childs.splice(index, 0, this.childs.splice(this.childs.indexOf(c), 1));
			return this;
		}
		
		/**
		 * Swap position of childs
		 * 
		 * @param	c1
		 * @param	c2
		 * @return
		 */
		public function swapChildren (c1:DisplayObject, c2:DisplayObject):Stage
		{
			return this.swapChildrenAt(this.childs.indexOf(c1), this.childs.indexOf(c2));
		}
		
		/**
		 * Swap position
		 * 
		 * @param	i1
		 * @param	i2
		 * @return
		 */
		public function swapChildrenAt (i1:int, i2:int):Stage
		{
			if (i1 < i2)
				this.childs.splice(i2 - 1, 0, this.childs.splice(i1, 1, this.childs.splice(i2, 1)));
			else
				this.childs.splice(i1 - 1, 0, this.childs.splice(i2, 1, this.childs.splice(i1, 1)));
			
			return this;
		}
		
		
	}
}