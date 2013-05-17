package Minesweeper
{
	import Minesweeper.Cell;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.ui.Keyboard;

	public class Game extends MovieClip
	{		
		private static const LargeText:TextFormat = new TextFormat();
		LargeText.color = 0x333333;
		LargeText.size = 16;
		LargeText.font = "Arial";
				
		public static var STAGE:Stage;
		public static var Playing:Boolean;
		private static var Rows:int;
		private static var Columns:int;
		private static var Mines:int;
		public static var MinesRemaining:int;
		private static var Seconds:int;
		public static var Grid:Array;
		private static var Clock:Timer;
		public static var FlagMode:Boolean;
		private static var GameBoard:MovieClip;
		private static var TimerField:TextField;
		public static var MinesField:TextField;
		public static var WinNotice:MovieClip;

		public function Game()
		{
			STAGE = this.stage;
			loaderInfo.addEventListener(Event.COMPLETE, Initialise);
		}
		
		public function Initialise(e:Event):void
		{
			// Set up our button handlers
			this.EasyButton.addEventListener(MouseEvent.MOUSE_UP, StartEasy);
			this.MediumButton.addEventListener(MouseEvent.MOUSE_UP, StartMedium);
			this.HardButton.addEventListener(MouseEvent.MOUSE_UP, StartHard);
			
			// Set up our clock
			Clock = new Timer(1000);
			Clock.addEventListener(TimerEvent.TIMER, Tick);
			
			// Set up our game board which holds all of the cells
			GameBoard = new MovieClip();
			GameBoard.buttonMode = true;
			GameBoard.useHandCursor = true;
			this.addChild(GameBoard);
			
			// Set up our timer and mine display fields
			TimerField = new TextField();
			TimerField.x = 15;
			TimerField.y = 354;
			TimerField.defaultTextFormat = LargeText;
			TimerField.selectable=  false;
			this.addChild(TimerField);
			
			MinesField = new TextField();
			MinesField.x = 151;
			MinesField.y = 354;
			MinesField.defaultTextFormat = LargeText;
			MinesField.selectable = false;
			this.addChild(MinesField);
			
			// Set up our win notice
			WinNotice = new Minesweeper.WinNotice();
			WinNotice.x = 0;
			WinNotice.y = 56;
			WinNotice.visible = false;
			this.addChild(WinNotice);
			
			// Set up our key handler for placing flags
			STAGE.addEventListener(KeyboardEvent.KEY_DOWN, FlagModeOn);
			STAGE.addEventListener(KeyboardEvent.KEY_UP, FlagModeOff);
			StartHard(null);
		}
		
		private static function StartEasy(e:MouseEvent):void
		{
			Rows = 9;
			Columns = 9;
			Mines = 10;
			StartGame();
		}
		
		private static function StartMedium(e:MouseEvent):void
		{
			Rows = 16;
			Columns = 16;
			Mines = 40;
			StartGame();
		}
		
		private static function StartHard(e:MouseEvent):void
		{
			Rows = 30;
			Columns = 16;
			Mines = 99;
			StartGame();
		}
		
		private static function StartGame():void
		{
			// Reset the game data
			Playing = true;
			MinesRemaining = Mines;
			Seconds = 0;
			FlagMode = false;
			TimerField.text = "0:00";
			MinesField.text = MinesRemaining + " mines";
			WinNotice.visible = false;
			
			// Reset the game grid
			while(GameBoard.numChildren > 0)
				GameBoard.removeChildAt(0);

			GameBoard.x = (600 - (Rows * 19)) / 2;
			GameBoard.y = (400 - (Columns * 19)) / 2;
					
			// Set up the mines
			Grid = new Array(Rows);
			var cell:Cell;
			var x:int;
			var y:int;
			
			for(x=0; x<Rows; x++)
			{
				Grid[x] = new Array(Columns);
				
				for(y=0; y<Columns; y++)
				{
					cell = new Cell(x, y);
					cell.x = x * 19;
					cell.y = y * 19;
					Grid[x][y] = cell;
					GameBoard.addChild(cell);
				}
			}		
			
			// Place the mines			
			var adjacentcells:Array;
			var i:int;
			var ax:int;
			var ay:int;
			var acell:Cell;
			
			while(Mines > 0)
			{
				// Choose a random cell to put the mine in
				x = Math.round(Math.random() * Rows - 1);
				y = Math.round(Math.random() * Columns - 1);
				
				// Make sure it's a valid cell
				if(!InRange(x, y))
					continue;
	
				cell = Grid[x][y];
				
				if(cell.Mined)
					continue;
					
				// We've placed a mine
				Mines--;
				cell.Mined = true;
				cell.Adjacent = 0;
	
				// Determine the cells adjacent to our new mine
				adjacentcells = Cell.AdjacentCells(x, y);
				
				if(adjacentcells.length == 0)
					continue;
					
				// Increase their adjacent count on all valid cells
				for(i=0; i<adjacentcells.length; i++)
				{
					ax = adjacentcells[i].X;					
					ay = adjacentcells[i].Y;
					acell = Grid[ax][ay];
					
					if(!acell.Mined)
					{
						acell.Adjacent += 1;
					}
				}
			}
			
			// Start the clock
			Clock.start();
		}
		
		// Key handlers for turning flag mode on/off
		private static function FlagModeOn(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SPACE)
			{
				FlagMode = true;
			}
		}
		
		private static function FlagModeOff(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SPACE)
			{
				FlagMode = false;
			}
		}
		
		// Our clock tick
		private static function Tick(e:TimerEvent):void
		{
			Seconds++;
			
			var minutes:int = Math.floor(Seconds / 60);
			var seconds:int = Seconds % 60;
			
			TimerField.text = minutes + ":" + (seconds > 9 ? seconds : "0" + seconds);
		}
		
		public static function CheckWin():void
		{
			var cell:Cell;
			
			for(var x:int=0; x<Rows; x++)
			{
				for(var y:int=0; y<Columns; y++)
				{
					cell = Grid[x][y];
					
					// If a cell has a mine but isn't flagged then we can't have won
					if(cell.Mined == true && !cell.Flagged)
						return;
				}
			}
			
			Playing = false;
			Clock.stop();
			WinNotice.visible = true;
		}
		
		public static function Lose():void
		{
			var cell:Cell;
			
			for(var x:int=0; x<Rows; x++)
			{
				for(var y:int=0; y<Columns; y++)
				{
					cell = Grid[x][y];
					Cell.FinalReveal(cell);
				}
			}
			
			Playing = false;
			Clock.stop();
		}
		
		// Removes every blank adjacent cell when we click a blank
		public static function ClearEmptySpaces(x:int, y:int):void
		{
			var adjacentcells:Array = Cell.AdjacentCells(x, y);
			
			if(adjacentcells.length == 0)
				return;
				
			var cell:Cell;
			var ax:int;
			var ay:int;
	
			for(var i:int=0; i<adjacentcells.length; i++)
			{
				ax = adjacentcells[i].X;				
				ay = adjacentcells[i].Y;
				cell = Grid[ax][ay];
				
				if(cell.Mined || cell.Flagged)
					continue;
	
				if(cell.Adjacent == 0)
				{
					Cell.Blank(cell);
					ClearEmptySpaces(ax, ay);
				}
				else
				{
					Cell.Reveal(cell);
				}
			}
		}
	
		// Checks if a cell coordinate is valid
		public static function InRange(x:int, y:int):Boolean
		{
			return (x > -1 && y > -1 && x < Rows && y < Columns && Grid[x][y] != null && Grid[x][y].Ignore == false);
		}
	}
}