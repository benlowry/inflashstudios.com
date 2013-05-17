package Doubloons
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundManager
	{
		public static function Play(sound:Class):void
		{
			if(Main.SoundOn)
			{
				var soundchannel:SoundChannel = new sound().play(0, 0);
			}
		}
	}
}