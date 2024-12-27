package old;

typedef FreeplaySong = 
{
	var name:String;
	var diffs:Array<String>;
}

class FreeplayStateOld extends MusicBeatState
{
	var songList:Array<FreeplaySong> = [];

	static var curSelected:Int = 0;
	static var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;

	override function create()
	{
		// -- Settings -- //

		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music(TitleScreen.titleMusic), TitleScreen.titleMusicVolume);

		ImageCache.clear();
		
		for (i in 0...Song.data.length)
		{
			var week = Song.getData(i);
			if (week.storyOnly) continue;

			for (song in week.songs)
				addSong(song, week.diffs);
		}

		// -- Assets -- //

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu/menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songList.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songList[i].name, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;

		add(scoreBG);
		add(diffText);
		add(scoreText);

		changeSelection(0);
		changeDiff(0, false);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		lerpScore = Math.floor(Utils.fpsAdjsutedLerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		if (Controls.justPressed('ui_up'))
			changeSelection(-1);
		
		if (Controls.justPressed('ui_down'))
			changeSelection(1);

		if (Controls.justPressed('ui_left'))
			changeDiff(-1);
			
		if (Controls.justPressed('ui_right'))
			changeDiff(1);
			
		if (Controls.justPressed('back') && !FlxUIStateExt.inTransition)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			if(Settings.data.cacheMusic) 
				FlxG.sound.music.stop(); 
			switchState(new MainMenuState());
		}

		if (Controls.justPressed('accept') && !FlxUIStateExt.inTransition)
		{
			var poop:String = Highscore.formatSong(songList[curSelected].name.toLowerCase(), curDifficulty);
			PlayState.SONG = Song.loadFromJson(poop, songList[curSelected].name.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.loadEvents = true;
			PlayState.returnLocation = "freeplay";
			//PlayState.storyWeek = songs[curSelected].week;
			//trace('CUR WEEK' + PlayState.storyWeek);
			switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}
	}

	// Function that gets called every time you change the difficulty
	function changeDiff(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'));

		curDifficulty += change;

		var max:Int = songList[curSelected].diffs.length - 1;
		curDifficulty = FlxMath.wrap(curDifficulty, 0, max);

		updateScore();
	}

	// Function that gets called every time you change the song 
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));

		curSelected += change;
		curSelected = FlxMath.wrap(curSelected, 0, songList.length - 1);
		changeDiff(0, false);
		updateScore();

		if(Settings.data.cacheMusic)
		{
			FlxG.sound.playMusic(Paths.inst(songList[curSelected].name), 0);
			FlxG.sound.music.fadeIn(1, 0, 1);
		}

		var bullShit:Int = 0;
		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

	// Function that... adds the songs....
	function addSong(songName:String, diffs:Array<String>)
	{
		songList.push({name:songName, diffs:diffs});
	}
	
	// Updates the highscore depending on the difficulty
	function updateScore()
	{
		var curSong = songList[curSelected];

		intendedScore = Highscore.getScore(curSong.name, curDifficulty).score;
		diffText.text = curSong.diffs[curDifficulty].toUpperCase();
	}
}