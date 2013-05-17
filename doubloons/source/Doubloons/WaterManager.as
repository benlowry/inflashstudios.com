package Doubloons
{
	import flash.display.MovieClip;
	
	public class WaterManager extends MovieClip
	{
		public var Pieces:Array;
		
		public function WaterManager() { }
		
		public function Tick():void
		{
			// Move each piece of the water around
			for each(var water:MovieClip in this.Pieces)
			{
				water.x += water.Direction;
				
				if(water.x == 0 || water.x + water.width == 550)
				{
					water.Direction = water.Direction == 1 ? -1 : 1;
				}
			}
		}
	}
}