package;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;

/**
 * ...
 * @author Zack
 */
class GlobalRegistry
{

	public static var effectLayer:FlxGroup;
	public static var player:Player;
	public static var home:Planet;
	public static var asteroidExplosionSounds:FlxTypedGroup<FlxSound>;
	
	
	public static function getOldestExplosionSound():FlxSound {
		var oldestSound:FlxSound = asteroidExplosionSounds.members[0];
		for (sound in asteroidExplosionSounds.members) {
			if (sound.time > oldestSound.time) {
				oldestSound = sound;
			}
		}
		return oldestSound;
	}
}