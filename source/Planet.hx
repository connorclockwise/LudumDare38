package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Planet extends FlxSprite{

	public var _size:Int;
	public var _rotationSpeed:Float;
	public var _reticule:FlxSprite;
	public var _type:String;
	public var dying:Bool;
	public var deathTimer:Float;
	public var explosionTimer:Float;
	
	public function new (x:Float, y:Float, size:Int, rotationSpeed:Float, type:String){
		super(x, y);
		_type = type;
		switch(_type) {
			case "life":
				loadGraphic(AssetPaths.Planet_Life__png);
			case "desert":
				loadGraphic(AssetPaths.Planet_Desert__png);
			case "lava":
				loadGraphic(AssetPaths.Planet_Lava__png);
			case "gas1":
				loadGraphic(AssetPaths.Planet_Light_Gas__png);
			case "gas2":
				loadGraphic(AssetPaths.Planet_Dark_Gas__png);
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
		dying = false;
	}
	
	override public function kill():Void 
	{
		//super.kill();
		if (!dying) {
			dying = true;
			deathTimer = 1.5;
			explosionTimer = 0.03;
			triggerExplosion();
			FlxG.sound.play("assets/sounds/Multi-Explosion-Long.wav", 0.3, false);
		}
	}
	
	private function triggerExplosion() {
		var explosionPosition:FlxPoint = new FlxPoint(FlxG.random.float(x, x+width), FlxG.random.float(y, y+height));
		if (GlobalRegistry.effectLayer.getFirstAvailable(ExplosionFX) != null) {
			cast(GlobalRegistry.effectLayer.getFirstAvailable(ExplosionFX), ExplosionFX).reset(explosionPosition.x, explosionPosition.y);
		}else {
			GlobalRegistry.effectLayer.add(new ExplosionFX(explosionPosition.x, explosionPosition.y));
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (dying) {
			visible = !visible;
			deathTimer -= elapsed;
			explosionTimer -= elapsed;
			if (explosionTimer < 0) {
				triggerExplosion();
				explosionTimer += 0.03;
			}
			if (deathTimer < 0) {
				super.kill();
			}
		}
	}
}