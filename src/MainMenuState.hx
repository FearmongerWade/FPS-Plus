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
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		// -- Setting up -- // 

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), TitleScreen.titleMusicVolume);

		persistentUpdate = persistentDraw = true;

		// -- Assets -- //

		var scroll:Float = 0.25;
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
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
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

		FlxG.camera.follow(camFollow, null, 2);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (Binds.justPressed("menuUp"))
				changeItem(-1);

			if (Binds.justPressed("menuDown"))
				changeItem(1);

			if (Binds.justPressed("menuBack"))
				switchState(new TitleScreen());

			if (Binds.justPressed("menuAccept"))
			{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					var daChoice:String = optionShit[curSelected];
					
					switch (daChoice){
						case 'freeplay':
							if(Settings.data.cacheMusic)
								FlxG.sound.music.stop();
						case 'options':
							FlxG.sound.music.stop();
					}

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite){
						if (curSelected != spr.ID){
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween){
									spr.kill();
								}
							});
						}
						else{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker){
								spr.visible = true;

								switch (daChoice)
								{
									case 'storymode':
										StoryMenuState.curWeek = 0;
										switchState(new StoryMenuState());
									case 'freeplay':
										switchState(new old.FreeplayStateOld());
									case 'options':
										OptionsState.onPlayState = false;
										switchState(new options.OptionsState());
								}
							});
						}
					});
				}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected = FlxMath.wrap(curSelected + huh, 0, optionShit.length - 1);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
				spr.animation.play('selected');

			spr.updateHitbox();
		});

		camFollow.x = menuItems.members[curSelected].getGraphicMidpoint().x;
		camFollow.y = menuItems.members[curSelected].getGraphicMidpoint().y - (menuItems.length > 4 ? menuItems.length * 8 : 0);
	}
}
