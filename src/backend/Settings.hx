package backend;

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

		var save:FlxSave = new FlxSave();
		save.bind('settings', Utils.getSavePath());
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function load()
	{
		for (key in Reflect.fields(data))
			if (Reflect.hasField(FlxG.save.data, key))
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));
	}

	public static inline function reset()
	{
		data = defaultData;
	}
}