package Doubloons
{
	import flash.display.MovieClip;
	
	public class CloudManager extends MovieClip
	{
		private var NextCloud:int = 0; // our timer for spawning new clouds
		
		public function CloudManager() { }
		
		public function Tick():void
		{
			// Move the clouds around, we do this by going backwards
			// through the 'children' of our Clouds clip and moving 
			// each one then checking if it has left the stage.  
			for(var i:int=this.numChildren-1; i>-1; i--)
			{
				var cloud:MovieClip = this.getChildAt(i) as MovieClip;
				cloud.x -= 0.5;
				
				// check if it's off the stage
				if(cloud.x + cloud.width < 0)
				{
					// remove from the display and array
					cloud.parent.removeChild(cloud);
				}			
			}
			
			// Check if we can spawn another cloud
			if(NextCloud == 0)
			{				
				// Create the cloud
				var newcloud:MovieClip;
				var rand:Number = Math.random();
				
				if(rand < 0.25)
					newcloud = new Doubloons.Cloud1();
				else if(rand < 0.5)
					newcloud = new Doubloons.Cloud2();
				else if(rand < 0.75)
					newcloud = new Doubloons.Cloud3();
				else
					newcloud = new Doubloons.Cloud4();
				
				newcloud.x = 550;
				newcloud.y = Math.random() * 200;
				newcloud.scaleX = Math.random();
				newcloud.scaleY = newcloud.scaleX;
				
				this.addChild(newcloud);
				
				NextCloud = Math.random() * 600;
			}
			else
			{
				NextCloud--;
			}
		}
	}
}