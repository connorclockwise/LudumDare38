package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class GameOverState extends FlxState
{

	public var _splashScreen:FlxSprite;
	public var _playButton:FlxButton;
	public var _scoreText:FlxText;
	public var _isWin:Bool;
	public var _score:Int;

	public function new(isWin:Bool, score:Int){
		super();
		_isWin = isWin;
		_score = score;
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
		_playButton = new FlxButton(0, 0, "", gotoMenuState);
		_playButton.loadGraphic(AssetPaths.playAgainButton__png, true, 239, 65);
		_playButton.x = 58;
		_playButton.y = 385;
		_scoreText = new FlxText(0, 0, 0,"Final Score:" + _score, 24);
		_scoreText.x = 48;
		_scoreText.y = 335;
		add(_splashScreen);
		add(_playButton);
		add(_scoreText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
