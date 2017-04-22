package;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class SlingShotHud extends FlxTypedGroup<FlxSprite>
{
	
	public var _reticule:FlxSprite;
	public var _player:FlxSprite;

	public var _offset:Float = 150;

	public function new (player:FlxSprite){
		super();
		_reticule = new FlxSprite(0, 0);
		_reticule.loadGraphic(AssetPaths.Reticle__png, true, 16, 16);
		_reticule.animation.add("pulse", [0, 1, 2, 3, 4, 5, 6, 7], 20);
		_reticule.animation.play("pulse");
		_player = player;

		add(_reticule);
	}

	public function positionAroundOrigin(){
		var mouseAngle:Float = FlxAngle.angleBetweenMouse(_player, true);
		var resultantPosition:FlxPoint = FlxAngle.getCartesianCoords(_offset, mouseAngle);

		_reticule.x = resultantPosition.x + _player.x;
		_reticule.y = resultantPosition.y + _player.y;

	}

	override public function update (elapsed:Float){
		positionAroundOrigin();
		super.update(elapsed);
	}
}