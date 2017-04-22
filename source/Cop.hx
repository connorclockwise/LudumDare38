package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class Cop extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Copper__png, true, 32, 64);
		animation.add("pulse", [0, 1, 2, 3, 4], 16);
		animation.play("pulse");
	}
	
}