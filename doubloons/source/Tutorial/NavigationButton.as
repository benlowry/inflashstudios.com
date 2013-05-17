package Tutorial
{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	public class NavigationButton extends MovieClip
	{
		public var Image:Bitmap;
		public var Enabled:Boolean;
		public var EnabledImage:BitmapData;
		public var DisabledImage:BitmapData;
		
		public function NavigationButton()
		{
			this.Image = new Bitmap();
			this.addChild(this.Image);
			
			this.Enabled = true;
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;			
		}
		
		public function Enable():void
		{
			this.useHandCursor = true;
			this.Enabled = true;
			this.Image.bitmapData = EnabledImage;
		}
		
		public function Disable():void
		{
			this.useHandCursor = false;
			this.Enabled = false;
			this.Image.bitmapData = DisabledImage;
		}
	}
}