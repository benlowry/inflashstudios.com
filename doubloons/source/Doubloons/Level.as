package Doubloons
{	
	public class Level
	{
		public var Clip:Class;
		public var Shots:int;
		public var CoinsToWin:int;

		public static function Level1():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 20;
			level.Clip = Doubloons.Level1;
			
			return level;
		}
		
		public static function Level2():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 21;
			level.Clip = Doubloons.Level2;
			
			return level;
		}
		
		public static function Level3():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 22;
			level.Clip = Doubloons.Level3;
			
			return level;
		}
		
		public static function Level4():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 23;
			level.Clip = Doubloons.Level4;
			
			return level;
		}
		
		public static function Level5():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 24;
			level.Clip = Doubloons.Level5;
			
			return level;
		}
		
		public static function Level6():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 25;
			level.Clip = Doubloons.Level6;
			
			return level;
		}
		
		public static function Level7():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 26;
			level.Clip = Doubloons.Level7;
			
			return level;
		}
		
		public static function Level8():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 27;
			level.Clip = Doubloons.Level8;
			
			return level;
		}
		
		public static function Level9():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 28;
			level.Clip = Doubloons.Level9;
			
			return level;
		}
		
		public static function Level10():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 29;
			level.Clip = Doubloons.Level10;
			
			return level;
		}
		
		public static function Level11():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 30;
			level.Clip = Doubloons.Level11;
			
			return level;
		}
		
		public static function Level12():Level
		{
			var level:Level = new Level();
			level.Shots = 5;
			level.CoinsToWin = 31;
			level.Clip = Doubloons.Level12;
			
			return level;
		}
	}
}