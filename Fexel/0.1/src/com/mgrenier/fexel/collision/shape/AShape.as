package com.mgrenier.fexel.collision.shape
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Disposable;
	import flash.display.Graphics;
	import com.mgrenier.geom.Projection2D;
	import com.mgrenier.fexel.collision.ContactInfo;
	import com.mgrenier.geom.Segment2D;

	public class AShape implements Disposable
	{
		fexel var entity:Entity;
		protected var aabb:Rectangle2D;
		protected var aabbTransform:Rectangle2D;
		protected var center:Vec2D;
		
		/**
		 * Constructor
		 */
		public function AShape ():void
		{
			this.center = new Vec2D();
		}
		
		/**
		 * Dispose shape
		 */
		public function dispose ():void
		{
			this.entity = null;
			this.aabb = null;
			this.center = null;
		}
		
		/**
		 * Return AABB
		 * 
		 * @return	
		 */
		public function getAABB ():Rectangle2D
		{
			return this.aabb.copy();
		}
		
		/**
		 * Return AABB Transformed
		 */
		public function getAABBTransformed ():Rectangle2D
		{
			if (this.aabbTransform == null)
				this.aabbTransform = this.aabb.copy();
			
			this.aabbTransform.x = this.aabb.x;
			this.aabbTransform.x += this.entity.x;
			this.aabbTransform.x -= this.entity.width / 2;
			this.aabbTransform.y = this.aabb.y;
			this.aabbTransform.y += this.entity.y;
			this.aabbTransform.y -= this.entity.height / 2;
			
			return this.aabbTransform;
		}
		
		/**
		 * Get Center
		 * 
		 * @return
		 */
		public function getCenter():Vec2D
		{
			return this.center.copy();
		}
		
		/**
		 * Get Edges's normal
		 * 
		 * @param	offset
		 * @param	offsetB
		 * @param	shapeB
		 * @return	
		 */
		public function getNormals (offset:Vec2D, offsetB:Vec2D, shapeB:AShape):Vector.<Vec2D>
		{
			return null;
		}
		
		/**
		 * Project Polygon onto axis
		 * 
		 * @param	offset
		 * @param	axis
		 * @return	
		 */
		public function projectOntoAxis (offset:Vec2D, axis:Vec2D):Projection2D
		{
			return null;
		}
		
		/**
		 * Get Vector from Crossing multiple Segment
		 * 
		 * @param	shapeA
		 * @param	shapeB
		 * @param	offsetA
		 * @param	offsetB
		 * @param	contact
		 * @param	segments
		 * @return
		 */
		public function pointFromSegmentsCrossing (shapeA:AShape, offsetA:Vec2D, shapeB:AShape, offsetB:Vec2D, contact:ContactInfo, segments:Vector.<Segment2D>):Boolean
		{
			return false;
		}
		
		/**
		 * Draw shape into graphics
		 * 
		 * @param	graphics
		 * @param	colorAlpha
		 * @param	colorAABB
		 * @param	colorShape
		 */
		public function drawDebug (graphics:Graphics, colorAlpha:Number, colorShape:uint):void
		{
		}
		
		
	}
}