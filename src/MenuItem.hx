package;

class MenuItem extends FlxSprite
{
	public var targetY:Float = 0;

	public function new(x:Float, y:Float, weekNum:String)
	{
		super(x, y);

		loadGraphic(Paths.image('menu/story/weeks/' + weekNum));
		antialiasing = true;
	}

	public var isFlashing(default, set):Bool = false;
	private var flashingElapsed:Float = 0;
	var flashColor = 0xff33ffff;
	var flash_per_second:Int = 6;

	public function set_isFlashing(value:Bool = true)
	{
		isFlashing = value;
		flashingElapsed = 0;
		color = (isFlashing) ? flashColor : FlxColor.WHITE;
		return isFlashing;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		y = Utils.fpsAdjsutedLerp(y, (targetY * 120) + 480, 0.17);

		if (isFlashing)
		{
			flashingElapsed += elapsed;
			color = (Math.floor(flashingElapsed * FlxG.updateFramerate * flash_per_second) % 2 == 0) ? flashColor : FlxColor.WHITE;
		}
	}
}
