package;

import haxe.Json;

import flixel.graphics.frames.FlxAtlasFrames;
import lime.net.curl.CURLCode;
import backend.Song.WeekData;

class StoryMenuState extends MusicBeatState
{
	public static var weekList:Array<WeekData> = [];

	static var curDifficulty:Int = 1;
	static var curWeek:Int = 0;

	public static var fromPlayState:Bool = false;

	var scoreText:FlxText;
	var weekTitle:FlxText;
	var trackList:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var ui_tex:FlxAtlasFrames;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	public function new(?stickerIntro:Bool = false) 
	{
		super();
		if(stickerIntro)
			customTransIn = new transition.data.StickerIn();
	}

	override function create()
	{
		// -- Settings -- //

		ImageCache.clear();
		
		if (FlxG.sound.music == null || !FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), TitleScreen.titleMusicVolume);

		persistentUpdate = persistentDraw = true;

		for (i in 0...Song.data.length)
		{
			var week = Song.getData(i);
			if (week.freeplayOnly) continue;

			weekList.push(week);
		}

		// -- Assets -- //

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		for (i in 0...weekList.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, weekList[i].storyName);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.screenCenter(X);
		}

		add(blackBarThingie);
		add(yellowBG);

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 32);
		scoreText.setFormat(Paths.font('vcr.ttf'), 32);
		add(scoreText);

		weekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "week name", 32);
		weekTitle.setFormat(Paths.font('vcr.ttf'), FlxColor.WHITE, RIGHT);
		add(weekTitle);

		trackList = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks", 32);
		trackList.alignment = CENTER;
		trackList.font = Paths.font('vcr.ttf');
		trackList.color = 0xFFe55777;
		add(trackList);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();
		add(grpWeekCharacters);

		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter(0, 0, weekList[curWeek].menuChars[char]);
			grpWeekCharacters.add(weekCharacterThing);
			repositionCharacter(char);
		}

		ui_tex = Paths.getSparrowAtlas('menu/story/campaign_menu_UI_assets');

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		changeWeek(0);
		changeDifficulty();
		updateText();

		if(fromPlayState)
			customTransIn = new StickerIn();

		fromPlayState = false;

		super.create();
	}

	function repositionCharacter(charIndex:Int) 
	{
		grpWeekCharacters.members[charIndex].screenCenter(XY);
		grpWeekCharacters.members[charIndex].y -= 104;
		switch(charIndex)
		{
			case 0:
				grpWeekCharacters.members[charIndex].x -= 1280 * (3/10); 	
			case 2:
				grpWeekCharacters.members[charIndex].x += 1280 * (3/10);
		}
	}

	var lerpScore:Int = 49324858;
	var intendedScore:Int = 0;

	override function update(elapsed:Float)
	{
		if (intendedScore != lerpScore)
		{
			lerpScore = Math.floor(Utils.fpsAdjsutedLerp(lerpScore, intendedScore, 0.5));
			if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;

			scoreText.text = "LEVEL SCORE:" + lerpScore;
		}

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (Controls.justPressed('ui_up'))
					changeWeek(-1);

				if (Controls.justPressed('ui_down'))
					changeWeek(1);

				if (Controls.justPressed('ui_right'))
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (Controls.justPressed('ui_left'))
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (Controls.justPressed('ui_right'))
					changeDifficulty(1);
				if (Controls.justPressed('ui_left'))
					changeDifficulty(-1);
			}

			if (Controls.justPressed('accept'))
				selectWeek();
		}

		if (Controls.justPressed('back') && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (stopspamming == false)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));

			grpWeekText.members[curWeek].isFlashing = true;
			grpWeekCharacters.members[1].animation.play('confirm');
			grpWeekCharacters.members[1].centerOffsets();
			stopspamming = true;
		}

		PlayState.storyPlaylist = weekList[curWeek].songs.copy();
		PlayState.isStoryMode = true;
		selectedWeek = true;

		var diffic = "";

		switch (curDifficulty)
		{
			case 0:
				diffic = '-easy';
			case 2:
				diffic = '-hard';
		}

		PlayState.storyDifficulty = curDifficulty;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
		//PlayState.storyWeek = weekList[curWeek];
		PlayState.returnLocation = "story";

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
			PlayState.loadEvents = true;
			switchState(new PlayState());
		});
	}

	function changeDifficulty(change:Int = 0, ?playAnim:Bool = true):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}

		FlxTween.cancelTweensOf(sprDifficulty);

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		//intendedScore = Highscore.getWeekScore(Song.data.length[curWeek], curDifficulty).score;
		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
		if(!playAnim)
			FlxTween.completeTweensOf(sprDifficulty);
		updateText();
	}

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekList.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekList.length - 1;

		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		changeDifficulty(0, false);

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		grpWeekCharacters.members[0].setCharacter(weekList[curWeek].menuChars[0]);
		grpWeekCharacters.members[1].setCharacter(weekList[curWeek].menuChars[1]);
		grpWeekCharacters.members[2].setCharacter(weekList[curWeek].menuChars[2]);
		repositionCharacter(0);
		repositionCharacter(1);
		repositionCharacter(2);

		weekTitle.text = weekList[curWeek].displayName;
		weekTitle.x = FlxG.width - (weekTitle.width + 10);
		weekTitle.alignment = RIGHT;

		trackList.text = "TRACKS\n";

		var stringThing:Array<String> = weekList[curWeek].songs;
		for (song in stringThing)
		{
			var meta = Json.parse(Utils.getText("assets/songs/" + song.toLowerCase() + "/meta.json"));
			trackList.text += "\n" + meta.name;
		}

		trackList.screenCenter(X);
		trackList.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(weekList[curWeek].storyName, curDifficulty).score;
		#end

		trace(weekTitle.text);
	}
}
