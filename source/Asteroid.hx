package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.system.FlxSound;

/**
 * ...
 * @author Zack
 */
class Asteroid extends FlxSprite
{
	public var xBounds:FlxPoint;
	public var killTimer:Float = 0.2; //0.2 seconds of exploding before death
	public var explosionTimer:Float = 0.05; //An explosion every 0.05 seconds
	public var dying:Bool = false;
	public function new(X, Y, XBounds:FlxPoint) 
	{
		super(X, Y, AssetPaths.ASS_Troid__png);
		this.xBounds = XBounds;
		angle = FlxG.random.float(0, 360);
		angularVelocity = FlxG.random.float(5, 20);
		pixelPerfectRender = false;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (y > FlxG.camera.scroll.y + FlxG.height) {
			reset(0, 0);
		}
		
		if (dying) {
			visible = !visible;
			killTimer -= elapsed;
			explosionTimer -= elapsed;
			if (explosionTimer < 0) {
				explosionTimer += 0.05;
				triggerExplosion();
			}
			if (killTimer < 0) {
				reset(0, 0);
			}
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
	
	override public function kill():Void 
	{
		//Do no super.kill
		if (dying == false) {
			triggerExplosion();
			GlobalRegistry.getOldestExplosionSound().play(true);
		}
		dying = true;
	}
	
	override public function reset(X:Float, Y:Float):Void 
	{
		dying = false;
		visible = true;
		killTimer = 0.2;
		explosionTimer = 0.05;
		super.reset(FlxG.random.float(xBounds.x, xBounds.y), y - (FlxG.height + height + 20));
		angle = FlxG.random.float(0, 360);
	}
	
	public function fullReset():Void {
		x = FlxG.random.float(xBounds.x, xBounds.y);
		y = FlxG.random.float(FlxG.camera.scroll.y, FlxG.camera.scroll.y + FlxG.height + 84);
		angle = FlxG.random.float(0, 360);
	}
	
	
}