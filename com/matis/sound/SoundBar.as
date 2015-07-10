package com.matis.sound
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SoundBar extends Sprite
	{
		private var baseHeight:Number = 0;
		public function SoundBar()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE , onAdded);
			
		}
		
		
		private function onAdded(e:Event):void{
			this.removeEventListener(Event.ADDED_TO_STAGE , onAdded);
			baseHeight = this.height;
			//bar_mc.height = this.height;
			setSound(0);
		}
		
		
		public function setSound(_sound:Number):void{
			var sound:int = (_sound / baseHeight) * 100;
			var percent:Number = baseHeight / 100;
			if(sound > 100)
				sound = 100;
			if(sound < 0)
				sound = 0;
			//this.mask_mc.scaleY = -1;
			//this.mask_mc.height = sound * percent;
			var _y:Number = (sound) * percent;
			
			//trace(_y , _sound , sound);
			TweenLite.to(this.point_mc , 0.5 , {y:_y , onUpdate:onUpdate , ease:Back.easeOut});
			//this.mask_mc.y = this.height - this.mask_mc.height;
		}
		
		
		private function onUpdate():void{
			//this.point_mc
			this.mask_mc.y = this.mask_mc.height - this.point_mc.y;
			if(this.mask_mc.y <= 0)
				this.mask_mc.y = 0;
		}
		
	}
}