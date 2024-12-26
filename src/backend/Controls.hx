package backend;

import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;

class Controls
{
    public static var keyBinds:Map<String, Array<FlxKey>> = [
        // Hi. These are the only ones you can change
        // Fuck you

        'note_left'       => [LEFT],
        'note_down'       => [DOWN],
        'note_up'         => [UP],
        'note_right'      => [RIGHT],
        'die'             => [R],

        // You can't change these I won't let you

        'ui_left'         => [A, LEFT],
        'ui_down'         => [S, DOWN],
        'ui_up'           => [W, UP],
        'ui_right'        => [D, RIGHT],

        'accept'          => [ENTER, SPACE],
        'back'            => [ESCAPE, BACKSPACE],
        'pause'           => [ENTER, ESCAPE]
    ];

    public static var defaultKeys:Map<String, Array<FlxKey>> = keyBinds;

    static var coolSave:FlxSave;

    // -- Backend -- // 

    public static function pressed(name:String)
        return FlxG.keys.anyPressed(defaultKeys[name]);

    public static function justReleased(name:String)
        return FlxG.keys.anyJustReleased(defaultKeys[name]);

    public static function justPressed(name:String)
        return FlxG.keys.anyJustPressed(defaultKeys[name]);

    public static function save() 
    {
		coolSave.data.keyboard = keyBinds;
		coolSave.flush();
	}

    public static function load() 
    {
		if (coolSave == null) 
        {
			coolSave = new FlxSave();
			coolSave.bind('controls', Utils.getSavePath());
		}

		if (coolSave.data.keyboard != null) 
        {
			var loadedKeys:Map<String, Array<FlxKey>> = coolSave.data.keyboard;
			for (control => keys in loadedKeys) 
				if (keyBinds.exists(control))
				    keyBinds.set(control, keys);
		}
    }

    public static function reset() 
    {
		for (key in keyBinds.keys())
            if(defaultKeys.exists(key))
                keyBinds.set(key, defaultKeys.get(key).copy());
    }
}