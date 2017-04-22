package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;

class CollisionIndicatorHud extends FlxTypedGroup<FlxSprite>
{

	public var _planets:FlxTypedGroup<FlxSprite>;

	public function new (player:FlxSprite, planets:FlxTypedGroup<FlxSprite>){
		super();

		var arrowSprite:FlxSprite; 

		for(i in 1...5){
			arrowSprite = new FlxSprite(0, 0);
			arrowSprite.makeGraphic(16,16,FlxColor.WHITE);
			add(arrowSprite);
		}
		_planets = planets;
	}

	public function indicateNearestCollidables(){
		//collidables.so
	}

	override public function update (elapsed:Float){
		super.update(elapsed);
		indicateNearestCollidables();
	}
}