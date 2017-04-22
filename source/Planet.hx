package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Planet extends FlxSprite{

	public var _size:Int;
	public var _rotationSpeed:Float;
	public var _reticule:FlxSprite;
	public var _type:String;
	
	public function new (x:Float, y:Float, size:Int, rotationSpeed:Float, type:String){
		super(x, y);
		_type = type;
		switch(_type) {
			case "life":
				loadGraphic(AssetPaths.Planet_Life__png);
			case "desert":
				loadGraphic(AssetPaths.Planet_Desert__png);
			case "home":
				loadGraphic(AssetPaths.Planet_Life__png);
			default:
				loadGraphic(AssetPaths.Planet_Desert__png);
		}
		//var color:FlxColor = FlxColor.fromHSL(1, 0.0, (size - 20) / 40.0, 1);
		//makeGraphic(size, size, color);
		//this.color = color;
		_size = size;
		setGraphicSize(size, size);
		updateHitbox();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//angle += _rotationSpeed * elapsed;
	}
}