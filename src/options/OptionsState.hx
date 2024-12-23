package options;

/*
    Hi guys, in today's episode I made the worst options menu known to man
    This code fucking sucks I know
    Feel free to kill me
    Fast

    Yours, Wade
*/

class OptionsState extends FlxUIStateExt
{
    public static var onPlayState:Bool = false;
    var path:String = 'menu/options/';

    var options:Array<String> = [
        'downscroll',
        'ghostTapping',
        //'shaders',
        //'flashing', 
        'keybinds',
        'offset', 
        'framerate'
    ];
    var grpOptions:FlxTypedGroup<FlxSprite>;
    var curSelected = 0;

    var selector:FlxSprite;

    override function create()
    {
        super.create();

        FlxG.sound.playMusic(Paths.music('chartEditorLoop'));
        FlxG.mouse.visible = true;
        Settings.load();

        var bg = new FlxSprite().loadGraphic(Paths.image('menu/menuBGBlue'));
        add(bg);

        var title = new FlxSprite(580, 40).loadGraphic(Paths.image(path+'title'));
        add(title);

        var window = new FlxSprite(60).makeGraphic(500, 600, 0xffacacac);
        window.screenCenter(Y);
        add(window);

        var text = new FlxText(65, 60, 0, 'crazy window wade, you dumb slut', 12);
        add(text);

        selector = new FlxSprite().makeGraphic(390, 80, 0xff320b9e);
        selector.alpha = 0;
        add(selector);

        grpOptions = new FlxTypedGroup<FlxSprite>();
        add(grpOptions);

        for (i in 0...options.length)
        {
            var steve:Float = window.x+5;
            var billy:Float = window.y+30;
            var item = new FlxSprite();
            item.frames = Paths.getSparrowAtlas(path+'option_items');
            item.animation.addByPrefix('off', options[i] + '_off', 1);
            item.animation.addByPrefix('on', options[i] + '_on', 1);
            item.ID = i;

            switch(i)
            {
                case 0:
                    item.animation.play(Settings.data.downscroll ? 'on' : 'off');
                case 1:
                    item.animation.play(Settings.data.ghostTapping ? 'on' : 'off');
                default:
                    item.animation.play('off');
            }

            grpOptions.add(item);
            switch(i)
            {
                case 0: // downscroll
                    item.setPosition(steve, billy);
                case 1: // ghost tapping
                    item.setPosition(steve+150, billy);
                case 2: // shaders
                    item.setPosition(steve+300, billy);
                case 3: // flashing
                    item.setPosition(steve, billy+150);
                case 4: // keybinds
                    item.setPosition(steve+150, billy+150);
                case 5: // offset
                    item.setPosition(steve+300, billy+150);
                case 6: // framerate
                    item.setPosition(steve, billy+300);
            }
        }

        check();
    }

    var mClick:Bool = true;
	var mHover:Bool = false;

    override function update(elapsed:Float)
    {
        grpOptions.forEach(function(spr:FlxSprite)
        {
            if (mHover)
                if (!FlxG.mouse.overlaps(spr))
                {
                    spr.scale.set(1,1);
                }

            if (FlxG.mouse.overlaps(spr))
            {
                if (mClick)
                {
                    curSelected = spr.ID;
                    mHover = true;
                    FlxTween.tween(spr.scale, {x:1.05, y:1.05}, 0.5, {ease: FlxEase.elasticOut});
                }
                if (FlxG.mouse.justPressed && mClick)
                    selectItem();
            }
        });

        if (FlxG.keys.justPressed.ESCAPE)
            backToMenu();

        super.update(elapsed);
    }

    function selectItem()
    {
        FlxG.sound.play(Paths.sound('confirmMenu'));

        switch (options[curSelected])
        {
            case 'downscroll':
                Settings.data.downscroll = !Settings.data.downscroll;
                grpOptions.members[0].animation.play(Settings.data.downscroll ? 'on' : 'off');
            case 'ghostTapping':
                Settings.data.ghostTapping = !Settings.data.ghostTapping;
                grpOptions.members[1].animation.play(Settings.data.ghostTapping ? 'on' : 'off');
            case 'keybinds':
                grpOptions.members[2].animation.play('on');
                switchState(new config.KeyBindMenu());
                trace('opening the keybinds submenu');
            case 'offset':
                trace('opening the offset submenu');    
            case 'framerate':
                trace('adjust your framerate');
            default:
                trace('fuck me');
        }

        check();

        Settings.save();
    }

    function backToMenu()
    {
        Settings.save();
        FlxG.mouse.visible = false;

        if (onPlayState)
        {
            PlayState.instance.tweenManager.clear();
			PlayState.instance.switchState(new PlayState());
			PlayState.sectionStart = false;
			PlayState.replayStartCutscene = false;
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.8);
        }
        else
            switchState(new MainMenuState());
    }

    function check()
    {
        trace('hi, downscroll is ' + Settings.data.downscroll);
        trace('also! ghost tapping is currently ' + Settings.data.ghostTapping);
    }
}