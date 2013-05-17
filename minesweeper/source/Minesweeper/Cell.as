package Minesweeper
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;	
	import flash.text.TextField;
		
	public class Cell extends MovieClip
	{
		// The text colors for cells, the index position represents
		// the number of adjacent mines
		private static const Colors:Array = new Array(9);
		Colors[1] = 0x0004FF;
		Colors[2] = 0x007000;
		Colors[3] = 0xFE0100;
		Colors[4] = 0x05006C;
		Colors[5] = 0x840800;
		Colors[6] = 0x008284;
		Colors[7] = 0x840084;
		Colors[8] = 0x000000;

		private var X:int;
		private var Y:int;
		public var Mined:Boolean;
		public var Flagged:Boolean;
		private var Questioned:Boolean;
		public var Ignore:Boolean;
		public var Adjacent:int;

		public function Cell(x:int, y:int)
		{
			this.Mined = false;
			this.Flagged = false;
			this.Questioned = false;
			this.Ignore = false;
			this.X = x;
			this.Y = y;
			this.Adjacent = 0;
			
			this.gotoAndStop(1);
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false
			this.addEventListener(MouseEvent.MOUSE_UP, Click);
		}
		
		private static function Click(e:MouseEvent):void
		{
			if(!Game.Playing)
				return;
				
			var cell:Cell = e.target as Cell;
			
			// When we're in flag mode
			if(Game.FlagMode == true)
			{
				// Make questioned if it's flagged
				if(cell.Flagged)
				{
					cell.gotoAndStop(6);
					cell.Questioned = true;					
					cell.Flagged = false;
					Game.MinesRemaining++;
					Game.MinesField.text = Game.MinesRemaining + (Game.MinesRemaining != 1 ? " mines" : " mine");
				
				}
				
				// Make normal if it's questioned
				else if(cell.Questioned)
				{
					cell.gotoAndStop(1);
					cell.Flagged = false;
					cell.Questioned = false;
				}
				
				// Make flagged if it's normal and there's available mines
				else if(Game.MinesRemaining > 0)
				{
					Game.MinesRemaining--;
					Game.MinesField.text = Game.MinesRemaining + (Game.MinesRemaining != 1 ? " mines" : " mine");
					cell.gotoAndStop(4);
					cell.Flagged = true;
					cell.Questioned = false;
				}
				
				return;
			}
			
			// When the cell is blank
			if(cell.Ignore)
			{
				if(cell.AdjacentField.text != "")
				{
					var adjacentcells:Array = AdjacentCells(cell.X, cell.Y);
					
					if(adjacentcells.length == 0)
						return;
						
					var adjacentminesfound:int = 0;
					var acell:Cell;
					var ax:int;
					var ay:int;
					
					for(var i:int=0; i<adjacentcells.length; i++)
					{
						ax = adjacentcells[i].X;
						ay = adjacentcells[i].Y;				
						acell = Game.Grid[ax][ay];
						
						if(acell.Mined && acell.Flagged)
						{
							adjacentminesfound++;
						}
					}
					
					if(adjacentminesfound == cell.Adjacent)
					{					
						Game.ClearEmptySpaces(cell.X, cell.Y);
					}
				}
			
				return;
			}

			// Otherwise if we've flagged or questioned the cell we leave
			if(cell.Flagged || cell.Questioned)
				return;
				
			// If there's a mine and it's not flagged we lose
			if(cell.Mined && cell.Flagged == false)
			{
				cell.gotoAndStop(5);
				Game.Lose();
				return;
			}
			
			// Clear the mine, and possibly any adjacent cells
			if(cell.Adjacent == 0)
			{
				cell.gotoAndStop(2);
				Game.ClearEmptySpaces(cell.X, cell.Y);
			}
			else
			{
				Reveal(cell);
			}
			
			// Check to see if we won the game
			Game.CheckWin();			
		}
		
		// Makes the cell blank
		public static function Blank(cell:Cell):void
		{
			cell.Ignore = true;
			cell.gotoAndStop(2);
		}
		
		// Reveals a cell with adjacent mines		
		public static function Reveal(cell:Cell):void
		{
			cell.Ignore = true;
			cell.gotoAndStop(3);
			cell.AdjacentField.text = String(cell.Adjacent);
			cell.AdjacentField.textColor = Colors[cell.Adjacent];
		}
		
		// Reveals the cell whether it's mined or not
		public static function FinalReveal(cell:Cell):void
		{
			if(cell.Mined == false)
			{
				cell.gotoAndStop(2);
				
				if(cell.Adjacent > 0)
				{
					cell.AdjacentField.text = String(cell.Adjacent);
					cell.AdjacentField.textColor = Colors[cell.Adjacent];
				}
			}
			else if(cell.Flagged == false)
			{
				cell.gotoAndStop(5);
			}
		}
		
		// Returns the coordinates of any adjacent cells
		public static function AdjacentCells(x:int, y:int):Array
		{
			var adjacentcells:Array = new Array();
			
			if(Game.InRange(x - 1, y - 1))
				adjacentcells.push(new Coordinates(y - 1, x - 1));
				
			if(Game.InRange(x, y - 1))
				adjacentcells.push(new Coordinates(y - 1, x));
				
			if(Game.InRange(x + 1, y - 1))
				adjacentcells.push(new Coordinates(y - 1, x + 1));
				
			if(Game.InRange(x - 1, y))
				adjacentcells.push(new Coordinates(y    , x - 1));
												 
			if(Game.InRange(x + 1, y))
				adjacentcells.push(new Coordinates(y    , x + 1));
				
			if(Game.InRange(x - 1, y + 1))
				adjacentcells.push(new Coordinates(y + 1, x - 1));
				
			if(Game.InRange(x, y + 1))
				adjacentcells.push(new Coordinates(y + 1, x));
				
			if(Game.InRange(x + 1, y + 1))
				adjacentcells.push(new Coordinates(y + 1, x + 1));
				
			return adjacentcells;
		}
	}
}