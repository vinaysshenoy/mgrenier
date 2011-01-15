package com.mgrenier.fexel.display
{
	import com.mgrenier.fexel.fexel;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;

	use namespace fexel;
	
	/**
	 * AnimatedSpriteSheet
	 * 
	 * @author Michael Grenier
	 */
	public class AnimatedSpriteSheet extends SpriteSheet
	{
		public var frameRate:int;
		protected var animations:Dictionary;
		protected var currentAnimation:String;
		protected var _currentFrame:Number;
		public function get currentFrame():Number { return this._currentFrame; }
		protected var delaying:int;
		
		protected var _playing:Boolean;
		public function get playing():Boolean { return this._playing; }
		
		/**
		 * Constructor
		 */
		public function AnimatedSpriteSheet(width:Number, height:Number, frameRate:int = 24, transparent:Boolean=true, smooth:Boolean=false)
		{
			super(width, height, transparent, smooth);
			this.frameRate = 24;
			this.animations = new Dictionary(true);
			this.currentAnimation = "";
			this._currentFrame = 0;
			this.delaying = 0;
		}
		
		
		/**
		 * Dispose
		 */
		override public function dispose ():void
		{
			for (var name:String in this.animations)
			{
				this.animations[name] = null;
				delete this.animations[name];
			}
			this.animations = null;
			
			super.dispose();
		}
		
		/**
		 * Add Animation
		 * 
		 * @param	name
		 * @param	cells
		 * @param	loop
		 * @param	callback
		 * @return
		 */
		public function addAnimation (name:String, cells:Vector.<int>, loop:Boolean, callback:Function = null):AnimatedSpriteSheet
		{
			if (this.animations[name])
				this.animations[name] = null;
			this.animations[name] = new Animation(cells, loop, callback);
			return this;
		}
		
		/**
		 * Play animation
		 * 
		 * @param	animation
		 * @param	rate
		 * @return
		 */
		public function play (animation:String, rate:int = 0):AnimatedSpriteSheet
		{
			if (rate)
				this.frameRate = rate;
			
			this._playing = true;
			this.currentAnimation = animation;
			this._currentFrame = 0;
			this.delaying = 0;
			
			return this;
		}
		/**
		 * Stop animation
		 * 
		 * @return
		 */
		public function stop ():AnimatedSpriteSheet
		{
			this._playing = false;
			this.delaying = 0;
			
			return this;
		}
		
		/**
		 * Resume animation
		 * 
		 * @return
		 */
		public function resume ():AnimatedSpriteSheet
		{
			this._playing = true;
			this.delaying = 0;
			
			return this;
		}
		
		/**
		 * Delay animation for d frames
		 * 
		 * @param       d
		 * @return
		 */
		public function delay (d:int):AnimatedSpriteSheet
		{
			this.delaying = d;
			
			return this;
		}
		
		/**
		 * Render to buffer
		 * 
		 * @param	buffer
		 * @param	transformation
		 */
		override fexel function render (buffer:BitmapData, matrix:Matrix, color:ColorTransform, rate:int):void
		{
			if (this._playing && this.currentAnimation != "" && this.animations[this.currentAnimation])
			{
				var anim:Animation = Animation(this.animations[this.currentAnimation]),
					currentFrame:int = Math.floor(this._currentFrame);
				this.delaying -= this.delaying > 0 ? 1 : 0;
				
				if (this.delaying == 0)
				{
					if (currentFrame > anim.cells.length - 1)
					{
						if (anim.callback)
							anim.callback();
						if (anim.loop)
							this._currentFrame = currentFrame = 0;
						else
						{
							this.stop();
							return;
						}
						
					}
					this.cellIndex = anim.cells[currentFrame];
					this._currentFrame += this.frameRate / rate;
				}
			}
			
			super.render(buffer, matrix, color, rate);
		}
		
	}
}

class Animation
{
	public var cells:Vector.<int>;
	public var loop:Boolean;
	public var callback:Function;
	
	public function Animation (cells:Vector.<int>, loop:Boolean = false, callback:Function = null)
	{
		this.cells = cells;
		this.loop = loop;
		this.callback = callback;
	}
	
}