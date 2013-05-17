package Doubloons
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Restart extends MovieClip
	{
		public function Restart()
		{
			this.alpha = 0;
			this.addEventListener(Event.ENTER_FRAME, this.FadeIn);
			
			this.RestartButton.addEventListener(MouseEvent.CLICK, this.RestartLevel);
		}
		
		// Restarts the level
		private function RestartLevel(e:MouseEvent):void
		{
			this.parent.removeChild(this);
			Main.CurrentLevel = Main.CurrentLevelRestarter();
			Main.CurrentCoins = 0;
			Main.LevelHolder.removeChildAt(0);
			Main.LevelHolder.addChild(new Main.CurrentLevel.Clip());
			Main.Playing = true;
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