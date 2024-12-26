package;

import flixel.effects.FlxFlicker;
import lime.app.Application;

import title.TitleScreen;
import options.OptionsState;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	
	var optionShit:Array<String> = [
		'storymode', 
		'freeplay', 
		'options',
		'credits'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camTarget:FlxPoint = new FlxPoint();

	override function create()
	{
		// -- Setting up -- // 

		ImageCache.clear();

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), TitleScreen.titleMusicVolume);

		persistentUpdate = persistentDraw = true;

		// -- Assets -- //

		var scroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg = new FlxSprite(-80).loadGraphic(Paths.image('menu/menuBG'));
		bg.scrollFactor.set(0, scroll);
		bg.setGraphicSize(Std.int(bg.width * 1.18));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
	
		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menu/menuBGMagenta'));
		magenta.scrollFactor.set(0, scroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.18));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 60 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 160) + offset);
			menuItem.frames = Paths.getSparrowAtlas("menu/main/" + optionShit[i]);
			menuItem.animation.addByPrefix('idle', "idle", 24);
			menuItem.animation.addByPrefix('selected', "selected", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		var versionText = new FlxTextExt(5, FlxG.height - 21, 0, "FPS Plus: " + Application.current.meta.get('version'), 16);
		versionText.scrollFactor.set();
		versionText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionText);

		changeItem();

		super.create();

		FlxG.camera.follow(camFollow);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (Controls.justPressed('ui_up'))
				changeItem(-1);

			if (Controls.justPressed('ui_down'))
				changeItem(1);

			if (Controls.justPressed('back'))
				switchState(new TitleScreen());

			if (Controls.justPressed('accept'))
				selectItem();
		}

		super.update(elapsed);

		camFollow.x = Utils.fpsAdjsutedLerp(camFollow.x, camTarget.x, 0.1);
		camFollow.y = Utils.fpsAdjsutedLerp(camFollow.y, camTarget.y, 0.1);

		menuItems.forEach(function(spr:FlxSprite) {
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected = FlxMath.wrap(curSelected + huh, 0, optionShit.length - 1);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camTarget.set(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
				
			spr.updateHitbox();
			spr.centerOffsets();
		});
	}

	function selectItem()
	{
		var daChoice:String = optionShit[curSelected];

		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

		switch (daChoice)
		{
			case 'freeplay':
				if (Settings.data.cacheMusic)
					FlxG.sound.music.stop();
			case 'options' | 'credits':
				FlxG.sound.music.stop();
		}

		FlxFlicker.flicker(magenta, 1.1, 0.15, false);

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
				FlxTween.tween(spr, {alpha: 0}, 0.4, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween){
						spr.kill();
					}
				});
			else
				FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker){
					spr.visible = true;
					openMenu();
				});
		});
	}

	function openMenu()
	{
		switch (optionShit[curSelected])
		{
			case 'storymode':
				StoryMenuState.curWeek = 0;
				switchState(new StoryMenuState());
			case 'freeplay':
				switchState(new old.FreeplayStateOld());
			case 'options':
				OptionsState.onPlayState = false;
				switchState(new options.OptionsState());
			default: // crash prevention
				FlxG.resetState();
		}
	}
}
