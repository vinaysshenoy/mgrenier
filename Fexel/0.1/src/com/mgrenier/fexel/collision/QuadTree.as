package com.mgrenier.fexel.collision
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.collision.shape.AShape;
	import com.mgrenier.geom.FastRectangle2D;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.geom.Vec2D;
	import com.mgrenier.utils.Disposable;
	
	import flash.utils.Dictionary;

	/**
	 * QuadTree 2D
	 * 
	 */
	public class QuadTree implements IBroadphase
	{
		protected var root:QuadTreeNode;
		
		internal var dictionary:Dictionary;
		internal var maxDepth:int;
		
		/**
		 * Constructor
		 * 
		 * @param	entities
		 */
		public function QuadTree(maxDepth:int = 4)
		{
			this.maxDepth = maxDepth;
			
			this.clean();
		}
		
		/**
		 * Reset QuadTree
		 * 
		 * @param	entities
		 */
		public function reset(entities:Vector.<Entity>):void
		{
			if (entities.length == 0)
			{
				this.root = new QuadTreeNode(this, null, 0, 0, 0, 1, 1);
				return;
			}
			
			// Clean old tree
			this.clean();
			
			// Calculate entities bounds
			var bound:Rectangle2D,
				shape:AShape,
				aabb:Rectangle2D,
				rect:Rectangle2D,
				left:Number = Number.MAX_VALUE,
				right:Number = Number.MIN_VALUE,
				top:Number = Number.MAX_VALUE,
				bottom:Number = Number.MIN_VALUE,
				n:int;
			for (n = entities.length - 1; n >= 0; n--)
			{
				shape = entities[n].getShape();
				if (!shape) continue;
				aabb = shape.getAABBTransformed();
				if (!aabb) continue;
				
				left = Math.min(left, aabb.left);
				top = Math.min(top, aabb.top);
				right = Math.max(right, aabb.right);
				bottom = Math.max(bottom, aabb.bottom);
			}
			
			bound = new Rectangle2D(left, top, right - left, bottom - top);
			
			
			// Create root node
			this.root = new QuadTreeNode(this, null, 0, bound.x, bound.y, bound.width, bound.height);
			
			// Add entities to Tree
			if (entities)
			{
				for (n = entities.length - 1; n >= 0; n--)
				{
					shape = entities[n].getShape();
					if (!shape) continue;
					aabb = shape.getAABBTransformed();
					if (!aabb) continue;
					this.root.add(entities[n]);
				}
			}
			
		}
		
		/**
		 * Clean Tree
		 */
		public function clean ():void
		{
			if (this.root)
			{
				this.root.dispose();
				this.root = null;
			}
			this.dictionary = null;
			this.dictionary = new Dictionary(true);
		}
		
		/**
		 * Add Entity in Tree
		 */
		public function add(entity:Entity):void
		{
			var shape:AShape = entity.getShape();
			if (!shape) return;
			var aabb:Rectangle2D = shape.getAABBTransformed();
			if (!aabb) return;
			
			// Entity outside Tree...
			if (this.root.intersection(aabb) != this.root)
			{
				// FIXME Entity outside Tree !!
				//trace(entity, "outside", this.root);
				//var entities:Vector.<Entity> = this.getEntities();
				//this.reset(entities);
			}
			
			this.root.add(entity);
		}
		
		
		/**
		 * Remove entity
		 * 
		 * @param	entity
		 */
		public function remove (entity:Entity):void
		{
			if (!this.dictionary[entity]) return;
			
			var node:QuadTreeNode,
				i:int,
				n:int;
			while (Vector.<QuadTreeNode>(this.dictionary[entity]).length > 0)
			{
				node = Vector.<QuadTreeNode>(this.dictionary[entity]).pop();
				node.entities.splice(node.entities.indexOf(entity), 1);
				/*for (i = 0, n = node.entities.length; i < n && node.entities[i] != entity; ++i);
				for (; i < n-1; ++i)
					node.entities[i] = node.entities[i + 1];
				node.entities.pop();*/
			}
			delete this.dictionary[entity];
		}
		
		/**
		 * Update entity
		 * 
		 * @param	entity
		 */
		public function update (entity:Entity):void
		{
			this.remove(entity);
			this.add(entity);
		}
		
		/**
		 * Overlap with Entity
		 * 
		 * @return	
		 */
		public function overlapEntity (entity:Entity):Vector.<Entity>
		{
			var shape:AShape = entity.getShape();
			if (!shape) return null;
			var aabb:Rectangle2D = shape.getAABBTransformed();
			if (!aabb) return null;
			
			var overlap:Vector.<Entity> = this.overlapRectangle(aabb);
			while (overlap.indexOf(entity) != -1)
				overlap.splice(overlap.indexOf(entity), 1);
			return overlap;
		}
		
		/**
		 * Overlap with Rectangle
		 * 
		 * @return	
		 */
		public function overlapRectangle (rect:Rectangle2D):Vector.<Entity>
		{
			var overlap:Vector.<Entity> = new Vector.<Entity>();
			this.root.overlap(overlap, rect);
			
			for (var i:int = overlap.length - 1; i >= 0; i--)
				if (!rect.intersects(overlap[i].getShape().getAABBTransformed()))
					overlap.pop();
			
			return overlap;
		}
	}
}