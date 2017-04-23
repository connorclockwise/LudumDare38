package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;

/**
 * ...
 * @author Zack
 */
class TestBed extends FlxState
{
	public var policeCar:Cop;
	public var cops:FlxTypedGroup<Cop>;
	public var player:Player;
	override public function create():Void 
	{
		super.create();
		
		player = new Player(50, 50);
		player.isGoTime = true;
		player.fuel = 100000000;
		
		cops = new FlxTypedGroup<Cop>();
		
		for (i in 0...2) {
			cops.add(new Cop(i * 500, 500));
		}
		cops.forEach(function(cop:Cop) {
			cop.pursueOn(player);
		});
		
		add(player);
		add(cops);
		
		FlxG.camera.follow(player);
		
		//policeCar.seekOn(player);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		FlxG.overlap(player, cops, handleCops);
	}
	
	private function handleCops(player:Player, cop:Cop) {
		//cop.kill();
	}
	
}