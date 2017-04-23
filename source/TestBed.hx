package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
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
	public var effectLayer:FlxGroup;
	override public function create():Void 
	{
		super.create();
		
		player = new Player(50, 50);
		player.isGoTime = true;
		player.fuel = 100000000;
		
		effectLayer = new FlxGroup();
		GlobalRegistry.effectLayer = effectLayer;
		
		cops = new FlxTypedGroup<Cop>();
		
		for (i in 0...2) {
			cops.add(new Cop(i * 500, 500));
		}
		cops.forEach(function(cop:Cop) {
			cop.pursueOn(player);
		});
		
		add(player);
		add(cops);
		add(effectLayer);
		
		FlxG.camera.follow(player);
		
		//policeCar.seekOn(player);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		FlxG.overlap(player, cops, handleCops);
		FlxG.worldBounds.set(camera.scroll.x, camera.scroll.y, FlxG.width, FlxG.height);
	}
	
	private function handleCops(player:Player, cop:Cop) {
		cop.kill();
	}
	
}