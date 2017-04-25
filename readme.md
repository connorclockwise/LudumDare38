In order to build this project you'll have to have a few things installed.

You'll need HaxeFlixel installed at version 4.2.1. This will force a specific version of OpenFl and Lime on you. The game was compiled with the Haxe compiler at version 3.2.1.

In addition to installing Haxe, and HaxeFlixel - you'll also need to apply a patch to {HAXE_INSTALL}/lib/flixel/4.2.1/flixel/util/FlxSpriteUtil.hx:

/**
* This function draws a collection of lines on a FlxSprite from starts to ends with the specified color.
*
* @param sprite The FlxSprite to manipulate
* @param starts Array of FlxPoints containing the start points for the line batch
* @param ends Array of FlxPoints containing the end points for the line batch
* @param lineStyle A LineStyle typedef containing the params of Graphics.lineStyle()
* @param drawStyle A DrawStyle typdef containing the params of BitmapData.draw()
* @return The FlxSprite for chaining
*/
public static function drawBatchLines(sprite:FlxSprite, starts:Array<FlxPoint>, ends:Array<FlxPoint>,
	?lineStyle:LineStyle, ?drawStyle:DrawStyle):FlxSprite
{
	lineStyle = getDefaultLineStyle(lineStyle);
	beginDraw(0x0, lineStyle);
	for (i in 0...starts.length) {
		flashGfx.moveTo(starts[i].x, starts[i].y);
		flashGfx.lineTo(ends[i].x, ends[i].y);
	}
	endDraw(sprite, drawStyle);
	return sprite;
}