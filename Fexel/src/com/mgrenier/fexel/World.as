package com.mgrenier.fexel
{
	import com.mgrenier.fexel.display.View;
	import com.mgrenier.utils.Disposable;

	public class World extends EntitiesContainer implements Disposable
	{
		protected var views:Vector.<View>;
		
		/**
		 * World
		 * 
		 * 
		 */
		public function World()
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