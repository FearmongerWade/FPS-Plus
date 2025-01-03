package stages;

import flixel.tweens.FlxTween.FlxTweenManager;

/**
	This is the base class for stages. When making your own stage make a new class extending this one.    
	@author Rozebud
**/

class BaseStage
{

    public var name:String;
    public var startingZoom:Float = 1.05;
    public var uiType:String = "default";
    public var cameraMovementEnabled:Bool = true;
    public var extraCameraMovementAmount:Null<Float> = null; //Leave null for PlayState default.
    public var cameraStartPosition:FlxPoint; //Leave null for PlayState default.
    public var globalCameraOffset:FlxPoint = new FlxPoint();
    public var bfCameraOffset:FlxPoint = new FlxPoint();
    public var dadCameraOffset:FlxPoint = new FlxPoint();
    public var gfCameraOffset:FlxPoint = new FlxPoint();
    public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();
    public var events:Map<String, (String)->Void> = new Map<String, (String)->Void>();

    public var backgroundElements:Array<Dynamic> = [];
    public var middleElements:Array<Dynamic> = [];
    public var foregroundElements:Array<Dynamic> = [];

    var updateGroup:FlxGroup = new FlxGroup();

    public var useStartPoints:Bool = true; //Auto positions characters if set to true
    public var overrideBfStartPoints:Bool = false;  //Does the opposite of useStartPoints for this specific character.
    public var overrideDadStartPoints:Bool = false; //Does the opposite of useStartPoints for this specific character.
    public var overrideGfStartPoints:Bool = false;  //Does the opposite of useStartPoints for this specific character.
    public var dadStart:FlxPoint = new FlxPoint(314.5, 867);
    public var bfStart:FlxPoint = new FlxPoint(975.5, 862);
    public var gfStart:FlxPoint = new FlxPoint(751.5, 778);

    /**
	 * Do not override this function, override `init()` instead.
	 */
    public function new(){
        init();
    }

    /**
	 * Override this function to initialize all of your stage elements.
	 */
    function init(){}

    /**
	 * Adds an object to `backgroundElements` to be added to PlayState.
	 *
	 * @param   x  The object to add. Should be any type that can be added to a state.
	 */
    public function addToBackground(x:FlxBasic){
        backgroundElements.push(x);
    }

    /**
	 * Adds an object to `middleElements` to be added to PlayState.
	 *
	 * @param   x  The object to add. Should be any type that can be added to a state.
	 */
    public function addToMiddle(x:FlxBasic){
        middleElements.push(x);
    }

    /**
	 * Adds an object to `foregroundElements` to be added to PlayState.
	 *
	 * @param   x  The object to add. Should be any type that can be added to a state.
	 */
    public function addToForeground(x:FlxBasic){
        foregroundElements.push(x);
    }

    /**
	 * Adds arbitrary info to the stage that can be read in PlayState.
	 *
	 * @param   k  A string key.
	 * @param   x  The dyanmic data.
	 */
    public function addExtraData(k:String, x:Dynamic){
        extraData.set(k, x);
    }

    /**
     * Adds arbitrary info to the stage that can be read in PlayState.
     *
     * @param   name    The name of the event.
     * @param   func    The function that gets called when the event is triggered. Must have no arguments and no return type.
     */
    public function addEvent(name:String, func:(String)->Void){
        events.set(name, func);
    }

    /**
     * Add any object that will up updated in the stage's update loop.
     *
     * @param   obj     The object that will be added to the update loop.
     */
     public function addToUpdate(obj:FlxBasic){
        updateGroup.add(obj);
    }

    /**
	 * Destroys all objects added to the stage elements.
	 */
    public function destroyAll(){
        for(x in backgroundElements){ x.destroy(); }
        for(x in middleElements){ x.destroy(); }
        for(x in foregroundElements){ x.destroy(); }
    }

    /**
	 * Called every frame in PlayState update.
	 * Don't forget to call `super.update(elasped)` or the update group won't be updated.
     *
     * @param   elpased  The elapsed time between previous frames passed in by PlayState.
	 */
    public function update(elapsed:Float){
        for(obj in updateGroup){
            obj.update(elapsed);
        }
    }

    /**
	 * Called every beat hit in PlayState.
     *
     * @param   curBeat  The current song beat passed in by PlayState.
	 */
    public function beat(curBeat:Int){}

    /**
	 * Called every step hit in PlayState.
     *
     * @param   curStep  The current song step passed in by PlayState.
	 */
    public function step(curStep:Int){}

    /**
	 * Called once the song starts.
	 */
    public function songStart(){}

    /**
	 * Called when the game is paused.
	 */
    public function pause(){}

    /**
	 * Called when the game is unpaused.
	 */
    public function unpause(){}

    /**
	 * Called when the game over state is started.
	 */
    public function gameOverStart(){}

    /**
	 * Called when the starting the game over loop animation.
	 */
    public function gameOverLoop(){}

    /**
	 * Called when the game over retry is confirmed.
	 */
    public function gameOverEnd(){}


    var boyfriend(get, never):Character;
    @:noCompletion inline function get_boyfriend()  { return PlayState.instance.boyfriend; }
    var gf(get, never):Character;
    @:noCompletion inline function get_gf()         { return PlayState.instance.gf; }
    var dad(get, never):Character;
    @:noCompletion inline function get_dad()        { return PlayState.instance.dad; }
    var playstate(get, never):PlayState;
    @:noCompletion inline function get_playstate()  { return PlayState.instance; }
    var tween(get, never):FlxTweenManager;
    @:noCompletion inline function get_tween()      { return PlayState.instance.tweenManager; }
    var data(get, never):Map<String, Dynamic>;
    @:noCompletion inline function get_data()       { return PlayState.instance.arbitraryData; }


    //It is only recommended that you only use this if you have to add dynamic objects.
    //For normal stage elements you should just add them to the groups in the init() and toggle their visibility.
    inline function addToBackgroundLive(x:FlxBasic)      { PlayState.instance.backgroundLayer.add(x); }
    inline function removeFromBackgroundLive(x:FlxBasic) { PlayState.instance.backgroundLayer.remove(x); }
    inline function addToGfLive(x:FlxBasic)              { PlayState.instance.gfLayer.add(x); }
    inline function removeFromGfLive(x:FlxBasic)         { PlayState.instance.gfLayer.remove(x); }
    inline function addToMiddleLive(x:FlxBasic)          { PlayState.instance.middleLayer.add(x); }
    inline function removeFromMiddleLive(x:FlxBasic)     { PlayState.instance.middleLayer.remove(x); }
    inline function addToCharacterLive(x:FlxBasic)       { PlayState.instance.characterLayer.add(x); }
    inline function removeFromCharacterLive(x:FlxBasic)  { PlayState.instance.characterLayer.remove(x); }
    inline function addToForegroundLive(x:FlxBasic)      { PlayState.instance.foregroundLayer.add(x); }
    inline function removeFromForegroundLive(x:FlxBasic) { PlayState.instance.foregroundLayer.remove(x); }

}