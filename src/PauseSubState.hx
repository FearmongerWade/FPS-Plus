package;

import haxe.Json;
import debug.ChartingState;
import options.OptionsState;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', "Options", 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var allowControllerPress:Bool = false;

	var camPause:FlxCamera;

	var songName:FlxTextExt;
	var songArtist:FlxTextExt;

	public function new(x:Float, y:Float){

		super();

		PlayState.instance.tweenManager.active = false;

		camPause = new FlxCamera();
		camPause.bgColor.alpha = 0;
		FlxG.cameras.add(camPause, false);
		cameras = [camPause];
		
		if (PlayState.storyPlaylist.length > 1 && PlayState.isStoryMode){
			menuItems.insert(2, "Skip Song");
		}
		
		if (!PlayState.isStoryMode){
			menuItems.insert(2, "Chart Editor");
		}

		if (!PlayState.isStoryMode && PlayState.sectionStart){
			menuItems.insert(1, "Restart Section");
		}

		var pauseSongName = "pause/breakfast";
		
		pauseMusic = new FlxSound().loadEmbedded(Paths.music(pauseSongName), true, true);
		
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		pauseMusic.fadeIn(16, 0, 0.7);

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length){
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		if(PlayState.instance.metadata != null){
			var distance:Float = 32;

			songName = new FlxTextExt(16, 16, 1280-32, PlayState.instance.metadata.name, 40);
			songName.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
			songName.borderSize = 3;
			songName.alpha = 0;

			songArtist = new FlxTextExt(16, 32 + 40, 1280-32, PlayState.instance.metadata.artist, 40);
			songArtist.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
			songArtist.borderSize = 3;
			songArtist.alpha = 0;

			songName.y -= distance;
			songArtist.y -= distance;

			FlxTween.tween(songName, {alpha: 1, y: songName.y + distance}, 0.6, {ease: FlxEase.quartOut});
			FlxTween.tween(songArtist, {alpha: 1, y: songArtist.y + distance}, 0.6, {ease: FlxEase.quartOut, startDelay: 0.25});

			add(songName);
			add(songArtist);
		}

		changeSelection();

	}

	override function update(elapsed:Float){
			
		super.update(elapsed);

		if (Controls.justPressed('ui_up'))
			changeSelection(-1);

		if (Controls.justPressed('ui_down'))
			changeSelection(1);

		if (Controls.justPressed('back')){
			PlayState.instance.tweenManager.active = true;
			unpause();
		}

		if (Controls.justPressed('accept'))
		{
			PlayState.instance.tweenManager.active = true;

			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					unpause();
					
				case "Restart Song":
					PlayState.instance.tweenManager.clear();
					PlayState.instance.switchState(new PlayState());
					PlayState.sectionStart = false;
					PlayState.replayStartCutscene = false;
					pauseMusic.fadeOut(0.5, 0);
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.8);

				case "Restart Section":
					PlayState.instance.tweenManager.clear();
					PlayState.instance.switchState(new PlayState());
					PlayState.replayStartCutscene = false;
					pauseMusic.fadeOut(0.5, 0);
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.8);

				case "Chart Editor":
					PlayState.instance.tweenManager.clear();
					PlayState.instance.switchState(new ChartingState());
					pauseMusic.fadeOut(0.5, 0);
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.8);
					
				case "Skip Song":
					PlayState.instance.preventScoreSaving = true;
					PlayState.instance.tweenManager.clear();
					PlayState.instance.endSong();
					pauseMusic.fadeOut(0.5, 0);
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.8);
					
				case "Options":
					PlayState.instance.tweenManager.clear();
					OptionsState.onPlayState = true;
					PlayState.instance.switchState(new options.OptionsState());
					PlayState.replayStartCutscene = false;
					pauseMusic.fadeOut(0.5, 0);
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.8);
					
				case "Exit to menu":
					PlayState.instance.tweenManager.clear();
					PlayState.sectionStart = false;
					PlayState.instance.returnToMenu();
					pauseMusic.fadeOut(0.5, 0);
					FlxG.sound.play(Paths.sound('cancelMenu'), 0.8);
			}
		}

		//This is to work around a flixel issue that makes the controller input state reset on state/sub-state change. idk why it happens
		if(!allowControllerPress && Binds.justReleasedControllerOnly("pause")){
			allowControllerPress = true;
		}
	}

	function unpause(){
		FlxG.cameras.remove(camPause, true);
		close();
	}

	override function destroy(){
		pauseMusic.fadeTween.cancel();
		pauseMusic.destroy();
		if(songName != null){
			FlxTween.cancelTweensOf(songName);
			FlxTween.cancelTweensOf(songArtist);
		}
		super.destroy();
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.8);
			
		curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}
