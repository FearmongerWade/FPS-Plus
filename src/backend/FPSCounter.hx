package backend;

/*
    This code here doesn't belong to me, it was written by teles for FNF: Doido Engine
    Please be sure to check them out and give them lots of support

    https://github.com/DoidoTeam/FNF-Doido-Engine/blob/main/source/data/FPSCounter.hx
    https://x.com/teles_ahhh
*/

import haxe.Timer;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.display.Sprite;

class FPSCounter extends Sprite
{
    @:noCompletion private var times:Array<Float>;
	@:noCompletion private var deltaTimeout:Float = 0.0;

    var fpsField:TextFieldExt;
    var memField:TextFieldExt;

    public function new(x:Float = 0, y:Float = 0)
    {
        super();
        this.x = x;
        this.y = y;

        fpsField = new TextFieldExt(0, 0, 14, 100);
		addChild(fpsField);

        memField = new TextFieldExt(0, 16, 14, 300);
		addChild(memField);

        visible = Config.showFPS;

        times = [];
    }
    private override function __enterFrame(deltaTime:Float)
	{
		if(!visible) return;
		
		final now:Float = Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();
		// prevents the overlay from updating every frame, why would you need to anyways @crowplexus
		if (deltaTimeout < 50) {
			deltaTimeout += deltaTime;
			return;
		}
		
		var fps:Int = times.length;
		if (fps > FlxG.updateFramerate)
			fps = FlxG.updateFramerate;

		fpsField.text = '$fps'+' FPS';

		var mem:Float = Math.abs(Math.round(System.totalMemory / 1024 / 1024 * 100) / 100);
		memField.text = formatBytes(mem);

		#if debug
		memField.text += '\n${Type.getClassName(Type.getClass(FlxG.state))}';
		#end
		
		if(fps < 30 || fps > 360)
			fpsField.textColor = 0xFF0000;
		else
			fpsField.textColor = 0xFFFFFF;

		if(mem >= 2 * 1024)
			memField.textColor = 0xFF0000;
		else
			memField.textColor = 0xFFFFFF;
	}

    public static var byteUnits:Array<String> = ["MB", "GB", "TB", "PB"];

	public static function formatBytes(bytes:Float):String
	{
		var unitCount:Int = 0;

		// Love me some recursion up in here
		function format()
		{
			if(bytes >= 1024) {
				unitCount++;
				bytes /= 1024;
				format();
			}
		}
		format();

		bytes = Math.floor(bytes * 100) / 100;
		
		return '$bytes ${byteUnits[unitCount]}';
	}

}

class TextFieldExt extends TextField
{
    public function new(x:Float = 0, y:Float = 0, size:Int = 14, width:Float = 0, text:String = "", color:Int = 0xFFFFFF)
    {
        super();

        this.x = x;
        this.y = y;
        this.text = text;

        if (width != 0) this.width = width;

        selectable = false;
        defaultTextFormat = new TextFormat(Paths.font("jetbrains"), size, color);
    }
}