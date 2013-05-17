package Doubloons
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NextLevel extends MovieClip
	{
		public function NextLevel()
		{
			this.alpha = 0;
			this.addEventListener(Event.ENTER_FRAME, this.FadeIn);
			
			this.NextLevelButton.addEventListener(MouseEvent.CLICK, this.StartNextLevel);
		}
		
		// Starts the next level
		private function StartNextLevel(e:MouseEvent):void
		{
			this.parent.removeChild(this);
			Main.CurrentLevelNumber++;
			Main.CurrentLevelRestarter = Level["Level" + Main.CurrentLevelNumber] as Function;
			Main.CurrentLevel = Main.CurrentLevelRestarter();
			Main.CurrentCoins = 0;
			Main.LevelHolder.removeChildAt(0);
			Main.LevelHolder.addChild(new Main.CurrentLevel.Clip());
			Main.Playing = true;
			
			SaveManager.Save(Main.CurrentLevelNumber);
		}
		
		private function FadeIn(e:Event):void
		{
			this.alpha += 0.05;
			
			if(this.alpha >= 1)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.FadeIn);
			}
		}
	}
}