package transition.data;

/**
    A simple fade to a color.
**/

class FadeOut extends BaseTransition
{
    var blockThing:FlxSprite;
    var time:Float;

    override public function new(_time:Float, ?_color:FlxColor = FlxColor.BLACK)
    {    
        super();

        time = _time;

        blockThing = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, _color);
        blockThing.alpha = 0;
        add(blockThing);
    }

    override public function play()
    {
        FlxTween.tween(blockThing, {alpha: 1}, time, {ease: FlxEase.quartOut, onComplete: function(tween){
            end();
        }});
    }
}