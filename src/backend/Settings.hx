package backend;

/*
	New settings/save variable system
	It's based on Psych Engine
	With a few things from Rudyrue's psych fork
	Support Shadow and Rudy, not me

	https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/ClientPrefs.hx
	https://github.com/Rudyrue/custom-psych/blob/main/src/backend/Settings.hx
*/

import flixel.util.FlxSave;

@:structInit class SaveVariables
{
	public var downscroll:Bool = false;
	public var shaders:Bool = true;
	public var flashing:Bool = true;
	public var framerate:Int = 144;
	public var offset:Int = 0;
}
class Settings
{
	public static var defaultData:SaveVariables = {};
	public static var data:SaveVariables = defaultData;

	public static function save()
	{
		for (key in Reflect.fields(data))
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));

		FlxG.save.flush();
	}

	public static function load()
	{
		FlxG.save.bind('settings', Utils.getSavePath());

		for (key in Reflect.fields(data))
			if (Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));
	}

	public static inline function reset()
	{
		data = defaultData;
	}
}