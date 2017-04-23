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
	public var _collectibles:FlxTypedGroup<FlxSprite>;
	public var _alivePlanets:Array<FlxSprite>;
	public var _aliveCollectibles:Array<FlxSprite>;
	public var _planetArrows:FlxTypedGroup<FlxSprite>;
	public var _collectibleArrows:FlxTypedGroup<FlxSprite>;
	public var _playerMidpoint:FlxPoint;
	public var _tempDistance1:Float;
	public var _tempDistance2:Float;

	public var _numPlanetArrows = 3;
	public var _numCollectibleArrows = 3;

	public function new (player:Player, 
						 planets:FlxTypedGroup<FlxSprite>,
						 collectibles:FlxTypedGroup<FlxSprite>){
		super();

		var arrowSprite:FlxSprite; 
		_planetArrows = new FlxTypedGroup<FlxSprite>();
		_collectibleArrows = new FlxTypedGroup<FlxSprite>();

		for(i in 0..._numPlanetArrows){
			arrowSprite = new FlxSprite(0, 0);
			arrowSprite.makeGraphic(24,24,FlxColor.WHITE);
			add(arrowSprite);
			_planetArrows.add(arrowSprite);
		}
		for(i in 0..._numCollectibleArrows){
			arrowSprite = new FlxSprite(0, 0);
			arrowSprite.makeGraphic(24,24,FlxColor.WHITE);
			add(arrowSprite);
			_collectibleArrows.add(arrowSprite);
		}
		_player = player;
		_planets = planets;
		_collectibles = collectibles;
	}

	public function sortByPlayerProximity(sprite1:FlxSprite, sprite2:FlxSprite):Int
	{
		_playerMidpoint = _player.getMidpoint();
		var _tempDistance1 = sprite1.getMidpoint().distanceTo(_playerMidpoint);
		var _tempDistance2 = sprite2.getMidpoint().distanceTo(_playerMidpoint);
		return Std.int(_tempDistance1 - _tempDistance2);
	}

	public function indicateNearestCollidables() {	
		_alivePlanets = _planets.members.filter(function(_){
			return _.alive && !cast(_, Planet).dying;
		});
		_alivePlanets.sort(sortByPlayerProximity);

		_aliveCollectibles = _collectibles.members.filter(function(_){
			return _.alive;
		});
		_aliveCollectibles.sort(sortByPlayerProximity);

		var playerMidpoint:FlxPoint = _player.getMidpoint();
		var planet:Planet;
		var planetMidPoint:FlxPoint;
		var playerToPlanet:FlxPoint;
		var size:Float;

		var count = Std.int(Math.min(_alivePlanets.length, _numPlanetArrows));

		for(i in 0...count){
			planet = cast(_alivePlanets[i], Planet);
			planetMidPoint = planet.getMidpoint();
			playerToPlanet = planetMidPoint.subtractPoint(playerMidpoint);
			playerToPlanet = FlxAngle.getPolarCoords(playerToPlanet.x, playerToPlanet.y);

			size = Math.max( 1 - (Math.min(Math.max(playerToPlanet.x, 40), 1000) - 40) / 960.0, 0.2);
			playerToPlanet = FlxAngle.getCartesianCoords(100, playerToPlanet.y);
			_planetArrows.members[i].x = playerToPlanet.x + playerMidpoint.x;
			_planetArrows.members[i].y = playerToPlanet.y + playerMidpoint.y;
			_planetArrows.members[i].scale.set(size, size);

			if(planet._type == "home")
			{
				_planetArrows.members[i].color = FlxColor.GREEN;
			}
			else
			{
				_planetArrows.members[i].color = FlxColor.WHITE;
			}
		}
		for(i in count..._numPlanetArrows){
			_planetArrows.members[i].color = FlxColor.TRANSPARENT;
		}

		var collectible:FlxSprite;
		var collectibleMidPoint:FlxPoint;
		var playerToCollectible:FlxPoint;
		count = Std.int(Math.min(_aliveCollectibles.length, _numCollectibleArrows));

		for(i in 0...count){
			collectible = cast(_aliveCollectibles[i], FlxSprite);
			collectibleMidPoint = collectible.getMidpoint();
			playerToCollectible = collectibleMidPoint.subtractPoint(playerMidpoint);
			playerToCollectible = FlxAngle.getPolarCoords(playerToCollectible.x, playerToCollectible.y);

			size = Math.max( 1 - (Math.min(Math.max(playerToCollectible.x, 40), 1000) - 40) / 960.0, 0.2);
			playerToCollectible = FlxAngle.getCartesianCoords(100, playerToCollectible.y);
			_collectibleArrows.members[i].x = playerToCollectible.x + playerMidpoint.x;
			_collectibleArrows.members[i].y = playerToCollectible.y + playerMidpoint.y;
			_collectibleArrows.members[i].scale.set(size, size);
			
			_collectibleArrows.members[i].color = FlxColor.BLUE;
		}
		for(i in count..._numCollectibleArrows){
			_collectibleArrows.members[i].color = FlxColor.TRANSPARENT;
		}
	}

	override public function update (elapsed:Float){
		super.update(elapsed);
		indicateNearestCollidables();
	}
}