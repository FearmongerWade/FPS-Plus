package transition.data;

import flixel.util.FlxGradient;

/**
    Recreation of the normal FNF transition in.
**/

class ScreenWipeIn extends BaseTransition
{
    var blockThing:FlxSprite;
    var time:Float;

    override public function new(_time:Float)
    {
        super();

        time = _time;

        blockThing = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height*2, [0x00000000, FlxColor.BLACK, FlxColor.BLACK]);
        blockThing.y -= blockThing.height/2;
        add(blockThing);
    }

    override public function play()
    {
        FlxTween.tween(blockThing, {y: blockThing.height}, time, {onComplete: function(tween){
            end();
        }});
    }
}