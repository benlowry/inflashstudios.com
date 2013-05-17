package Tutorial
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Assets.*;
	
	public class Main extends MovieClip
	{
		private static var HomeButton:NavigationButton;
		private static var BackButton:NavigationButton;
		private static var ForwardButton:NavigationButton;
		private static var LastButton:NavigationButton;
		private static var PageContainer:MovieClip;
		
		private static const Pages:Array = new Array();
		Pages[0] = new Tutorial.Part1A();
		Pages[1] = new Tutorial.Part1B();
		Pages[2] = new Tutorial.Part1C();
		Pages[3] = new Tutorial.Part1D();
		Pages[4] = new Tutorial.Part1E();
		Pages[5] = new Tutorial.Part1F();
		Pages[6] = new Tutorial.Part1G();
		Pages[7] = new Tutorial.Part1H();
						
		private static const Menu:Array = new Array();
		Menu[0] = new Tutorial.MenuButton("Introduction", 1);
		Menu[1] = new Tutorial.MenuButton("The sky", 1);
		Menu[2] = new Tutorial.MenuButton("The ship", 1);
		Menu[3] = new Tutorial.MenuButton("The water", 1);
		Menu[4] = new Tutorial.MenuButton("The cannon", 1);
		Menu[5] = new Tutorial.MenuButton("Sound and restart buttons", 1);		
		Menu[6] = new Tutorial.MenuButton("Firing power", 1);
		Menu[7] = new Tutorial.MenuButton("The status bar", 1);

		private static var Page:int = 0;
		
		public function Main()
		{
			 loaderInfo.addEventListener(Event.COMPLETE, Initialise);
			 this.stop();
		}
		
		private function Initialise(e:Event):void
		{
			this.gotoAndStop(2);
			
			// navigation buttons
			HomeButton = new NavigationButton();
			HomeButton.x = 463;
			HomeButton.y = 1;
			HomeButton.EnabledImage = new Assets.Home(32, 32);
			HomeButton.DisabledImage = new Assets.HomeDisabled(32, 32);
			HomeButton.Enable();
			HomeButton.addEventListener(MouseEvent.CLICK, Home);
			stage.addChild(HomeButton);
			
			BackButton = new NavigationButton();
			BackButton.x = 496;
			BackButton.y = 1;
			BackButton.EnabledImage = new Assets.Back(32, 32);
			BackButton.DisabledImage = new Assets.BackDisabled(32, 32);
			BackButton.Enable();
			BackButton.addEventListener(MouseEvent.CLICK, Back);
			stage.addChild(BackButton);
			
			ForwardButton = new NavigationButton();
			ForwardButton.x = 529;
			ForwardButton.y = 1;
			ForwardButton.EnabledImage = new Assets.Forward(32, 32);
			ForwardButton.DisabledImage = new Assets.ForwardDisabled(32, 32);
			ForwardButton.Enable();
			ForwardButton.addEventListener(MouseEvent.CLICK, Forward);
			stage.addChild(ForwardButton);
			
			LastButton = new NavigationButton();
			LastButton.x = 562;
			LastButton.y = 1;
			LastButton.EnabledImage = new Assets.Last(32, 32);
			LastButton.DisabledImage = new Assets.LastDisabled(32, 32);
			LastButton.Enable();
			LastButton.addEventListener(MouseEvent.CLICK, Last);
			stage.addChild(LastButton);		
			
			// menu buttons
			var button:MenuButton;			

			for(var j:int=0; j<Menu.length; j++)
			{
				button = Menu[j];
				button.x = 10;
				button.y = 40 + (j * 16) + (button.Group * 24);
				button.Page = j;
				button.addEventListener(MouseEvent.CLICK, SetPage);
				stage.addChild(button);
			}
			
			// page container			
			PageContainer = new MovieClip();
			PageContainer.x = 170;
			PageContainer.y = 40;
			stage.addChild(PageContainer);
			
			ShowPage();
		}
		
		private function SetPage(e:MouseEvent):void
		{
			var button:MenuButton = e.target as MenuButton;
			Page = button.Page;
			
			ShowPage();
		}
		
		private function ShowPage():void
		{
			// Show the page
			while(PageContainer.numChildren > 0)
				PageContainer.removeChildAt(0);
				
			PageContainer.addChild(Pages[Page]);
			
			// Refresh the navigation buttons
			if(Page == 0)
			{
				HomeButton.Disable();
				BackButton.Disable();
				ForwardButton.Enable();
				LastButton.Enable();
			}
			else
			{
				HomeButton.Enable();
				BackButton.Enable();
				
				if(Page == Pages.length - 1)
				{
					ForwardButton.Disable();
					LastButton.Disable();
				}
				else
				{
					ForwardButton.Enable();
					LastButton.Enable();
				}
			}
			
			// Refresh the menu buttons
			for(var i:int=0; i<Menu.length; i++)
			{
				Menu[i].Label.textColor = i == Page ? 0x999999 : 0x555555;
			}
		}
		
		private function Home(e:MouseEvent):void
		{
			if(!HomeButton.Enabled)
				return;
				
			Page = 0;
			ShowPage();
		}
		
		private function Back(e:MouseEvent):void
		{
			if(!BackButton.Enabled)
				return;
				
			Page -= 1;
			ShowPage();
		}
		
		private function Forward(e:MouseEvent):void
		{
			if(!ForwardButton.Enabled)
				return;
				
			Page += 1;
			ShowPage();
		}
		
		private function Last(e:MouseEvent):void
		{
			if(!LastButton.Enabled)
				return;
				
			Page = Pages.length - 1;
			ShowPage();
		}
	}
}