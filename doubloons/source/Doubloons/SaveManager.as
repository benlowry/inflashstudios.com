package Doubloons
{
	import flash.net.SharedObject;

	public class SaveManager
	{
		public static function Save(level:int):void
		{
			try
			{
				// Check if we have already saved the level
				var savedlevel:int = Get();
			}
			catch(e:Error)
			{
				trace("Error");
				trace(e.message);
				return;
			}
			
			// If our saved level is the same or higher we just leave
			if(savedlevel >= level)
				return;
				
			// Otherwise save it
			try
			{
				var cookie:SharedObject = SharedObject.getLocal("zlevel");
				cookie.data["zlevel"] = level.toString();
				cookie.flush();
			}
			catch(e2:Error)
			{
				trace("Error2");
				trace(e2.message);
			}
		}
		
		public static function Get():int
		{
			var cookie:SharedObject = SharedObject.getLocal("zlevel");
			
			if(cookie.data["zlevel"] == undefined)
				return 1;
			else
				return int(cookie.data["zlevel"]);
		}
	}
}