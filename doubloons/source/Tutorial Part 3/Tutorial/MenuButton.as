package Tutorial
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class MenuButton extends MovieClip
	{		
		public var Page:int;
		public var Group:int;
		
		public function MenuButton(text:String = "", group:int = 0)
		{
			this.Label.text = text;
			this.Group = group;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
		}
	}
}