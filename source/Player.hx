package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;

class Player extends FlxSprite
{

	public var _reticule:FlxSprite;

	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Junker__png, true, 32, 64);
		animation.add("pulse", [0, 1, 2, 3, 4], 15);
		animation.play("pulse");
		//makeGraphic(20, 50, FlxColor.WHITE);
	}

	public function handleImpulse(newVelocity:FlxPoint){
		velocity.copyFrom(newVelocity);
		var polarCoords:FlxPoint = FlxAngle.getPolarCoords(newVelocity.x, newVelocity.y);
		angle = polarCoords.y += 90;
	}

	public function handleSlingshot(launchVector:FlxPoint):Void{
		launchVector.scale(4);
		handleImpulse(launchVector);
	}

	public function handleInput(){

		var resultantVelocity:FlxVector = new FlxVector(velocity.x, velocity.y);
		var velocityMag = FlxAngle.getPolarCoords(velocity.x, velocity.y).x; 
		var amountToTurn:Float = 1.5 * ( Math.min(velocityMag, 10.0) / 10.0);

		if(FlxG.keys.anyPressed([LEFT, A])){
			resultantVelocity.rotateByDegrees(-amountToTurn);
		}
		if(FlxG.keys.anyPressed([RIGHT, D])){
			resultantVelocity.rotateByDegrees(amountToTurn);
		}

		#if FLX_DEBUG
		if (FlxG.keys.pressed.LEFT) {
			this.velocity.x = -400;
		}else if (FlxG.keys.pressed.RIGHT) {
			this.velocity.x = 400;
		}else {
			this.velocity.x = 0;
		}
		if (FlxG.keys.pressed.UP) {
			this.velocity.y = -400;
		}else if (FlxG.keys.pressed.DOWN) {
			this.velocity.y = 400;
		}else {
			this.velocity.y = 0;
		}
		#end

		handleImpulse(resultantVelocity);
	}
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		handleInput();
	}
}