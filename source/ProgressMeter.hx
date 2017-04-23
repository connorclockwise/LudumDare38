package;

import flixel.FlxSprite;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class ProgressMeter extends FlxSprite
{
	public var player:Player;
	public var startIcon:FlxSprite;
	public var endIcon:FlxSprite;
	public var carIcon:FlxSprite;
	public var totalDistance:Float;
	public var goal:FlxSprite;
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(350, 2); 
		
		startIcon = new FlxSprite(x-10, y);
		startIcon.loadGraphic(AssetPaths.Icons__png, true, 8, 8);
		startIcon.animation.frameIndex = 2;
		startIcon.dirty = true;
		
		carIcon = new FlxSprite(x, y);
		carIcon.loadGraphic(AssetPaths.Icons__png, true, 8, 8);
		carIcon.animation.frameIndex = 1;
		carIcon.dirty = true;
		
		endIcon = new FlxSprite(x+width+2, y);
		endIcon.loadGraphic(AssetPaths.Icons__png, true, 8, 8);
		endIcon.animation.frameIndex = 0;
		endIcon.dirty = true;
		
		scrollFactor.set(0, 0);
		carIcon.scrollFactor.set(0, 0);
		endIcon.scrollFactor.set(0, 0);
		startIcon.scrollFactor.set(0, 0);
	}
	
	public function initialize(goal:FlxSprite, player:Player):Void {
		this.player = player;
		this.goal = goal;
		totalDistance = new FlxVector(goal.x - player.x, goal.y - player.y).length - (goal.width/2);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		startIcon.update(elapsed);
		endIcon.update(elapsed);
		carIcon.update(elapsed);
		
		//Car icon moves from x to x+348 as distance approaches 0.
		carIcon.x = (1 - (new FlxVector(goal.x - player.x, goal.y - player.y).length / totalDistance))*348 + x;
	}
	
	override public function draw():Void 
	{
		super.draw();
		startIcon.draw();
		endIcon.draw();
		carIcon.draw();
	}
	
}