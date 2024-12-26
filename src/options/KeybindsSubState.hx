package options;

import config.KeyIcon;

class KeybindsSubState extends MusicBeatSubstate
{
    var window:FlxSprite;
    var red:FlxSprite;
    var keys:Array<String> = [
        'left',
        'down',
        'up',
        'right',
        'death'
    ];
    var keyGroup:FlxTypedGroup<FlxSprite>;

    var moving:Bool = false;
    var curSelected:Int = 0;

    public function new()
    {
        super();

        window = new FlxSprite(500, 100).loadGraphic(Paths.image('menu/options/keybindsWindow'));
        window.scrollFactor.set();
        window.antialiasing = true;
        add(window);

        red = new FlxSprite(window.x+200, window.y+10).makeGraphic(15, 15, FlxColor.RED);
        red.blend = MULTIPLY;
        red.scrollFactor.set();
        red.alpha = 0;
        add(red);
    }

    var mClick:Bool = true;
	var mHover:Bool = false;

    override function update(elapsed:Float)
    {
        if (!moving)
        {
            if (mHover)
                if (!FlxG.mouse.overlaps(red))
                    red.alpha = 0;
            if (FlxG.mouse.overlaps(red))
            {
                if (mClick)
                {
                    mHover = true;
                    red.alpha = 1;
                }
                if (FlxG.mouse.justPressed && mClick)
                    goBack();
            }
    
            if (FlxG.keys.justPressed.ESCAPE)
                goBack();
        }

        super.update(elapsed);
    }

    function goBack()
    {
        FlxG.sound.play(Paths.sound('cancelMenu'));

        red.alpha = 0;
        moving = true;
        FlxTween.tween(window, {y:FlxG.height + window.height + 5}, 0.5,
        {
            ease: FlxEase.expoInOut,
            onComplete: function(twn:FlxTween){ close(); }
        });
    }
}
