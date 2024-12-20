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
	// -- Gameplay -- // 
	
	public var downscroll:Bool = false;
	public var ghostTapping:Bool = true;
	public var offset:Int = 0;
	public var framerate:Int = 144;

	// -- Customization -- //

	public var shaders:Bool = true;
	public var flashing:Bool = true;
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

		if (FlxG.save.data.framerate == null) 
		{
			var refreshRate:Int = FlxG.stage.application.window.displayMode.refreshRate;
			data.framerate = Std.int(FlxMath.bound(refreshRate * 2, 60, 360));
		}
			
	}

	public static inline function reset()
	{
		data = defaultData;
	}
}