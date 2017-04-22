package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class SlingShotHud extends FlxTypedGroup<FlxSprite>
{
	
	public var _reticule:FlxSprite;
	public var _reticuleTrail1:FlxSprite;
	public var _reticuleTrail2:FlxSprite;

	public var _slingshotStart:FlxPoint;
	public var _slingshotEnd:FlxPoint;
	public var _slingshotPointer:FlxSprite;
	public var _canReleaseSlingshot:Bool;
	public var _slingshotTimer:FlxTimer;

	public var _player:FlxSprite;

	public var _minOffset:Float = 50;
	public var _maxOffset:Float = 300;

	public function new (player:FlxSprite){
		super();
		_reticule = new FlxSprite(0, 0);
		_reticule.loadGraphic(AssetPaths.Reticle__png, true, 16, 16);
		_reticule.animation.add("pulse", [0, 1, 2, 3, 4, 5, 6, 7], 20);
		_reticule.animation.play("pulse");
		_reticuleTrail1 = new FlxSprite(0, 0);
		_reticuleTrail1.makeGraphic(8, 8, FlxColor.fromHSL(1, 0.0, 0.5, 1));
		_reticuleTrail2 = new FlxSprite(0, 0);
		_reticuleTrail2.makeGraphic(4, 4, FlxColor.fromHSL(1, 0.0, 0.25, 1));
		_player = player;

		_slingshotPointer = new FlxSprite(0,0);
		_slingshotPointer.makeGraphic(20, 50, FlxColor.WHITE);
		_slingshotPointer.origin.set(10, 0);
		_slingshotPointer.kill();

		_slingshotTimer = new FlxTimer();

		add(_reticule);
		add(_reticuleTrail1);
		add(_reticuleTrail2);
		add(_slingshotPointer);
	}

	public function positionAroundOrigin(){
		var mousePosition:FlxPoint = FlxG.mouse.getWorldPosition();
		var toMouse:FlxPoint = mousePosition.subtractPoint(_player.getMidpoint());
		toMouse = FlxAngle.getPolarCoords(toMouse.x, toMouse.y);
		var offset:Float = Math.min(Math.max(toMouse.x, _minOffset), _maxOffset);
		var resultantPosition:FlxPoint = FlxAngle.getCartesianCoords(offset, toMouse.y);
		var newPosition:FlxPoint = resultantPosition.addPoint(_player.getMidpoint());
		_reticule.setPosition(
			newPosition.x - _reticule.width/2,
			newPosition.y - _reticule.height/2
		);

		resultantPosition = FlxAngle.getCartesianCoords(offset * 2 / 3, toMouse.y);
		newPosition = resultantPosition.addPoint(_player.getMidpoint());
		_reticuleTrail1.setPosition(
			newPosition.x - _reticuleTrail1.width/2,
			newPosition.y - _reticuleTrail1.height/2
		);

		resultantPosition = FlxAngle.getCartesianCoords(offset * 1 / 3, toMouse.y);
		newPosition = resultantPosition.addPoint(_player.getMidpoint());
		_reticuleTrail2.setPosition(
			newPosition.x - _reticuleTrail2.width/2,
			newPosition.y - _reticuleTrail2.height/2
		);

	}


	public function handleClick():Void{
		if (FlxG.mouse.justPressed)
	    {
	    	_slingshotStart = FlxG.mouse.getWorldPosition();
	    	_reticule.kill();
	    	_reticuleTrail1.kill();
	    	_reticuleTrail2.kill();
	    	_slingshotPointer.reset(0,0);
	    	_slingshotPointer.width = 20;
	        _slingshotTimer.start(0.1, allowReleaseSlingshot, 0);

	    	_slingshotStart = FlxG.mouse.getWorldPosition();
	    	_slingshotPointer.setPosition(_slingshotStart.x, _slingshotStart.y);
	    	var slingShotPointAngle:Float = FlxAngle.angleBetweenPoint( _player, _slingshotStart, true);
	    	slingShotPointAngle -= 90;
	    	_slingshotPointer.angle = slingShotPointAngle;
	    }

	    if (FlxG.mouse.pressed)
	    {
	    	_slingshotEnd = FlxG.mouse.getWorldPosition();
			var toSlingShotEnd:FlxPoint = _slingshotStart.subtractPoint(_slingshotEnd);
			toSlingShotEnd = FlxAngle.getPolarCoords(toSlingShotEnd.x, toSlingShotEnd.y);
	    	_slingshotPointer.scale.set(1, toSlingShotEnd.y/50);
	    }

	    if (_canReleaseSlingshot && FlxG.mouse.justReleased)
	    {
	        // The left mouse button has just been released
	    }
	}

	public function allowReleaseSlingshot(_){
		 _canReleaseSlingshot = true;
	}

	override public function update (elapsed:Float){
		super.update(elapsed);
		positionAroundOrigin();
		handleClick();
	}
}