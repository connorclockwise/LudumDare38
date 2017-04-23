package;

import flixel.FlxGame;
import openfl.display.Sprite;

//DRUNK DRIVE MAN

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TestBed, 1, 60, 60, true));
	}
}
