package Doubloons
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Win extends MovieClip
	{
		public function Win()
		{
			this.alpha = 0;
			this.addEventListener(Event.ENTER_FRAME, this.FadeIn);
			
			this.addEventListener(MouseEvent.CLICK, this.Close);
		}
		
		private function Close(e:MouseEvent):void
		{
			this.parent.addChild(new Menu());
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