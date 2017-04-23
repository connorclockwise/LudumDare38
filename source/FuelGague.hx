package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class FuelGague extends FlxSprite
{
	public var needle:FlxSprite;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.GasGague__png, true, 64, 64);
		animation.add("good", [0]);
		animation.add("warn", [1]);
		animation.add("empty", [0, 1], 10);
		scale.set(2, 2);
		updateHitbox();
		x = 0;
		y = FlxG.height - height;
		scrollFactor.set(0, 0);
		
		//Gas needle
		needle = new FlxSprite(x + 30, y + height - 70, AssetPaths.GagueNeedle__png);
		needle.pixelPerfectRender = false;
		needle.scrollFactor.set(0, 0);
		needle.scale.set(2, 2);
		needle.updateHitbox();
		needle.origin.set(2.5, needle.height / 2 - 3);
		needle.angle = 359;
		
		animation.play("good");
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		needle.update(elapsed);
		
		//Needle goes from 90 when empty, to 0 when at 10,000 fuel.
		needle.angle = (1 - (GlobalRegistry.player.fuel / 10000)) * 90;
		if (GlobalRegistry.player.fuel <= 0) {
			animation.play("empty");
		}else if (GlobalRegistry.player.fuel < 1500) {
			animation.play("warn");
		}else {
			animation.play("good");
		}
	}
	
	override public function draw():Void 
	{
		super.draw();
		needle.draw();
	}
	
}