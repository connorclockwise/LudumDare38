package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class Booster extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Booster__png, true, 32, 32);
		animation.add("pulse", [0, 1, 2, 3, 4], 20);
		animation.play("pulse");
		scale.set(2, 2);
		updateHitbox();
	}
	
	public function onCollect(player:Player) {
		player.changeSpeed(300);
		FlxG.sound.play("assets/sounds/Booster-Pickup.wav", 0.3, false);
	}
}