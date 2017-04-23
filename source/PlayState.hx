package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var starfield:FlxStarfield;

	public var scoreHud:ScoreHud;
	public var score:Int = 0;
	public var slingShotHud:SlingShotHud;
	public var collisionIndicatorHud:CollisionIndicatorHud;
	
	public var uiLayer:FlxGroup;
	public var objectLayer:FlxGroup;
	public var planets:FlxTypedGroup<FlxSprite>;
	public var collectibles:FlxTypedGroup<FlxSprite>;
	public var effectLayer:FlxGroup;
	public var backgroundLayer:FlxGroup;

	public var player:Player;

	public var levelBounds:FlxPoint = new FlxPoint(FlxG.width * 1.1, FlxG.height * 20);
	
	public var asteroidBoundarySpacing:Int = 1000;
	public var asteroidBounds:FlxPoint;
	public var asteroidPool:FlxTypedGroup<Asteroid>;
	public var boundaryAsteroids:FlxGroup;
	public var boundaryPosition:Int = 0; //0 is on the left, 1 is on the right.
	public var asteroidBeltWidth:Float;

	public var loopMusic:FlxSound;
	
	override public function create():Void
	{
		super.create();
		
		uiLayer = new FlxGroup();
		objectLayer = new FlxGroup();
		effectLayer = new FlxGroup();
		backgroundLayer = new FlxGroup();

		planets = new FlxTypedGroup<FlxSprite>();
		collectibles = new FlxTypedGroup<FlxSprite>();
		var position:FlxPoint = new FlxPoint();
		var size:Int;
		var rotationSpeed:Float;
		var planet:Planet;
		var planetType:String;
		var numPlanets:Int = 20;
		
		for(i in 0...numPlanets){
			position.x = Std.int(FlxG.random.float() * levelBounds.x);
			position.y = Std.int((FlxG.random.float(-1, 1) * 40) - (i/numPlanets * levelBounds.y));
			size = Std.int(FlxG.random.float(90, 118));
			rotationSpeed = FlxG.random.float(1, 4) * 100;

			planetType = FlxG.random.getObject(["desert", "lava", "gas1", "gas2"]);

			planet = new Planet(position.x, position.y, size, rotationSpeed, planetType);
			planets.add(planet);
			objectLayer.add(planet);
		}

		var numGasCans:Int = 2;
		var gasCan:GasCan;

		for(i in 0...numGasCans){
			position.x = Std.int(FlxG.random.float() * levelBounds.x);
			position.y = Std.int((FlxG.random.float(-1, 1) * 40) - (i/numGasCans * levelBounds.y));

			gasCan = new GasCan(position.x, position.y);
			objectLayer.add(gasCan);
			collectibles.add(gasCan);
		}

		var numBoosters:Int = 5;
		var booster:Booster;

		for(i in 0...numBoosters){
			position.x = Std.int(FlxG.random.float() * levelBounds.x);
			position.y = Std.int((FlxG.random.float(-1, 1) * 40) - (i/numBoosters * levelBounds.y));

			booster = new Booster(position.x, position.y);
			objectLayer.add(booster);
			collectibles.add(booster);
		}

		var homePlanet:Planet = new Planet(levelBounds.x / 2, -levelBounds.y - 800, 500, 0, "home");
		planets.add(homePlanet);
		objectLayer.add(homePlanet);
		GlobalRegistry.home = homePlanet;

		player = new Player(0,0);
		player.screenCenter();
		player.y = FlxG.height - player.height - 50;
		objectLayer.add(player);
		GlobalRegistry.player = player;
		
		asteroidBounds = new FlxPoint(player.x - asteroidBoundarySpacing/2, player.x + asteroidBoundarySpacing/2);

		//Asteroid pool
		asteroidPool = new FlxTypedGroup<Asteroid>();
		asteroidBeltWidth = FlxG.width * 0.8;
		boundaryAsteroids = new FlxGroup();
		for (i in 0...80) {
			var asteroid:Asteroid = new Asteroid(0, 0, new FlxPoint(0, 0));
			asteroidPool.add(asteroid);
		}
		objectLayer.add(asteroidPool);
		asteroidPool.forEach(function(asteroid:Asteroid):Void {
			asteroid.xBounds.set(asteroidBounds.x-asteroidBeltWidth, asteroidBounds.x);
			asteroid.fullReset();
		});
		
		starfield = new FlxStarfield(0, 0, FlxG.width, FlxG.height);
		backgroundLayer.add(starfield);
		
		// objectLayer.add(new Asteroid(100, 50, new FlxPoint(0, FlxG.width/2)));
		// objectLayer.add(new Cop(50, 50));
		// objectLayer.add(new Booster(150, 50));
		// objectLayer.add(new GasCan(200, 50));
		// objectLayer.add(new Planet(250, 50, 0, 0, "life"));
		// objectLayer.add(new Planet(350, 50, 0, 0, "desert"));
		
		// effectLayer.add(new ExplosionFX(50, 150, 1));
		// effectLayer.add(new ExplosionFX(120, 150, 2));
		// effectLayer.add(new ExplosionFX(180, 150, 3));
		// effectLayer.add(new ExplosionFX(230, 150, 4));

		scoreHud = new ScoreHud();
		uiLayer.add(scoreHud);
		
		slingShotHud = new SlingShotHud(player);
		slingShotHud.launchSignal.addOnce(handleSlingshot);
		uiLayer.add(slingShotHud);

		collisionIndicatorHud = new CollisionIndicatorHud(player, planets, collectibles);
		
		add(backgroundLayer);
		add(objectLayer);
		add(effectLayer);
		add(uiLayer);
		
		GlobalRegistry.effectLayer = effectLayer;
		FlxG.watch.add(effectLayer.members, "length", "Explosion Pool Count");
		
		uiLayer.add(new SpeedGague());
		uiLayer.add(new FuelGague());
		
		FlxG.camera.setScrollBounds(asteroidBounds.x - asteroidBeltWidth, asteroidBounds.y + asteroidBeltWidth, null, null);
	}

	public function handleSlingshot(launchVector:FlxPoint):Void{
		FlxG.camera.follow(player);
		player.handleSlingshot(launchVector);
		slingShotHud.kill();
		uiLayer.add(collisionIndicatorHud);
		player.isGoTime = true;

		loopMusic = FlxG.sound.play(AssetPaths.loop__ogg, 0.2);
	}

	public function handleCollision(p:Player, _):Void{
		if ( Std.is(_, Planet) ) {
			var planet:Planet = cast (_, Planet);
			if (planet.dying) {
				return; //Do nothing if the planet is already in the process of dying.
			}
			var planetToPlayer:FlxPoint = new FlxPoint().copyFrom(p.getMidpoint());
			planetToPlayer.subtractPoint(planet.getMidpoint());
			planetToPlayer = FlxAngle.getPolarCoords(planetToPlayer.x, planetToPlayer.y);

			var actualPlanetSize:Int = Std.int(planet._size * 0.5);
			if(planetToPlayer.x > actualPlanetSize && planet._type == "home"){
				return;
			}

			if(planet._type == "home"){
				FlxG.camera.flash(FlxColor.WHITE, 1);
				collisionIndicatorHud.kill();
				player.kill();
				loopMusic.pause();
				FlxG.sound.play(AssetPaths.explosion__ogg, 1.6);
				new FlxTimer().start(0.3, function(_){
					effectLayer.add(new ExplosionFX(player.x + 5, player.y -3, 3));
				});
				new FlxTimer().start(0.4, function(_){
					effectLayer.add(new ExplosionFX(player.x - 10, player.y + 5, 1));
				});
				new FlxTimer().start(0.5, function(_){
					effectLayer.add(new ExplosionFX(player.x + 5, player.y + 8, 2));
				});
				new FlxTimer().start(3.0, function(_){
					FlxG.switchState(new GameOverState(true, score));
				});
				return;
			}
			var velocityNorm:FlxPoint = new FlxPoint().copyFrom(p.velocity);
			velocityNorm.x = -velocityNorm.x;
			velocityNorm.y = -velocityNorm.y;
			velocityNorm = FlxAngle.getPolarCoords(velocityNorm.x, velocityNorm.y);
			var angleDiff:Float = FlxAngle.wrapAngle(velocityNorm.y - planetToPlayer.y);
			angleDiff = Math.min(Math.max(angleDiff, -30), 30);

			var resultantVelocity:FlxVector = new FlxVector(p.velocity.x, p.velocity.y);
			resultantVelocity.rotateByDegrees(angleDiff);
			p.handleImpulse(resultantVelocity);

			score += 100;
			var excuseString:String = FlxG.random.getObject([
				"Accidental Collision",
				"I didn't see it.",
				"*Cough* *Cough*",
				"Get out my way.",
				"Have a nice day.",
				"Stop being so tiny.",
				"THIS IS NOT MY DAY.",
				"That's life friend.",
				"Somebody get that guy's plate."
			]);
			scoreHud.updateScore(score, excuseString);
			FlxG.sound.play(AssetPaths.explosion__ogg, 0.8);
			planet.kill();
			player.changeSpeed(-75);
		}
		
		if (Std.is(_, Asteroid)) {
			if (!cast(_, Asteroid).dying) {
				player.changeSpeed(-15);				
			}
			cast(_, Asteroid).kill();
		}
		
		if (Std.is(_, GasCan)) {
			cast(_, GasCan).kill();
			cast(_, GasCan).onCollect(player);
		}
		
		if (Std.is(_, Booster)) {
			cast(_, Booster).kill();
			cast(_, Booster).onCollect(player);
		}
	}

	public function updateStarfieldSpeed(){
		if(player.alive){
			starfield.speed.x = -player.velocity.x;
			starfield.speed.y = -player.velocity.y;
		}
		else {
			starfield.speed.x = 0;
			starfield.speed.y = 0;
		}
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
		if (FlxG.camera.scroll.x < asteroidBounds.x + 70) {
			if (boundaryPosition != 0) {
				boundaryPosition = 0;
				asteroidPool.forEach(function(asteroid:Asteroid):Void {
					asteroid.xBounds.set(asteroidBounds.x-asteroidBeltWidth, asteroidBounds.x);
					asteroid.fullReset();
				});
			}
		}
		if (FlxG.camera.scroll.x + FlxG.width > asteroidBounds.y) {
			if (boundaryPosition != 1) {
				boundaryPosition = 1;
				asteroidPool.forEach(function(asteroid:Asteroid):Void {
					asteroid.xBounds.set(asteroidBounds.y, asteroidBounds.y+asteroidBeltWidth);
					asteroid.fullReset();
				});
			}
		}
		
		//Keep the player in-bounds
		if (player.x < asteroidBounds.x - asteroidBeltWidth && player.velocity.x < 0) {
			player.velocity.x = -player.velocity.x;
		}
		if (player.x + player.width > asteroidBounds.y + asteroidBeltWidth && player.velocity.x > 0) {
			player.velocity.x = -player.velocity.x;
		}
		
		if (Math.floor(new FlxVector(player.velocity.x, player.velocity.y).length) == 0 &&
			Math.floor(Math.max(player.fuel, 0)) == 0) {
			new FlxTimer().start(3.0, function(_){
				FlxG.switchState(new GameOverState(false, score));
			});				
		}
		
	}
}
