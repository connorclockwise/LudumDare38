package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Planet extends FlxSprite{

	public var _size:Int;
	public var _rotationSpeed:Float;
	
	public function new (x:Float, y:Float, size:Int, rotationSpeed:Float){
		super(x, y);
		var color:FlxColor = FlxColor.fromHSL(1, 1.0, (size - 20) / 40.0, 1);
		makeGraphic(size, size, color);
		_size = size;
		_rotationSpeed = rotationSpeed;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		angle += _rotationSpeed;
	}
}