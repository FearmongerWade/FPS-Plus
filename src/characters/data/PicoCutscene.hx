package characters.data;

@charList(false)
class PicoCutscene extends CharacterInfoBase
{

    override public function new(){

        super();

        info.name = "pico-cutscene";
        info.spritePath = "weekend1/Pico_Intro";
        info.frameLoadType = sparrow;
        
        info.iconName = "pico";
        info.facesLeft = true;

        addByPrefix("pissed", offset(57, 0), "Pico Gets Pissed", 24, loop(false, 0), false, false);
        addByIndices("reload", offset(-14, -10), "cutscene cock", [0,1,2,3,4], "", 24, loop(false, 0), false, false);
        addByPrefix("shoot", offset(253, 230), "shoot and return", 24, loop(false, 0), false, false);

    }

}