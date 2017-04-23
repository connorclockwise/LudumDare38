package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxSound;

class Player extends FlxSprite
{

	public var _reticule:FlxSprite;
	public var _helperVector:FlxVector;
	public var fuel:Float;
	public var isGoTime:Bool;
	public var swayCounter:Float;
	public var lastSpeedChangeCountdown:Float = 2; //2 second countdown from last speed change

	public var _boosterLoop:FlxSound;

	public function new(X:Float, Y:Float) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Junker__png, true, 32, 64);
		animation.add("pulse", [0, 1, 2, 3, 4], 15);
		animation.add("off", [5]);
		animation.play("off");
		_helperVector = new FlxVector();
		fuel = 5000;
		isGoTime = false;
		swayCounter = 0;
		
		_boosterLoop = FlxG.sound.load(AssetPaths.Thrust__wav, 1, true);
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
	
	public function changeSpeed(amount:Float, ?ignoreDecay:Bool=false) {
		_helperVector.copyFrom(velocity);
		if (_helperVector.length < Math.abs(amount) && amount< 0) {
			_helperVector.length = 0;
		}else {
			_helperVector.length += amount;
		}
		velocity.copyFrom(_helperVector);
		if (!ignoreDecay) {
			lastSpeedChangeCountdown = 2;
		}
	}

	public function handleInput(){

		var _helperVector:FlxVector = new FlxVector(velocity.x, velocity.y);
		
		var velocityMag = FlxAngle.getPolarCoords(velocity.x, velocity.y).x; 
		var amountToTurn:Float = 1.5 * ( Math.min(velocityMag, 200.0) / 200.0);
		_helperVector.rotateByDegrees(FlxMath.fastSin(swayCounter) * 1.1);
	
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
				//Using fuel doesn't do nearly as much as hitting something for stabilizing speed loss. But only if it would help.
				if (lastSpeedChangeCountdown < 0.4) {
					lastSpeedChangeCountdown = 0.4; 				
				}

				if(!_boosterLoop.playing){
					_boosterLoop.play(false, 0.3);
				}
			}
			else{
				_boosterLoop.pause();
			}
			handleImpulse(_helperVector);			
		}
	}

	override public function kill(){
		super.kill();
		_boosterLoop.pause();
	}
	
	override public function update(elapsed:Float) 
	{
		super.update(elapsed);
		swayCounter += 5 * elapsed;
		if (swayCounter > Math.PI * 2) {
			swayCounter -= Math.PI * 2;
		}
		handleInput();
		lastSpeedChangeCountdown -= elapsed;
		if (lastSpeedChangeCountdown < 0) {
			changeSpeed( -50 * elapsed, true);
		}
		if (fuel <= 0) {
			animation.play("off");
		}else if(isGoTime) {
			animation.play("pulse");
		}
	}
}