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
	public var _helpButton:FlxButton;

	private function gotoPlayState():Void
	{
		FlxG.switchState(new PlayState());
	}

	private function gotoHelpState():Void
	{
		FlxG.switchState(new HelpState());
	}

	override public function create():Void
	{
		super.create();
		_splashScreen = new FlxSprite(0,0);
		_splashScreen.loadGraphic(AssetPaths.splashScreen__png, false, 450, 200);
		_splashScreen.screenCenter();
		_playButton = new FlxButton(0, 0, "", gotoPlayState);
		_playButton.loadGraphic(AssetPaths.driveSafelyButton__png, true, 363, 110);
		_playButton.screenCenter();
		_playButton.y += 50;
		_helpButton = new FlxButton(0, 0, "", gotoHelpState);
		_helpButton.loadGraphic(AssetPaths.helpButton__png, true, 336, 117);
		_helpButton.screenCenter();
		_helpButton.y += 160;
		add(_splashScreen);
		add(_playButton);
		add(_helpButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
