package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;

class PlayState extends FlxState
{
	public var starfield:FlxStarfield;

	public var slingShotHud:SlingShotHud;
	
	public var uiLayer:FlxGroup;
	public var objectLayer:FlxGroup;
	public var planets:FlxTypedGroup<FlxSprite>;
	public var effectLayer:FlxGroup;
	public var backgroundLayer:FlxGroup;

	public var player:Player;

	public var levelBounds:FlxPoint = new FlxPoint(FlxG.width * 1.1, FlxG.height * 10);
	
	override public function create():Void
	{
		super.create();
		
		uiLayer = new FlxGroup();
		objectLayer = new FlxGroup();
		effectLayer = new FlxGroup();
		backgroundLayer = new FlxGroup();

		planets = new FlxTypedGroup<FlxSprite>();
		var position:FlxPoint = new FlxPoint();
		var size:Int;
		var rotationSpeed:Float;
		var planet:Planet;
		var numPlanets:Int = 15;
		
		for(i in 0...numPlanets){
			position.x = Std.int(FlxG.random.float() * levelBounds.x);
			position.y = Std.int((FlxG.random.float(-1, 1) * 40) - (i/numPlanets * levelBounds.y));
			size = Std.int(FlxG.random.float(20, 60));
			rotationSpeed = FlxG.random.float(1, 4) * 100;

			planet = new Planet(position.x, position.y, size, rotationSpeed, "desert");
			planets.add(planet);
			objectLayer.add(planet);
		}

		player = new Player(0,0);
		player.screenCenter();
		player.y = FlxG.height - player.height - 50;
		objectLayer.add(player);

		starfield = new FlxStarfield(0, 0, FlxG.width, FlxG.height);
		backgroundLayer.add(starfield);
		
		// objectLayer.add(new Asteroid(100, 50));
		// objectLayer.add(new Cop(50, 50));
		// objectLayer.add(new Booster(150, 50));
		// objectLayer.add(new GasCan(200, 50));
		objectLayer.add(new Planet(250, 50, 0, 0, "life"));
		objectLayer.add(new Planet(350, 50, 0, 0, "desert"));
		
		effectLayer.add(new ExplosionFX(50, 150, 1));
		effectLayer.add(new ExplosionFX(120, 150, 2));
		effectLayer.add(new ExplosionFX(180, 150, 3));
		effectLayer.add(new ExplosionFX(230, 150, 4));
		
		slingShotHud = new SlingShotHud(player);
		slingShotHud.launchSignal.addOnce(handleSlingshot);
		uiLayer.add(slingShotHud);

		var collisionIndicatorHud:CollisionIndicatorHud;
		collisionIndicatorHud = new CollisionIndicatorHud(player, planets);
		uiLayer.add(collisionIndicatorHud);
		
		add(backgroundLayer);
		add(objectLayer);
		add(effectLayer);
		add(uiLayer);
	}

	public function handleSlingshot(launchVector:FlxPoint):Void{
		FlxG.camera.follow(player);
		player.handleSlingshot(launchVector);
	}

	public function handleCollision(p:Player, _):Void{
		if( Std.is(_, Planet)){
			var planet:Planet = _;
			var planetToPlayer:FlxPoint = new FlxPoint().copyFrom(p.getMidpoint());
			planetToPlayer.subtractPoint(planet.getMidpoint());
			planetToPlayer = FlxAngle.getPolarCoords(planetToPlayer.x, planetToPlayer.y);
			var velocityNorm:FlxPoint = new FlxPoint().copyFrom(p.velocity);
			velocityNorm.x = -velocityNorm.x;
			velocityNorm.y = -velocityNorm.y;
			velocityNorm = FlxAngle.getPolarCoords(velocityNorm.x, velocityNorm.y);
			var angleDiff:Float = velocityNorm.y - planetToPlayer.y; 

			var resultantVelocity:FlxVector = new FlxVector(p.velocity.x, p.velocity.y);
			resultantVelocity.rotateByDegrees(angleDiff);
			p.handleImpulse(resultantVelocity);

			planet.kill();
		}
	}

	public function updateStarfieldSpeed(){
		starfield.speed.x = player.velocity.x;
		starfield.speed.y = player.velocity.y;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.overlap(player, objectLayer, handleCollision);
		FlxG.worldBounds.set(
			player.x - FlxG.worldBounds.width / 2,
			player.y - FlxG.worldBounds.height / 2,
			FlxG.worldBounds.width,
			FlxG.worldBounds.height
		);
		updateStarfieldSpeed();
	}
}
