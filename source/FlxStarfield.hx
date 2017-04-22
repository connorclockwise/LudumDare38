package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Zack
 */

typedef Star = {
	var pos:FlxPoint;
	var prevPos:FlxPoint;
	var vScale:Float;
}
 
class FlxStarfield extends FlxSprite
{
	private var stars:Array<Star>;
	private var starts:Array<FlxPoint> = new Array<FlxPoint>();
	private var ends:Array<FlxPoint> = new Array<FlxPoint>();
	public var speed:FlxVector = new FlxVector(0, 100);
	public function new(X:Float, Y:Float, Width:Float, Height:Float) 
	{
		super(X, Y);
		stars = new Array<Star>();
		for (i in 0...300) {
			stars.push( {
				pos: new FlxPoint(FlxG.random.int(0, Std.int(Width)), FlxG.random.int(0, Std.int(Height))),
				prevPos: new FlxPoint(0, 0),
				vScale: FlxG.random.float(1, 3)
			});
			ends.push(stars[i].pos);
			starts.push(stars[i].prevPos);
		}
		makeGraphic(Std.int(Width), Std.int(Height), 0x0, true);
	}
	
	override public function update(elapsed:Float) {
		for (star in stars) {
			star.prevPos.x = star.pos.x;
			star.prevPos.y = star.pos.y;
			star.pos.y += speed.y * star.vScale * elapsed;
			star.pos.x += speed.x * star.vScale * elapsed;
			if (star.pos.y > height) {
				star.pos.y -= height;
				star.prevPos.y -= height; //Also back up the star
			}
			if (star.pos.y < 0) {
				star.pos.y += height;
				star.prevPos.y += height; //Also back up the star
			}
			if (star.pos.x > width) {
				star.pos.x -= width;
				star.prevPos.x -= width; //Also back up the star
			}
			if (star.pos.x < 0) {
				star.pos.x += width;
				star.prevPos.x += width; //Also back up the star
			}
		}
		speed.x = (FlxG.mouse.x - FlxG.width/2) * 2;
		speed.y = (FlxG.mouse.y - FlxG.height/2) * 2;
		super.update(elapsed);
	}
	
	override public function draw():Void 
	{
		pixels.lock();
		pixels.fillRect(new Rectangle(0, 0, width, height), 0x0);
		if (speed.lengthSquared < 10000) {
			for (star in stars) {
				pixels.setPixel32(Std.int(star.pos.x), Std.int(star.pos.y), 0xFFFFFFFF);				
			}
		}else {
			FlxSpriteUtil.drawBatchLines(this, starts, ends);	
		}
		dirty = true;
		pixels.unlock();
		super.draw();
	}
}