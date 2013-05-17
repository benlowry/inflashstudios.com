package Doubloons
{
	import flash.display.MovieClip;
	
	public class SeagullManager extends MovieClip
	{
		private var NextSeagull:int = 0; // our timer for spawning new seagulls
		
		public function SeagullManager() { }
		
		public function Tick():void
		{
			// Move the seagulls around, we do this by going backwards
			// through the 'children' of our Seagulls clip and moving 
			// each one then checking if it has left the stage.  
			for(var i:int=this.numChildren-1; i>-1; i--)
			{
				var seagull:MovieClip = this.getChildAt(i) as MovieClip;
				seagull.x += seagull.MoveX;
				seagull.y += seagull.MoveY;
				
				// check if it's off the stage
				// condition 1 = it's come off the left edge (x + width)
				// condition 2 = it's come off the right edge (x)
				// condition 3 = it's come off the top edge (y + height)
				if(seagull.x + seagull.width < 0 || seagull.x > 550 || seagull.y + seagull.height < 0)
				{
					// remove from the display and array
					seagull.parent.removeChild(seagull);
				}			
			}
			
			// Check if we can spawn another seagull
			if(NextSeagull == 0)
			{				
				// Create the seagull
				var newseagull:MovieClip;
				
				if(Math.random() < 0.5)
				{
					// type one, moves up and to the right starting from the left edge
					newseagull = new Doubloons.Seagull1();
					newseagull.MoveX = 1 + Math.random();
					newseagull.MoveY = -0.01;
					newseagull.x = -newseagull.width;
					newseagull.y = Math.random() * 350;
				}
				else
				{
					// type two, moves up and to the left starting from the right edge
					newseagull = new Doubloons.Seagull2();
					newseagull.MoveX = -1;
					newseagull.MoveY = -0.01;
					newseagull.x = 550;
					newseagull.y = Math.random() * 350;					
				}
				
				this.addChild(newseagull);
				
				NextSeagull = Math.random() * 360;
			}
			else
			{
				NextSeagull--;
			}		
		}
	}
}