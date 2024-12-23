package options;

class OptionsState extends FlxUIStateExt
{
    public static var onPlayState:Bool = false;
    var path:String = 'menu/options/';

    var options:Array<String> = [
        'downscroll',
        'ghostTapping',
        'shaders',
        //'flashing', 
        'keybinds',
        'offset', 
        'framerate',
        'caching'
    ];
    var grpOptions:FlxTypedGroup<OptionIcon>;
    var curSelected = 0;

    var selector:FlxSprite;

    override function create()
    {
        super.create();

        if (!FlxG.sound.music.playing)
            FlxG.sound.playMusic(Paths.music('chartEditorLoop'));
        FlxG.mouse.visible = true;
        Settings.load();

        var bg = new FlxSprite().loadGraphic(Paths.image('menu/menuBGBlue'));
        add(bg);

        var title = new FlxSprite(580, 40).loadGraphic(Paths.image(path+'title'));
        add(title);

        var window = new FlxSprite(60).makeGraphic(500, 620, 0xffacacac);
        window.screenCenter(Y);
        add(window);

        var text = new FlxText(65, 60, 0, 'crazy window wade, you dumb slut', 12);
        add(text);

        selector = new FlxSprite().makeGraphic(390, 80, 0xff320b9e);
        selector.alpha = 0;
        add(selector);

        grpOptions = new FlxTypedGroup<OptionIcon>();
        add(grpOptions);

        for (i in 0...options.length)
        {
            var item = new OptionIcon(options[i]);
            item.ID = i;

            var stu:Float = window.x+5;
            var billy:Float = window.y+30;
            item.x = stu + ((i % 4) * item.width) + 5;
            item.y = billy + (Math.floor(i/4) * item.height) + 5;

            switch(i)
            {
                case 0:
                    item.animation.curAnim.curFrame = Settings.data.downscroll ? 1 : 0;
                case 1:
                    item.animation.curAnim.curFrame = Settings.data.ghostTapping ? 1 : 0;
                case 2:
                    item.animation.curAnim.curFrame = Settings.data.shaders ? 1 : 0;
                default:
                    item.animation.curAnim.curFrame = 0;
            }

            grpOptions.add(item);
        }
    }

    var mClick:Bool = true;
	var mHover:Bool = false;

    override function update(elapsed:Float)
    {
        grpOptions.forEach(function(spr:OptionIcon)
        {
            if (mHover)
                if (!FlxG.mouse.overlaps(spr))
                {
                    spr.scale.set(1.25,1.25);
                }

            if (FlxG.mouse.overlaps(spr))
            {
                if (mClick)
                {
                    curSelected = spr.ID;
                    mHover = true;
                    FlxTween.tween(spr.scale, {x:1.3, y:1.3}, 0.5, {ease: FlxEase.elasticOut});
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
                grpOptions.members[0].animation.curAnim.curFrame = Settings.data.downscroll ? 1 : 0;
            case 'ghostTapping':
                Settings.data.ghostTapping = !Settings.data.ghostTapping;
                grpOptions.members[1].animation.curAnim.curFrame = Settings.data.ghostTapping ? 1 : 0;
            case 'shaders':
                Settings.data.shaders = !Settings.data.shaders;
                grpOptions.members[2].animation.curAnim.curFrame = Settings.data.shaders ? 1 : 0;
            case 'keybinds':
                grpOptions.members[3].animation.curAnim.curFrame = 1;
                switchState(new config.KeyBindMenu());
                trace('opening the keybinds submenu');
            case 'offset':
                trace('opening the offset submenu');    
            case 'framerate':
                trace('adjust your framerate');
            default:
                trace('fuck me');
        }

        Settings.save();
    }

    function backToMenu()
    {
        Settings.save();
        FlxG.mouse.visible = false;
        FlxG.sound.music.stop();
        FlxG.sound.play(Paths.sound('cancelMenu'));

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
}