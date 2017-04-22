package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class ExplosionFX extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0, ?Force:Int=0) 
	{
		super(X, Y);
		if (Force == 0) {
			Force = FlxG.random.int(1, 4);
		}
		switch(Force) {
			case 2:
				loadGraphic(AssetPaths.Explosion_Large_2__png, true, 64, 64);
				animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8], 20, false);
			case 3:
				loadGraphic(AssetPaths.Explosion_Small_1__png, true, 32, 32);
				animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8], 20, false);
			case 4:
				loadGraphic(AssetPaths.Explosion_Small_2__png, true, 32, 32);
				animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8], 20, false);
			default:
				loadGraphic(AssetPaths.Explosion_Large_1__png, true, 64, 64);
				animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8], 20, false);
		}
		animation.play("explode");
		x -= width / 2;
		y -= height / 2;
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		super.reset(X, Y);
		x -= width / 2;
		y -= height / 2;
		animation.play("explode", true);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (animation.finished) {
			kill();
		}
	}

}