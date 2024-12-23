package options;

enum OptionType
{
    BOOL;
    SUBMENU;
    KEYBIND;
}

class Option
{
    public var onChange:Void->Void = null;

    public var variable(default, null):String = null;
    public var defaultValue:Dynamic = null;

    public var curOption:Int = 0;

    public function new(name:String, description:String, variable:String, type:OptionType = BOOL)
    {
        this.name = name;
        this.description = description;
        this.variable = variable;
        this.type = type;

        switch(type)
        {
            case BOOL:
                if (defaultValue == null) defualtValue = false;
        }

        try
        {
            if (getValue() == null)
                setValue(defaultValue);
        }
        catch(e) { }
        super();
    }

    public function change()
    {
        if (onChange != null)
            onChange();
    }

    dynamic public function getValue():Dynamic
	{
		return Reflect.getProperty(Settings.data, variable);
	}

	dynamic public function setValue(value:Dynamic)
	{
		return Reflect.setProperty(Settings.data, variable, value);
	}
}