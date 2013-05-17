package Sudoku
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;	
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
		
	public class Cell extends MovieClip
	{
		// Common properties of the cells
		private static const HintFormat:TextFormat = new TextFormat();
		HintFormat.size = 25;
		HintFormat.color = 0x666666;
		HintFormat.font = "Arial";
		HintFormat.align = TextFormatAlign.CENTER;
			
		private static const AnswerFormat:TextFormat = new TextFormat();
		AnswerFormat.size = 25;
		AnswerFormat.color = 0x000000;
		AnswerFormat.font = "Arial";
		AnswerFormat.align = TextFormatAlign.CENTER;
		
		private static const ScratchFormat:TextFormat = new TextFormat();
		ScratchFormat.size = 10;
		ScratchFormat.color = 0x666666;
		ScratchFormat.font = "Arial";
		ScratchFormat.align = TextFormatAlign.LEFT;
		
		// The cell state information
		public var Answer:int;
		public var Revealed:Boolean;
		
		// The grid and region information
		public var X:int;
		public var Y:int;
		public var Region:int;		
		public var RegionRowStart:int;
		public var RegionColStart:int;
		
		// The text fields
		private var TextBox:TextField;
		private var ScratchBox:TextField;

		public function Cell(x:int, y:int)
		{
			// Set up our cell
			this.Answer = 0;
			this.Revealed = false;
			this.X = x;
			this.Y = y;
	
			// Set up the main text field
			this.TextBox = new TextField();
			this.TextBox.maxChars = 1;
			this.TextBox.type = "input";
			this.TextBox.x = (x * 50);
			this.TextBox.y = 7 + (y * 50);
			this.TextBox.multiline = false;
			this.TextBox.width = 49;
			this.TextBox.height = 30;
			this.TextBox.defaultTextFormat = AnswerFormat;
			this.TextBox.addEventListener(KeyboardEvent.KEY_UP, ValueChanged);
			this.TextBox.addEventListener(FocusEvent.FOCUS_IN, this.Highlight);
			this.TextBox.addEventListener(FocusEvent.FOCUS_OUT, UnHighlight);

			// Set up the 'scratch' text field which is for notes
			this.ScratchBox = new TextField();
			this.ScratchBox.maxChars = 9;
			this.ScratchBox.type = "input";
			this.ScratchBox.x = (x * 50);
			this.ScratchBox.y = 7 + (y * 50) + 28;
			this.ScratchBox.defaultTextFormat = ScratchFormat;
			this.ScratchBox.height = 15;
			this.ScratchBox.addEventListener(FocusEvent.FOCUS_IN, this.Highlight);
			this.ScratchBox.addEventListener(FocusEvent.FOCUS_OUT, UnHighlight);

			Game.CellHolder.addChild(this.TextBox);			
			Game.CellHolder.addChild(this.ScratchBox);			
			
			// Work out what region this cell is in
			if(y < 3) // Region 1, 2 or 3
			{
				if(x < 3)
				{
					this.Region = 1;
					this.RegionRowStart = 0;
					this.RegionColStart = 0;
				}
				else if(x >= 3 && x < 6)
				{
					this.Region = 2;
					this.RegionRowStart = 3;
					this.RegionColStart = 0;
				}
				else if(x >= 6)
				{
					this.Region = 3;
					this.RegionRowStart = 6;
					this.RegionColStart = 0;
				}
			}
			else if(y >= 3 && y < 6) // Region 4, 5 or 6
			{
				if(x < 3)
				{
					this.Region = 4;
					this.RegionRowStart = 0;
					this.RegionColStart = 3;
				}
				else if(x >= 3 && x < 6)
				{
					this.Region = 5;
					this.RegionRowStart = 3;
					this.RegionColStart = 3;
				}
				else if(x >= 6)
				{
					this.Region = 6;
					this.RegionRowStart = 6;
					this.RegionColStart = 3;
				}
			}
			else if(y >= 6) // Region 7, 8 or 9
			{
				if(x < 3)
				{
					this.Region = 7;
					this.RegionRowStart = 0;
					this.RegionColStart = 6;
				}
				else if(x >= 3 && x < 6)
				{
					this.Region = 8;
					this.RegionRowStart = 3;
					this.RegionColStart = 6;
				}
				else if(x >= 6)
				{
					this.Region = 9;
					this.RegionRowStart = 6;
					this.RegionColStart = 6;
				}
			}
		}
		
		// Highlight this cell when we focus on a textfield if it can be written in
		private function Highlight(e:Object):void
		{
			if(this.Revealed == true)
			{
				Game.Highlighter.visible = false;
				return;
			}
				
			Game.Highlighter.x = 11 + (this.X * 50);
			Game.Highlighter.y = 51 + (this.Y * 50);
			Game.Highlighter.visible = true;
		}
		
		// Unhighlights the cell
		private static function UnHighlight(e:FocusEvent):void
		{
			Game.Highlighter.visible = false;
		}
		
		// When the value changes we check to see if we have won
		private static function ValueChanged(e:KeyboardEvent):void
		{
			Game.CheckWin();
		}
		
		// Resets a cell
		public static function Reset(cell:Cell):void
		{
			cell.Answer = 0;
			cell.Revealed = false;			
			
			cell.TextBox.type = "input";
			cell.TextBox.selectable = true;
			cell.TextBox.text = "";
			cell.TextBox.setTextFormat(cell.TextBox.defaultTextFormat);
			
			cell.ScratchBox.text = "";
			cell.ScratchBox.selectable = true;
		}
		
		// Reveals the answer in a cell
		public static function ShowAnswer(cell:Cell):void
		{
			cell.Revealed = true;
			
			cell.TextBox.type = "dynamic";
			cell.TextBox.selectable = false;
			cell.TextBox.text = String(cell.Answer);
			cell.TextBox.setTextFormat(HintFormat);
			
			cell.ScratchBox.text = "";
			cell.ScratchBox.selectable = false;
		}

		// Gets the answer for a cell
		public static function GetAnswer(cell:Cell):String
		{
			if(cell.Revealed)
			{
				return String(cell.Answer);
			}
			else
			{
				return cell.TextBox.text;
			}
		}		
	}
}