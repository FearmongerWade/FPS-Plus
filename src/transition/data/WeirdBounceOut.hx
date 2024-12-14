package transition.data;

/**
    Transition animation made to test the new transition system.
**/

class WeirdBounceOut extends BaseTransition
{
    var blockThing:FlxSprite;
    var time:Float;

    override public function new(_time:Float)
    {
        super();

        time = _time;

        blockThing = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        blockThing.x -= blockThing.width;
        add(blockThing);
    }

    override public function play()
    {
        FlxTween.tween(blockThing, {x: 0}, time, {ease: FlxEase.quartOut, onComplete: function(tween){
            end();
        }});
    }
}