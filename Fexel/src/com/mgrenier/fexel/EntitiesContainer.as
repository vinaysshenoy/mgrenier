package com.mgrenier.fexel 
{
	import com.mgrenier.fexel.fexel;
	use namespace fexel;
	
	import com.mgrenier.utils.Disposable;
	
	/**
	 * Entities container
	 */
	public class EntitiesContainer implements Disposable
	{
		protected var world:World;
		protected var entities:Vector.<Entity>;
		
		/**
		 * Constructor
		 */
		public function EntitiesContainer() 
		{
			this.entities = new Vector.<Entity>();
		}
		
		/**
		 * Dispose World
		 */
		public function dispose ():void
		{
			var e:Entity;
			while (this.entities.length > 0)
			{
				e = this.entities.pop();
				e.dispose();
				e = null;
			}
			this.entities = null;
		}
		
		/**
		 * Get entities
		 * 
		 * @return
		 */
		public function getEntities():Vector.<Entity>
		{
			return this.entities;
		}
		
		/**
		 * Add entity to the world
		 * 
		 * @param	e
		 * @return
		 */
		public function addEntity (e:Entity):Entity
		{
			this.entities.push(e);
			return e;
		}
		
		/**
		 * Remove entity from world
		 * 
		 * @param	e
		 * @return
		 */
		public function removeEntity (e:Entity):Entity
		{
			this.entities.splice(this.entities.indexOf(e), 1);
			return e;
		}
		
		/**
		 * Remove all entities from world
		 */
		public function removeAllEntities ():void
		{
			var e:Entity;
			for (var n:int = this.entities.length - 1; n >= 0; n--)
				this.removeEntity(this.entities[n]);
		}
		
		/**
		 * Change position of an existing entity
		 * 
		 * @param	e
		 * @param	index
		 * @return
		 */
		public function setChildIndex (e:Entity, index:int):EntitiesContainer
		{
			this.entities.splice(index, 0, this.entities.splice(this.entities.indexOf(e), 1));
			
			return this;
		}
		
		/**
		 * Swap position of entities
		 * 
		 * @return
		 */
		public function swapEntities (e1:Entity, e2:Entity):EntitiesContainer
		{
			var i1:int = this.entities.indexOf(e1),
				i2:int = this.entities.indexOf(e2);
			if (i1 < i2)
				this.entities.splice(i2 - 1, 0, this.entities.splice(i1, 1, this.entities.splice(i2, 1)));
			else
				this.entities.splice(i1 - 1, 0, this.entities.splice(i2, 1, this.entities.splice(i1, 1)));
			
			return this;
		}
		
		/**
		 * Set World
		 * 
		 * @param	w
		 * @return
		 */
		final internal function setWorld (w:World):EntitiesContainer
		{
			this.world = w;
			
			return this;
		}
		
		/**
		 * Get World
		 * 
		 * @return
		 */
		final internal function getWorld ():World
		{
			return this.world;
		}
		
		/**
		 * Remove World
		 * 
		 * @return
		 */
		final internal function removeWorld ():EntitiesContainer
		{
			this.world = null;
			
			return this;
		}
		
	}
	
}