package;

import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author Zack
 */
class TestBed extends FlxState
{
	public var policeCar:Cop;
	public var player:Player;
	override public function create():Void 
	{
		super.create();
		
		player = new Player(50, 50);
		player.isGoTime = true;
		player.fuel = 100000000;
		
		policeCar = new Cop(400, 400);
		
		add(player);
		add(policeCar);
		
		FlxG.camera.follow(player);
		policeCar.seekOn(player);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
	}
	
}