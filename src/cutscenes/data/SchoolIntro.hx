package cutscenes.data;

class SchoolIntro extends ScriptedCutscene
{
    
    final BLACK_ALPHA_SUBTRACT:Float = 0.15;
    var black:FlxSprite;
    var red:FlxSprite;
    var senpaiEvil:FlxSprite;
    var dialogueBox:DialogueBox;


    override function init():Void{

        black = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();

        red = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

        senpaiEvil = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('week6/weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 5.5));
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.scrollFactor.set();
		senpaiEvil.x += 275;

        var dialogue:Array<String> = [];

        if(Utils.exists(Paths.text(PlayState.SONG.song.toLowerCase() + "/" + PlayState.SONG.song.toLowerCase() + "Dialogue"))){
			dialogue = Utils.coolTextFile(Paths.text(PlayState.SONG.song.toLowerCase() + "/" + PlayState.SONG.song.toLowerCase() + "Dialogue"));
		}

        dialogueBox = new DialogueBox(false, dialogue);
		dialogueBox.scrollFactor.set();
		dialogueBox.finishThing = playstate.startCountdown;
		dialogueBox.cameras = [playstate.camHUD];

        addEvent(0, setup);
        var blackTime:Float = 0;
        var blackAlpha:Float = 1;
        while(blackAlpha > 0){
            blackTime += 0.3;
            blackAlpha -= BLACK_ALPHA_SUBTRACT;
            addEvent(blackTime, blackLowerAlpha);
        }
        if(PlayState.SONG.song.toLowerCase() != "thorns"){
            addEvent(blackTime, startDialogue);
        }
        else{
            addEvent(blackTime, thornsSetup);
            var senpaiTime:Float = 0;
            var senpaiAlpha:Float = 1;
            while(senpaiAlpha > 0){
                senpaiTime += 0.3;
                senpaiAlpha -= BLACK_ALPHA_SUBTRACT;
                addEvent(blackTime + senpaiTime, thornsSenpaiIncreaseAlpha);
            }
            addEvent(blackTime + senpaiTime, senpaiDie);
            addEvent(blackTime + senpaiTime + 3.2, cameraFade);
        }
    }

    function setup() {
        switch(PlayState.SONG.song.toLowerCase()){
            case "senpai":
                addGeneric(black);
                FlxG.sound.playMusic(Paths.music("week6/Lunchbox"), 0);
                FlxG.sound.music.fadeIn(1, 0, 0.8);
            case "roses":
                FlxG.sound.play(Paths.sound('week6/ANGRY_TEXT_BOX'));
            case "thorns":
                addGeneric(red);
                FlxG.sound.playMusic(Paths.music("week6/LunchboxScary"), 0);
                FlxG.sound.music.fadeIn(1, 0, 0.8);
        }
    }

    function blackLowerAlpha() {
        black.alpha -= BLACK_ALPHA_SUBTRACT;
    }

    function startDialogue() {
        addGeneric(dialogueBox);
    }

    function thornsSetup() {
        addGeneric(senpaiEvil);
		senpaiEvil.alpha = 0;
    }

    function thornsSenpaiIncreaseAlpha() {
        senpaiEvil.alpha += BLACK_ALPHA_SUBTRACT;
    }
    
    function senpaiDie() {
        senpaiEvil.animation.play('idle');
		FlxG.sound.play(Paths.sound('week6/Senpai_Dies'), 1, false, null, true, function(){
			removeGeneric(senpaiEvil);
			removeGeneric(red);
			FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function(){
				addGeneric(dialogueBox);
			}, true);
		});
    }

    function cameraFade() {
        FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
    }

}