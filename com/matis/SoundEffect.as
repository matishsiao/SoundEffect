package com.matis
{
	import com.matis.sound.RecordData;
	import com.matis.sound.SoundBar;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.*;
	import flash.media.Microphone;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class SoundEffect extends Sprite
	{
		private var mic:Microphone = Microphone.getMicrophone();
		private var DELAY_LENGTH:uint = 2000;
		
		private var soundBytes:ByteArray = new ByteArray();
		//顯示音譜總數
		private var range:uint = 100;
		private var soundRange:Vector.<RecordData>= new Vector.<RecordData>();
		private var clearTimer:Timer;
		private var khz:Number = 44;
		private var countTimer:Timer = new Timer(100000 , 1);
		private var barArray:Vector.<SoundBar> = new Vector.<SoundBar>();
		public function SoundEffect()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE , onAdded);
		}
		
		
		private function onAdded(e:Event):void{
			clearTimer = new Timer(1000/khz);
			countTimer.addEventListener(TimerEvent.TIMER_COMPLETE , onStop);
			clearTimer.addEventListener(TimerEvent.TIMER , onClean);
			start_btn.addEventListener(MouseEvent.CLICK , onStart);
			var _width:Number = stage.stageWidth / range;
			for(var i:int = 0;i < range;i++){
				
				soundRange.push(new RecordData());
				var bar:SoundBar = new soundBar();
				bar.width = _width;
				bar.height = stage.stageHeight;
				bar.x = i * _width;
				bar.y = 0;
				bar.name = "bar_" + i;
				trace(bar.name , bar.x , bar.y , bar.height , bar.width);
				this.addChild(bar);
				//bar.setSound(1);
				barArray.push(bar);
			}
			this.setChildIndex(start_btn , this.numChildren - 1);
			
		}
		
		
		private function onClean(e:TimerEvent):void{
			showSound();
		}
		
		
		private function showSound():void{
			var center:Number =  stage.stageHeight >> 1;
			var rangeX:Number = stage.stageWidth / range;
			/*this.graphics.clear();
			this.graphics.lineStyle(5, 0x99FF00);
			this.graphics.moveTo(0, center);
			this.graphics.lineTo(stage.stageWidth, center);*/
			
			for(var i:int = 0;i < range;i++){
				//var _x:int = (i >= 500) ? i - 500:i;
				//var _height:Number = (i >= 500)?soundRange[i].getAvgNumber() - center:soundRange[i].getAvgNumber() + center;
				if((soundRange[i].getAvgNumber() > 0)){
					var _height:int = soundRange[i].getAvgNumber();
					_height = _height / (khz * 8);
					if(_height > stage.stageHeight)
						_height = stage.stageHeight;
					if(_height < 10)
						_height = 10;
					//trace("_height:" + _height);
						barArray[i].setSound(_height);
				}else
					barArray[i].setSound(10);
				soundRange[i].resetData();
				
				
			}
			//this.graphics.endFill();
		
		}
		
		
		private function onStop(e:TimerEvent):void{
			mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
			//this.graphics.endFill();
			clearTimer.stop();
		}
		
		
		private function onStart(e:MouseEvent):void{
			onInit();
			//countTimer.start();
			clearTimer.start();
		}
		
		
		private function onInit():void{
			mic.setSilenceLevel(0); 
			mic.gain = 100; 
			mic.rate = khz;
			mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler); 
			trace("onInit");
			//soundBytes.clear();
		}
		
		//private var count:Number = 0;
		
		private function micSampleDataHandler(event:SampleDataEvent):void 
		{
			var count:Number = 0;
			
			//var oldPoint:Point = new Point();
			
			while(event.data.bytesAvailable) 
			{ 
				var sample:Number = event.data.readFloat();
				var _y:Number = sample * 100000;
				if(_y > 0){
					var pos:int = _y % range;
					/*if(_y > 0)
						pos += 500;	*/							
					
					if(pos >= 0 && pos < soundRange.length){
						//trace("y:" + _y , "pos:" + pos);
						soundRange[pos].addData(_y);
						
						//var _x:int = (pos >= 500)?pos - 500:pos;
						//this.graphics.lineTo(_x , soundRange[pos].getAvgNumber() + (stage.stageHeight / 2));
					}
					
					
				}
				
				/*//}
				count++;
				if(count >= stage.stageWidth){
					count = 0;
					//this.graphics.clear();
				}*/
					
				
				//soundBytes.writeFloat(sample); 		
			} 
			//this.graphics.endFill();
		} 
	}
}