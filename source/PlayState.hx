package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	public var starfield:FlxStarfield;
	public var planets:FlxTypedGroup<Planet>;

	public var slingShotHud:SlingShotHud;
	
	public var uiLayer:FlxGroup;
	public var objectLayer:FlxGroup;
	public var effectLayer:FlxGroup;
	public var backgroundLayer:FlxGroup;

	public var player:Player;
	
	override public function create():Void
	{
		super.create();
		
		uiLayer = new FlxGroup();
		objectLayer = new FlxGroup();
		effectLayer = new FlxGroup();
		backgroundLayer = new FlxGroup();
		
		planets = new FlxTypedGroup<Planet>();

		var position:FlxPoint = new FlxPoint();
		var size:Int;
		var rotationSpeed:Float;
		var planet:Planet;
		
		//for(i in 0...20){
			//position.x = Std.int(FlxG.random.float() * FlxG.width);
			//position.y = Std.int(FlxG.random.float() * FlxG.height);
			//size = Std.int(FlxG.random.float(20, 60));
			//rotationSpeed = FlxG.random.float(1, 4) * 100;
//
			//planet = new Planet(position.x, position.y, size, rotationSpeed);
			//planets.add(planet);
		//}
		//objectLayer.add(planets);
		starfield = new FlxStarfield(0, 0, FlxG.width, FlxG.height);
		backgroundLayer.add(starfield);


		player = new Player(0,0);
		player.screenCenter();
		player.y = FlxG.height - player.height - 50;
		objectLayer.add(player);
		
		objectLayer.add(new Asteroid(100, 50));
		objectLayer.add(new Cop(50, 50));
		objectLayer.add(new Booster(150, 50));
		objectLayer.add(new GasCan(200, 50));
		objectLayer.add(new Planet(250, 50, 0, 0, "life"));
		objectLayer.add(new Planet(350, 50, 0, 0, "desert"));
		
		slingShotHud = new SlingShotHud(player);
		slingShotHud.launchSignal.addOnce(handleSlingshot);
		uiLayer.add(slingShotHud);
		
		add(backgroundLayer);
		add(objectLayer);
		add(effectLayer);
		add(uiLayer);
	}

	public function handleSlingshot(launchVector:FlxPoint):Void{
		FlxG.camera.follow(player);
		player.handleSlingshot(launchVector);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
