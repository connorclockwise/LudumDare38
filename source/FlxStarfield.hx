package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Zack
 */

typedef Star = {
	var x:Float;
	var y:Float;
	var vScale:Float;
}
 
class FlxStarfield extends FlxSprite
{
	private var stars:Array<Star>;
	public var speed = 100;
	public function new(X:Float, Y:Float, Width:Float, Height:Float) 
	{
		super(X, Y);
		stars = new Array<Star>();
		for (i in 0...300) {
			stars.push( {
				x: FlxG.random.int(0, Std.int(Width)),
				y: FlxG.random.int(0, Std.int(Height)),
				vScale: FlxG.random.float(1, 3)
			});
		}
		makeGraphic(Std.int(Width), Std.int(Height), 0x0, true);
	}
	
	override public function update(elapsed:Float) {
		FlxG.log.add(stars[0].y);
		for (star in stars) {
			star.y += speed * star.vScale * elapsed;
			if (star.y > 640) {
				star.y -= 640;
			}
		}
		speed = FlxG.mouse.x;
		super.update(elapsed);
	}
	
	override public function draw():Void 
	{
		pixels.lock();
		pixels.fillRect(new Rectangle(0, 0, width, height), 0x0);
		for (star in stars) {
			pixels.setPixel32(Std.int(star.x), Std.int(star.y), 0xFFFFFFFF);
		}
		dirty = true;
		pixels.unlock();
		super.draw();
	}
}