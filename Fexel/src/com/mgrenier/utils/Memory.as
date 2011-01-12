package com.mgrenier.utils
{
	import flash.system.System;

	public class Memory
	{
		/**
		 * Force Garbage Collector
		 * 
		 * 
		 */
		static public function forceGC ():void
		{
			System.gc();
			System.gc();
			try {
				new LocalConnection().connect('Force GC!');
				new LocalConnection().connect('Force GC!');
			} catch (e:Error) { }
		}
	}
}