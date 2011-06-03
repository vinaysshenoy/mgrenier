package com.mgrenier.fexel.collision
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.geom.Rectangle2D;
	
	public interface IBroadphase
	{
		/**
		 * Reset Broadphase and populate with entities
		 * 
		 * @param	entities
		 * @return
		 */
		function reset (entities:Vector.<Entity>):void;
		
		/**
		 * Clean Broadphase
		 * 
		 * @return
		 */
		function clean ():void;
		
		/**
		 * Add entity
		 * 
		 * @param	entity
		 */
		function add (entity:Entity):void;
		
		/**
		 * Remove entity
		 * 
		 * @param	entity
		 */
		function remove (entity:Entity):void;
		
		/**
		 * Update entity
		 * 
		 * @param	entity
		 */
		function update (entity:Entity):void;
		
		/**
		 * Overlap with Entity
		 */
		function overlapEntity (entity:Entity):Vector.<Entity>;
		
		/**
		 * Overlap with Rectangle
		 */
		function overlapRectangle (rect:Rectangle2D):Vector.<Entity>;
		
	}
}