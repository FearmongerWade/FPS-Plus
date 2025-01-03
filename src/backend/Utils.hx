package backend;

import lime.utils.Assets;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

using Lambda;

class Utils
{

	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String 
	{
		final company:String = FlxG.stage.application.meta.get('company');
		
		return '${company}/${flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file'))}';
	}

	public static final resultsTextCharacters = "AaBbCcDdEeFfGgHhiIJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz:1234567890.-'";

	public static function coolTextFile(path:String):Array<String>{
		var daList:Array<String> = getText(path).trim().split('\n');

		for (i in 0...daList.length){
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	//find actual graphic mid point (for backwards compatanility with people who don't update flixel)
	public static inline function getGraphicMidpoint(sprite:FlxSprite, ?point:FlxPoint):FlxPoint{
		#if (flixel >= "5.7.0")
		return sprite.getGraphicMidpoint(point);
		#else
		if (point == null){
			point = FlxPoint.get();
		}
		return point.set(sprite.x + sprite.frameWidth * 0.5 * sprite.scale.x, sprite.y + sprite.frameHeight * 0.5 * sprite.scale.y);
		#end
	}

	//the options menu requires the old one to work :[[[[[
	public static inline function oldGetGraphicMidpoint(sprite:FlxSprite, ?point:FlxPoint):FlxPoint{
		if (point == null){
			point = FlxPoint.get();
		}
		return point.set(sprite.x + sprite.frameWidth * 0.5, sprite.y + sprite.frameHeight * 0.5);
	}

	//Actually center offsets.
	public static inline function centerOffsets(sprite:FlxSprite, AdjustPosition:Bool = false):Void{
		sprite.offset.x = ((sprite.frameWidth * sprite.scale.x) - sprite.width) * 0.5;
		sprite.offset.y = ((sprite.frameHeight * sprite.scale.y) - sprite.height) * 0.5;
		if (AdjustPosition){
			sprite.x += sprite.offset.x;
			sprite.y += sprite.offset.y;
		}
	}

	/*
	*	Adjusts the value based on the reference FPS.
	*/
	public static inline function fpsAdjust(value:Float, ?referenceFps:Float = 60):Float{
		return value * (referenceFps * FlxG.elapsed);
	}

	/*
	*	Lerp that calls `fpsAdjust` on the ratio.
	*/
	public static inline function fpsAdjsutedLerp(a:Float, b:Float, ratio:Float):Float{
		return FlxMath.lerp(a, b, clamp(fpsAdjust(ratio), 0, 1));
	}

	/*
	* Uses FileSystem.exists for desktop and Assets.exists for non-desktop builds.
	* This is because Assets.exists just checks the manifest and can't find files that weren't compiled with the game.
	* This also means that if you delete a file, it will return true because it's still in the manifest.
	* FileSystem only works on certain build types though (namely, not web).
	*/
	public static function exists(path:String):Bool{
		#if desktop
		return FileSystem.exists(path);
        #else
        return Assets.exists(path);
		#end
	}

	//Same as above but for getting text from a file.
	public static function getText(path:String):String{
		#if desktop
		return File.getContent(path);
        #else
        return Assets.getText(path);
		#end
	}

	public static function clamp(v:Float, min:Float, max:Float):Float {
		if(v < min) { v = min; }
		if(v > max) { v = max; }
		return v;
	}

	public static function worldToLocal(object:FlxObject, x:Float, y:Float):FlxPoint{
        return new FlxPoint(x - object.x, y - object.y);
    }

	public static inline function sign(v:Float):Int {
		return (v > 0 ? 1 : (v < 0 ? -1 : 0));
	}
}

class OrderedMap<K, V>{

    public var keys:Array<K>;
    public var values:Array<V>;

    public function new() {
        keys = [];
        values = [];
    }

    public function set(key:K, value:V):Void{
        if(keys.contains(key)){
            var index = keys.indexOf(key);
            values[index] = value;
        }
        else{
            keys.push(key);
            values.push(value);
        }
    }

    public function get(key:K):V{
        if(keys.contains(key)){
            return values[keys.indexOf(key)];
        }
        return null;
    }

    public function remove(key:K):Void{
        if(keys.contains(key)){
            var index = keys.indexOf(key);
            keys.remove(key);
            values.remove(values[index]);
        }
    }

}