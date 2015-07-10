package com.matis.sound
{
	public class RecordData
	{
		private var data:Vector.<Number> = new Vector.<Number>();
		public function RecordData()
		{
		}
		
		
		public function addData(_num:Number):void{
			data.push(_num);
		}
		
		public function getAvgNumber():Number{
			var count:Number = 0;
			if(data.length > 0){
				for each(var num:Number in data){
					count += num;
				}
				//trace("count:" + count , "data:" + data.length);
				count = Math.abs(count / 5);
			}
			return count;
		}
		
		
		public function resetData():void{
			data.length = 0;
		}
	}
}