package com.mgrenier.fexel
{
	import com.mgrenier.fexel.display.View;
	import com.mgrenier.fexel.display.DisplayObjectContainer;
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
		 * Stage
		 * 
		 */
		public function Stage()
		{
			this.views = new Vector.<View>();
		}
		
		/**
		 * Dispose World
		 */
		override public function dispose ():void
		{
			super.dispose();
		}
	}
}