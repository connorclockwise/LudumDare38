package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxBitmapText;
import flixel.math.FlxPoint;
/**
 * ...
 * @author Zack
 */
class SpeedGague extends FlxSprite
{
	public var speedText:FlxBitmapText;
	public var needle:FlxSprite;
	public var helperVector:FlxVector;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y, AssetPaths.SpeedGague__png);
		scale.set(2, 2);
		updateHitbox();
		x = FlxG.width - width;
		y = FlxG.height - height;
		scrollFactor.set(0, 0);
		
		//Speed text
		speedText = new FlxBitmapText();
		speedText.scale.set(2, 2);
		speedText.updateHitbox();
		speedText.x = x + 20;
		speedText.y = y + height - 19;
		speedText.font = FlxBitmapFont.fromMonospace(AssetPaths.Seven_Segment_Numbers__png, "0123456789", new FlxPoint(5, 9));
		speedText.letterSpacing = 1;
		speedText.scrollFactor.set(0, 0);
		
		needle = new FlxSprite(x + width - 35, y + height - 90, AssetPaths.GagueNeedle__png);
		needle.pixelPerfectRender = false;
		needle.scrollFactor.set(0, 0);
		needle.scale.set(2, 2);
		needle.updateHitbox();
		needle.origin.set(2.5, needle.height / 2 - 3);
		needle.angle = 359;
		
		helperVector = new FlxVector();
	}

	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		helperVector.copyFrom(GlobalRegistry.player.velocity);
		speedText.text = "" + Math.floor(helperVector.length);
		speedText.update(elapsed);
		needle.update(elapsed);
		
		//Needle goes from 270 when not moving, to 359 when at 900 speed.
		needle.angle = (helperVector.length / 900) * 90 + 270;
	}
	
	override public function draw():Void 
	{
		super.draw();
		speedText.draw();
		needle.draw();
	}
}