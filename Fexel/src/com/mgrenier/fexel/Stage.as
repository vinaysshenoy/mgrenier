package com.mgrenier.fexel
{
	import com.mgrenier.fexel.display.DisplayObject;
	import com.mgrenier.fexel.display.DisplayObjectContainer;
	import com.mgrenier.fexel.display.View;
	import com.mgrenier.utils.Disposable;

	/**
	 * Stage
	 * 
	 * @author Michael Grenier
	 */
	public class Stage extends DisplayObjectContainer implements Disposable
	{
		protected var views:Vector.<View>;
		
		/**
		 * Constructor
		 */
		public function Stage()
		{
			this.views = new Vector.<View>();
		}
		
		/**
		 * Dispose
		 */
		override public function dispose ():void
		{
			var v:View;
			while (v = this.views.pop())
			{
				v.dispose();
				v = null;
			}
			this.views = null;
			
			super.dispose();
		}
	}
}