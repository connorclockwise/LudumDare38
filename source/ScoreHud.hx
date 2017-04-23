package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class ScoreHud extends FlxTypedGroup<FlxSprite>
{
	public var _scoreText:FlxText;
	public var _scoreReason:FlxText;
	public var _tween:FlxTween = null;

	public function new(){
		super();

		_scoreText = new FlxText(5, 5, 0,"Score:0", 16);
		_scoreReason = new FlxText(5, 20, 0,"", 12);
		add(_scoreText);
		add(_scoreReason);

		_scoreText.scrollFactor.set(0,0);
		_scoreReason.scrollFactor.set(0,0);
	}

	public function updateScore(score:Int, reason:String):Void{
		_scoreText.text = "Score:" + score;
		_scoreReason.text = reason;
		if(_tween != null){
			_tween.cancel();
			_scoreReason.alpha = 1;
			_scoreReason.y = 20;
		}
		_tween = FlxTween.tween(_scoreReason, { alpha: 0, y: 40 }, 2.5, { ease: FlxEase.expoOut});
	}

	override public function update (elapsed:Float){
		super.update(elapsed);
	}
}