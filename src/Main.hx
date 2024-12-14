package;

import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;

#if desktop
import backend.ALSoftConfig;
#end

class Main extends Sprite
{
	public static var fpsCounter:FPSCounter;

	public function new()
	{
		super();

		SaveManager.global();

		addChild(new FlxGame(0, 0, Startup, 60, 60, true));

		fpsCounter = new FPSCounter(10, 3);
		fpsCounter.visible = true;
		#if desktop addChild(fpsCounter);#end
	}
}
