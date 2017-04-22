package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState
{

	public var _splashScreen:FlxSprite;
	public var _playButton:FlxButton;

	private function gotoPlayState():Void
	{
		FlxG.switchState(new PlayState());
	}

	override public function create():Void
	{
		super.create();
		_splashScreen = new FlxSprite(0,0);
		_splashScreen.loadGraphic(AssetPaths.splashScreen__png, false, 450, 200);
		_splashScreen.screenCenter();
		_splashScreen.y -= 100;
		_playButton = new FlxButton(0, 0, "Drive Safetly", gotoPlayState);
		_playButton.screenCenter();
		_playButton.y += 50;
		add(_splashScreen);
		add(_playButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
