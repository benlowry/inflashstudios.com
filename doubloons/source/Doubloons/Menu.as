package Doubloons
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Menu extends MovieClip
	{
		public function Menu()
		{
			this.alpha = 0;
			this.addEventListener(Event.ENTER_FRAME, this.FadeIn);
			
			this.PlayButton.addEventListener(MouseEvent.CLICK, this.Play);
		}
		
		private function Play(e:MouseEvent):void
		{
			this.parent.addChild(new LevelSelect());
			this.parent.removeChild(this);
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