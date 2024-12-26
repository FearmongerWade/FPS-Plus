package options;

class MissingSubState extends MusicBeatSubstate
{
    var hampter:FlxSprite;
    var red:FlxSprite;
    var text:FlxText;

    var moving:Bool = true;

    public function new()
    {
        super();

        hampter = new FlxSprite(0, 250).loadGraphic(Paths.image('menu/options/missing'));
        hampter.antialiasing = true;
        hampter.scrollFactor.set();

        red = new FlxSprite(1080, 253).makeGraphic(15, 15, FlxColor.RED);
        red.blend = MULTIPLY;
        red.scrollFactor.set();
        red.alpha = 0;
        
        text = new FlxText(700, 300, hampter.width, 'this menu isnt done yet, sorry...', 24);
        text.setFormat(Paths.font('funkin', 'otf'), 24, CENTER, FlxColor.WHITE);
        text.scrollFactor.set();
        text.antialiasing = true;
        text.alpha = 0;

        add(text);
        add(hampter);
        add(red);
        hampter.x = FlxG.width + hampter.width+5;

        FlxTween.tween(hampter, {x: 700}, 0.5,
        {
            ease: FlxEase.expoInOut,
            onComplete: function(twn:FlxTween) { 
                moving = false; 
                text.alpha = 1;
                FlxTween.tween(text, {y: 660}, 0.5);
            }
        });
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
        
        text.alpha = 0;
        red.alpha = 0;
        moving = true;
        FlxTween.tween(hampter, {y:FlxG.height + hampter.height + 5}, 0.5,
        {
            ease: FlxEase.expoInOut,
            onComplete: function(twn:FlxTween){ close(); }
        });
    }
}