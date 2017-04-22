package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var starfield:FlxStarfield;
	public var planets:FlxTypedGroup<Planet>;
	
	public var uiLayer:FlxGroup;
	public var objectLayer:FlxGroup;
	public var effectLayer:FlxGroup;
	public var backgroundLayer:FlxGroup;
	
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
		
		for(i in 0...20){
			position.x = Std.int(FlxG.random.float() * FlxG.width);
			position.y = Std.int(FlxG.random.float() * FlxG.height);
			size = Std.int(FlxG.random.float(20, 60));
			rotationSpeed = FlxG.random.float(1, 4) * 100;

			planet = new Planet(position.x, position.y, size, rotationSpeed);
			planets.add(planet);
		}
		
		objectLayer.add(planets);
		starfield = new FlxStarfield(0, 0, FlxG.width, FlxG.height);
		backgroundLayer.add(starfield);
		
		add(backgroundLayer);
		add(objectLayer);
		add(effectLayer);
		add(uiLayer);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
