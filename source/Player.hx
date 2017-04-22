package;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Player extends FlxSprite
{

	public var _reticule:FlxSprite;

	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		makeGraphic(20, 50, FlxColor.WHITE);
	}

	public function handleSlingshot(){

	}
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		handleSlingshot();
	}
}