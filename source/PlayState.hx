package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	
	public var starfield:FlxStarfield;
	
	override public function create():Void
	{
		super.create();
		starfield = new FlxStarfield(0, 0, FlxG.width, FlxG.height);
		add(starfield);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
