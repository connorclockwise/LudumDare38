package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class HelpState extends FlxState
{
	public var _playButton:FlxButton;
	public var _helpButton:FlxButton;
	public var _helpText1:FlxText;

	private function gotoPlayState():Void
	{
		FlxG.switchState(new PlayState());
	}

	override public function create():Void
	{
		super.create();
		add(new FlxText(10,10, "Syuka Blyinn Boris, ", 24));
		add(new FlxText(290,15, "what have you done now?", 18));
		add(new FlxText(15,65, "You had one too many at the club,", 14));
		add(new FlxText(15,80, " now you drive like old man river", 22));
		add(new FlxText(20,110, " with glasses on backwards.", 22));
		add(new FlxText(15,140, "Ok ok ok ok, its cool. Play it safe. ", 14));
		add(new FlxText(15,170, "Just take the shortcut through the tiny planet nebula.", 12));

		add(new FlxText(15,210, "This is your planet, drive here. The faster the better.", 14));

		var homePlanet:Planet = new Planet(500, 200, 50, 0, "home");
		add(homePlanet);

		add(new FlxText(15,250, "(A and D) or (Left/Right Arrows) to steer,", 14));
		add(new FlxText(15,270, "(W) or (Up Arrow) to accelerate,", 14));
		add(new FlxText(15,290, "in case you forgot how to drive.", 14));

		var gas:GasCan = new GasCan(530, 350);
		add(gas);

		var booster:Booster = new Booster(580, 350);
		add(booster);

		add(new FlxText(15,330, "Boris you idiot, you forgot to refill gas.", 18));
		add(new FlxText(15,360, "Grab gas cans and boosters to make it back in one piece.", 14));

		_playButton = new FlxButton(0, 0, "", gotoPlayState);
		_playButton.loadGraphic(AssetPaths.driveSafelyButton__png, true, 363, 110);
		_playButton.scale.set(0.5, 0.5);
		_playButton.updateHitbox();
		_playButton.screenCenter();
		_playButton.y = FlxG.height - 50 - 20;
		add(_playButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
