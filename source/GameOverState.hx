package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class GameOverState extends FlxState
{

	public var _splashScreen:FlxSprite;
	public var _playButton:FlxButton;
	public var _isWin:Bool;

	public function new(isWin:Bool){
		super();
		_isWin = isWin;
	}

	private function gotoMenuState():Void
	{
		FlxG.switchState(new MenuState());
	}

	override public function create():Void
	{
		super.create();
		_splashScreen = new FlxSprite(0,0);
		if(_isWin){
			_splashScreen.loadGraphic(AssetPaths.winScreen__png, false, 640, 480);
		}
		else{
			_splashScreen.loadGraphic(AssetPaths.loseScreen__png, false, 640, 480);
		}
		_splashScreen.screenCenter();
		_playButton = new FlxButton(0, 0, "Try Again Comrade", gotoMenuState);
		_playButton.screenCenter();
		_playButton.width = 150;
		_playButton.y += 50;
		add(_splashScreen);
		add(_playButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
