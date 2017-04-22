package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class ExplosionFX extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Explosion_Large_1__png, true, 64, 64);
		animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8], 20);
		animation.play("explode");
	}
	
}