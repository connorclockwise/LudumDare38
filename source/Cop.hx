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

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Copper__png, true, 32, 64);
		animation.add("pulse", [0, 1, 2, 3, 4], 16);
		animation.play("pulse");
	}
	
	public function seek(target:FlxSprite):FlxVector {
		var targetPos:FlxPoint = target.getPosition(null);
		var myPos:FlxPoint = getPosition(null);
		var targetVec:FlxVector = cast(FlxVector.get().copyFrom(targetPos), FlxVector);
		var myVec:FlxVector = cast(FlxVector.get().copyFrom(myPos), FlxVector);
		
		var desiredVelocity:FlxVector = cast(targetVec.subtractPoint(myVec), FlxVector).normalize().scale((cast(FlxVector.get().copyFrom(target.velocity), FlxVector).length + 400));
		
		//Clean up vector pools.
		targetPos.put();
		myPos.put();
		targetVec.put();
		myVec.put();
		FlxG.log.add(desiredVelocity);
		var retVal:FlxVector = cast(desiredVelocity.subtract(velocity.x, velocity.y), FlxVector);
		forces.push(retVal);
		FlxG.log.add(retVal);
		return retVal;
	}
	
	public function pursue(target:FlxSprite) {
		var targetVelocity:FlxVector = FlxVector.get(target.velocity.x, target.velocity.y);
		var myVelocity:FlxVector = FlxVector.get(velocity.x, velocity.y);
		var relativeHeading:Float = myVelocity.normalize().dotProdWithNormalizing(targetVelocity);
		
		targetVelocity.put();
		myVelocity.
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
		var newAccel:FlxVector = sumForces();
		acceleration.copyFrom(newAccel);
		newAccel.put();
		
		angle = FlxVector.get().angleBetween(velocity);
	}
	
}