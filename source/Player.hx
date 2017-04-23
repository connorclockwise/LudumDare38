package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;

class Player extends FlxSprite
{

	public var _reticule:FlxSprite;
	public var _helperVector:FlxVector;
	public var fuel:Float;
	public var isGoTime:Bool;

	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Junker__png, true, 32, 64);
		animation.add("pulse", [0, 1, 2, 3, 4], 15);
		animation.play("pulse");
		_helperVector = new FlxVector();
		fuel = 5000;
		isGoTime = false;
		//makeGraphic(20, 50, FlxColor.WHITE);
	}

	public function handleImpulse(newVelocity:FlxPoint) {
		_helperVector.copyFrom(newVelocity);
		if (_helperVector.length > 900) {
			_helperVector.length = 900;
		}
		velocity.copyFrom(_helperVector);
		if (!_helperVector.isZero()) {
			var polarCoords:FlxPoint = FlxAngle.getPolarCoords(newVelocity.x, newVelocity.y);
			angle = polarCoords.y += 90;			
		}
	}

	public function handleSlingshot(launchVector:FlxPoint):Void{
		launchVector.scale(4);
		handleImpulse(launchVector);
	}
	
	public function changeSpeed(amount:Float) {
		_helperVector.copyFrom(velocity);
		if (_helperVector.length < Math.abs(amount) && amount< 0) {
			_helperVector.length = 0;
		}else {
			_helperVector.length += amount;
		}
		velocity.copyFrom(_helperVector);
	}

	public function handleInput(){

		var _helperVector:FlxVector = new FlxVector(velocity.x, velocity.y);
		
		var velocityMag = FlxAngle.getPolarCoords(velocity.x, velocity.y).x; 
		var amountToTurn:Float = FlxG.random.float(-2, 4) * ( Math.min(velocityMag, 200.0) / 200.0);
	
		if(FlxG.keys.anyPressed([LEFT, A])){
			_helperVector.rotateByDegrees(-amountToTurn);
		}
		if(FlxG.keys.anyPressed([RIGHT, D])){
			_helperVector.rotateByDegrees(amountToTurn);
		}

		if (isGoTime) {
			if (FlxG.keys.anyPressed([UP, W]) && fuel > 0) {
				//TODO: Consume fuel
				fuel -= 1000 * FlxG.elapsed;
				if (_helperVector.isZero()) {
					FlxG.log.add("vector was zero");
					_helperVector.set(1, 0);
					_helperVector.rotateByDegrees(angle - 90);
				}
				_helperVector.length = Math.sqrt(_helperVector.lengthSquared + 2500);
			}
			handleImpulse(_helperVector);			
		}
	}
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		handleInput();
	}
}