package options;

class OptionIcon extends FlxSprite
{
    public function new(option:String)
    {
        super(option);

        scrollFactor.set();
        antialiasing = true;

        var name:String = 'menu/options/icons/' + option;
        var graphic = Paths.image(name);

        loadGraphic(graphic, true, 125, 125);
        animation.add('icon', [0, 1], 0, false);
        animation.play('icon');
        updateHitbox();
    }
}