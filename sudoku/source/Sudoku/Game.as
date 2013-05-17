package Sudoku
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class Game extends MovieClip
	{		
		public static var STAGE:Stage;
		public static var Playing:Boolean;
		private static var Grid:Array;
		private static var GridCells:Array;
		public static var CellHolder:MovieClip;
		private static var WinDialogue:Sudoku.WinDialogue;
		public static var Highlighter:Shape;
		
		public function Game()
		{
			STAGE = this.stage;
			loaderInfo.addEventListener(Event.COMPLETE, Initialise);			
		}
		
		private function Initialise(e:Event):void
		{
			// Set up our button click handlers
			this.NewGameButton.addEventListener(MouseEvent.MOUSE_UP, NewGame);
			this.HintButton.addEventListener(MouseEvent.MOUSE_UP, Hint);
			this.SolveButton.addEventListener(MouseEvent.MOUSE_UP, Solve);

			// Create the container movieclip for our cells
			CellHolder = new MovieClip();
			CellHolder.x = 10;
			CellHolder.y = 50;
			addChild(CellHolder);
			
			// Initialise our grid of cells
			Grid = new Array(9);
			GridCells = new Array(81);
			
			var gindex:int = 0;
			var cell:Cell;
						
			for(var x:int=0; x<9; x++)
			{
				Grid[x] = new Array(9);
				
				for(var y:int=0; y<9; y++)
				{
					cell = new Cell(x, y);
					Grid[x][y] = cell;
					GridCells[gindex] = cell;
					gindex++;
				}
			}
			
			// Create our highlighter to indicate which cell is being edited
			Highlighter = new Shape();
			Highlighter.graphics.lineStyle(0.1, 0x999999);
			Highlighter.graphics.moveTo(0, 0);
			Highlighter.graphics.lineTo(0, 47);
			Highlighter.graphics.lineTo(47, 47);
			Highlighter.graphics.lineTo(47, 0);
			Highlighter.graphics.lineTo(0, 0);
			Highlighter.graphics.endFill();
			Highlighter.visible = false;
			STAGE.addChild(Highlighter);

			// Create our win dialogue and hide it for later
			WinDialogue = new Sudoku.WinDialogue();
			WinDialogue.x = 10;
			WinDialogue.y = 239;
			WinDialogue.visible = false;
			STAGE.addChild(WinDialogue);
			
			
			NewGame();			
		}
		
		// Starts a new game
		private static function NewGame(e:MouseEvent = null):void
		{
			// Reset the grid
			ResetGrid();
			
			// Create a puzzle
			GeneratePuzzle();
			
			// Hide the win dialogue if it's visible
			WinDialogue.visible = false;
				
			var revealed:int = 28;
	
			while(revealed > 0)
			{
				var y = Random(0, 8);
				var x = Random(0, 8);
	
				if(Grid[y][x].Revealed == false)
				{
					Grid[y][x].Revealed = true;
					Cell.ShowAnswer(Grid[y][x]);
					revealed--;
				}
			}
			
			// Set the status  to playing
			Playing = true;
		}
		
		// Generates a Sudoku solution
		private static function GeneratePuzzle():void
		{
			var index:int = 0;
			
			while(index < 81)
			{
				var number:int = 0;
				var values:Array = [1,2,3,4,5,6,7,8,9];
	
				while(values.length > 0 && number == 0)
				{
					var zindex:int = Random(0, values.length);
					var z:int = values[zindex];
					values.splice(zindex, 1);
	
					if(!Conflicts(z, GridCells[index]))
					{
						number = z;
					}
				}
	
				if(number == 0)
				{
					var maxbacktrack:int = index > 10 ? 10 : index;
					var backtrack:int = Random(1, maxbacktrack);
					var backtracked:int = 0;
	
					while(backtracked < backtrack)
					{
						 GridCells[index - backtracked].Answer = 0;
						 backtracked++;
					}
	
					index -= backtrack;
				}
				else
				{
					GridCells[index].Answer = number;
					index++;
				}
			}
		}
			
		// Resets the grid to it's original state
		private static function ResetGrid():void
		{
			// Go through each cell
			for(var i:int=0; i<81; i++)
			{
				// Reset it
				Cell.Reset(GridCells[i]);
			}
		}
		
		// Checks if there are any available cells
		private static function AvailableCells():Boolean
		{
			// Go through each cell
			for(var i:int=0; i<81; i++)
			{
				// Check if it's empty
				if(Cell.GetAnswer(GridCells[i]) == "")
				{
					return true;
				}
			}
			
			return false;
		}
			
		// Check if there is a conflict between a cell and the row, column and 
		// region it's on
		private static function Conflicts(number:int, cell:Sudoku.Cell):Boolean
		{
			// Check the rows and columns
			for(var i:int=0; i<9; i++)
			{
				if(Grid[cell.X][i].Answer == number || Grid[i][cell.Y].Answer == number)
				{
					return true;
				}
			}
	
			// Check the region it's in
			for(var x:int=cell.RegionRowStart; x<cell.RegionRowStart+3; x++)
			{
				for(var y:int=cell.RegionColStart; y<cell.RegionColStart+3; y++)
				{
					if(Grid[x][y].Answer == number)
					{
						return true;
					}
				}
			}
	
			return false;
		}
			
		// Generates a random number between min and max inclusive
		private static function Random(min:int, max:int):int
		{
			var number:int = min - 1;
	
			while(number < min || number > max)
			{
				number = min + Math.round(Math.random() * (max - min));
			}
	
			return number;
		}
		
		// Reveals one correct answer for the player
		private static function Hint(e:MouseEvent):void
		{
			if(!Playing)
				return;
				
			if(AvailableCells() == false)
				return;
	
			// Because we're not sure which cell to reveal we have to
			// keep doing this till we find one
			var done:Boolean = false;
			var cell:Cell;
	
			while(!done)
			{
				// Select a random cell
				var row:int = Random(0, 8);
				var column:int = Random(0, 8);
				cell = Grid[row][column];
	
				// If it's not revealed then we do so
				if(cell.Revealed == false)
				{
					Cell.ShowAnswer(cell);
					
					// Check if the game's over now
					CheckWin();
					
					return;
				}
			}
		}
		
		// Checks if all cells have been correctly filled out
		public static function CheckWin():void
		{
			// Don't check if there are any empty cells
			if(AvailableCells() == true)
				return;
				
			// Check the rows and columns
			var rowcell:Cell;
			var rowanswer:String;
			var rowanswers:String;
			var colcell:Cell;
			var colanswer:String;
			var colanswers:String;
			
			for(var i:int=0; i<9; i++)
			{
				rowanswers = "";
				colanswers = "";
				
				for(var j=0; j<9; j++)
				{
					rowcell = Grid[i][j];
					colcell = Grid[j][i];
					
					// Check the row answer, if it's blank or already been
					// entered we can return
					rowanswer = Cell.GetAnswer(rowcell);
					
					if(rowanswer == "" || rowanswers.indexOf(rowanswer) > -1)
						return;
	
					// Check the column answer
					colanswer = Cell.GetAnswer(colcell);
	
					if(colanswer == "" || colanswers.indexOf(colanswer) > -1)
						return;
	
					// Append these answers to our check lists
					rowanswers += rowanswer;
					colanswers += colanswer;
				}
			}
	
			// Check the regions
			var regionanswers:String;
			var regionanswer:String;
			var rowstart:int = 0;
			var colstart:int = 0;

			for(var k:int=1; k<10; k++)
			{
				// Work out what the x/y coordinates of the region we're in begin at
				switch(k)
				{
					case 1:
						rowstart = 0;
						colstart = 0;
						break;
	
					case 2:
						rowstart = 3;
						colstart = 0;
						break;
	
					case 3:
						rowstart = 6;
						colstart = 0;
						break;
	
					case 4:
						rowstart = 0;
						colstart = 3;
						break;
	
					case 5:
						rowstart = 3;
						colstart = 3;
						break;
	
					case 6:
						rowstart = 6;
						colstart = 3;
						break;
	
					case 7:
						rowstart = 0;
						colstart = 6;
						break;
	
					case 8:
						rowstart = 3;
						colstart = 6;
						break;
	
					case 9:
						rowstart = 6;
						colstart = 6;
						break;
				}
	
				// Check each cell in this region
				regionanswers = "";
	
				for(var x:int=rowstart; x<rowstart+3; x++)
				{
					for(var y:int=colstart; y<colstart+3; y++)
					{
						rowcell = Grid[x][y];
						
						regionanswer = Cell.GetAnswer(rowcell);
	
						// If there's no answer
						if(regionanswer == "" || regionanswers.indexOf(regionanswer) > -1)
							return;
	
						// Append the answer to our check list
						regionanswers += regionanswer;
					}
				}
			}
				
			Playing = false;
			WinDialogue.visible = true;
			STAGE.setChildIndex(WinDialogue, STAGE.numChildren - 1);
		}
		
		// Solves the puzzle
		private static function Solve(e:MouseEvent):void
		{
			if(!Playing)
				return;
				
			// We're not playing any more
			Playing = false;
	
			// Go through each cell and show the answer
			for(var i:int=0; i<81; i++)
			{
				if(GridCells[i].Revealed == false)
				{
					Cell.ShowAnswer(GridCells[i]);
				}
			}
		}
	}
}