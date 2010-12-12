package com.mgrenier.utils
{
	import apparat.inline.Inlined;
	
	public class FastVector extends Inlined
	{
		/**
		 * Get Index of value in Vector
		 * 
		 * @param	vector
		 * @param	value
		 * @return
		 */
		static public function indexOf (vect:Vector.<Object>, value:Object):int
		{
			var i:int = vect.length - 1
			for (; i >= 0; --i)
				if (vect[i] == value)
					return i;
			return -1;
		}
		
		/**
		 * Remove value from Vector
		 * 
		 * @param	vector
		 * @param	value
		 * @return
		 */
		static public function remove (vect:Vector.<Object>, value:Object):Object
		{
			var i:int = FastVector.indexOf(vect, value),
				n:int = vect.length - 1;
			for (; i < n; ++i)
				vect[i] = vect[i + 1];
			vect.pop();
			return vect;
		}
	}
}