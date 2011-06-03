package com.mgrenier.fexel.collision
{
	import com.mgrenier.fexel.Entity;
	import com.mgrenier.fexel.collision.QuadTree;
	import com.mgrenier.fexel.collision.shape.AShape;
	import com.mgrenier.geom.Rectangle2D;
	import com.mgrenier.utils.Disposable;
	import com.mgrenier.utils.IPool;
	
	/**
	 * QuadTree Node
	 */
	public class QuadTreeNode extends Rectangle2D implements Disposable, IPool
	{
		static protected var nextId:int = 0;
		
		internal var	id:int,
						root:QuadTree,
						depth:int,
						parent:QuadTreeNode,
						entities:Vector.<Entity>,
						nodeNW:QuadTreeNode,
						nodeNE:QuadTreeNode,
						nodeSW:QuadTreeNode,
						nodeSE:QuadTreeNode;
		
		/**
		 * Constructor
		 * 
		 * @param	root
		 * @param	parent
		 * @param	depth
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public function QuadTreeNode (root:QuadTree = null, parent:QuadTreeNode = null, depth:int = 0, x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0)
		{
			super(x, y, width, height);
			
			this.id = QuadTreeNode.nextId++;
			this.root = root;
			this.parent = parent;
			this.depth = depth;
			this.entities = new Vector.<Entity>();
		}
		
		/**
		 * To String
		 * @return
		 */
		override public function toString ():String
		{
			return "(" + this.x +", " + this.y +", " + this.width +", " + this.height +", " + this.depth +")";
		}
		
		/**
		 * Add Entity in Tree
		 */
		public function add(entity:Entity):void
		{
			// Max Depth reached
			if (this.root.maxDepth == this.depth)
			{
				this.addToNode(entity);
				return;
			}
			
			// Get AABB
			var shape:AShape = entity.getShape(),
				aabb:Rectangle2D = shape.getAABBTransformed();
			
			// Overlap quadrants ?
			var halfWidth:Number = this.width/2,
				halfHeight:Number = this.height/2,
				halfX:Number = this.x + halfWidth,
				halfY:Number = this.y + halfHeight,
				inNW:Boolean = aabb.left <= halfX && aabb.top <= halfY,
				inSW:Boolean = aabb.left <= halfX && aabb.bottom >= halfY,
				inNE:Boolean = aabb.right >= halfX && aabb.top <= halfY,
				inSE:Boolean = aabb.right >= halfX && aabb.bottom >= halfY;
			
			// If overlap all quadrants, insert here
			if (inNW && inNE && inSW && inSE)
			//if (int(inNW) + int(inNE) + int(inSW) + int(inSE) > 1)
			{
				this.addToNode(entity);
				return;
			}
			
			// Insert into
			else
			{
				if (inNW)
				{
					if (this.nodeNW == null) this.nodeNW = new QuadTreeNode(this.root, this, this.depth+1, this.left, this.top, halfWidth, halfHeight);
					this.nodeNW.add(entity);
				}
				if (inNE)
				{
					if (this.nodeNE == null) this.nodeNE = new QuadTreeNode(this.root, this, this.depth+1, halfX, this.top, halfWidth, halfHeight);
					this.nodeNE.add(entity);
				}
				if (inSW)
				{
					if (this.nodeSW == null) this.nodeSW = new QuadTreeNode(this.root, this, this.depth+1, this.left, halfY, halfWidth, halfHeight);
					this.nodeSW.add(entity);
				}
				if (inSE)
				{
					if (this.nodeSE == null) this.nodeSE = new QuadTreeNode(this.root, this, this.depth+1, halfX, halfY, halfWidth, halfHeight);
					this.nodeSE.add(entity);
				}
			}
		}
		
		/**
		 * Add to this node
		 */
		protected function addToNode (e:Entity):void
		{
			//trace("ADDED TO", e, this);
			
			this.entities.push(e);
			if (!this.root.dictionary[e])
				this.root.dictionary[e] = new Vector.<QuadTreeNode>();
			Vector.<QuadTreeNode>(this.root.dictionary[e]).push(this);
		}
		
		/**
		 * Return Entities that overlap with Rectangle
		 * 
		 * @param	r
		 * @return
		 */
		public function overlap (overlap:Vector.<Entity>, r:Rectangle2D):Vector.<Entity>
		{
			var shape:AShape,
				aabb:Rectangle2D;
			
			// Rectangle overlap with current entities ?
			for (var n:int = this.entities.length - 1; n >= 0; n--)
			{
				shape = this.entities[n].getShape();
				aabb = shape.getAABBTransformed();
				if (r.intersects(aabb))
					if (overlap.indexOf(this.entities[n]) == -1) 
						overlap.push(this.entities[n]);
			}
			
			// Merge sub-quadrants overlaps
			var halfWidth:Number = this.width/2,
				halfHeight:Number = this.height/2,
				halfX:Number = this.x + halfWidth,
				halfY:Number = this.y + halfHeight,
				inNW:Boolean = r.left <= halfX && r.top <= halfY,
				inSW:Boolean = r.left <= halfX && r.bottom >= halfY,
				inNE:Boolean = r.right >= halfX && r.top <= halfY,
				inSE:Boolean = r.right >= halfX && r.bottom >= halfY;
			
			if (inNW && this.nodeNW) this.nodeNW.overlap(overlap, r);
			if (inNE && this.nodeNE) this.nodeNE.overlap(overlap, r);
			if (inSW && this.nodeSW) this.nodeSW.overlap(overlap, r);
			if (inSE && this.nodeSE) this.nodeSE.overlap(overlap, r);
			
			return overlap;
		}
		
		/**
		 * Dispose Node
		 */
		public function dispose ():void
		{
			// Dispose sub Nodes
			if (this.nodeNE) this.nodeNE.dispose();
			this.nodeNE = null;
			if (this.nodeNW) this.nodeNW.dispose();
			this.nodeNW = null;
			if (this.nodeSE) this.nodeSE.dispose();
			this.nodeSE = null;
			if (this.nodeSW) this.nodeSW.dispose();
			this.nodeSW = null;
			
			// Clean entities list
			this.entities = null;
		}
	}
}