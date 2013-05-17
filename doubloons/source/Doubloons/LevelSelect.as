package Doubloons
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class LevelSelect extends MovieClip
	{
		public function LevelSelect()
		{
			var level:MovieClip;
			var upto:int = SaveManager.Get();
			
			for(var i:int=1; i<13; i++)
			{
				level = this["Level" + i] as MovieClip;
				level.LevelNumber = i;
				level.LevelLoader = Doubloons.Level["Level" + i] as Function;
				
				// Create an instance of the level to get the thumbnail
				var l:Level = level.LevelLoader();
				
				// Create the thumbnail
				var thumb:MovieClip = new l.Clip();
				thumb.scaleX = 0.3;
				thumb.scaleY = 0.3;
				thumb.x = level.width / 2 - thumb.width / 2;
				thumb.y = level.height / 2 - thumb.height / 2;
				
				level.addChild(thumb);
					
				// If this level is higher than what we're up to we disable the button
				if(i > upto)
				{
					level.alpha = 0.5;
					level.useHandCursor = false;
				}
				
				// Otherwise we enable it and add the mouse over, out and click events
				else
				{
					level.useHandCursor = true;
					level.buttonMode = true;
					level.mouseChildren = false;
					level.filters = [new GlowFilter(0x000000, 0.3)];
					
					level.addEventListener(MouseEvent.CLICK, this.LoadLevel);
					level.addEventListener(MouseEvent.MOUSE_OVER, Over);
					level.addEventListener(MouseEvent.MOUSE_OUT, Out);					
				}
			}
		}
		
		// Clicking a level button
		private function LoadLevel(e:MouseEvent):void
		{
			var level:MovieClip = e.target as MovieClip;
			Main.CurrentLevel = level.LevelLoader();
			Main.CurrentLevelNumber = level.LevelNumber;			
			Main.CurrentLevelRestarter = level.LevelLoader;
			Main.LevelHolder.addChild(new Main.CurrentLevel.Clip());
			this.addEventListener(Event.ENTER_FRAME, this.FadeOut);
		}
		
		// Mousing over a level button
		private static function Over(e:MouseEvent):void
		{
			var level:MovieClip = e.target as MovieClip;
			level.filters = [new GlowFilter(0xFFCC00, 1)];
		}
		
		// Mousing off a level button
		private static function Out(e:MouseEvent):void
		{
			var level:MovieClip = e.target as MovieClip;			
			level.filters = [new GlowFilter(0x000000, 0.3)];
		}
		
		// Fades this screen out to start a new level
		private function FadeOut(e:Event):void
		{
			this.alpha -= 0.05;
			
			if(this.alpha <= 0)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.FadeOut);
				
				// go to the level selection
				this.parent.removeChild(this);				
				Main.Playing = true;
			}
		}
	}
}