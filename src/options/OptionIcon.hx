package options;

class OptionIcon extends FlxSprite
{
    public function new(option:String)
    {
        super(option);

        scrollFactor.set();
        scale.set(1.25, 1.25);
        antialiasing = true;

        var name:String = 'menu/options/icons/' + option;
        var graphic = Paths.image(name);

        loadGraphic(graphic, true, 100, 100);
        animation.add('icon', [0, 1], 0, false);
        animation.play('icon');
        updateHitbox();
    }
}