package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class SlingShotHud extends FlxTypedGroup<FlxSprite>
{
	
	public var _reticule:FlxSprite;
	public var _reticuleTrail1:FlxSprite;
	public var _reticuleTrail2:FlxSprite;

	public var _slingshotStart:FlxPoint;
	public var _slingshotEnd:FlxPoint;
	public var _slingshotPointer:FlxSprite;

	public var _player:FlxSprite;

	public var _minOffset:Float = 50;
	public var _maxOffset:Float = 300;

	public function new (player:FlxSprite){
		super();
		_reticule = new FlxSprite(0, 0);
		_reticule.makeGraphic(16, 16, FlxColor.WHITE);
		_reticuleTrail1 = new FlxSprite(0, 0);
		_reticuleTrail1.makeGraphic(8, 8, FlxColor.fromHSL(1, 0.0, 0.5, 1));
		_reticuleTrail2 = new FlxSprite(0, 0);
		_reticuleTrail2.makeGraphic(4, 4, FlxColor.fromHSL(1, 0.0, 0.25, 1));
		_player = player;

		_slingshotPointer = new FlxSprite(0,0);
		_reticuleTrail2.makeGraphic(4, 4, FlxColor.WHITE);

		add(_reticule);
		add(_reticuleTrail1);
		add(_reticuleTrail2);
	}

	public function positionAroundOrigin(){
		var mousePosition:FlxPoint = FlxG.mouse.getScreenPosition();
		var toMouse:FlxPoint = mousePosition.subtractPoint(_player.getScreenPosition());
		toMouse = FlxAngle.getPolarCoords(toMouse.x, toMouse.y);
		var offset:Float = Math.min(Math.max(toMouse.x, _minOffset), _maxOffset);
		var resultantPosition:FlxPoint = FlxAngle.getCartesianCoords(offset, toMouse.y);

		_reticule.x = resultantPosition.x + _player.x;
		_reticule.y = resultantPosition.y + _player.y;

		resultantPosition = FlxAngle.getCartesianCoords(offset * 2 / 3, toMouse.y);

		_reticuleTrail1.x = resultantPosition.x + _player.x;
		_reticuleTrail1.y = resultantPosition.y + _player.y;

		resultantPosition = FlxAngle.getCartesianCoords(offset * 1 / 3, toMouse.y);

		_reticuleTrail2.x = resultantPosition.x + _player.x;
		_reticuleTrail2.y = resultantPosition.y + _player.y;

	}


	public function handleClick():Void{
		//FlxG.
	}

	override public function update (estimated:Float){
		positionAroundOrigin();
		handleClick();

	}
}