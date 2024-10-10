package characterSelect.characters;

class PicoPlayer extends CharacterSelectCharacter
{

    override function setup():Void{
        loadAtlas(Paths.getTextureAtlas("menu/characterSelect/characters/pico/CharacterSelect_Pico"));

        addAnimationByLabel("enter", "Enter", 24, false);
        addAnimationByLabel("idle", "Idle", 24, false);
        addAnimationByLabel("confirm", "Confirm", 24, false);
        addAnimationByLabel("cancel", "Cancel", 24, false);
        addAnimationByLabel("exit", "Exit", 24, false);
    }

    override function playEnter():Void{
        playAnim("enter", true);
    }

    override function playIdle():Void{
        if(curAnim != "enter" || finishedAnim){
            playAnim("idle", true);
        }
    }

    override function playConfirm():Void{
        playAnim("confirm", true);
    }

}