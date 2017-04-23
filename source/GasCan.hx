package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class GasCan extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Fuel_Can__png, true, 32, 32);
		animation.add("pulse", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 20);
		animation.play("pulse");
		scale.set(2, 2);
		updateHitbox();
	}
	
	public function onCollect(player:Player) {
		player.fuel += 1500;
		FlxG.sound.play("assets/sounds/Gascan-Pickup.wav", 0.6, false);
	}
}