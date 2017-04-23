package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxPrerotatedAnimation;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class Cop extends FlxSprite
{
	
	public var forces:Array<FlxVector> = [];
	public var isSeeking:Bool = false;
	public var isPursuing:Bool = false;
	public var seekTarget:FlxSprite;
	public var MAX_SPEED:Float = 1000;
	
	public var seekPoint:FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Copper__png, true, 32, 64);
		animation.add("pulse", [0, 1, 2, 3, 4], 16);
		animation.play("pulse");
		
		seekPoint = new FlxSprite(0, 0);
		seekPoint.makeGraphic(3, 3);
	}
	
	public function seek(target:FlxSprite):FlxVector {
		return seekToAtSpeed(FlxVector.get(target.x, target.y), (cast(FlxVector.get().copyFrom(target.velocity), FlxVector).length + 600));
	}
	
	public function seekToAtSpeed(targetPoint:FlxVector, speed:Float):FlxVector {
		seekPoint.x = targetPoint.x;
		seekPoint.y = targetPoint.y;
		var myPos:FlxPoint = getPosition(null);
		var targetVec:FlxVector = cast(FlxVector.get().copyFrom(targetPoint), FlxVector);
		var myVec:FlxVector = cast(FlxVector.get().copyFrom(myPos), FlxVector);
		
		var desiredVelocity:FlxVector = cast(targetVec.subtractPoint(myVec), FlxVector).normalize().scale(MAX_SPEED);
		//Clean up vector pools.
		targetPoint.put();
		myPos.put();
		targetVec.put();
		myVec.put();
		var retVal:FlxVector = cast(desiredVelocity.subtract(velocity.x, velocity.y), FlxVector);
		forces.push(retVal);
		return retVal;		
	}
	
	public function pursue(target:FlxSprite):FlxVector {
		var targetVelocity:FlxVector = FlxVector.get(target.velocity.x, target.velocity.y);
		var myVelocity:FlxVector = FlxVector.get(velocity.x, velocity.y);
		var myPos:FlxVector = FlxVector.get(x, y);
		var targetPos:FlxVector = FlxVector.get(target.x, target.y);
		var toTarget:FlxVector = cast(targetPos.subtractNew(myPos), FlxVector);
		
		var relativeHeading:Float = myVelocity.normalize().dotProdWithNormalizing(targetVelocity);
		
		if (toTarget.dotProduct(myVelocity.normalize()) < 0 && relativeHeading < -0.95) {
			return seek(target);
		}
		
		var lookAheadTime:Float = toTarget.length / ((targetVelocity.length + 400) + targetVelocity.length);
		
		var returnVector:FlxVector = seekToAtSpeed(cast(targetPos.addPoint(targetVelocity.scale(lookAheadTime)), FlxVector), targetVelocity.length + 600);
		
		
		targetVelocity.put();
		myVelocity.put();
		toTarget.put();
		targetPos.put();
		forces.push(returnVector);
		return returnVector;
	}
	
	public function seekOn(target:FlxSprite) {
		seekTarget = target;
		isSeeking = true;
	}
	
	public function pursueOn(target:FlxSprite) {
		isPursuing = true;
		seekTarget = target;
	}
	
	public function sumForces():FlxVector {
		var finalForce = FlxVector.get();
		for (force in forces) {
			finalForce.add(force.x, force.y);
		}
		return finalForce;
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		forces = [];
		if (isSeeking) {
			seek(seekTarget);
		}
		if (isPursuing) {
			pursue(seekTarget);
		}
		var newAccel:FlxVector = sumForces();
		acceleration.copyFrom(newAccel);
		newAccel.put();
		
		angle = FlxVector.get().angleBetween(velocity);
		
		seekPoint.update(elapsed);
	}
	
	override public function draw():Void 
	{
		super.draw();
		seekPoint.draw();
	}
	
}