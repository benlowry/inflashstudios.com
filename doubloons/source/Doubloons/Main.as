package Doubloons
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import Sounds.*;
		
	public class Main extends MovieClip
	{
		private var Loading:Boolean = true; // a trigger that tells us the game is still loading
		public static var SoundOn:Boolean = true; // a trigger that tells us whether sound is on or off
		public static var Playing:Boolean = false; // a trigger that tells us the user is playing		
		
		// playing and scoring information
		public static var CurrentLevel:Level; // the current level
		public static var CurrentLevelRestarter:Function; // method to restart this level
		public static var CurrentLevelNumber:int = 0;		
		public static var CurrentCoins:int = 0; // the current coins i've collected
		public static var TotalCoins:int = 0; // the total coins i've collected
		public static var LevelHolder:MovieClip;
		
		// shooting information
		private var FiringPower:int;
		private var FiringAngle:Number;
		private var FiringIncrement:int;
		
		// our scenery managers
		private var Water:WaterManager; // the water manager controls moving the water back and forth
		private var Seagulls:SeagullManager; // the seagull manager controls spawning and moving seagulls
		private var Clouds:CloudManager; // the cloud manager controls spawning and moving clouds
		
		public function Main()
		{			
			// Set up the water manager
			this.Water = new WaterManager();
			this.Water.Pieces = [this.Water1, this.Water2, this.Water3];
			this.Water.Pieces[0].Direction = 1;
			this.Water.Pieces[1].Direction = 1;
			this.Water.Pieces[2].Direction = -1;
			
			// Set up the seagull and cloud managers
			this.Clouds = new CloudManager();
			this.addChild(this.Clouds);
			
			this.Seagulls = new SeagullManager();
			this.addChild(this.Seagulls);
			
			// Set up the level holder
			LevelHolder = new MovieClip();
			LevelHolder.x = 182;
			LevelHolder.y = 90;
			this.addChild(LevelHolder);
			
			// Put the ship over the seaguls, the cannon over the ship, and water3 over the ship
			this.setChildIndex(this.Ship, this.numChildren - 1);
			this.setChildIndex(this.Cannon, this.numChildren - 1);
			this.setChildIndex(this.Water3, this.numChildren - 1);
			this.setChildIndex(this.StatusBar, this.numChildren - 1);
			
			// Hide the status bar and cannon power
			this.StatusBar.visible = false;
			
			this.CannonBall.visible = false;
			this.CannonBall.smoothing = true;
			
			this.CannonPower.visible = false;
			this.CannonPower.x = (stage.stageWidth / 2) - (this.CannonPower.width / 2);
			this.CannonPower.y = (stage.stageHeight / 2) - (this.CannonPower.height / 2);
			this.setChildIndex(this.CannonPower, this.numChildren - 1);
			this.setChildIndex(this.CannonBall, this.numChildren - 1);
		
			// Set up the gameloop, a method that runs over and over again and 
			// processes all of our game logic
			stage.addEventListener(Event.ENTER_FRAME, this.Tick);
			
			// Set up the sound button
			this.SoundButton.addEventListener(MouseEvent.CLICK, this.ToggleSound);			
			
			// Set up the restart button
			this.RestartSmallButton.addEventListener(MouseEvent.CLICK, this.RestartLevel);
			this.QuitSmallButton.addEventListener(MouseEvent.CLICK, this.QuitLevel);			
			
			// Set up the mouse tracker that angles the cannon if we are playing
			stage.addEventListener(MouseEvent.MOUSE_MOVE, this.RotateCannon);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, this.LoadCannon);

			// Set up the events that will track the preloader
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, this.PreloadProgress);
			loaderInfo.addEventListener(Event.COMPLETE, this.PreloadComplete);
		}
		
		// This method is called each time a bit of the movie loads
		private function PreloadProgress(e:ProgressEvent):void
		{
			var done:Number = loaderInfo.bytesLoaded;
			var total:Number = loaderInfo.bytesTotal;
			
			// Update the progress bar
			//this.Bar.width = (done / total) * 200;
		}
		
		// This method is called when the preloading is finished
		private function PreloadComplete(e:Event):void
		{
			// Get rid of the event listeners for preloading the movie
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, this.PreloadProgress);
			loaderInfo.removeEventListener(Event.COMPLETE, this.PreloadComplete);
			
			// Set our loading trigger to false so the gameloop continues
			this.Loading = false;
			
			// Attach the main menu
			this.addChild(new Menu());
		}
		
		// Our gameloop
		private function Tick(e:Event):void
		{
			// water, seagulls and clouds
			this.Water.Tick();
			this.Seagulls.Tick();
			this.Clouds.Tick();

			// at this point if the game is still loading or we aren't playing we don't go any further in the gameloop
			if(Loading || !Playing)
				return;
				
			// status bar
			this.StatusBar.visible = true;
			this.StatusBar.Level.text = "LEVEL " + CurrentLevelNumber + ": " + CurrentLevel.CoinsToWin + " COINS";
			this.StatusBar.Shots.text = CurrentLevel.Shots.toString();
			this.StatusBar.Coins.text = CurrentCoins.toString();
			
			// cannon ball
			if(this.CannonBall.visible)
			{
				this.CannonBall.rotation += 3;
	            this.CannonBall.DirectionY += 3; // gravity
				
				// Move the ball, because we can be adjusting x/y in large amounts we break it down
				// into a series of steps that allow us to check at each pixel whether we've hit
				// something.
				var movex:Number = this.CannonBall.DirectionX / 2;
				var movey:Number = this.CannonBall.DirectionY / 2;
				
				var xsteps:int = Math.ceil(Math.abs(movex));
				var ysteps:int = Math.ceil(Math.abs(movey));
				
				// These variables are for the items in the level.  We declare outside of 
				// the while loop because they are used every time and we it's more efficient 
				// than creating new variables every time we go through the loop
				var level:MovieClip = LevelHolder.getChildAt(0) as MovieClip;
				var ballp:Point = new Point(this.CannonBall.x - 9, this.CannonBall.y - 9);
				var item:MovieClip;
				var itemp:Point = new Point();
				var i:int;
				var distance:Number;
				
				// Calculate the  ball moving					
				while(xsteps > 0 || ysteps > 0)
				{								
					if(xsteps > 0)
						this.CannonBall.x += movex > 0 ? 1 : -1;
						
					if(ysteps > 0)
						this.CannonBall.y += movey > 0 ? 1 : -1;
					
					xsteps--;
					ysteps--;
					
					// Check if it's moved off the stage
					if(this.CannonBall.y > 400 || this.CannonBall.x > 550)
					{
						this.CannonBall.visible = false;
						
						// Check if the level is complete:
						// 1) We have enough coins (go to next level or win)
						// 2) We have no more shots (restart this level)
						if(CurrentCoins >= CurrentLevel.CoinsToWin)
						{
							if(CurrentLevelNumber < 12)
							{
								// next level
								Playing = false;
								this.addChild(new NextLevel());
							}
							else
							{
								// win
								Playing = false;
								this.addChild(new Win());
							}
						}
						
						else if(CurrentLevel.Shots == 0)
						{
							Playing = false;
							this.addChild(new Restart());
							
						}
						
						return;						
					}
					
					// Otherwise check if it's hit anything in the level
					for(i=level.numChildren-1; i>-1; i--)
					{
						item = level.getChildAt(i) as MovieClip;
						
						// Check for hits, because the items are circles
						// we have always got a hit if the distance between
						// the ball and an item is less than their combined
						// radiuses.
						itemp.x = LevelHolder.x + item.x + 9;
						itemp.y = LevelHolder.y + item.y + 9;
							
						distance = Math.abs(Point.distance(ballp, itemp));
						
						if(distance > (item.width / 2) + (this.CannonBall.width / 2))
							continue;

						// If we've hit a doubloon then we've collected it
						if(item is Doubloon)
						{
							CurrentCoins++;
							TotalCoins++;
							level.removeChildAt(i);	
							
							SoundManager.Play(Sounds.GotDoubloon);
						}
						
						// If we hit a blocker then the ball is going to drop straight down
						else if(item is Blocker && !item.Ignore)
						{
							item.Ignore = true; // We set this so we don't keep processing the hit against this blocker
							
							this.CannonBall.DirectionX = 0;
							this.CannonBall.DirectionY = 0;
							
							// Put the sound here
							SoundManager.Play(Sounds.GotBlocker);
							
							continue;
						}
					}
				}
			}
		}
		
		// Loads the cannon for firing.  This sets up the AdjustCannonPower
		// enterframe event which increases and decreases power until we
		// release the mouse button
		private function LoadCannon(e:MouseEvent):void
		{
			// If we're not playing, or we are currently watching a shot
			if(!Playing || this.CannonBall.visible)
				return;
			
			// If we clicked on a button
			if(e.target is SimpleButton)
				return;
				
			this.CannonPower.visible = true;
			this.CannonPower.addEventListener(Event.ENTER_FRAME, this.AdjustCannonPower);
			stage.addEventListener(MouseEvent.MOUSE_UP, this.FireCannon);
			
			this.FiringPower = 0;
			this.FiringIncrement = 1;
		}
		
		// Fires the cannon
		private function FireCannon(e:MouseEvent):void
		{
			if(!Playing || this.CannonBall.visible)
				return;			
				
			// Get rid of the cannon power movieclip and enterframe
			this.CannonPower.visible = false;
			this.CannonPower.removeEventListener(Event.ENTER_FRAME, this.AdjustCannonPower);
			stage.removeEventListener(MouseEvent.MOUSE_UP, this.FireCannon);
			
			// Reset any 'ignored' items in the level
			var level:MovieClip = LevelHolder.getChildAt(0) as MovieClip;
			var item:MovieClip;
			
			for(var i:int =level.numChildren-1; i>-1; i--)
			{
				item = level.getChildAt(i) as MovieClip;
				item.Ignore = false;
			}
				
			// Reset the cannon ball
			var ballpoint:Point = this.Cannon.localToGlobal(new Point(this.Cannon.FiringPoint.x, this.Cannon.FiringPoint.y));
			this.CannonBall.x = ballpoint.x;
			this.CannonBall.y = ballpoint.y;
			this.CannonBall.visible = true;
			
			// Apply the angle / power to the cannon ball
			this.CannonBall.Angle = this.Cannon.rotation;
			this.CannonBall.StartX = ballpoint.x;
			this.CannonBall.StartY = ballpoint.y;
			this.CannonBall.DirectionX = Math.cos(this.Cannon.rotation * Math.PI / 180) * this.FiringPower;
			this.CannonBall.DirectionY = Math.sin(this.Cannon.rotation * Math.PI / 180) * this.FiringPower;
			
			// Subtract this shot
			CurrentLevel.Shots--;
			
			// Play the sound
			SoundManager.Play(Sounds.Boom);
		}
		
		// Adjusts the cannon power 		
		private function AdjustCannonPower(e:Event):void
		{
			this.FiringPower += this.FiringIncrement;
			
			// Reverse the increase direction if it's 100 or 1
			if(this.FiringPower == 100)
				this.FiringIncrement = -1;
			else if(this.FiringPower == 1)
				this.FiringIncrement = 1;
			
			// Update the textfield and its shadow
			this.CannonPower.Power.text = this.FiringPower.toString();
			this.CannonPower.Power2.text = this.FiringPower.toString();			
			
			// Update the background fill (circle that fills up)
			this.CannonPower.Fill.height = (this.FiringPower / 100) * 40;
			this.CannonPower.Fill.y = 40 - this.CannonPower.Fill.height;
		}
		
		// Rotates the cannon to follow the mouse
		private function RotateCannon(e:MouseEvent):void
		{
			// if we're not playing or the cannonball is visible then don't rotate the cannon
			if(!Playing || this.CannonBall.visible)
				return;

			// get the angle from the cannon to the mouse		
			var radians:Number = Math.atan2(e.stageY - this.Cannon.y, e.stageX - this.Cannon.x);
			
			// if the angle is outside of these numbers don't rotate it
			if(radians < -1.5 || radians > 0.25)
				return;

			this.Cannon.rotation = radians * (180 / Math.PI);
		}		
		
		// turns the sound on or off
		private function ToggleSound(e:MouseEvent):void
		{
			SoundOn = !SoundOn;
			this.SoundButton.alpha = SoundOn ? 1 : 0.5;
		}
		
		// Restarts the level
		private function RestartLevel(e:MouseEvent):void
		{
			CurrentLevel = Main.CurrentLevelRestarter();
			CurrentCoins = 0;
			LevelHolder.removeChildAt(0);
			LevelHolder.addChild(new Main.CurrentLevel.Clip());
		}
		
		// Quits the level
		private function QuitLevel(e:MouseEvent):void
		{
			Playing = false;
			LevelHolder.removeChildAt(0);
			this.addChild(new Menu());
		}
	}
}