package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSort;

class CollisionIndicatorHud extends FlxTypedGroup<FlxSprite>
{
	public var _player:Player;
	public var _planets:FlxTypedGroup<FlxSprite>;
	public var _alivePlanets:Array<FlxSprite>;
	public var _arrows:FlxTypedGroup<FlxSprite>;
	public var _playerMidpoint:FlxPoint;
	public var _tempDistance1:Float;
	public var _tempDistance2:Float;

	public var _numArrows = 3;

	public function new (player:Player, planets:FlxTypedGroup<FlxSprite>){
		super();

		var arrowSprite:FlxSprite; 
		_arrows = new FlxTypedGroup<FlxSprite>();

		for(i in 0..._numArrows){
			arrowSprite = new FlxSprite(0, 0);
			arrowSprite.makeGraphic(24,24,FlxColor.WHITE);
			add(arrowSprite);
			_arrows.add(arrowSprite);
		}
		_player = player;
		_planets = planets;
	}

	public function sortByPlayerProximity(planet1:FlxSprite, planet2:FlxSprite):Int
	{
		_playerMidpoint = _player.getMidpoint();
		var _tempDistance1 = planet1.getMidpoint().distanceTo(_playerMidpoint);
		var _tempDistance2 = planet2.getMidpoint().distanceTo(_playerMidpoint);
		return Std.int(_tempDistance1 - _tempDistance2);
	}

	public function indicateNearestCollidables(){
		_alivePlanets = _planets.members.filter(function(_){
			return _.alive;
		});
		_alivePlanets.sort(sortByPlayerProximity);

		var playerMidpoint:FlxPoint = _player.getMidpoint();
		var planetMidPoint:FlxPoint;
		var playerToPlanet:FlxPoint;
		var size:Float;

		var count = Std.int(Math.min(_alivePlanets.length, _numArrows));

		for(i in 0...count){
			planetMidPoint = _alivePlanets[i].getMidpoint();
			playerToPlanet = planetMidPoint.subtractPoint(playerMidpoint);
			playerToPlanet = FlxAngle.getPolarCoords(playerToPlanet.x, playerToPlanet.y);

			size = Math.max( 1 - (Math.min(Math.max(playerToPlanet.x, 40), 1000) - 40) / 960.0, 0.2);
			FlxG.log.add(size);
			playerToPlanet = FlxAngle.getCartesianCoords(100, playerToPlanet.y);
			_arrows.members[i].x = playerToPlanet.x + playerMidpoint.x;
			_arrows.members[i].y = playerToPlanet.y + playerMidpoint.y;
			_arrows.members[i].scale.set(size, size);
		}
	}

	override public function update (elapsed:Float){
		super.update(elapsed);
		indicateNearestCollidables();
	}
}